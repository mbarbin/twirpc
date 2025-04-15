let%expect_test "rountrip" =
  Twirpc_quickcheck.run_exn
    [%here]
    (module Keyval_rpc.Get)
    ~requests:[ Keyval.Key.v "foo"; Keyval.Key.v "bar" ];
  [%expect {||}];
  ()
;;
