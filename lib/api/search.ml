(** [https://opensearch.org/docs/latest/api-reference/search/]
    The Search API operation lets you execute a search request to search
    your cluster for data. *)
open Req

(** Whether to ignore wildcards that don’t match any indexes. Default
    is true. *)
let with_allow_no_indices b params =
  ("allow_no_indices", Param.bool_to_string b) :: params
;;

(** Whether to return partial results if the request runs into an
    error or times out. Default is true. *)
let with_allow_partial_search_results b params =
  ("allow_partial_search_results", Param.bool_to_string b) :: params
;;

(** Analyzer to use in the query string. *)
let with_analyzer str params = ("analyzer", str) :: params

(** Whether the update operation should include wildcard and prefix
    queries in the analysis. Default is false. *)
let with_analyze_wildcard b params =
  ("analyze_wildcard", Param.bool_to_string b) :: params
;;

(** How many shard results to reduce on a node. Default is 512. *)
let with_batched_reduce_size i params =
  ("batched_reduce_size", Param.int_to_string i) :: params
;;

(** The time after which the search request will be canceled.
    Request-level parameter takes precedence over
    cancel_after_time_interval cluster setting. Default is -1. *)
let with_cancel_after_time_interval d params =
  ("cancel_after_time_interval", Duration.to_string d) :: params
;;

(** Whether to minimize roundtrips between a node and remote clusters.
    Default is true. *)
let with_ccs_minimize_roundtrips b params =
  ("ccs_minimize_roundtrips", Param.bool_to_string b) :: params
;;

(** Indicates whether the default operator for a string query should
    be AND or OR. Default is OR. *)
let with_default_operator str params = ("default_operator", str) :: params

(** The default field in case a field prefix is not provided in the
    query string. *)
let with_df str params = ("df", str) :: params

(** The fields that OpenSearch should return using their docvalue
    forms. *)
let with_docvalue_fields str params = ("docvalue_fields", str) :: params

(** Specifies the type of index that wildcard expressions can match.
    Supports comma-separated values. Valid values are all (match any
    index), open (match open, non-hidden indexes), closed (match closed,
    non-hidden indexes), hidden (match hidden indexes), and none (deny
    wildcard expressions). Default is open. *)
let with_expand_wildcards str params = ("expand_wildcards", str) :: params

(** Whether to return details about how OpenSearch computed the
    document’s score. Default is false. *)
let with_explain b params = ("explain", Param.bool_to_string b) :: params

(** The starting index to search from. Default is 0. *)
let with_from i params = ("from", Param.int_to_string i) :: params

(** Whether to ignore concrete, expanded, or indexes with aliases if
    indexes are frozen. Default is true. *)
let with_ignore_throttled b params =
  ("ignore_throttled", Param.bool_to_string b) :: params
;;

(** Specifies whether to include missing or closed indexes in the
    response. Default is false. *)
let with_ignore_unavailable b params =
  ("ignore_unavailable", Param.bool_to_string b) :: params
;;

(** Specifies whether OpenSearch should accept requests if queries
    have format errors (for example, querying a text field for an
    integer). Default is false. *)
let with_lenient b params = ("lenient", Param.bool_to_string b) :: params

(** How many concurrent shard requests this request should execute on
    each node. Default is 5. *)
let with_max_concurrent_shard_requests i params =
  ("max_concurrent_shard_requests", Param.int_to_string i) :: params
;;

(** Whether to return phase-level took time values in the response.
    Default is false. *)
let with_phase_took b params = ("phase_took", Param.bool_to_string b) :: params

(** A prefilter size threshold that triggers a prefilter operation if
    the request exceeds the threshold. Default is 128 shards. *)
let with_pre_filter_shard_size i params =
  ("pre_filter_shard_size", Param.int_to_string i) :: params
;;

(** Specifies the shards or nodes on which OpenSearch should perform
    the search. For valid values, see The preference query parameter. *)
let with_preference str params = ("preference", str) :: params

(** Lucene query string’s query. *)
let with_q str params = ("q", str) :: params

(** Specifies whether OpenSearch should use the request cache. Default
    is whether it’s enabled in the index’s settings. *)
let with_request_cache b params = ("request_cache", Param.bool_to_string b) :: params

(** Whether to return hits.total as an integer. Returns an object
    otherwise. Default is false. *)
let with_rest_total_hits_as_int b params =
  ("rest_total_hits_as_int", Param.bool_to_string b) :: params
;;

(** Value used to route the update by query operation to a specific
    shard. *)
let with_routing str params = ("routing", str) :: params

(** How long to keep the search context open. *)
let with_scroll d params = ("scroll", Duration.to_string d) :: params

(** Whether OpenSearch should use global term and document frequencies
    when calculating relevance scores. Valid choices are query_then_fetch
    and dfs_query_then_fetch. query_then_fetch scores documents using
    local term and document frequencies for the shard. It’s usually faster
    but less accurate. dfs_query_then_fetch scores documents using global
    term and document frequencies across all shards. It’s usually slower
    but more accurate. Default is query_then_fetch. *)
let with_search_type str params = ("search_type", str) :: params

(** Whether to return sequence number and primary term of the last
    operation of each document hit. *)
let with_seq_no_primary_term b params =
  ("seq_no_primary_term", Param.bool_to_string b) :: params
;;

(** How many results to include in the response. *)
let with_size i params = ("size", Param.int_to_string i) :: params

(** A comma-separated list of <field> : <direction> pairs to sort by. *)
let with_sort fields params = ("sort", fields) :: params

(** Whether to include the _source field in the response. *)
let with__source str params = ("_source", str) :: params

(** A comma-separated list of source fields to exclude from the
    response. *)
let with__source_excludes fields params = ("_source_excludes", fields) :: params

(** A comma-separated list of source fields to include in the
    response. *)
let with__source_includes fields params = ("_source_includes", fields) :: params

(** Value to associate with the request for additional logging. *)
let with_stats str params = ("stats", str) :: params

(** Whether the get operation should retrieve fields stored in the
    index. Default is false. *)
let with_stored_fields b params = ("stored_fields", Param.bool_to_string b) :: params

(** Fields OpenSearch can use to look for similar terms. *)
let with_suggest_field str params = ("suggest_field", str) :: params

(** The mode to use when searching. Available options are always (use
    suggestions based on the provided terms), popular (use suggestions
    that have more occurrences), and missing (use suggestions for terms
    not in the index). *)
let with_suggest_mode str params = ("suggest_mode", str) :: params

(** How many suggestions to return. *)
let with_suggest_size i params = ("suggest_size", Param.int_to_string i) :: params

(** The source that suggestions should be based off of. *)
let with_suggest_text str params = ("suggest_text", str) :: params

(** The maximum number of documents OpenSearch should process before
    terminating the request. Default is 0. *)
let with_terminate_after i params = ("terminate_after", Param.int_to_string i) :: params

(** How long the operation should wait for a response from active
    shards. Default is 1m. *)
let with_timeout d params = ("timeout", Duration.to_string d) :: params

(** Whether to return document scores. Default is false. *)
let with_track_scores b params = ("track_scores", Param.bool_to_string b) :: params

(** Whether to return how many documents matched the query. *)
let with_track_total_hits i params = ("track_total_hits", Param.int_to_string i) :: params

(** Whether returned aggregations and suggested terms should include
    their types in the response. Default is true. *)
let with_typed_keys b params = ("typed_keys", Param.bool_to_string b) :: params

(** Whether to include the document version as a match. *)
let with_version b params = ("version", Param.bool_to_string b) :: params

(** Whether to return scores with named queries. Default is false. *)
let with_include_named_queries_score b params =
  ("include_named_queries_score", Param.bool_to_string b) :: params
;;

let post index params = new_req `POST (Fmt.str "/%s/_search" index) params
