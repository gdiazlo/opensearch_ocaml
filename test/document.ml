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

let index_create (do_req : requester) =
  let params = Param.empty in
  let res = do_req (Api.Index.Create.put "create_index_bulk_test" params) in
  let _ =
    match res with
    | Ok _ -> Alcotest.pass
    | Error str -> Alcotest.failf "index_create error: %s" str
  in
  ()
;;

let index_exists (do_req : requester) =
  let params = Param.empty in
  let res = do_req (Api.Index.Exists.head "create_index_bulk_test" params) in
  let _ =
    match res with
    | Ok _ -> Alcotest.pass
    | Error str -> Alcotest.failf "index_exists error: %s" str
  in
  ()
;;

let bulk_create (do_req : requester) =
  let params = Param.empty in
  let body =
    Bulk.to_body
      (Bulk.init 100 (fun i ->
         Bulk.with_create "create_index_bulk_test" (`Assoc [ "data", `Int i ])))
  in
  let res = do_req ~body (Api.Document.Bulk.post params) in
  let _ =
    match res with
    | Ok _ -> Alcotest.pass
    | Error str -> Alcotest.failf "bulk_create error: %s" str
  in
  ()
;;

let index_delete (do_req : requester) =
  let params = Param.empty in
  let res = do_req (Api.Index.Delete.delete "create_index_bulk_test" params) in
  let _ =
    match res with
    | Ok _ -> Alcotest.pass
    | Error str -> Alcotest.failf "index_delete error: %s" str
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
        ; test_case "bulk_create" bulk_create do_req
        ; test_case "index_delete" index_delete do_req
        ] )
    ]
;;
