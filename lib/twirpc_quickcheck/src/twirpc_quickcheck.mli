(** Running roundtrip tests for RPC with quickcheck. *)

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

(** Run 2 quickcheck tests to go over requests and responses and make sure the
    generated inputs roundtrips correctly through serialization. *)
val run_exn
  :  Source_code_position.t
  -> ?config:Base_quickcheck.Test.Config.t
  -> ?requests:'request list
  -> ?responses:'response list
  -> ('request, 'response) t
  -> unit

(** {1 Individual tests} *)

val run_request_exn
  :  Source_code_position.t
  -> ?config:Base_quickcheck.Test.Config.t
  -> ?examples:'request list
  -> ('request, 'response) t
  -> unit

val run_response_exn
  :  Source_code_position.t
  -> ?config:Base_quickcheck.Test.Config.t
  -> ?examples:'response list
  -> ('request, 'response) t
  -> unit
