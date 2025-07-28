let main =
  Command.make
    ~summary:"Set a binding [key=value]."
    (let open Command.Std in
     let+ connection_config = Twirpc_discovery.Connection_config.arg
     and+ key =
       Arg.named
         [ "key" ]
         (Param.validated_string (module Keyval.Key))
         ~docv:"KEY"
         ~doc:"The name of the key."
     and+ value =
       Arg.named
         [ "value" ]
         (Param.stringable (module Keyval.Value))
         ~docv:"VALUE"
         ~doc:"The desired value."
     in
     let%bind connection_config = connection_config in
     let%bind port = Twirpc_discovery.Connection_config.port connection_config in
     Twirpc_client.with_connection ~port ~f:(fun connection ->
       Twirpc_client.call (module Keyval_rpc.Set_) ~connection { key; value }))
;;
