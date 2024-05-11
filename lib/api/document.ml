open Req

(** [https://opensearch.org/docs/latest/api-reference/document-apis/index-document/]

    You can use the Index document operation to add a single document to your index. *)
module Index = struct
  (** Only perform the index operation if the document has the specified
      sequence number. *)
  let with_if_seq_no i params = ("if_seq_no", Param.int_to_string i) :: params

  (** Only perform the index operation if the document has the specified
      primary term.*)
  let with_if_primary_term i params = ("if_primary_term", Param.int_to_string i) :: params

  (** Specifies the type of operation to complete with the document.
      Valid values are [create] (index a document only
      if it doesn’t exist) and [index]. If a document ID is included
      in the request, then the default is [index]. Otherwise, the
      default is [create].*)
  let with_op_type str params = ("op_type", str) :: params

  (** Route the index operation to a certain pipeline. *)
  let with_pipeline str params = ("pipeline", str) :: params

  (** value used to assign the index operation to a specific shard.*)
  let with_routing str params = ("routing", str) :: params

  (** If true, OpenSearch refreshes shards to make the operation visible
      to searching. Valid options are [true], [false],
      and [wait_for], which tells OpenSearch to wait for a refresh
      before executing the operation. Default is false.*)
  let with_refresh str params = ("refres", str) :: params

  (** How long to wait for a response from the cluster. Default is 1m. *)
  let with_timeout d params = ("duration", Duration.to_string d) :: params

  (** The document’s version number. *)
  let with_version i params = ("version", Param.int_to_string i) :: params

  (** Assigns a specific type to the document. Valid options are
      [external] (retrieve the document if the specified version number
      is greater than the document’s current version) and
      [external_gte] (retrieve the document if the specified version
      number is greater than or equal to the document’s current
      version). For example, to index version 3 of a document, use
      [/_doc/1?version=3&version_type=external].*)
  let with_version_type str params = ("version_type", str) :: params

  (** The number of active shards that must be available before
      OpenSearch processes the request. Default is 1 (only the primary
      shard).
      Set to [all] or a positive integer. Values greater than [1]
      require replicas. For example, if you specify a value of [3],
      the index must have two replicas distributed across two
      additional nodes for the operation to succeed. *)
  let with_wait_for_active_shards str params = ("wait_for_active_shards", str) :: params

  (** Specifies whether the target index must be an index alias. Default
      is false. *)
  let with_require_alias b params = ("require_alias", Param.bool_to_string b) :: params

  (** adds or updates documents in the index with a specified ID. Used
      for controlled document creation or updates. *)
  let put index id params = new_req `POST (Fmt.str "/%s/_doc/%s" index id) params

  (** adds documents with auto-generated IDs to the index. Useful for
      adding new documents without specifying IDs. *)
  let post index params = new_req `POST (Fmt.str "/%s/_doc" index) params

  (** adds or updates documents in the index with a specified ID. Used
      for controlled document creation or updates.
      Document creation should only occur if the document with the
      specified ID doesn’t already exist.*)
  let put_create index id params =
    new_req `POST (Fmt.str "/%s/_create/%s" index id) params
  ;;

  (** adds documents with auto-generated IDs to the index. Useful for
      adding new documents without specifying IDs.
      Document creation should only occur if the document with the
      specified ID doesn’t already exist.*)
  let post_create index id params =
    new_req `POST (Fmt.str "/%s/_create/%s" index id) params
  ;;
end

(** [https://opensearch.org/docs/latest/api-reference/document-apis/get-documents/]

    After adding a JSON document to your index, you can use the get document API operation to retrieve the document’s information and data. *)
module Get = struct
  (** Specifies a preference of which shard to retrieve results from.
      Available options are _local, which tells the operation to retrieve
      results from a locally allocated shard replica, and a custom string
      value assigned to a specific shard replica. By default, OpenSearch
      executes get document operations on random shards. *)
  let with_preference str params = ("preference", str) :: params

  (** Specifies whether the operation should run in realtime. If false, the
      operation waits for the index to refresh to analyze the source to
      retrieve data, which makes the operation near-realtime. Default is
      true. *)
  let with_realtime b params = ("realtime", Param.bool_to_string b) :: params

  (** If true, OpenSearch refreshes shards to make the get operation
      available to search results. Valid options are true, false, and
      wait_for, which tells OpenSearch to wait for a refresh before
      executing the operation. Default is false. *)
  let with_refresh b params = ("refresh", Param.bool_to_string b) :: params

  (** A value used to route the operation to a specific shard.*)
  let with_routing str params = ("routing", str) :: params

  (** Whether the get operation should retrieve fields stored in the index.
      Default is false
      .*)
  let with_stored_fields b params = ("stored_fields", Param.bool_to_string b) :: params

  (** Whether to include the _source field in the response body. Default is
      true. *)
  let with__source str params = ("_source", str) :: params

  (** A comma-separated list of source fields to exclude in the query
      response. *)
  let with__source_excludes str params = ("_source_excludes", str) :: params

  (** A comma-separated list of source fields to include in the query
      response. *)
  let with__source_includes str params = ("_source_includes", str) :: params

  (** The version of the document to return, which must match the current
      version of the document. *)
  let with_version i params = ("version", Param.int_to_string i) :: params

  (** Retrieves a specifically typed document. Available options are
      external (retrieve the document if the specified version number is
      greater than the document’s current version) and external_gte
      (retrieve the document if the specified version number is greater than
      or equal to the document’s current version). For example, to retrieve
      version 3 of a document, use /_doc/1?version=3&version_type=external. *)
  let with_version_type str params = ("version_type", str) :: params

  let get index id params = new_req `GET (Fmt.str "%s/_doc/%s" index id) params
  let head index id params = new_req `GET (Fmt.str "%s/_doc/%s" index id) params

  (**  Contains the document’s data if found is true. If _source is
       set to false or stored_fields is set to true in the URL
       parameters, this field is omitted.*)
  let get_source index id params = new_req `GET (Fmt.str "%s/_source/%s" index id) params

  (** Contains the document’s data if found is true. If _source is
      set to false or stored_fields is set to true in the URL
      parameters, this field is omitted.*)
  let head_source index id params = new_req `GET (Fmt.str "%s/_source/%s" index id) params
end

(** [https://opensearch.org/docs/latest/api-reference/document-apis/update-document/]

    If you need to update a document’s fields in your index, you can use
    the update document API operation. You can do so by specifying the new
    data you want to be in your index or by including a script in your
    request body, which OpenSearch runs to update the document. By
    default, the update operation only updates a document that exists in
    the index. If a document does not exist, the API returns an error. To
    upsert a document (update the document that exists or index a new
    one), use the upsert operation. *)
module Update = struct
  (** Only perform the update operation if the document has the
      specified sequence number. *)
  let with_if_seq_no i params = ("if_seq_no", Param.int_to_string i) :: params

  (** Perform the update operation if the document has the specified
      primary term. *)
  let with_if_primary_term i params = ("if_primary_term", i) :: params

  (** Language of the script. Default is painless. *)
  let with_lang str params = ("lang", str) :: params

  (** Specifies whether the destination must be an index alias. Default
      is false. *)
  let with_require_alias b params = ("require_alias", Param.bool_to_string b) :: params

  (** If true, OpenSearch refreshes shards to make the operation visible
      to searching. Valid options are true, false, and wait_for, which tells
      OpenSearch to wait for a refresh before executing the operation.
      Default is false. *)
  let with_refresh str params = ("refresh", str) :: params

  (** The amount of times OpenSearch should retry the operation if
      there’s a document conflict. Default is 0. *)
  let with_retry_on_conflict i params = ("retry_on_conflict", i) :: params

  (** Value to route the update operation to a specific shard. *)
  let with_routing str params = ("routing", str) :: params

  (** Whether or not to include the _source field in the response body.
      Default is false. This parameter also supports a comma-separated list
      of source fields for including multiple source fields in the query
      response. *)
  let with__source str params = ("_source", str) :: params

  (** A comma-separated list of source fields to exclude in the query
      response. *)
  let with__source_excludes str params = ("_source_excludes", str) :: params

  (** A comma-separated list of source fields to include in the query
      response. *)
  let with__source_includes str params = ("_source_includes", str) :: params

  (** How long to wait for a response from the cluster. *)
  let with_timeout d params = ("timeout", Duration.to_string d) :: params

  (** The number of active shards that must be available before
      OpenSearch processes the update request. Default is 1 (only the
      primary shard). Set to all or a positive integer. Values greater than
      1 require replicas. For example, if you specify a value of 3, the
      index must have two replicas distributed across two additional nodes
      for the operation to succeed. *)
  let with_wait_for_active_shards str params = ("wait_for_active_shards", str) :: params

  let post index id params = new_req `POST (Fmt.str "%s/_update/%s" index id) params
end

(** [https://opensearch.org/docs/latest/api-reference/document-apis/delete-document/]
    If you no longer need a document in your index, you can use the delete
    document API operation to delete it. *)
module Delete = struct
  (** Only perform the delete operation if the document’s version number
      matches the specified number. *)
  let with_if_seq_no i params = ("if_seq_no", Param.int_to_string i) :: params

  (** Only perform the delete operation if the document has the
      specified primary term. *)
  let with_if_primary_term i params = ("if_primary_term", i) :: params

  (** If true, OpenSearch refreshes shards to make the delete operation
      available to search results. Valid options are true, false, and
      wait_for, which tells OpenSearch to wait for a refresh before
      executing the operation. Default is false. *)
  let with_refresh str params = ("refresh", str) :: params

  (** Value used to route the operation to a specific shard. *)
  let with_routing str params = ("routing", str) :: params

  (** How long to wait for a response from the cluster. Default is 1m. *)
  let with_timeout d params = ("timeout", Duration.to_string d) :: params

  (** The version of the document to delete, which must match the last
      updated version of the document. *)
  let with_version i params = ("version", i) :: params

  (** Retrieves a specifically typed document. Available options are
      external (retrieve the document if the specified version number is
      greater than the document’s current version) and external_gte
      (retrieve the document if the specified version number is greater than
      or equal to the document’s current version). For example, to delete
      version 3 of a document, use /_doc/1?version=3&version_type=external. *)
  let with_version_type str params = ("version_type", str) :: params

  (** The number of active shards that must be available before
      OpenSearch processes the delete request. Default is 1 (only the
      primary shard). Set to all or a positive integer. Values greater than
      1 require replicas. For example, if you specify a value of 3, the
      index must have two replicas distributed across two additional nodes
      for the operation to succeed. *)
  let with_wait_for_active_shards str params = ("wait_for_active_shards", str) :: params

  let delete index id params = new_req `DELETE (Fmt.str "/%s/_doc/%s" index id) params
end

(** [https://opensearch.org/docs/latest/api-reference/document-apis/bulk/]

    The bulk operation lets you add, update, or delete multiple documents
    in a single request. Compared to individual OpenSearch indexing
    requests, the bulk operation has significant performance benefits.
    Whenever practical, we recommend batching indexing operations into
    bulk requests.

    Beginning in OpenSearch 2.9, when indexing documents using the bulk
    operation, the document _id must be 512 bytes or less in size. *)
module Bulk = struct
  (** The pipeline ID for preprocessing documents. *)
  let with_pipeline str params = ("pipeline", str) :: params

  (** Whether to refresh the affected shards after performing the
      indexing operations. Default is [false]. [true] makes the changes show up
      in search results immediately, but hurts cluster performance. [wait_for]
      waits for a refresh. Requests take longer to return, but cluster
      performance doesn’t suffer. *)
  let with_refresh str params = ("refresh", str) :: params

  (** Set to [true] to require that all actions target an index alias
      rather than an index. Default is [false]. *)
  let with_require_alias b params = ("require_alias", Param.bool_to_string b) :: params

  (** Routes the request to the specified shard. *)
  let with_routing str params = ("routing", str) :: params

  (** How long to wait for the request to return. Default [1m]. *)
  let with_timeout d params = ("timeout", Duration.to_string d) :: params

  (** (Deprecated) The default document type for documents that don’t
      specify a type. Default is _doc. We highly recommend ignoring this
      parameter and using a type of _doc for all indexes. *)
  let with_type str params = ("type", str) :: params

  (** Specifies the number of active shards that must be available
      before OpenSearch processes the bulk request. Default is 1 (only the
      primary shard). Set to all or a positive integer. Values greater than
      1 require replicas. For example, if you specify a value of 3, the
      index must have two replicas distributed across two additional nodes
      for the request to succeed. *)
  let with_wait_for_active_shards str params = ("wait_for_active_shards", str) :: params

  let post params = new_req `POST "_bulk" params
end

(**[https://opensearch.org/docs/latest/api-reference/document-apis/multi-get/]
   The multi-get operation allows you to run multiple GET operations in
   one request, so you can get back all documents that match your
   criteria. *)
module MultiGet = struct
  (** Specifies the nodes or shards OpenSearch should execute the
      multi-get operation on. Default is random. *)
  let with_preference str params = ("preference", str) :: params

  (** Specifies whether the operation should run in realtime. If false,
      the operation waits for the index to refresh to analyze the source to
      retrieve data, which makes the operation near-realtime. Default is
      true. *)
  let with_realtime b params = ("realtime", Param.bool_to_string b) :: params

  (** If true, OpenSearch refreshes shards to make the multi-get
      operation available to search results. Valid options are true, false,
      and wait_for, which tells OpenSearch to wait for a refresh before
      executing the operation. Default is false. *)
  let with_refresh b params = ("refresh", Param.bool_to_string b) :: params

  (** Value used to route the multi-get operation to a specific shard.*)
  let with_routing str params = ("routing", str) :: params

  (** Specifies whether OpenSearch should retrieve documents fields from
      the index instead of the document’s _source. Default is false. *)
  let with_stored_fields b params = ("stored_fields", Param.bool_to_string b) :: params

  (** Whether to include the _source field in the query response.
      Default is true. *)
  let with__source str params = ("_source", str) :: params

  (** A comma-separated list of source fields to exclude in the query
      response. *)
  let with__source_excludes str params = ("_source_excludes", str) :: params

  (** A comma-separated list of source fields to include in the query
      response. *)
  let with__source_includes str params = ("_source_includes", str) :: params

  let get index params = new_req `GET (Fmt.str "/%s/_mget" index) params
  let post index params = new_req `POST (Fmt.str "/%s/_mget" index) params
end

(** [https://opensearch.org/docs/latest/api-reference/document-apis/delete-by-query/]

    You can include a query as part of your delete request so OpenSearch
    deletes all documents that match that query. *)
module DeleteByQuery = struct
  (** Whether to ignore wildcards that don’t match any indexes. Default
      is true. *)
  let with_allow_no_indices b params =
    ("allow_no_indices", Param.bool_to_string b) :: params
  ;;

  (** The analyzer to use in the query string. *)
  let with_analyzer str params = ("analyzer", str) :: params

  (** Specifies whether to analyze wildcard and prefix queries. Default
      is false. *)
  let with_analyze_wildcard b params =
    ("analyze_wildcard", Param.bool_to_string b) :: params
  ;;

  (** Indicates to OpenSearch what should happen if the delete by query
      operation runs into a version conflict. Valid options are abort and
      proceed. Default is abort. *)
  let with_conflicts str params = ("conflicts", str) :: params

  (** Indicates whether the default operator for a string query should
      be AND or OR. Default is OR. *)
  let with_default_operator str params = ("default_operator", str) :: params

  (** The default field in case a field prefix is not provided in the
      query string. *)
  let with_df str params = ("df", str) :: params

  (** Specifies the type of index that wildcard expressions can match.
      Supports comma-separated values. Valid values are all (match any
      index), open (match open, non-hidden indexes), closed (match closed,
      non-hidden indexes), hidden (match hidden indexes), and none (deny
      wildcard expressions). Default is open. *)
  let with_expand_wildcards str params = ("expand_wildcards", str) :: params

  (** The starting index to search from. Default is 0. *)
  let with_from i params = ("from", Param.int_to_string i) :: params

  (** Specifies whether to include missing or closed indexes in the
      response. Default is false. *)
  let with_ignore_unavailable b params =
    ("ignore_unavailable", Param.bool_to_string b) :: params
  ;;

  (** Specifies whether OpenSearch should accept requests if queries
      have format errors (for example, querying a text field for an
      integer). Default is false. *)
  let with_lenient b params = ("lenient", Param.bool_to_string b) :: params

  (**How many documents the delete by query operation should process at
     most. Default is all documents.*)
  let with_max_docs i params = ("max_docs", Param.int_to_string i) :: params

  (** Specifies which shard or node OpenSearch should perform the delete
      by query operation on. *)
  let with_preference str params = ("preference", str) :: params

  (** Lucene query string’s query. *)
  let with_q str params = ("q", str) :: params

  (** Specifies whether OpenSearch should use the request cache. Default
      is whether it’s enabled in the index’s settings. *)
  let with_request_cache b params = ("request_cache", Param.bool_to_string b) :: params

  (** If true, OpenSearch refreshes shards to make the delete by query
      operation available to search results. Valid options are true, false,
      and wait_for, which tells OpenSearch to wait for a refresh before
      executing the operation. Default is false. *)
  let with_refresh b params = ("refresh", Param.bool_to_string b) :: params

  (** Specifies the request’s throttling in sub-requests per second.
      Default is -1, which means no throttling. *)
  let with_requests_per_second i params =
    ("requests_per_second", Param.int_to_string i) :: params
  ;;

  (** Value used to route the operation to a specific shard. *)
  let with_routing str params = ("routing", str) :: params

  (** Amount of time the search context should be open. *)
  let with_scroll d params = ("scroll", Duration.to_string d) :: params

  (** Size of the operation’s scroll requests. Default is 1000. *)
  let with_scroll_size i params = ("scroll_size", Param.int_to_string i) :: params

  (** Whether OpenSearch should use global term and document frequencies
      calculating revelance scores. Valid choices are query_then_fetch and
      dfs_query_then_fetch. query_then_fetch scores documents using local
      term and document frequencies for the shard. It’s usually faster but
      less accurate. dfs_query_then_fetch scores documents using global term
      and document frequencies across all shards. It’s usually slower but
      more accurate. Default is query_then_fetch. *)
  let with_search_type str params = ("search_type", str) :: params

  (** How long to wait until OpenSearch deems the request timed out.
      Default is no timeout. *)
  let with_search_timeout d params = ("search_timeout", Duration.to_string d) :: params

  (** How many slices to cut the operation into for faster processing.
      Specify an integer to set how many slices to divide the operation
      into, or use auto, which tells OpenSearch it should decide how many
      slices to divide into. If you have a lot of shards in your index, set
      a lower number for better efficiency. Default is 1, which means the
      task should not be divided. *)
  let with_slices str params = ("slices", str) :: params

  (** A comma-separated list of <field> : <direction> pairs to sort by. *)
  let with_sort str params = ("sort", str) :: params

  (** Specifies whether to include the _source field in the response. *)
  let with__source str params = ("_source", str) :: params

  (** A comma-separated list of source fields to exclude from the
      response. *)
  let with__source_excludes str params = ("_source_excludes", str) :: params

  (** A comma-separated list of source fields to include in the
      response. *)
  let with__source_includes str params = ("_source_includes", str) :: params

  (** Value to associate with the request for additional logging. *)
  let with_stats str params = ("stats", str) :: params

  (** The maximum number of documents OpenSearch should process before
      terminating the request. *)
  let with_terminate_after i params = ("terminate_after", Param.int_to_string i) :: params

  (** How long the operation should wait from a response from active
      shards. Default is 1m. *)
  let with_timeout d params = ("timeout", Duration.to_string d) :: params

  (** Whether to include the document version as a match. *)
  let with_version b params = ("version", Param.bool_to_string b) :: params

  (** The number of shards that must be active before OpenSearch
      executes the operation. Valid values are all or any integer up to the
      total number of shards in the index. Default is 1, which is the
      primary shard. *)
  let with_wait_for_active_shards str params = ("wait_for_active_shards", str) :: params

  (** Setting this parameter to false indicates to OpenSearch it should
      not wait for completion and perform this request asynchronously.
      Asynchronous requests run in the background, and you can use the Tasks
      API to monitor progress. *)
  let with_wait_for_completion b params =
    ("wait_for_completion", Param.bool_to_string b) :: params
  ;;

  let post index params = new_req `POST (Fmt.str "/%s/_delete_by_query" index) params
end

(**[https://opensearch.org/docs/latest/api-reference/document-apis/update-by-query/]

   You can include a query and a script as part of your update request so
   OpenSearch can run the script to update all of the documents that
   match the query. *)
module UpdateByQuery = struct
  (** Whether to ignore wildcards that don’t match any indexes. Default
      is true. *)
  let with_allow_no_indices b params =
    ("allow_no_indices", Param.bool_to_string b) :: params
  ;;

  (** Analyzer to use in the query string. *)
  let with_analyzer str params = ("analyzer", str) :: params

  (** Whether the update operation should include wildcard and prefix
      queries in the analysis. Default is false. *)
  let with_analyze_wildcard b params =
    ("analyze_wildcard", Param.bool_to_string b) :: params
  ;;

  (** Indicates to OpenSearch what should happen if the update by query
      operation runs into a version conflict. Valid options are abort and
      proceed. Default is abort. *)
  let with_conflicts str params = ("conflicts", str) :: params

  (** Indicates whether the default operator for a string query should
      be AND or OR. Default is OR. *)
  let with_default_operator str params = ("default_operator", str) :: params

  (** The default field if a field prefix is not provided in the query
      string. *)
  let with_df str params = ("df", str) :: params

  (** Specifies the type of index that wildcard expressions can match.
      Supports comma-separated values. Valid values are all (match any
      index), open (match open, non-hidden indexes), closed (match closed,
      non-hidden indexes), hidden (match hidden indexes), and none (deny
      wildcard expressions). Default is open. *)
  let with_expand_wildcards str params = ("expand_wildcards", str) :: params

  (** The starting index to search from. Default is 0. *)
  let with_from i params = ("from", Param.int_to_string i) :: params

  (** Whether to exclude missing or closed indexes in the response.
      Default is false. *)
  let with_ignore_unavailable b params =
    ("ignore_unavailable", Param.bool_to_string b) :: params
  ;;

  (** Specifies whether OpenSearch should accept requests if queries
      have format errors (for example, querying a text field for an
      integer). Default is false. *)
  let with_lenient b params = ("lenient", Param.bool_to_string b) :: params

  (** How many documents the update by query operation should process at
      most. Default is all documents. *)
  let with_max_docs i params = ("max_docs", Param.int_to_string i) :: params

  (** ID of the pipeline to use to process documents. *)
  let with_pipeline str params = ("pipeline", str) :: params

  (** Specifies which shard or node OpenSearch should perform the update
      by query operation on. *)
  let with_preference str params = ("preference", str) :: params

  (** Lucene query string’s query. *)
  let with_q str params = ("q", str) :: params

  (** Specifies whether OpenSearch should use the request cache. Default
      is whether it’s enabled in the index’s settings. *)
  let with_request_cache b params = ("request_cache", Param.bool_to_string b) :: params

  (** If true, OpenSearch refreshes shards to make the update by query
      operation available to search results. Valid options are true and
      false. Default is false. *)
  let with_refresh b params = ("refresh", Param.bool_to_string b) :: params

  (** Specifies the request’s throttling in sub-requests per second.
      Default is -1, which means no throttling. *)
  let with_requests_per_second i params =
    ("requests_per_second", Param.int_to_string i) :: params
  ;;

  (** Value used to route the update by query operation to a specific
      shard. *)
  let with_routing str params = ("routing", str) :: params

  (** How long to keep the search context open. *)
  let with_scroll d params = ("scroll", Duration.to_string d) :: params

  (** Size of the operation’s scroll request. Default is 1000. *)
  let with_scroll_size i params = ("scroll_size", Param.int_to_string i) :: params

  (** Whether OpenSearch should use global term and document frequencies
      calculating relevance scores. Valid choices are query_then_fetch and
      dfs_query_then_fetch. query_then_fetch scores documents using local
      term and document frequencies for the shard. It’s usually faster but
      less accurate. dfs_query_then_fetch scores documents using global term
      and document frequencies across all shards. It’s usually slower but
      more accurate. Default is query_then_fetch. *)
  let with_search_type str params = ("search_type", str) :: params

  (** How long to wait until OpenSearch deems the request timed out.
      Default is no timeout. *)
  let with_search_timeout d params = ("search_timeout", Duration.to_string d) :: params

  (** The number slices to split an operation into for faster
      processing, specified by integer. When set to auto OpenSearch it
      should decides how many the number of slices for the operation.
      Default is 1, which indicates an operation will not be split. *)
  let with_slices str params = ("slices", str) :: params

  (** A comma-separated list of <field> : <direction> pairs to sort by. *)
  let with_sort str params = ("sort", str) :: params

  (** Whether to include the _source field in the response. *)
  let with__source str params = ("_source", str) :: params

  (** A comma-separated list of source fields to exclude from the
      response. *)
  let with__source_excludes str params = ("_source_excludes", str) :: params

  (** A comma-separated list of source fields to include in the
      response. *)
  let with__source_includes str params = ("_source_includes", str) :: params

  (** Value to associate with the request for additional logging. *)
  let with_stats str params = ("stats", str) :: params

  (** The maximum number of documents OpenSearch should process before
      terminating the request. *)
  let with_terminate_after i params = ("terminate_after", Param.int_to_string i) :: params

  (** How long the operation should wait from a response from active
      shards. Default is 1m. *)
  let with_timeout d params = ("timeout", Duration.to_string d) :: params

  (** Whether to include the document version as a match. *)
  let with_version b params = ("version", Param.bool_to_string b) :: params

  (** The number of shards that must be active before OpenSearch
      executes the operation. Valid values are all or any integer up to the
      total number of shards in the index. Default is 1, which is the
      primary shard. *)
  let with_wait_for_active_shards str params = ("wait_for_active_shards", str) :: params

  (** When set to false, the response body includes a task ID and
      OpenSearch executes the operation asynchronously. The task ID can be
      used to check the status of the task or to cancel the task. Default is
      set to true. *)
  let with_wait_for_completion boolean params = ("wait_for_completion", boolean) :: params

  let post index params = new_req `POST (Fmt.str "/%s/_update_by_query" index) params
end

(** [https://opensearch.org/docs/latest/api-reference/document-apis/reindex/]

    The reindex document API operation lets you copy all or a subset of
    your data from a source index into a destination index. *)
module Reindex = struct
  (** If true, OpenSearch refreshes shards to make the reindex operation
      available to search results. Valid options are true, false, and
      wait_for, which tells OpenSearch to wait for a refresh before
      executing the operation. Default is false. *)
  let with_refresh b params = (" refresh", Param.bool_to_string b) :: params

  (** How long to wait for a response from the cluster. Default is 30s. *)
  let with_timeout d params = ("timeout", Duration.to_string d) :: params

  (** The number of active shards that must be available before
      OpenSearch processes the reindex request. Default is 1 (only the
      primary sharDuration.to_string d). Set to all or a positive integer.
      Values greater than 1 require replicas. For example, if you specify a
      value of 3, the index must have two replicas distributed across two
      additional nodes for the operation to succeed. *)
  let with_wait_for_active_shards str params = ("wait_for_active_shards", str) :: params

  (** Waits for the matching tasks to complete. Default is false. *)
  let with_wait_for_completion b params =
    ("wait_for_completion", Param.bool_to_string b) :: params
  ;;

  (** Specifies the request’s throttling in sub-requests per second.
      Default is -1, which means no throttling. *)
  let with_requests_per_second i params =
    ("requests_per_second", Param.int_to_string i) :: params
  ;;

  (** Whether the destination index must be an index alias. Default is
      false. *)
  let with_require_alias b params = ("require_alias", Param.bool_to_string b) :: params

  (** How long to keep the search context open. Default is 5m. *)
  let with_scroll d params = ("scroll", Duration.to_string d) :: params

  (** Number of sub-tasks OpenSearch should divide this task into.
      Default is 1, which means OpenSearch should not divide this task.
      Setting this parameter to auto indicates to OpenSearch that it should
      automatically decide how many slices to split the task into. *)
  let with_slices i params = ("slices", Param.int_to_string i) :: params

  (** How many documents the update by query operation should process at
      most. Default is all documents. *)
  let with_max_docs i params = ("max_docs", Param.int_to_string i) :: params

  let post params = new_req `POST "/_reindex" params
end
