module Unix = UnixLabels

module Config = struct
  module Process_command = struct
    type t =
      { executable : string
      ; args : string list
      }

    let to_string_list { executable; args } = executable :: args
  end

  module Client_invocation = struct
    type t =
      | Connect_to of { connection_config : Twirpc_discovery.Connection_config.t }
      | Offline
  end

  module type S = sig
    val run_server_command
      :  listening_config:Twirpc_discovery.Listening_config.t
      -> Process_command.t

    val run_client_command
      :  client_invocation:Client_invocation.t
      -> args:string list
      -> Process_command.t
  end

  type t = (module S)

  let create s = s

  let twirpc_discovery ~run_server_command ~run_client_command : t =
    let module Config : S = struct
      let run_server_command ~listening_config =
        let { Process_command.executable; args } = run_server_command in
        { Process_command.executable
        ; args = args @ Twirpc_discovery.Listening_config.to_args listening_config
        }
      ;;

      let run_client_command ~client_invocation ~args =
        let { Process_command.executable; args = client_args } = run_client_command in
        let connection_args =
          match (client_invocation : Client_invocation.t) with
          | Offline -> []
          | Connect_to { connection_config } ->
            Twirpc_discovery.Connection_config.to_args connection_config
        in
        { Process_command.executable
        ; args = List.concat [ args; client_args; connection_args ]
        }
      ;;
    end
    in
    (module Config)
  ;;
end

let run_client ~context args =
  let process = Shexp_process.call_exit_code args in
  let exit_code = Shexp_process.eval ~context process in
  match exit_code with
  | 0 -> ()
  | code -> prerr_endline (Printf.sprintf "[%d]\n" code)
;;

type t = { context : Shexp_process.Context.t }

let run ~f =
  let t = { context = Shexp_process.Context.create () } in
  Exn.protect ~f:(fun () -> f t) ~finally:(fun () -> ())
;;

module Server = struct
  type nonrec t =
    { test : t
    ; config : Config.t
    ; connection_config : Twirpc_discovery.Connection_config.t
    ; listening_on_port : int
    }

  let listening_on_port t = t.listening_on_port

  let with_connection { test = { context = _ }; listening_on_port = port; _ } ~f =
    Twirpc_client.with_connection ~port ~f:(fun connection ->
      f connection;
      Ok ())
    |> Or_error.ok_exn
  ;;
end

let run_client
      { Server.test = { context }; config; listening_on_port = _; connection_config }
      ?(offline = false)
      args
  =
  let module C = (val config : Config.S) in
  run_client
    ~context
    (C.run_client_command
       ~client_invocation:(if offline then Offline else Connect_to { connection_config })
       ~args:(List.concat args)
     |> Config.Process_command.to_string_list)
;;

module With_server = struct
  type t =
    { server : Server.t
    ; client : ?offline:bool -> string list list -> unit
    }
end

module Sockaddr_kind = struct
  type t = Tcp_localhost
end

let with_server
      ?(sockaddr_kind = Sockaddr_kind.Tcp_localhost)
      ({ context } as t)
      ~config
      ~f
  =
  let module C = (val config : Config.S) in
  let temp_file = Stdlib.Filename.temp_file "unix_socket_test" ".sock" in
  Unix.unlink temp_file;
  let listening_config : Twirpc_discovery.Listening_config.t =
    match sockaddr_kind with
    | Tcp_localhost ->
      { specification = Tcp { port = `Chosen_by_OS }
      ; discovery_file = Some (Fpath.v temp_file)
      }
  in
  let server_process =
    match
      C.run_server_command ~listening_config |> Config.Process_command.to_string_list
    with
    | [] -> assert false
    | prog :: args -> Shexp_process.spawn prog args |> Shexp_process.eval ~context
  in
  (* Give the server a little time before it is ready to accept connections. *)
  Unix.sleepf 0.5;
  let connection_config : Twirpc_discovery.Connection_config.t =
    match listening_config.specification with
    | Tcp { port = `Supplied port } -> Tcp { host = `Localhost; port }
    | Tcp { port = `Chosen_by_OS } ->
      (match listening_config.discovery_file with
       | None -> failwith "Tcp port chosen by OS but no discovery file"
       | Some discovery_file -> Discovery_file { path = discovery_file })
  in
  let listening_on_port =
    Twirpc_discovery.Connection_config.port connection_config |> Or_error.ok_exn
  in
  let server = { Server.test = t; config; connection_config; listening_on_port } in
  let client ?offline args = run_client server ?offline args in
  Exn.protect
    ~f:(fun () ->
      f { With_server.server; client };
      Unix.kill
        ~pid:(Shexp_process.Background_command.pid server_process)
        ~signal:Stdlib.Sys.sigterm;
      match Shexp_process.wait server_process |> Shexp_process.eval ~context with
      | Exited _ | Signaled _ -> ())
    ~finally:(fun () -> if Stdlib.Sys.file_exists temp_file then Unix.unlink temp_file)
;;
