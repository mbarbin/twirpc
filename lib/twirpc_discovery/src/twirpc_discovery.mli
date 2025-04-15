(** A simple service discovery via file. This supports only tcp
    servers running on localhost. *)

module Discovery_file = Discovery_file

module Connection_config : sig
  (** The client side of the discovery answers the question: "Where is the
      service running?"

      The intended usage for this library is to add {!arg} to you command line
      parameters, and resolve the {!t} using {!port} in the body of your
      client command. *)

  type t =
    | Tcp of
        { host : [ `Localhost ]
        ; port : int
        }
    | Discovery_file of { path : Fpath.t }
  [@@deriving equal, sexp_of]

  val arg : t Or_error.t Command.Arg.t
  val port : t -> int Or_error.t

  (** Returns the arguments that a client command needs to be supplied to
      rebuild [t] via {!arg}. This is used by tests and by
      [Twirpc_test_helpers.Config.Twirpc_discovery] to create the right invocations for
      clients whose cli uses {!arg}. *)
  val to_args : t -> string list
end

module Listening_config : sig
  (** The server side of the discovery specifies where to serve, and how to
      advertize that information so clients can find you.

      The intended usage for this library is to add {!arg} to you command line
      parameters, and resolve the {!t} using {!port} in the body of your
      server command. Also, you should call {!advertize} after starting to
      serve, to save the discovery information to a file that clients will load. *)

  module Specification : sig
    type t = Tcp of { port : [ `Chosen_by_OS | `Supplied of int ] }
    [@@deriving equal, sexp_of]
  end

  type t =
    { specification : Specification.t
    ; discovery_file : Fpath.t option
    }
  [@@deriving equal, sexp_of]

  val arg : t Or_error.t Command.Arg.t
  val port : t -> int

  (** To be run on the server after starting to listen for connections. If a
      discovery file is created it is attempted to be removed when the supplied
      switch is released. *)
  val advertize : t -> port:int -> unit

  (** Returns the arguments that a server needs to be supplied to rebuild [t]
      via {!arg}. This is used by tests and by
      [Twirpc_test_helpers.Config.Twirpc_discovery] to create the right invocations
      for servers whose cli uses {!arg}. *)
  val to_args : t -> string list
end
