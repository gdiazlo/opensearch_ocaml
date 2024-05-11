(** [https://opensearch.org/docs/latest/api-reference/count/]

    The count API gives you quick access to the number of documents that match a query.
    You can also use it to check the document count of an index, data stream, or cluster. *)

open Req

(** If false, the request returns an error if any wildcard expression
    or index alias targets
    any closed or missing indexes. Default is false.*)
let with_allow_no_indices b params =
  ("allow_no_indices", Param.bool_to_string b) :: params
;;

(** The analyzer to use in the query string.*)
let with_analyzer str params = ("analyzer", str) :: params

(** Specifies whether to analyze wildcard and prefix queries. Default
    is false. *)
let with_analyze_wildcard b params =
  ("analyze_wildcard", Param.bool_to_string b) :: params
;;

(** Indicates whether the default operator for a string query should be
    AND or OR. Default is OR. *)
let with_default_operator str params = ("default_operator", str) :: params

(** The default field in case a field prefix is not provided in the
    query string. *)
let with_df str params = ("df", str) :: params

(** Specifies the type of index that wildcard expressions can match.
    Supports comma-separated
    values. Valid values are all (match any index), open (match open,
    non-hidden indexes), closed (match closed, non-hidden indexes),
    hidden (match hidden indexes), and none (deny wildcard
    expressions). Default is open. *)
let with_expand_wildcards str params = ("expand_wildcards", str) :: params

(** Specifies whether to include missing or closed indexes in the
    response. Default is false. *)
let with_ignore_unavailable b params =
  ("ignore_unavailable", Param.bool_to_string b) :: params
;;

(** Specifies whether OpenSearch should accept requests if queries have
    format errors (for example,
    querying a text field for an integer). Default is false.*)
let with_lenient b params = ("lenient", Param.bool_to_string b) :: params

(** Include only documents with a minimum _score value in the result. *)
let with_min_score f params = ("min_score", Param.float_to_string f) :: params

(** Value used to route the operation to a specific shard. *)
let with_routing str params = ("routing", str) :: params

(** Specifies which shard or node OpenSearch should perform the count
    operation on.*)
let with_preference str params = ("preference", str) :: params

(** The maximum number of documents OpenSearch should process before
    terminating the request.*)

let with_terminate_after i params = ("terminate_after", Param.int_to_string i) :: params
let get index params = new_req `GET (index ^ "/_count") params
