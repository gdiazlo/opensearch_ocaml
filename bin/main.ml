open Opensearch
open Ppx_yojson_conv_lib.Yojson_conv.Primitives

type t =
  { typ : string
  ; message : string
  }
[@@deriving yojson]

let () =
  Logs.set_reporter (Logs_fmt.reporter ());
  Logs_threaded.enable ()
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
  let open Api in
  let open Yojson.Safe in
  let params = Param.empty in
  let a_doc = { typ = "test"; message = "a test message" } in
  let body = Cohttp_eio.Body.of_string (yojson_of_t a_doc |> to_string) in
  let res = MyClient.do_req sw (Document.Index.post "test" params) ~body in
  match res with
  | Ok b -> print_string @@ Eio.Buf_read.(parse_exn take_all) b ~max_size:max_int
  | Error str -> Fmt.epr "Error: %s\n" str
;;
