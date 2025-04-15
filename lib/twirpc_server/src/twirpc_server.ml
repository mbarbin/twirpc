module Rpc = struct
  type t =
    | Handler :
        { spec : ('request, 'response) Twirpc_spec.t
        ; f : 'request -> 'response
        }
        -> t

  let make spec ~f : t = Handler { spec; f }
end

type t = Rpc.t list

let implement rpcs = rpcs

let add_services (t : t) ~to_server:httpd =
  t
  |> List.iter (function Rpc.Handler { spec; f } ->
      let handler = Twirp_tiny_httpd.mk_handler (Twirpc_spec.server_rpc spec) f in
      Twirp_tiny_httpd.add_service httpd (Twirpc_spec.server spec ~handler))
;;
