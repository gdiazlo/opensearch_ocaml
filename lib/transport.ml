let null_auth ?ip:_ ~host:_ _ =
  Ok None (* Warning: use a real authenticator in your code! *)
;;

let https ~authenticator =
  let tls_config = Tls.Config.client ~authenticator () in
  fun uri raw ->
    let host =
      Uri.host uri |> Option.map (fun x -> Domain_name.(host_exn (of_string_exn x)))
    in
    Tls_eio.client_of_flow ?host tls_config raw
;;

let make env = Cohttp_eio.Client.make ~https:(Some (https ~authenticator:null_auth)) env

let create_pool size env =
  let pool = Queue.create () in
  for _ = 1 to size do
    Queue.add (make env) pool
  done;
  pool
;;
