open Opensearch

(**
let () =
  Logs.set_level ~all:true @@ Some Logs.Debug;
  Logs.set_reporter (Logs_fmt.reporter ())
;;
*)

type requester = ?body:Cohttp_eio.Body.t -> Req.t -> (Cohttp_eio.Body.t, string) result

let test_case name f (do_req : requester) =
  let f () = f do_req in
  Alcotest.test_case name `Quick f
;;

let get_tasks (do_req : requester) =
  let params = Param.empty in
  let res = do_req (Api.Task.Get.get params) in
  let _ =
    match res with
    | Ok _ -> Alcotest.pass
    | Error str -> Alcotest.failf "index_create error: %s" str
  in
  ()
;;


let () =
  Eio_main.run
  @@ fun env ->
  Mirage_crypto_rng_eio.run (module Mirage_crypto_rng.Fortuna) env
  @@ fun () ->
  let cfg =
    Config.(
      default
      |> with_password (Sys.getenv "OPENSEARCH_PASSWORD")
      |> with_user (Sys.getenv "OPENSEARCH_USER"))
  in
  let module MyConfig = struct
    let config = cfg
    let client = Transport.make env#net
  end
  in
  let module MyClient = Client.Make (MyConfig) in
  Eio.Switch.run
  @@ fun sw ->
  let do_req = MyClient.do_req sw in
  Alcotest.run
    "opensearch"
    [ ( "opensearch client"
      , [ test_case "get_tasks" get_tasks do_req
        ] )
    ]
;;