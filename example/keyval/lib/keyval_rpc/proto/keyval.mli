(** Code for keyval.proto *)

(* generated from "keyval.proto", do not edit *)

(** {2 Types} *)

type key = { key : string } [@@deriving show { with_path = false }, eq]
type keys = { keys : key list } [@@deriving show { with_path = false }, eq]
type value = { value : string } [@@deriving show { with_path = false }, eq]
type error = { error : string } [@@deriving show { with_path = false }, eq]

type value_or_error =
  | Value of value
  | Error of error
[@@deriving show { with_path = false }, eq]

type keyval_pair =
  { key : string
  ; value : string
  }
[@@deriving show { with_path = false }, eq]

type unit_ = unit [@@deriving show { with_path = false }, eq]
type unit_or_error = { error : string } [@@deriving show { with_path = false }, eq]

(** {2 Basic values} *)

(** [default_key ()] is the default value for type [key] *)
val default_key : ?key:string -> unit -> key

(** [default_keys ()] is the default value for type [keys] *)
val default_keys : ?keys:key list -> unit -> keys

(** [default_value ()] is the default value for type [value] *)
val default_value : ?value:string -> unit -> value

(** [default_error ()] is the default value for type [error] *)
val default_error : ?error:string -> unit -> error

(** [default_value_or_error ()] is the default value for type [value_or_error] *)
val default_value_or_error : unit -> value_or_error

(** [default_keyval_pair ()] is the default value for type [keyval_pair] *)
val default_keyval_pair : ?key:string -> ?value:string -> unit -> keyval_pair

(** [default_unit_ ()] is the default value for type [unit_] *)
val default_unit_ : unit

(** [default_unit_or_error ()] is the default value for type [unit_or_error] *)
val default_unit_or_error : ?error:string -> unit -> unit_or_error

(** {2 Protobuf Encoding} *)

(** [encode_pb_key v encoder] encodes [v] with the given [encoder] *)
val encode_pb_key : key -> Pbrt.Encoder.t -> unit

(** [encode_pb_keys v encoder] encodes [v] with the given [encoder] *)
val encode_pb_keys : keys -> Pbrt.Encoder.t -> unit

(** [encode_pb_value v encoder] encodes [v] with the given [encoder] *)
val encode_pb_value : value -> Pbrt.Encoder.t -> unit

(** [encode_pb_error v encoder] encodes [v] with the given [encoder] *)
val encode_pb_error : error -> Pbrt.Encoder.t -> unit

(** [encode_pb_value_or_error v encoder] encodes [v] with the given [encoder] *)
val encode_pb_value_or_error : value_or_error -> Pbrt.Encoder.t -> unit

(** [encode_pb_keyval_pair v encoder] encodes [v] with the given [encoder] *)
val encode_pb_keyval_pair : keyval_pair -> Pbrt.Encoder.t -> unit

(** [encode_pb_unit_ v encoder] encodes [v] with the given [encoder] *)
val encode_pb_unit_ : unit_ -> Pbrt.Encoder.t -> unit

(** [encode_pb_unit_or_error v encoder] encodes [v] with the given [encoder] *)
val encode_pb_unit_or_error : unit_or_error -> Pbrt.Encoder.t -> unit

(** {2 Protobuf Decoding} *)

(** [decode_pb_key decoder] decodes a [key] binary value from [decoder] *)
val decode_pb_key : Pbrt.Decoder.t -> key

(** [decode_pb_keys decoder] decodes a [keys] binary value from [decoder] *)
val decode_pb_keys : Pbrt.Decoder.t -> keys

(** [decode_pb_value decoder] decodes a [value] binary value from [decoder] *)
val decode_pb_value : Pbrt.Decoder.t -> value

(** [decode_pb_error decoder] decodes a [error] binary value from [decoder] *)
val decode_pb_error : Pbrt.Decoder.t -> error

(** [decode_pb_value_or_error decoder] decodes a [value_or_error] binary value from [decoder]
*)
val decode_pb_value_or_error : Pbrt.Decoder.t -> value_or_error

(** [decode_pb_keyval_pair decoder] decodes a [keyval_pair] binary value from [decoder] *)
val decode_pb_keyval_pair : Pbrt.Decoder.t -> keyval_pair

