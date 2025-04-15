type t = { port : int }

module Serialized_format = struct
  module F = struct
    open Ppx_yojson_conv_lib.Yojson_conv.Primitives

    (* This format is used to serialize the sockaddr into the line of a file
       that is read during the service-discovery via file strategy. *)
    type t = Tcp of { port : int } [@@deriving yojson]
  end

  let of_t = function
    | { port } -> F.Tcp { port }
  ;;

  let to_t = function
    | F.Tcp { port } -> { port }
  ;;

  let yojson_of_t t = F.yojson_of_t (of_t t)
  let of_yojson json = to_t (F.t_of_yojson json)
end

let load ~path =
  In_channel.read_all (Fpath.to_string path)
  |> Yojson.Safe.from_string
  |> Serialized_format.of_yojson
;;

let save t ~path =
  Out_channel.write_all
    (Fpath.to_string path)
    ~data:(Yojson.Safe.to_string (Serialized_format.yojson_of_t t) ^ "\n")
;;
