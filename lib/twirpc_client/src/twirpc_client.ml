module Connection = struct
  (* CR mbarbin: I wish to be able to use unix domain sockets. *)

  type t =
    { client : Ezcurl.t
    ; host : string
    ; port : int
    }
end

module Twirp_error = struct
  type t = Twirp_core.Error.error =
    { code : string
    ; msg : string
    }
  [@@deriving sexp_of]
end

let with_connection ~port ~f =
  Ezcurl.with_client
    ~set_opts:(fun _curl -> ())
    (fun client -> f { Connection.client; host = "localhost"; port })
;;

let call ?(encoding = `JSON) rpc ~(connection : Connection.t) request =
  match
    Twirp_ezcurl.call
      ~client:connection.client
      ~encoding
      ~host:connection.host
      ~port:connection.port
      (Twirpc_spec.client_rpc rpc)
      request
  with
  | Ok _ as ok -> ok
  | Error error -> Or_error.error_s (Twirp_error.sexp_of_t error)
;;