(** [decode_pb_unit_ decoder] decodes a [unit_] binary value from [decoder] *)
val decode_pb_unit_ : Pbrt.Decoder.t -> unit_

(** [decode_pb_unit_or_error decoder] decodes a [unit_or_error] binary value from [decoder]
*)
val decode_pb_unit_or_error : Pbrt.Decoder.t -> unit_or_error

(** {2 Protobuf YoJson Encoding} *)

(** [encode_json_key v encoder] encodes [v] to to json *)
val encode_json_key : key -> Yojson.Basic.t

(** [encode_json_keys v encoder] encodes [v] to to json *)
val encode_json_keys : keys -> Yojson.Basic.t

(** [encode_json_value v encoder] encodes [v] to to json *)
val encode_json_value : value -> Yojson.Basic.t

(** [encode_json_error v encoder] encodes [v] to to json *)
val encode_json_error : error -> Yojson.Basic.t

(** [encode_json_value_or_error v encoder] encodes [v] to to json *)
val encode_json_value_or_error : value_or_error -> Yojson.Basic.t

(** [encode_json_keyval_pair v encoder] encodes [v] to to json *)
val encode_json_keyval_pair : keyval_pair -> Yojson.Basic.t

(** [encode_json_unit_ v encoder] encodes [v] to to json *)
val encode_json_unit_ : unit_ -> Yojson.Basic.t

(** [encode_json_unit_or_error v encoder] encodes [v] to to json *)
val encode_json_unit_or_error : unit_or_error -> Yojson.Basic.t

(** {2 JSON Decoding} *)

(** [decode_json_key decoder] decodes a [key] value from [decoder] *)
val decode_json_key : Yojson.Basic.t -> key

(** [decode_json_keys decoder] decodes a [keys] value from [decoder] *)
val decode_json_keys : Yojson.Basic.t -> keys

(** [decode_json_value decoder] decodes a [value] value from [decoder] *)
val decode_json_value : Yojson.Basic.t -> value

(** [decode_json_error decoder] decodes a [error] value from [decoder] *)
val decode_json_error : Yojson.Basic.t -> error

(** [decode_json_value_or_error decoder] decodes a [value_or_error] value from [decoder]
*)
val decode_json_value_or_error : Yojson.Basic.t -> value_or_error

(** [decode_json_keyval_pair decoder] decodes a [keyval_pair] value from [decoder] *)
val decode_json_keyval_pair : Yojson.Basic.t -> keyval_pair

(** [decode_json_unit_ decoder] decodes a [unit_] value from [decoder] *)
val decode_json_unit_ : Yojson.Basic.t -> unit_

(** [decode_json_unit_or_error decoder] decodes a [unit_or_error] value from [decoder] *)
val decode_json_unit_or_error : Yojson.Basic.t -> unit_or_error

(** {2 Services} *)

(** Keyval service *)
module Keyval : sig
  open Pbrt_services
  open Pbrt_services.Value_mode

  module Client : sig
    val get : (key, unary, value_or_error, unary) Client.rpc
    val set : (keyval_pair, unary, unit_, unary) Client.rpc
    val delete : (key, unary, unit_or_error, unary) Client.rpc
    val listKeys : (unit_, unary, keys, unary) Client.rpc
  end

  module Server : sig
    (** Produce a server implementation from handlers *)
    val make
      :  get:((key, unary, value_or_error, unary) Server.rpc -> 'handler)
      -> set:((keyval_pair, unary, unit_, unary) Server.rpc -> 'handler)
      -> delete:((key, unary, unit_or_error, unary) Server.rpc -> 'handler)
      -> listKeys:((unit_, unary, keys, unary) Server.rpc -> 'handler)
      -> unit
      -> 'handler Pbrt_services.Server.t

    (** The individual server stubs are only exposed for advanced users. Casual users should prefer accessing them through {!make}.
    *)

    val get : (key, unary, value_or_error, unary) Server.rpc
    val set : (keyval_pair, unary, unit_, unary) Server.rpc
    val delete : (key, unary, unit_or_error, unary) Server.rpc
    val listKeys : (unit_, unary, keys, unary) Server.rpc
  end
end
