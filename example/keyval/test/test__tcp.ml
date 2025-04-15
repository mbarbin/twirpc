(* In this test we connect to the server using explicitly the tcp option rather
   than via a unix socket.

   In practice for now this doesn't change anything since unix socket are not
   supported. *)

let%expect_test "using tcp" =
  let&- t = Twirpc_test_helpers.run in
  let&- { server; client = keyval } =
    Twirpc_test_helpers.with_server
      t
      ~config:Keyval_test.config
      ~sockaddr_kind:Tcp_localhost
  in
  (* First lets's store a binding to the store. *)
  keyval [ [ "set" ]; [ "--key"; "foo" ]; [ "--value"; "bar" ] ];
  keyval [ [ "get" ]; [ "--key"; "foo" ] ];
  [%expect {| bar |}];
  (* Now let's start access that binding using the RPC api. *)
  let&- connection = Twirpc_test_helpers.Server.with_connection server in
  let data =
    Twirpc_client.call (module Keyval_rpc.Get) ~connection (Keyval.Key.v "foo")
    |> Or_error.join
    |> Or_error.ok_exn
  in
  print_s [%sexp (data : Keyval.Value.t)];
  [%expect {| bar |}];
  ()
;;
