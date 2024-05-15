open Req

(** [https://opensearch.org/docs/latest/api-reference/explain/]

    Wondering why a specific document ranks higher (or lower) for a query?
    You can use the explain API for an explanation of how the relevance
    score (_score) is calculated for every result.

    OpenSearch uses a probabilistic ranking framework called Okapi BM25 to
    calculate relevance scores. Okapi BM25 is based on the original TF/IDF
    framework used by Apache Lucene.

    Note: The explain API is an expensive operation in terms of both
    resources and time. On production clusters, we recommend using it
    sparingly for the purpose of troubleshooting.*)

(** The analyzer to use in the query string. *)
let with_analyzer str params = ("analyzer", str) :: params

(** Specifies whether to analyze wildcard and prefix queries. Default
    is false. *)
let with_analyze_wildcard b params =
  ("analyze_wildcard", Param.bool_to_string b) :: params
;;

(** Indicates whether the default operator for a string query should
    be AND or OR. Default is OR. *)
let with_default_operator str params = ("default_operator", str) :: params

(** The default field in case a field prefix is not provided in the
    query string. *)
let with_df str params = ("df", str) :: params

(** Specifies whether OpenSearch should ignore format-based query
    failures (for example, querying a text field for an integer). Default
    is false. *)
let with_lenient b params = ("lenient", Param.bool_to_string b) :: params

(** Specifies a preference of which shard to retrieve results from.
    Available options are _local, which tells the operation to retrieve
    results from a locally allocated shard replica, and a custom string
    value assigned to a specific shard replica. By default, OpenSearch
    executes the explain operation on random shards. *)
let with_preference str params = ("preference", str) :: params

(** Query in the Lucene query string syntax. *)
let with_q str params = ("q", str) :: params

(** If true, the operation retrieves document fields stored in the
    index rather than the document’s _source. Default is false. *)
let with_stored_fields b params = ("stored_fields", Param.bool_to_string b) :: params

(** Value used to route the operation to a specific shard. *)
let with_routing str params = ("routing", str) :: params

(** Whether to include the _source field in the response body. Default
    is true. *)
let with__source str params = ("_source", str) :: params

(** A comma-separated list of source fields to exclude in the query
    response. *)
let with__source_excludes str params = ("_source_excludes", str) :: params

(** A comma-separated list of source fields to include in the query
    response. *)
let with__source_includes str params = ("_source_includes", str) :: params

let post index id params = new_req `POST (Fmt.str "/%s/_explain/%s" index id) params
