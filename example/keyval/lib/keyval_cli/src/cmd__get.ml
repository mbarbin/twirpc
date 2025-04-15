let main =
  Command.make
    ~summary:"get the value attached to a key"
    (let open Command.Std in
     let+ connection_config = Twirpc_discovery.Connection_config.arg
     and+ key =
       Arg.named
         [ "key" ]
         (Param.validated_string (module Keyval.Key))
         ~docv:"KEY"
         ~doc:"the name of the key"
     in
     let%bind connection_config = connection_config in
     let%bind port = Twirpc_discovery.Connection_config.port connection_config in
     Twirpc_client.with_connection ~port ~f:(fun connection ->
       let%bind value =
         Twirpc_client.call (module Keyval_rpc.Get) ~connection key |> Or_error.join
       in
       print_s [%sexp (value : Keyval.Value.t)];
       return ()))
;;
