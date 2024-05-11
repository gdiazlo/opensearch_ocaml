type t = string list

exception InvalidDocumentType of string

let empty = []
let to_body bulk = String.concat "\n" bulk
let init = List.init

(** Creates a document if it doesn’t already exist and returns an error
    otherwise. *)
let with_create index ?id doc =
  let open Yojson.Safe in
  let cmd =
    match id with
    | Some id ->
      `Assoc [ "create", `Assoc [ "_index", `String index; "_id", `String id ] ]
    | None -> `Assoc [ "create", `Assoc [ "index", `String index ] ]
  in
  Fmt.str "%s\n%s" (cmd |> to_string) (doc |> to_string)
;;

(**This action deletes a document if it exists. If the document doesn’t
   exist, OpenSearch doesn’t return an error but instead returns
   not_found under result. Delete actions don’t require documents*)
let with_delete index id =
  let open Yojson.Safe in
  let cmd = `Assoc [ "delete", `Assoc [ "_index", `String index; "_id", `String id ] ] in
  Fmt.str "%s" (cmd |> to_string)
;;

(**Index actions create a document if it doesn’t yet exist and replace
   the document if it already exists.*)
let with_index index ?id doc =
  let open Yojson.Safe in
  let cmd =
    match id with
    | Some id -> `Assoc [ "index", `Assoc [ "_index", `String index; "_id", `String id ] ]
    | None -> `Assoc [ "create", `Assoc [ "index", `String index ] ]
  in
  Fmt.str "%s\n%s" (cmd |> to_string) (doc |> to_string)
;;

(**By default, this action updates existing documents and returns an
   error if the document doesn’t exist. The doc can be a full or partial
   JSON document, depending on how much of the document you want to
   update*)
let with_update index id doc =
  let open Yojson.Safe in
  let cmd = `Assoc [ "update", `Assoc [ "_index", `String index; "_id", `String id ] ] in
  Fmt.str "%s\n%s" (cmd |> to_string) (doc |> to_string)
;;

(**To upsert a document, specify doc_as_upsert as true. If a document
   exists, it is updated; if it does not exist, a new document is indexed
   with the parameters specified in the doc field:*)
let with_upsert index id doc =
  let open Yojson.Safe in
  let cmd = `Assoc [ "update", `Assoc [ "_index", `String index; "_id", `String id ] ] in
  let doc =
    match doc with
    | `Assoc doc -> `Assoc [ "doc_as_upsert", `Bool true; doc ]
    | _ -> raise (InvalidDocumentType "upsert docs must be objects")
  in
  Fmt.str "%s\n%s" (cmd |> to_string) (doc |> to_string)
;;

(**You can specify a script for more complex document updates*)
let with_script index ?id script =
  let open Yojson.Safe in
  let cmd =
    match id with
    | Some id ->
      `Assoc [ "update", `Assoc [ "_index", `String index; "_id", `String id ] ]
    | None -> `Assoc [ "update", `Assoc [ "index", `String index ] ]
  in
  Fmt.str "%s\n%s" (cmd |> to_string) (script |> to_string)
;;
