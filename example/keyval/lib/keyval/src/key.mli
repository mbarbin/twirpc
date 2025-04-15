type t [@@deriving compare, equal, hash, quickcheck, sexp_of]

include Comparable.S with type t := t

val to_string : t -> string
val of_string : string -> (t, [ `Msg of string ]) Result.t
val v : string -> t
