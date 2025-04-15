let run_cmd =
  Command.make
    ~summary:"run the server"
    (let open Command.Std in
     let+ listening_config = Twirpc_discovery.Listening_config.arg
     and+ verbose = Arg.flag [ "verbose" ] ~doc:"be more verbose" in
     let%bind listening_config = listening_config in
     let server = Keyval_server.create () in
     let twirpc_server = Keyval_server.implement_rpcs server in
     let server =
       Tiny_httpd.create
         ~port:
           (match listening_config.specification with
            | Tcp { port = `Supplied port } -> port
            | Tcp { port = `Chosen_by_OS } -> 0)
         ()
     in
     Twirpc_server.add_services twirpc_server ~to_server:server;
     Stdlib.Sys.set_signal
       Stdlib.Sys.sigterm
       (Signal_handle (fun (_ : int) -> Tiny_httpd.stop server));
     (try
        Tiny_httpd.run_exn server ~after_init:(fun () ->
          let port = Tiny_httpd.port server in
          Twirpc_discovery.Listening_config.advertize listening_config ~port;
          if verbose
          then
            print_endline
              (Printf.sprintf "Listening for connections on %d" port) [@coverage off])
      with
      | Unix.Unix_error (Unix.EINTR, _, _) -> ());
     return ())
;;

let main = Command.group ~summary:"manage the server" [ "run", run_cmd ]
