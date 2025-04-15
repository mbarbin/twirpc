module Unix = UnixLabels
module Discovery_file = Discovery_file

module Switch = struct
  let port = "port"
  let discovery_file = "discovery-file"
  let port_chosen_by_os = "port-chosen-by-os"
end

module Connection_config = struct
  type t =
    | Tcp of
        { host : [ `Localhost ]
        ; port : int
        }
    | Discovery_file of { path : Fpath.t }
  [@@deriving equal, sexp_of]

  let arg =
    let open Command.Std in
    let+ by_port =
      Arg.named_opt
        [ Switch.port ]
        Param.int
        ~docv:"PORT"
        ~doc:"connect to localhost TCP port"
      >>| Option.map ~f:(fun port -> Tcp { host = `Localhost; port })
    and+ by_discovery_file =
      Arg.named_opt
        [ Switch.discovery_file ]
        (Param.validated_string (module Fpath))
        ~docv:"PATH"
        ~doc:"read sockaddr from discovery file"
      >>| Option.map ~f:(fun path -> Discovery_file { path })
    in
    match List.filter_opt [ by_port; by_discovery_file ] with
    | [ spec ] -> Or_error.return spec
    | [] -> Or_error.return (Tcp { host = `Localhost; port = 8080 })
    | _ :: _ :: _ ->
      Or_error.error_string
        "Only one of --port, --unix-socket, or --discovery-file can be used"
  ;;

  let to_args t =
    match t with
    | Tcp { host = `Localhost; port } -> [ "--" ^ Switch.port; Int.to_string port ]
    | Discovery_file { path } -> [ "--" ^ Switch.discovery_file; Fpath.to_string path ]
  ;;

  let port t : int Or_error.t =
    Or_error.try_with (fun () ->
      match t with
      | Tcp { host = `Localhost; port } -> port
      | Discovery_file { path } -> (Discovery_file.load ~path).port)
  ;;
end

module Listening_config = struct
  module Specification = struct
    type t = Tcp of { port : [ `Chosen_by_OS | `Supplied of int ] }
    [@@deriving equal, sexp_of]
  end

  type t =
    { specification : Specification.t
    ; discovery_file : Fpath.t option
    }
  [@@deriving equal, sexp_of]

  let arg =
    let open Command.Std in
    let+ specification =
      let+ by_os =
        let+ chosen_by_os =
          Arg.flag
            [ Switch.port_chosen_by_os ]
            ~doc:"listen on localhost TCP port chosen by OS (default)"
        in
        if chosen_by_os then Some (Specification.Tcp { port = `Chosen_by_OS }) else None
      and+ by_port =
        Arg.named_opt
          [ Switch.port ]
          Param.int
          ~docv:"PORT"
          ~doc:"listen on localhost TCP port"
        >>| Option.map ~f:(fun port -> Specification.Tcp { port = `Supplied port })
      in
      match List.filter_opt [ by_os; by_port ] with
      | [ spec ] -> Or_error.return spec
      | [] -> Or_error.return (Specification.Tcp { port = `Chosen_by_OS })
      | _ :: _ :: _ ->
        Or_error.error_string "Only one of --port or --port-chosen-by-os can be used"
    and+ discovery_file =
      Arg.named_opt
        [ Switch.discovery_file ]
        (Param.validated_string (module Fpath))
        ~docv:"PATH"
        ~doc:"save sockaddr to discovery file"
    in
    match specification with
    | Error _ as error -> error
    | Ok specification -> Ok { specification; discovery_file }
  ;;

  let to_args t =
    let specification =
      match t.specification with
      | Tcp { port = `Chosen_by_OS } -> [ "--" ^ Switch.port_chosen_by_os ]
      | Tcp { port = `Supplied port } -> [ "--" ^ Switch.port; Int.to_string port ]
    in
    let discovery_file =
      match t.discovery_file with
      | None -> []
      | Some path -> [ "--" ^ Switch.discovery_file; Fpath.to_string path ]
    in
    List.concat [ specification; discovery_file ]
  ;;

  let port { specification; discovery_file = _ } : int =
    match specification with
    | Tcp { port } ->
      (match port with
       | `Supplied port -> port
       | `Chosen_by_OS -> 0)
  ;;

  let advertize t ~port =
    match t.discovery_file with
    | None -> ()
    | Some path ->
      Discovery_file.save { port } ~path;
      Stdlib.at_exit (fun () ->
        try Unix.unlink (Fpath.to_string path) with
        | _ -> ())
  ;;
end
