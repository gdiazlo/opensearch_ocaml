open! Req

(**[https://opensearch.org/docs/latest/api-reference/scroll/]

   You can use the scroll operation to retrieve a large number of
   results. For example, for machine learning jobs, you can request an
   unlimited number of results in batches.

   To use the scroll operation, add a scroll parameter to the request
   header with a search context to tell OpenSearch how long you need to
   keep scrolling. This search context needs to be long enough to process
   a single batch of results.

   Because search contexts consume a lot of memory, we suggest you don’t
   use the scroll operation for frequent user queries. Instead, use the
   sort parameter with the search_after parameter to scroll responses for
   user queries. *)

(** Specifies the amount of time the search context is maintained. *)
let with_scroll d params = ("scroll", Duration.to_string d) :: params

(** The scroll ID for the search. *)
let with_scroll_id str params = ("scroll_id", str) :: params

(** Whether the hits.total property is returned as an integer (true)
    or an object (false). Default is false. *)
let with_rest_total_hits_as_int b params =
  ("rest_total_hits_as_int", Param.bool_to_string b) :: params
;;

let get id params = new_req `GET (Fmt.str "/_search/scroll/%s" id) params
