open Opensearch

type requester = Eio__core.Switch.t -> ?body:Eio.Flow.source_ty Eio.Resource.t -> Req.t -> (Cohttp_eio__.Body.t, string) result

type cvss = {
  attackComplexity: string;
  attackVector: string;
  availabilityImpact: string;
  baseScore: float;
  baseSeverity: string;
  confidentialityImpact: string;
  integrityImpact: string;
  privilegesRequired: string;
  scope: string;
  userInteraction: string;
  vectorString: string;
  version: string;
}

let cvss_default = {
  attackComplexity = "null";
  attackVector = "null";
  availabilityImpact = "null";
  baseScore = 0.0;
  baseSeverity = "null";
  confidentialityImpact = "null";
  integrityImpact = "null";
  privilegesRequired = "null";
  scope = "null";
  userInteraction = "null";
  vectorString = "null";
  version = "null";
}

type cve = {
  cveId: string;
  title: string;
  score: float;
  description: string;
  state: string;
  datePublished: string;
  cvss: cvss;
}

let parse_or_default f default =
  try f () with
  | _ -> default
;;

let to_string_even_null = function
  | `String s -> s
  | `Null -> "null"
  | `Float f -> string_of_float f
  | _ -> "null"
;;

let format_cvss json =
  let open Yojson.Safe.Util in
  let cvss = json |> member "cvssV3_1" in
  let attackComplexity = cvss |> member "attackComplexity" |> to_string_even_null in
  let attackVector = cvss |> member "attackVector" |> to_string_even_null in
  let availabilityImpact = cvss |> member "availabilityImpact" |> to_string_even_null in
  let baseScore = cvss |> member "baseScore" |> to_float in
  let baseSeverity = cvss |> member "baseSeverity" |> to_string_even_null in
  let confidentialityImpact = cvss |> member "confidentialityImpact" |> to_string_even_null in
  let integrityImpact = cvss |> member "integrityImpact" |> to_string_even_null in
  let privilegesRequired = cvss |> member "privilegesRequired" |> to_string_even_null in
  let scope = cvss |> member "scope" |> to_string_even_null in
  let userInteraction = cvss |> member "userInteraction" |> to_string_even_null in
  let vectorString = cvss |> member "vectorString" |> to_string_even_null in
  let version = cvss |> member "version" |> to_string_even_null in
  {attackComplexity; attackVector; availabilityImpact; baseScore; baseSeverity; confidentialityImpact; integrityImpact; privilegesRequired; scope; userInteraction; vectorString; version}
;;

let format_result res =
  let open Yojson.Safe.Util in
  let hits = res |> member "hits" |> member "hits" |> to_list in
  List.map (fun hit ->
    let score = hit |> member "_score" |> to_float in
    let metadata = hit |> member "_source" |> member "cveMetadata"  in
    let cveId = metadata |> member "cveId" |> to_string in
    let datePublished = metadata |> member "datePublished" |> to_string_even_null in
    let state = metadata |> member "state" |> to_string_even_null in
    let cna = hit |> member "_source" |> member "containers" |> member "cna"  in
    let description = parse_or_default (fun () -> cna |> member "descriptions" |> to_list |> List.hd |> member "value" |> to_string_even_null) "No description available" in
    let title = parse_or_default (fun () -> cna |> member "title" |> to_string_even_null) "No title available" in
    let cvss = parse_or_default (fun () -> cna |> member "metrics" |> to_list |> List.hd |> format_cvss) cvss_default in
    {cveId; title; score; description; state; datePublished; cvss}
  ) hits


let search (osc:requester) query =
  let open Api.Search in
  let params =
    Param.empty
    |> with_q query
    |> with_size 10
    |> with_timeout (1*Duration.second)
   in
  Eio.Switch.run @@ fun sw ->
  let body = Cohttp_eio.Body.of_string "" in
  let res = osc sw ~body (post "cvelist" params) in
  match res with
  | Ok b -> Ok (Eio.Buf_read.(parse_exn take_all) b ~max_size:max_int  |> Yojson.Safe.from_string  |>format_result)
  | Error str -> Error str

let cvss_summary severity =
  let open Dream_html in
  let open HTML in
  match severity with
  | "CRITICAL" -> span [class_ "badge badge-danger"] [txt "%s" severity]
  | "HIGH" -> span [class_ "badge badge-warning"] [txt "%s" severity]
  | "MEDIUM" -> span [class_ "badge badge-info"] [txt "%s" severity]
  | "LOW" -> span [class_ "badge badge-success"] [txt "%s" severity]
  | _ -> span [class_ "badge badge-secondary"] [txt "%s" severity]
;;

let format_cvss cvss =
  let open Dream_html in
  let open HTML in
  details [ ] [
    summary [] [ cvss_summary cvss.baseSeverity];
    ul [class_ "cvss" ] [
      li [] [ span [] [txt "Attack complexity"]; span [] [ txt "%s" cvss.attackComplexity];];
      li [] [ span [] [txt "Attack vector"]; span [] [ txt "%s" cvss.attackVector];];
      li [] [ span [] [txt "Availability impact"]; span [] [ txt "%s" cvss.availabilityImpact];];
      li [] [ span [] [txt "Base score"]; span [] [ txt "%f" cvss.baseScore];];
      li [] [ span [] [txt "Base severity"]; span [] [ txt "%s" cvss.baseSeverity];];
      li [] [ span [] [txt "Confidentiality impact"]; span [] [ txt "%s" cvss.confidentialityImpact];];
      li [] [ span [] [txt "Integrity impact"]; span [] [ txt "%s" cvss.integrityImpact];];
      li [] [ span [] [txt "Privileges required"]; span [] [ txt "%s" cvss.privilegesRequired];];
      li [] [ span [] [txt "Scope"]; span [] [ txt "%s" cvss.scope];];
      li [] [ span [] [txt "User interaction"]; span [] [ txt "%s" cvss.userInteraction];];
      li [] [ span [] [txt "Vector string"]; span [] [ txt "%s" cvss.vectorString];];
      li [] [ span [] [txt "Version"]; span [] [ txt "%s" cvss.version];];
    ];
  ]

let format_cve cve =
  let open Dream_html in
  let open HTML in
  article [] [
    header [] [txt "%s" cve.title];
    div [ class_ "grid"] [
      div [] [
        p [] [txt "%s" cve.cveId];
        hr [];
        p [] [txt "%s" cve.description];
      ];
      div [] [
        format_cvss cve.cvss;
      ];
    ];
    footer [] [
      p [] [txt "Score: %f" cve.score];
      p [] [txt "State: %s" cve.state];
      p [] [txt "Date published: %s" cve.datePublished];
    ];
  ]
;;

let format_cve_list cves =
  let open Dream_html in
  let open HTML in
  div [] [
    ul [] (List.map (fun cve -> li [] [format_cve cve]) cves);
  ]
;;



let error_page str =
  let open Dream_html in
  let open HTML in
  article [] [
    header [] [ h1 [] [txt "Error"]; ];
    pre [] [txt "%s" str];
    footer [] [];
  ]
;;

let results_page cves =
  let open Dream_html in
  let open HTML in
  article [] [
    header [] [ h1 [] [txt "Search results"]; ];
    format_cve_list cves;
    footer [] [];
  ]
;;

let search_bar req =
  let open Dream_html in
  let open HTML in
  article [] [
      header [] [
      h1 [] [txt "Search engine"]; ];
      form [method_ `POST; action "/search"] [
      (* Integrated with Dream's CSRF token generation *)
      csrf_tag req;

      label [for_ "search-box"] [txt "Input your search terms"];
      input [name "query"; id "query"];
      input [type_ "submit"; value "Search"]
    ];
    footer [] [];
  ]
