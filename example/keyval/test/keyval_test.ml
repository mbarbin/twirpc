let executable = "./keyval.exe"

let config =
  Twirpc_test_helpers.Config.twirpc_discovery
    ~run_server_command:{ executable; args = [ "server"; "run" ] }
    ~run_client_command:{ executable; args = [] }
;;
