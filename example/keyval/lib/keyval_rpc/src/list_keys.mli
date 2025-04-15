module Request : sig
  type t = unit [@@deriving compare, equal, hash, quickcheck, sexp_of]
end

module Response : sig
  type t = Set.M(Keyval.Key).t [@@deriving compare, equal, hash, quickcheck, sexp_of]
end

include Twirpc_spec.S with module Request := Request and module Response := Response
