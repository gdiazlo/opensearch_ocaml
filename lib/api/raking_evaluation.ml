open Req

(**[https://opensearch.org/docs/latest/api-reference/rank-eval/]

   The rank eval endpoint allows you to evaluate the quality of ranked
   search results.*)

(** Defaults to false. When set to false the response body will return
    an error if an index is closed or missing. *)
let with_ignore_unavailable b params =
  ("ignore_unavailable", Param.bool_to_string b) :: params
;;

(** Defaults to true. When set to false the response body will return
    an error if a wildcard expression points to indexes that are closed or
    missing. *)
let with_allow_no_indices b params =
  ("allow_no_indices", Param.bool_to_string b) :: params
;;

(** Expand wildcard expressions for indexes that are open, closed,
    hidden, none, or all. *)
let with_expand_wildcards str params = ("expand_wildcards", str) :: params

(** Set search type to either query_then_fetch or
    dfs_query_then_fetch. *)
let with_search_type str params = ("search_type", str) :: params

let post index params = new_req `POST (Fmt.str "/%s/_rank_eval" index) params
