let main =
  Command.make
    ~summary:"Delete a binding."
    (let open Command.Std in
     let+ connection_config = Twirpc_discovery.Connection_config.arg
     and+ key =
       Arg.named
         [ "key" ]
         (Param.validated_string (module Keyval.Key))
         ~docv:"KEY"
         ~doc:"The name of the key to delete."
     in
     let%bind connection_config = connection_config in
     let%bind port = Twirpc_discovery.Connection_config.port connection_config in
     Twirpc_client.with_connection ~port ~f:(fun connection ->
       Twirpc_client.call (module Keyval_rpc.Delete) ~connection key |> Or_error.join))
;;
