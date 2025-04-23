module Connection : sig
  type t
end

(** Unix sockets are not supported by the underlying deps used in this project,
    so we've removed that functionality, and require a [port] here. The server
    is assumed to be running on the localhost. *)
val with_connection : port:int -> f:(Connection.t -> 'a) -> 'a

(** call a given RPC [encoding] defaults to [JSON]. *)
val call
  :  ?encoding:[ `JSON | `BINARY ]
  -> ('request, 'response) Twirpc_spec.t
  -> connection:Connection.t
  -> 'request
  -> 'response Or_error.t
