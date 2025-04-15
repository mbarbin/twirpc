type t

val create : unit -> t
val implement_rpcs : t -> Twirpc_server.t
