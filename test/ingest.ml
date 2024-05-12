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

let create_pipeline (do_req : requester) =
  let params = Param.empty in
  let body =
    Cohttp_eio.Body.of_string
      {|{
  "description": "This pipeline processes student data",
  "processors": [
    {
      "set": {
        "description": "Sets the graduation year to 2023",
        "field": "grad_year",
        "value": 2023
      }
    },
    {
      "set": {
        "description": "Sets graduated to true",
        "field": "graduated",
        "value": true
      }
    },
    {
      "uppercase": {
        "field": "name"
      }
    }
  ]
} |}
  in
  let res = do_req ~body (Api.Ingest.CreatePipeline.create "my-pipeline" params) in
  let _ =
    match res with
    | Ok _ -> Alcotest.pass
    | Error str -> Alcotest.failf "index_create error: %s" str
  in
  ()
;;

let simulate_pipeline (do_req : requester) =
  let params = Param.empty in
  let body =
    Cohttp_eio.Body.of_string
      {|{
  "docs": [
    {
      "_index": "my-index",
      "_id": "1",
      "_source": {
        "grad_year": 2024,
        "graduated": false,
        "name": "John Doe"
      }
    },
    {
      "_index": "my-index",
      "_id": "2",
      "_source": {
        "grad_year": 2025,
        "graduated": false,
        "name": "Jane Doe"
      }
    }
  ]
} |}
  in
  let res = do_req ~body (Api.Ingest.SimulatePipeline.simulate "my-pipeline" params) in
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
      , [ test_case "create_pipeline" create_pipeline do_req
        ; test_case "simulate_pipeline" simulate_pipeline do_req
        ] )
    ]
;;
