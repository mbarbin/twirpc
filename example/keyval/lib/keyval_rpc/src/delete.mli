module Request : sig
  type t = Keyval.Key.t [@@deriving compare, equal, hash, quickcheck, sexp_of]
end

module Response : sig
  type t = unit Or_error.t [@@deriving compare, equal, hash, quickcheck, sexp_of]
end

include Twirpc_spec.S with module Request := Request and module Response := Response
