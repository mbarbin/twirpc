type unary = Pbrt_services.Value_mode.unary

module Rpc = struct
  type ('request, 'response) t =
    | T :
        { proto_client_rpc :
            ('proto_request, unary, 'proto_response, unary) Pbrt_services.Client.rpc
        ; proto_server_rpc :
            ('proto_request, unary, 'proto_response, unary) Pbrt_services.Server.rpc
        ; request_to_proto : 'request -> 'proto_request
        ; request_of_proto : 'proto_request -> 'request
        ; response_to_proto : 'response -> 'proto_response
        ; response_of_proto : 'proto_response -> 'response
        ; client_rpc : ('request, unary, 'response, unary) Pbrt_services.Client.rpc
        ; server_rpc : ('request, unary, 'response, unary) Pbrt_services.Server.rpc
        }
        -> ('request, 'response) t
end

module Protoable = struct
  module type S = sig
    type t [@@deriving equal, sexp_of]

    module Proto : sig
      type t
    end

    val of_proto : Proto.t -> t
    val to_proto : t -> Proto.t
  end
end

module Protospec = struct
  module type S = sig
    type request
    type response

    val client_rpc : (request, unary, response, unary) Pbrt_services.Client.rpc
    val server_rpc : (request, unary, response, unary) Pbrt_services.Server.rpc
  end
end

let make
      (type proto_request request proto_response response)
      ~client_rpc:(proto_client_rpc : _ Pbrt_services.Client.rpc)
      ~server_rpc:(proto_server_rpc : _ Pbrt_services.Server.rpc)
      (module Request : Protoable.S with type t = request and type Proto.t = proto_request)
      (module Response : Protoable.S
        with type t = response
         and type Proto.t = proto_response)
  =
  let client_rpc : _ Pbrt_services.Client.rpc =
    { proto_client_rpc with
      encode_json_req =
        (fun request -> proto_client_rpc.encode_json_req (Request.to_proto request))
    ; encode_pb_req =
        (fun request encoder ->
          proto_client_rpc.encode_pb_req (Request.to_proto request) encoder)
    ; decode_json_res =
        (fun json -> Response.of_proto (proto_client_rpc.decode_json_res json))
    ; decode_pb_res =
        (fun decoder -> Response.of_proto (proto_client_rpc.decode_pb_res decoder))
    }
  in
  let server_rpc : _ Pbrt_services.Server.rpc =
    { proto_server_rpc with
      encode_json_res =
        (fun response -> proto_server_rpc.encode_json_res (Response.to_proto response))
    ; encode_pb_res =
        (fun response encoder ->
          proto_server_rpc.encode_pb_res (Response.to_proto response) encoder)
    ; decode_json_req =
        (fun json -> Request.of_proto (proto_server_rpc.decode_json_req json))
    ; decode_pb_req =
        (fun decoder -> Request.of_proto (proto_server_rpc.decode_pb_req decoder))
    }
  in
  Rpc.T
    { proto_client_rpc
    ; proto_server_rpc
    ; request_to_proto = Request.to_proto
    ; request_of_proto = Request.of_proto
    ; response_to_proto = Response.to_proto
    ; response_of_proto = Response.of_proto
    ; client_rpc
    ; server_rpc
    }
;;

module type S = sig
  module Request : sig
    type t [@@deriving equal, sexp_of]
  end

  module Response : sig
    type t [@@deriving equal, sexp_of]
  end

  val rpc : (Request.t, Response.t) Rpc.t
end

type ('request, 'response) t =
  (module S with type Request.t = 'request and type Response.t = 'response)

module Make
    (Request : Protoable.S)
    (Response : Protoable.S)
    (Protospec :
       Protospec.S
       with type request := Request.Proto.t
        and type response := Response.Proto.t) =
struct
  let rpc =
    make
      ~client_rpc:Protospec.client_rpc
      ~server_rpc:Protospec.server_rpc
      (module Request)
      (module Response)
  ;;
end

let client_rpc
  : type request response.
    (request, response) t -> (request, unary, response, unary) Pbrt_services.Client.rpc
  =
  fun t ->
  let module T = (val t : S with type Request.t = request and type Response.t = response)
  in
  match T.rpc with
  | Rpc.T { client_rpc; _ } -> client_rpc
;;

let server_rpc
  : type request response.
    (request, response) t -> (request, unary, response, unary) Pbrt_services.Server.rpc
  =
  fun t ->
  let module T = (val t : S with type Request.t = request and type Response.t = response)
  in
  match T.rpc with
  | Rpc.T { server_rpc; _ } -> server_rpc
;;

let server
  : type request response.
    (request, response) t -> handler:'a -> 'a Pbrt_services.Server.t
  =
  fun t ~handler ->
  let module T = (val t : S with type Request.t = request and type Response.t = response)
  in
  match T.rpc with
  | Rpc.T { client_rpc; _ } ->
    { Pbrt_services.Server.service_name = client_rpc.service_name
    ; package = client_rpc.package
    ; handlers = [ handler ]
    }
;;
