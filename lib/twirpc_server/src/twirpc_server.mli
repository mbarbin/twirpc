module Rpc : sig
  type t

  val make : ('request, 'response) Twirpc_spec.t -> f:('request -> 'response) -> t
end

type t

val implement : Rpc.t list -> t
val add_services : t -> to_server:Tiny_httpd.t -> unit
