open Req

(**  [https://opensearch.org/docs/latest/api-reference/multi-search/]

     As the name suggests, the multi-search operation lets you bundle
     multiple search requests into a single request. OpenSearch then
     executes the searches in parallel, so you get back the response more
     quickly compared to sending one request per search. OpenSearch
     executes each search independently, so the failure of one doesn’t
     affect the others.*)

(** Whether to ignore wildcards that don’t match any indexes. Default
    is true. *)
let with_allow_no_indices b params =
  ("allow_no_indices", Param.bool_to_string b) :: params
;;

(** The time after which the search request will be canceled.
    Supported at both parent and child request levels. The order of
    precedence is:@@1. Child-level parameter@@2. Parent-level
    parameter@@3. Cluster setting.@@Default is -1. *)
let with_cancel_after_time_interval d params =
  ("cancel_after_time_interval", Duration.to_string d) :: params
;;

(** Whether OpenSearch should try to minimize the number of network
    round trips between the coordinating node and remote clusters (only
    applicable to cross-cluster search requests). Default is true. *)
let with_css_minimize_roundtrips b params =
  ("css_minimize_roundtrips", Param.bool_to_string b) :: params
;;

(** Expands wildcard expressions to concrete indexes. Combine multiple
    values with commas. Supported values are all, open, closed, hidden,
    and none. Default is open. *)
let with_expand_wildcards str params = ("expand_wildcards", str) :: params

(** If an index from the indexes list doesn’t exist, whether to ignore
    it rather than fail the query. Default is false. *)
let with_ignore_unavailable b params =
  ("ignore_unavailable", Param.bool_to_string b) :: params
;;

(** The maximum number of concurrent searches. The default depends on
    your node count and search thread pool size. Higher values can improve
    performance, but risk overloading the cluster. *)
let with_max_concurrent_searches i params =
  ("max_concurrent_searches", Param.int_to_string i) :: params
;;

(** Maximum number of concurrent shard requests that each search
    executes per node. Default is 5. Higher values can improve
    performance, but risk overloading the cluster. *)
let with_max_concurrent_shard_requests i params =
  ("max_concurrent_shard_requests", Param.int_to_string i) :: params
;;

(** Default is 128. *)
let with_pre_filter_shard_size i params =
  ("pre_filter_shard_size", Param.int_to_string i) :: params
;;

(** Whether the hits.total property is returned as an integer (true)
    or an object (false). Default is false. *)
let with_rest_total_hits_as_int str params = ("rest_total_hits_as_int", str) :: params

(** Affects relevance score. Valid options are query_then_fetch and
    dfs_query_then_fetch. query_then_fetch scores documents using term and
    document frequencies for the shard (faster, less accurate), whereas
    dfs_query_then_fetch uses term and document frequencies across all
    shards (slower, more accurate). Default is query_then_fetch. *)
let with_search_type str params = ("search_type", str) :: params

(** Whether to prefix aggregation names with their internal types in
    the response. Default is false. *)
let with_typed_keys b params = ("typed_keys", Param.bool_to_string b) :: params

let post params = new_req `POST "/_msearch" params
let post_index index params = new_req `POST (Fmt.str "/%s/_msearch" index) params
