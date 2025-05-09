(** Specifications for services. *)

(** {1 Creating RPC apis} *)

module Rpc : sig
  type ('request, 'response) t
end

module Protoable : sig
  module type S = sig
    type t [@@deriving equal, sexp_of]

    module Proto : sig
      type t
    end

    val of_proto : Proto.t -> t
    val to_proto : t -> Proto.t
  end
end

type unary = Pbrt_services.Value_mode.unary

module Protospec : sig
  module type S = sig
    type request
    type response

    val client_rpc : (request, unary, response, unary) Pbrt_services.Client.rpc
    val server_rpc : (request, unary, response, unary) Pbrt_services.Server.rpc
  end
end

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
    (_ :
       Protospec.S
       with type request := Request.Proto.t
        and type response := Response.Proto.t) :
  S with module Request := Request and module Response := Response

(** {1 Twirp_ezcurl Utils}

    The rest of the module contains utils to help creating what is required by
    the [Twirp_ezcurl] library. *)

val client_rpc
  :  ('request, 'response) t
  -> ('request, unary, 'response, unary) Pbrt_services.Client.rpc

val server_rpc
  :  ('request, 'response) t
  -> ('request, unary, 'response, unary) Pbrt_services.Server.rpc

(** Return the rpc wrapped into a server value with a single handler.
    This is abusing the [Twirp_tiny_httpd] api that require that
    wrapped value. This is outside of the intended usage, so we should
    probably revisit at some point. *)
val server : _ t -> handler:'a -> 'a Pbrt_services.Server.t

module Private : sig
  (** The [Private] module is not meant to be used by the users of the library
      directly. It is exported for tests. *)

  val encode_request : ('request, _) t -> 'request -> string
  val decode_request : ('request, _) t -> string -> 'request
  val encode_response : (_, 'response) t -> 'response -> string
  val decode_response : (_, 'response) t -> string -> 'response
end
