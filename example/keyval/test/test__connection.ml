(* In this test we demonstrate that we can use the OCaml rpc library in tests in
   addition to the cli. *)

let%expect_test "with_connection" =
  let&- t = Twirpc_test_helpers.run in
  let&- { server; client = keyval } =
    Twirpc_test_helpers.with_server t ~config:Keyval_test.config
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