;;

let page n req =
  let open Dream_html in
  let open HTML in
  html [lang "en"] [
    head [] [
      title [] "Search CVE engine" ];
      link [rel "stylesheet"; href "https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.pumpkin.min.css"; ];
      link [rel "stylesheet"; href "static/styles.css"; ];
    body [] [
      main [class_ "container" ] [
        div [] [search_bar req;];
        div [] [n;]
      ]
    ]
  ]
;;

let main_page  =
  let open Dream_html in
  let open HTML in
  article [ ][
    header [] [ h1 [] [txt "Search engine"]; ];
    p [] [ txt "Search cross thousand of vulnerabilities "];
    footer [] [];
  ]
;;

let search_handler req osc =
  let query = Dream.form req in
  match%lwt query with
  | `Ok ["query", q] ->
    (let resp = search osc q in
    match resp with
    | Ok cves ->
            Dream_html.respond (page (results_page cves) req)
    | Error str -> Dream_html.respond (page (error_page str) req))
  |   _ -> Dream_html.respond (page main_page req)
;;

let os_client env =
  let module MyConfig = struct
    let config =  Config.(
      default
      |> with_password (Sys.getenv "OPENSEARCH_PASSWORD")
      |> with_user (Sys.getenv "OPENSEARCH_USER")
      |> with_hosts (string_to_host_list (Sys.getenv "OPENSEARCH_HOSTS")))
      let client = Opensearch.Transport.make env#net
  end in
  let module MyClient = Client.Make(MyConfig) in
  MyClient.do_req
  ;;

let () =
  Eio_main.run
  @@ fun env ->
    let osc = os_client env in

    Dream.run ~port:3000
    @@ Dream.logger
    @@ Dream.memory_sessions
    @@ Dream.router [

      Dream.get "/"  (fun req -> Dream_html.respond (page main_page req));

      Dream.post "/search" (fun req -> search_handler req osc);
      Dream.get "/static/**" (Dream.static "static/")
    ]
