let main =
  Command.make
    ~summary:"Print the list of all known keys."
    (let open Command.Std in
     let+ connection_config = Twirpc_discovery.Connection_config.arg in
     let%bind connection_config = connection_config in
     let%bind port = Twirpc_discovery.Connection_config.port connection_config in
     Twirpc_client.with_connection ~port ~f:(fun connection ->
       let%bind keys = Twirpc_client.call (module Keyval_rpc.List_keys) ~connection () in
       print_s [%sexp (keys : Set.M(Keyval.Key).t)];
       return ()))
;;
