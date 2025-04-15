module type S = sig
  module Request : sig
    type t [@@deriving equal, quickcheck, sexp_of]
  end

  module Response : sig
    type t [@@deriving equal, quickcheck, sexp_of]
  end

  include Twirpc_spec.S with module Request := Request and module Response := Response
end

type ('request, 'response) t =
  (module S with type Request.t = 'request and type Response.t = 'response)

let run_request_exn
      (type request response)
      here
      ?config
      ?examples
      (t : (request, response) t)
  =
  let module M = (val t : S with type Request.t = request and type Response.t = response)
  in
  quickcheck_m
    here
    (module M.Request)
    ?config
    ?examples
    ~f:(fun request ->
      let buffer = Twirpc_spec.Private.encode_request (module M) request in
      let request' = Twirpc_spec.Private.decode_request (module M) buffer in
      require_equal here (module M.Request) request request')
;;

let run_response_exn
      (type request response)
      here
      ?config
      ?examples
      (t : (request, response) t)
  =
  let module M = (val t : S with type Request.t = request and type Response.t = response)
  in
  quickcheck_m
    here
    (module M.Response)
    ?config
    ?examples
    ~f:(fun response ->
      let buffer = Twirpc_spec.Private.encode_response (module M) response in
      let response' = Twirpc_spec.Private.decode_response (module M) buffer in
      require_equal here (module M.Response) response response')
;;

let run_exn here ?config ?requests ?responses t =
  run_request_exn here ?config ?examples:requests t;
  run_response_exn here ?config ?examples:responses t
;;
