type t =
  { hosts : Uri.t list
  ; user : string
  ; password : string
  ; retries : int
  }

let default : t =
  { hosts = [ Uri.of_string "https://localhost:8080" ]
  ; user = ""
  ; password = ""
  ; retries = 0
  }
;;

let with_password password config = { config with password }
let with_user user config = { config with user }
let with_hosts hosts config = { config with hosts }
let with_retries retries config = { config with retries }

let string_to_host_list str =
  String.split_on_char ',' str |> List.map (fun s -> Uri.of_string s)
;;
