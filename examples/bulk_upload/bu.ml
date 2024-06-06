let list_files sw dir =
  let results = ref [] in
  let re = Re.Posix.compile_pat "CVE-....-" in
  let rec traverse path =
    let dir_fd = Eio.Path.(open_dir ~sw path) in
    Eio.Path.read_dir dir_fd
    |> List.iter (fun entry ->
      let entry_path = Eio.Path.(path / entry) in
      let stat = Eio.Path.stat ~follow:false entry_path in
      match stat.kind with
      | `Directory -> traverse entry_path
      | `Regular_file -> if Re.execp re entry then results := entry_path :: !results
      | _ -> ())
  in
  traverse dir;
  !results
;;

let make_bulk_payload files =
  let open Opensearch.Bulk in
  files
  |> List.map (fun file ->
    let index = "cvelist" in
    let id = Format.asprintf "%a" Eio.Path.pp file in
    let doc = Eio.Path.load file |> Yojson.Safe.from_string in
    with_create index ~id doc)
  |> String.concat "\n"
  |> fun s -> s ^ "\n"
;;


let os_client env =
  let open Opensearch in
  let module MyConfig = struct
    let config =
      Opensearch.Config.(
        default
        |> with_password (Sys.getenv "OPENSEARCH_PASSWORD")
        |> with_user (Sys.getenv "OPENSEARCH_USER")
        |> with_hosts (string_to_host_list (Sys.getenv "OPENSEARCH_HOSTS")))
    ;;

    let client = Transport.make env#net
  end
  in
  let module MyClient = Client.Make (MyConfig) in
  MyClient.do_req
;;

let split_at n lst =
  if n <= 0
  then [], lst
  else (
    let rec loop i acc lst =
      match lst with
      | [] -> List.rev acc, []
      | x :: xs -> if i = 0 then List.rev acc, lst else loop (i - 1) (x :: acc) xs
    in
    loop n [] lst)
;;

let rec retry n f =
  try f () with
  | e ->
    if n > 0
    then (
      Eio_unix.sleep 2.0;
      retry (n - 1) f)
    else raise e
;;

let () =
  Eio_main.run
  @@ fun env ->
    Mirage_crypto_rng_eio.run (module Mirage_crypto_rng.Fortuna) env
    @@ fun () ->
  Eio.Switch.run
  @@ fun sw ->
  let ( / ) = Eio.Path.( / ) in
  let path = Eio.Stdenv.fs env / "/tmp" / "cvelistV5-main" in
  let files = list_files sw path in
  let client = os_client env in
  let rec bulk_insert files =
    match files with
    | [] -> ()
    | lst ->
      let chunk, rest = split_at 200 lst in
      let body = make_bulk_payload chunk |> Cohttp_eio.Body.of_string in
      let params =
        Opensearch.Param.empty |> Opensearch.Api.Document.Bulk.with_refresh "wait_for"
      in
      let res =
        retry 3
        @@ fun () ->
          client sw ~body (Opensearch.Api.Document.Bulk.post params) in
      (match res with
       | Ok _ -> ()
       | Error e -> Eio.traceln "Error: %s\n" e);
      Eio.traceln "Inserted %d files, remain %d\n" (List.length chunk) (List.length rest);
      bulk_insert rest
  in
  bulk_insert files
;;
