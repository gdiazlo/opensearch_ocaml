module Make (C : sig
    val config : Config.t
    val client : Cohttp_eio.Client.t
  end) =
struct
  exception NotImplemented of string

  let auth_header : Http.Header.t =
    let credentials = Printf.sprintf "%s:%s" C.config.user C.config.password in
    let encoded_credentials = Base64.encode_exn credentials in
    Http.Header.of_list [ "Authorization", "Basic " ^ encoded_credentials ]
  ;;

  let print_req (req : Req.t) =
    Format.printf "%a\n" Uri.pp (Uri.with_path (List.hd C.config.hosts) req.path)
  ;;

  let get sw headers uri =
    let resp, body = Cohttp_eio.Client.get ~headers ~sw C.client uri in
    if Http.Status.to_int resp.status < 399
    then Ok body
    else Error (Fmt.str "Unexpected HTTP status: %a" Http.Status.pp resp.status)
  ;;

  let put sw headers uri body =
    let resp, body = Cohttp_eio.Client.put ~sw ~body ~headers C.client uri in
    if Http.Status.to_int resp.status < 399
    then Ok body
    else Error (Fmt.str "Unexpected HTTP status: %a" Http.Status.pp resp.status)
  ;;

  let post sw headers uri body =
    let resp, body = Cohttp_eio.Client.post ~sw ~body ~headers C.client uri in
    if Http.Status.to_int resp.status < 399
    then Ok body
    else Error (Fmt.str "Unexpected HTTP status: %a" Http.Status.pp resp.status)
  ;;

  let delete sw headers uri =
    let resp, body = Cohttp_eio.Client.delete ~sw ~headers C.client uri in
    if Http.Status.to_int resp.status < 399
    then Ok body
    else Error (Fmt.str "Unexpected HTTP status: %a" Http.Status.pp resp.status)
  ;;

  let head sw headers uri =
    let resp = Cohttp_eio.Client.head ~sw ~headers C.client uri in
    if Http.Status.to_int resp.status < 399
    then Ok (Cohttp_eio.Body.of_string "")
    else Error (Fmt.str "Unexpected HTTP status: %a" Http.Status.pp resp.status)
  ;;

  let do_req sw ?body req =
    let open Req in
    let uri =
      Uri.add_query_params' (Uri.with_path (List.hd C.config.hosts) req.path) req.params
    in
    let headers = Http.Header.add auth_header "content-type" "application/json" in
    match req.meth with
    | `GET -> get sw headers uri
    | `PUT ->
      let payload =
        match body with
        | Some p -> p
        | None -> Cohttp_eio.Body.of_string ""
      in
      put sw headers uri payload
    | `POST ->
      let payload =
        match body with
        | Some p -> p
        | None -> Cohttp_eio.Body.of_string ""
      in
      post sw headers uri payload
    | `DELETE -> delete sw headers uri
    | `HEAD -> head sw headers uri
  ;;
end
