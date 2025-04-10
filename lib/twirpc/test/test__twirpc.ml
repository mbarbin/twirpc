let%expect_test "hello" =
  print_s Twirpc.hello_world;
  [%expect {| "Hello, World!" |}]
;;
