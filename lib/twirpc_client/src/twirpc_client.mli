module Connection : sig
  type t
end

val with_connection : port:int -> f:(Connection.t -> 'a Or_error.t) -> 'a Or_error.t

(** call a given RPC [encoding] defaults to [JSON]. *)
val call
  :  ?encoding:[ `JSON | `BINARY ]
  -> ('request, 'response) Twirpc_spec.t
  -> connection:Connection.t
  -> 'request
  -> 'response Or_error.t
