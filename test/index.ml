open Opensearch

(**
let () =
  Logs.set_level ~all:true @@ Some Logs.Debug;
  Logs.set_reporter (Logs_fmt.reporter ())
;;
*)

let test_case name f do_req =
  let f () = f do_req in
  Alcotest.test_case name `Quick f
;;

let index_create do_req =
  let params = Param.empty in
  let res = do_req (Api.Index.Create.put "create_index_test" params) in
  let _ =
    match res with
    | Ok _ -> Alcotest.pass
    | Error str -> Alcotest.failf "index_create error: %s" str
  in
  ()
;;

let index_exists do_req =
  let params = Param.empty in
  let res = do_req (Api.Index.Exists.head "create_index_test" params) in
  let _ =
    match res with
    | Ok _ -> Alcotest.pass
    | Error str -> Alcotest.failf "index_create error: %s" str
  in
  ()
;;

let index_get do_req =
  let params = Param.empty in
  let res = do_req (Api.Index.Get.get "create_index_test" params) in
  let _ =
    match res with
    | Ok _ -> Alcotest.pass
    | Error str -> Alcotest.failf "index_create error: %s" str
  in
  ()
;;

let index_close do_req =
  let params = Param.empty in
  let res = do_req (Api.Index.Close.post "create_index_test" params) in
  let _ =
    match res with
    | Ok _ -> Alcotest.pass
    | Error str -> Alcotest.failf "index_create error: %s" str
  in
  ()
;;

let index_open do_req =
  let params = Param.empty in
  let res = do_req (Api.Index.Open.post "create_index_test" params) in
  let _ =
    match res with
    | Ok _ -> Alcotest.pass
    | Error str -> Alcotest.failf "index_create error: %s" str
  in
  ()
;;

let index_clear_cache do_req =
  let params = Param.empty in
  let res = do_req (Api.Index.ClearCache.post "create_index_test" params) in
  let _ =
    match res with
    | Ok _ -> Alcotest.pass
    | Error str -> Alcotest.failf "index_create error: %s" str
  in
  ()
;;

let index_delete do_req =
  let params = Param.empty in
  let res = do_req (Api.Index.Delete.delete "create_index_test" params) in
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
      , [ test_case "index_create" index_create do_req
        ; test_case "index_exists" index_exists do_req
        ; test_case "index_get" index_get do_req
        ; test_case "index_close" index_close do_req
        ; test_case "index_open" index_open do_req
        ; test_case "index_clear_cache" index_clear_cache do_req
        ; test_case "index_delete" index_delete do_req
        ] )
    ]
;;
