open Req

(**[https://opensearch.org/docs/latest/api-reference/index-apis/create-index/]

   While you can create an index by using a document as a base, you
   can also create an empty index for later use.

   When creating an index, you can specify its mappings, settings,
   and aliases. *)
module Create = struct
  (** Specifies the number of active shards that must be available before
      OpenSearch processes the request.
      Default is 1 (only the primary shard). Set to all or a positive
      integer. Values greater than 1 require replicas. For example, if
      you specify a value of 3, the index must have two replicas
      distributed across two additional nodes for the request to
      succeed.*)
  let with_wait_for_active_shards str params = ("wait_for_active_shards", str) :: params

  (** How long to wait for a connection to the cluster manager node.
      Default is 30s. *)
  let with_cluster_manager_timeout d params =
    ("cluster_manager_timeout", Duration.to_string d) :: params
  ;;

  (** How long to wait for the request to return. Default is 30s. *)
  let with_timeout d params = ("timeout", Duration.to_string d) :: params

  let put index params = new_req `PUT ("/" ^ index) params
end

(** [https://opensearch.org/docs/latest/api-reference/index-apis/delete-index/]

    If you no longer need an index, you can use the delete index API
    operation to delete it. *)
module Delete = struct
  (** Whether to ignore wildcards that don’t match any indexes. Default
      is true. *)
  let with_allow_no_indices b params =
    ("allow_no_indices", Param.bool_to_string b) :: params
  ;;

  (** Expands wildcard expressions to different indexes. Combine multiple
      values with commas. Available values are all (match all indexes), open
      (match open indexes), closed (match closed indexes), hidden (match
      hidden indexes), and none (do not accept wildcard expressions), which
      must be used with open, closed, or both. Default is open. *)
  let with_expand_wildcards str params = ("expand_wildcards", str) :: params

  (** If true, OpenSearch does not include missing or closed indexes in
      the response. *)
  let with_ignore_unavailable b params =
    ("ignore_unavailable", Param.bool_to_string b) :: params
  ;;

  (** How long to wait for a connection to the cluster manager node.
      Default is 30s. *)
  let with_cluster_manager_timeout d params =
    ("cluster_manager_timeout", Duration.to_string d) :: params
  ;;

  (** How long to wait for the response to return. Default is 30s. *)
  let with_timeout d params = ("timeout", Duration.to_string d) :: params

  let delete index params = new_req `DELETE ("/" ^ index) params
end

(** [https://opensearch.org/docs/latest/api-reference/index-apis/exists/]

    The index exists API operation returns whether or not an index already
    exists. *)
module Exists = struct
  (** Whether to ignore wildcards that don’t match any indexes. Default
      is true. *)
  let with_allow_no_indices b params =
    ("allow_no_indices", Param.bool_to_string b) :: params
  ;;

  (** Expands wildcard expressions to different indexes. Combine
      multiple values with commas. Available values are all (match all
      indexes), open (match open indexes), closed (match closed indexes),
      hidden (match hidden indexes), and none (do not accept wildcard
      expressions). Default is open. *)
  let with_expand_wildcards str params = ("expand_wildcards", str) :: params

  (** Whether to return settings in the flat form, which can improve
      readability, especially for heavily nested settings. For example, the
      flat form of [“index”: { “creation_date”: “123456789” }] is
      [“index.creation_date”: “123456789”]. *)
  let with_flat_settings b params = ("flat_settings", Param.bool_to_string b) :: params

  (** Whether to include default settings as part of the response. This
      parameter is useful for identifying the names and current values of
      settings you want to update. *)
  let with_include_defaults b params =
    ("include_defaults", Param.bool_to_string b) :: params
  ;;

  (** If true, OpenSearch does not search for missing or closed indexes.
      Default is false. *)
  let with_ignore_unavailable b params =
    ("ignore_unavailable", Param.bool_to_string b) :: params
  ;;

  (** Whether to return information from only the local node instead of
      from the cluster manager node. Default is false. *)
  let with_local b params = ("local", b) :: params

  let head index params = new_req `HEAD (Fmt.str "%s" index) params
end

(** [https://opensearch.org/docs/latest/api-reference/index-apis/get-index/]

    You can use the get index API operation to return information about an
    index.*)
module Get = struct
  (** Whether to ignore wildcards that don’t match any indexes. Default
      is true. *)

  let with_allow_no_indices b params =
    (" allow_no_indices", Param.bool_to_string b) :: params
  ;;

  (** Expands wildcard expressions to different indexes. Combine
      multiple values with commas. Available values are all (match all
      indexes), open (match open indexes), closed (match closed indexes),
      hidden (match hidden indexes), and none (do not accept wildcard
      expressions), which must be used with open, closed, or both. Default
      is open. *)

  let with_expand_wildcards str params = ("expand_wildcards", str) :: params

  (** Whether to return settings in the flat form, which can improve
readability, especially for heavily nested settings. For example, the
flat form of “index”: { “creation_date”: “123456789” } is
“index.creation_date”: “123456789”. *)

  let with_flat_settings b params = ("flat_settings", Param.bool_to_string b) :: params

  (** Whether to include default settings as part of the response. This
      parameter is useful for identifying the names and current values of
      settings you want to update. *)

  let with_include_defaults b params =
    ("include_defaults", Param.bool_to_string b) :: params
  ;;

  (** If true, OpenSearch does not include missing or closed indexes in
      the response. *)

  let with_ignore_unavailable b params =
    ("ignore_unavailable", Param.bool_to_string b) :: params
  ;;

  (** Whether to return information from only the local node instead of
      from the cluster manager node. Default is false. *)

  let with_local b params = ("local", Param.bool_to_string b) :: params

  (** How long to wait for a connection to the cluster manager node.
      Default is 30s. *)
  let with_cluster_manager_timeout d params =
    ("cluster_manager_timeout", Duration.to_string d) :: params
  ;;

  let get index params = new_req `GET (Fmt.str "%s" index) params
end

(** [https://opensearch.org/docs/latest/api-reference/index-apis/open-index/]

    The open index API operation opens a closed index, letting you add or
    search for data within the index. *)
module Open = struct
  (** Whether to ignore wildcards that don’t match any indexes. Default
      is true. *)
  let with_allow_no_indices b params =
    ("allow_no_indices", Param.bool_to_string b) :: params
  ;;

  (** Expands wildcard expressions to different indexes. Combine
      multiple values with commas. Available values are all (match all
      indexes), open (match open indexes), closed (match closed indexes),
      hidden (match hidden indexes), and none (do not accept wildcard
      expressions). Default is open. *)
  let with_expand_wildcards str params = ("expand_wildcards", str) :: params

  (** If true, OpenSearch does not search for missing or closed indexes.
      Default is false. *)
  let with_ignore_unavailable b params =
    ("ignore_unavailable", Param.bool_to_string b) :: params
  ;;

  (** Specifies the number of active shards that must be available
      before OpenSearch processes the request. Default is 1 (only the
      primary shard). Set to all or a positive integer. Values greater than
      1 require replicas. For example, if you specify a value of 3, the
      index must have two replicas distributed across two additional nodes
      for the request to succeed. *)
  let with_wait_for_active_shards str params = ("wait_for_active_shards", str) :: params

  (** How long to wait for a connection to the cluster manager node.
      Default is 30s. *)
  let with_cluster_manager_timeout d params =
    ("cluster_manager_timeout", Duration.to_string d) :: params
  ;;

  (** How long to wait for a response from the cluster. Default is 30s. *)
  let with_timeout d params = ("timeout", Duration.to_string d) :: params

  (** When set to false, the request returns immediately instead of
      after the operation is finished. To monitor the operation status, use
      the Tasks API with the task ID returned by the request. Default is
      true. *)
  let with_wait_for_completion b params =
    ("wait_for_completion", Param.bool_to_string b) :: params
  ;;

  (** The explicit task execution timeout. Only useful when
      wait_for_completion is set to false. Default is 1h. *)
  let with_task_execution_timeout d params =
    ("task_execution_timeout", Duration.to_string d) :: params
  ;;

  let post index params = new_req `POST (Fmt.str "/%s/_open" index) params
end

(** [https://opensearch.org/docs/latest/api-reference/index-apis/close-index/]

    The close index API operation closes an index. Once an index is
    closed, you cannot add data to it or search for any data within the
    index.*)
module Close = struct
  (** Whether to ignore wildcards that don’t match any indexes. Default
      is true. *)
  let with_allow_no_indices b params =
    ("allow_no_indices", Param.bool_to_string b) :: params
  ;;

  (** Expands wildcard expressions to different indexes. Combine
      multiple values with commas. Available values are all (match all
      indexes), open (match open indexes), closed (match closed indexes),
      hidden (match hidden indexes), and none (do not accept wildcard
      expressions). Default is open. *)
  let with_expand_wildcards str params = ("expand_wildcards", str) :: params

  (** If true, OpenSearch does not search for missing or closed indexes.
      Default is false. *)
  let with_ignore_unavailable b params = ("ignore_unavailable", b) :: params

  (** Specifies the number of active shards that must be available
      before OpenSearch processes the request. Default is 1 (only the
      primary sharDuration.to_string b). Set to all or a positive integer.
      Values greater than 1 require replicas. For example, if you specify a
      value of 3, the index must have two replicas distributed across two
      additional nodes for the request to succeed. *)
  let with_wait_for_active_shards str params = ("wait_for_active_shards", str) :: params

  (** How long to wait for a connection to the cluster manager node.
      Default is 30s. *)
  let with_cluster_manager_timeout d params = ("cluster_manager_timeout", d) :: params

  (** How long to wait for a response from the cluster. Default is 30s.*)
  let with_timeout d params = ("timeout", d) :: params

  let post index params = new_req `POST (Fmt.str "/%s/_close" index) params
end

(** [https://opensearch.org/docs/latest/api-reference/index-apis/clear-index-cache/]

    The clear cache API operation clears the caches of one or more
    indexes. For data streams, the API clears the caches of the stream’s
    backing indexes.

    If you use the Security plugin, you must have the [manage index]
    privileges. *)
module ClearCache = struct
  (** Whether to ignore wildcards, index aliases, or _all target (target
      path parameter) values that don’t match any indexes. If false, the
      request returns an error if any wildcard expression, index alias, or
      _all target value doesn’t match any indexes. This behavior also
      applies if the request targets include other open indexes. For
      example, a request where the target is fig*,app* returns an error if
      an index starts with fig but no index starts with app. Defaults to
      true. *)
  let with_allow_no_indices b params =
    (" allow_no_indices", Param.bool_to_string b) :: params
  ;;

  (** Determines the index types that wildcard expressions can expand
      to. Accepts multiple values separated by a comma, such as open,hidden.
      Valid values are: [all] – Expand to open, closed, and hidden indexes.
      [open] – Expand only to open indexes. [closed] – Expand only to closed
      indexes [hidden] – Expand to include hidden indexes. Must be combined
      with [open], [closed], or both. [none] – Expansions are not accepted.
      Defaults to [open]. *)
  let with_expand_wildcards str params = ("expand_wildcards", str) :: params

  (** If true, clears the fields cache. Use the fields parameter to
      clear specific fields’ caches. Defaults to true. *)
  let with_fielddata b params = ("fielddata", Param.bool_to_string b) :: params

  (** Used in conjunction with the fielddata parameter. Comma-delimited
      list of field names that are cleared out of the cache. Does not
      support objects or field aliases. Defaults to all fields. *)
  let with_fields str params = ("fields", str) :: params

  (** If true, clears the unused entries from the file cache on nodes
      with the Search role. Defaults to false. *)
  let with_file b params = ("file", Param.bool_to_string b) :: params

  (** Comma-delimited list of index names that are cleared out of the
      cache. *)
  let with_index str params = ("index", str) :: params

  (** If true, OpenSearch ignores missing or closed indexes. Defaults to
      false. *)
  let with_ignore_unavailable b params =
    ("ignore_unavailable", Param.bool_to_string b) :: params
  ;;

  (** If true, clears the query cache. Defaults to true. *)
  let with_query b params = ("query", Param.bool_to_string b) :: params

  (** If true, clears the request cache. Defaults to true. *)
  let with_request b params = ("request", Param.bool_to_string b) :: params

  let post index params = new_req `POST (Fmt.str "/%s/_cache/clear" index) params
end

(** [https://opensearch.org/docs/latest/api-reference/index-apis/clone/]

    The clone index API operation clones all data in an existing read-only
    index into a new index. The new index cannot already exist. *)
module Clone = struct
  (** The number of active shards that must be available before
      OpenSearch processes the request. Default is 1 (only the primary
      sharDuration.to_string d). Set to all or a positive integer. Values
      greater than 1 require replicas. For example, if you specify a value
      of 3, the index must have two replicas distributed across two
      additional nodes for the operation to succeed. *)
  let with_wait_for_active_shards str params = ("wait_for_active_shards", str) :: params

  (** How long to wait for a connection to the cluster manager node.
      Default is 30s. *)
  let with_cluster_manager_timeout d params =
    ("cluster_manager_timeout", Duration.to_string d) :: params
  ;;

  (** How long to wait for the request to return. Default is 30s. *)
  let with_timeout d params = ("timeout", Duration.to_string d) :: params

  (** When set to false, the request returns immediately instead of
      after the operation is finished. To monitor the operation status, use
      the Tasks API with the task ID returned by the request. Default is
      true. *)
  let with_wait_for_completion b params =
    ("wait_for_completion", Param.bool_to_string b) :: params
  ;;

  (** The explicit task execution timeout. Only useful when
      wait_for_completion is set to false. Default is 1h. *)
  let with_task_execution_timeout d params =
    ("task_execution_timeout", Duration.to_string d) :: params
  ;;

  let post src dst params = new_req `POST (Fmt.str "/%s/_clone/%s" src dst) params
end

(** [https://opensearch.org/docs/latest/api-reference/index-apis/put-mapping/]

    If you want to create or add mappings and fields to an index, you can
    use the put mapping API operation. For an existing mapping, this
    operation updates the mapping.

    You can’t use this operation to update mappings that already map to
    existing data in the index. You must first create a new index with
    your desired mappings, and then use the reindex API operation to map
    all the documents from your old index to the new index. If you don’t
    want any downtime while you re-index your indexes, you can use
    aliases. *)
module CreateMappings = struct
  (** Whether to ignore wildcards that don’t match any indexes. Default
      is true. *)
  let with_allow_no_indices b params =
    (" allow_no_indices", Param.bool_to_string b) :: params
  ;;

  (** Expands wildcard expressions to different indexes. Combine
      multiple values with commas. Available values are all (match all
      indexes), open (match open indexes), closed (match closed indexes),
      hidden (match hidden indexes), and none (do not accept wildcard
      expressions), which must be used with open, closed, or both. Default
      is open. *)
  let with_expand_wildcards str params = ("expand_wildcards", str) :: params

  (** If true, OpenSearch does not include missing or closed indexes in
      the response. *)
  let with_ignore_unavailable b params =
    ("ignore_unavailable", Param.bool_to_string b) :: params
  ;;

  (** Use this parameter with the ip_range data type to specify that
      OpenSearch should ignore malformed fields. If true, OpenSearch does
      not include entries that do not match the IP range specified in the
      index in the response. The default is false. *)
  let with_ignore_malformed b params =
    ("ignore_malformed", Param.bool_to_string b) :: params
  ;;

  (** How long to wait for a connection to the cluster manager node.
      Default is 30s. *)
  let with_cluster_manager_timeout d params =
    ("cluster_manager_timeout", Duration.to_string d) :: params
  ;;

  (** How long to wait for the response to return. Default is 30s. *)
  let with_timeout d params = ("timeout", Duration.to_string d) :: params

  (** Whether OpenSearch should apply mapping updates only to the write
      index. *)
  let with_write_index_only b params =
    ("write_index_only", Param.bool_to_string b) :: params
  ;;

  let put index params = new_req `PUT (Fmt.str "/%s/_mapping" index) params
end

(** [https://opensearch.org/docs/latest/api-reference/index-apis/dangling-index/]

    After a node joins a cluster, dangling indexes occur if any shards
    exist in the node’s local directory that do not already exist in the
    cluster. Dangling indexes can be listed, deleted, or imported. *)
module Dangling = struct
  (** Must be set to true for an import or delete because OpenSearch is
      unaware of where the dangling index data came from. *)
  let with_accept_data_loss b params =
    ("accept_data_loss", Param.bool_to_string b) :: params
  ;;

  (** The amount of time to wait for a response. If no response is
      received in the defined time period, an error is returned. Default is
      30 seconds. *)
  let with_timeout d units params = ("timeout", d units) :: params

  (** The amount of time to wait for a connection to the cluster
      manager. If no response is received in the defined time period, an
      error is returned. Default is 30 seconds. *)
  let with_cluster_manager_timeout d units params =
    ("cluster_manager_timeout", d units) :: params
  ;;

  let get params = new_req `GET "/_dangling" params
  let post uuid params = new_req `POST (Fmt.str "/_dangling/%s" uuid) params
  let delete uuid params = new_req `DELETE (Fmt.str "/_dangling/%s" uuid) params
end

(** [https://opensearch.org/docs/latest/api-reference/index-apis/force-merge/]

    The force merge API operation forces a merge on the shards of one or
    more indexes. For a data stream, the API forces a merge on the shards
    of the stream’s backing index.

    [The merge operation]

    In OpenSearch, a shard is a Lucene index, which
    consists of segments (or segment files). Segments store the indexed
    data. Periodically, smaller segments are merged into larger ones and
    the larger segments become immutable. Merging reduces the overall
    number of segments on each shard and frees up disk space.

    OpenSearch performs background segment merges that produce segments no
    larger than index.merge.policy.max_merged_segment (the default is 5
    GB).

    [Deleted documents]

    When a document is deleted from an OpenSearch index,
    it is not deleted from the Lucene segment but is rather only marked to
    be deleted. When the segment files are merged, deleted documents are
    removed (or expunged). Thus, merging also frees up space occupied by
    documents marked as deleted.

    [Force Merge API]

    In addition to periodic merging, you can force a
    segment merge using the Force Merge API.

    Use the Force Merge API on an index only after all write requests sent
    to the index are completed. The force merge operation can produce very
    large segments. If write requests are still sent to the index, then
    the merge policy does not merge these segments until they primarily
    consist of deleted documents. This can increase disk space usage and
    lead to performance degradation.

    When you call the Force Merge API, the call is blocked until merge
    completion. If during this time the connection is lost, the force
    merge operation continues in the background. New force merge requests
    sent to the same index will be blocked until the currently running
    merge operation is complete.

    Force merging multiple indexes To force merge multiple indexes, you
    can call the Force Merge API on the following index combinations:

    Multiple indexes One or more data streams containing multiple backing
    indexes One or more index aliases pointing to multiple indexes All
    data streams and indexes in a cluster When you force merge multiple
    indexes, the merge operation is executed on each shard of a node
    sequentially. When the force merge operation is in progress, the
    storage for the shard temporarily increases so that all segments can
    be rewritten into a new segment. When max_num_segments is set to 1,
    the storage for the shard temporarily doubles.

    Force merging data streams It can be useful to force merge data
    streams in order to manage a data stream’s backing indexes, especially
    after a rollover operation. Time-based indexes receive indexing
    requests only during a specified time period. Once that time period
    has elapsed and the index receives no more write requests, you can
    force merge segments of all index shards into one segment. Searches on
    single-segment shards are more efficient because they use simpler data
    structures. *)
module ForceMerge = struct
  (** If false, the request returns an error if any wildcard expression
      or index alias targets any closed or missing indexes. Default is true. *)
  let with_allow_no_indices b params =
    ("allow_no_indices", Param.bool_to_string b) :: params
  ;;

  (** Specifies the types of indexes to which wildcard expressions can
      expand. Supports comma-separated values. Valid values are:

      - [all]: Expand to all open and closed indexes, including hidden indexes.
      - [open]: Expand to open indexes.
      - [closed]: Expand to closed indexes.
      - [hidden]: Include hidden indexes when expanding. Must be combined with open, closed, or both.
      - [none]: Do not accept wildcard expressions.
        Default is open. *)
  let with_expand_wildcards str params = ("expand_wildcards", str) :: params

  (** Performs a flush on the indexes after the force merge. A flush
      ensures that the files are persisted to disk. Default is true. *)

  let with_flush b params = ("flush", Param.bool_to_string b) :: params

  (** If true, OpenSearch ignores missing or closed indexes. If false,
      OpenSearch returns an error if the force merge operation encounters
      missing or closed indexes. Default is false. *)
  let with_ignore_unavailable b params =
    ("ignore_unavailable", Param.bool_to_string b) :: params
  ;;

  (** The number of larger segments into which smaller segments are
      merged. Set this parameter to 1 to merge all segments into one
      segment. The default behavior is to perform the merge as necessary. *)
  let with_max_num_segments i params =
    ("max_num_segments", Param.int_to_string i) :: params
  ;;

  (** If true, the merge operation only expunges segments containing a
      certain percentage of deleted documents. The percentage is 10% by
      default and is configurable in the
      [index.merge.policy.expunge_deletes_allowed] setting. Prior to
      OpenSearch 2.12, only_expunge_deletes ignored the
      [index.merge.policy.max_merged_segment] setting. Starting with
      OpenSearch 2.12, using [only_expunge_deletes] does not produce segments
      larger than [index.merge.policy.max_merged_segment] (by default, 5 GB).
      For more information, see Deleted documents. Default is [false]. *)
  let with_only_expunge_deletes b params =
    ("only_expunge_deletes", Param.bool_to_string b) :: params
  ;;

  (** If set to true, then the merge operation is performed only on the
      primary shards of an index. This can be useful when you want to take a
      snapshot of the index after the merge is complete. Snapshots only copy
      segments from the primary shards. Merging the primary shards can
      reduce resource consumption. Default is false. *)
  let with_primary_only b params = ("primary_only", Param.bool_to_string b) :: params

  let post index params = new_req `POST (Fmt.str "/%s/_forcemerge" index) params
end

(** [https://opensearch.org/docs/latest/api-reference/index-apis/get-settings/]
    The get settings API operation returns all the settings in your index. *)
module Settings = struct
  (** Whether to ignore wildcards that don’t match any indexes. Default
      is true. *)
  let with_allow_no_indices b params =
    ("allow_no_indices", Param.bool_to_string b) :: params
  ;;

  (** Expands wildcard expressions to different indexes. Combine
      multiple values with commas. Available values are all (match all
      indexes), open (match open indexes), closed (match closed indexes),
      hidden (match hidden indexes), and none (do not accept wildcard
      expressions), which must be used with open, closed, or both. Default
      is open. *)
  let with_expand_wildcards str params = ("expand_wildcards", str) :: params

  (** Whether to return settings in the flat form, which can improve
readability, especially for heavily nested settings. For example, the
flat form of “index”: { “creation_date”: “123456789” } is
“index.creation_date”: “123456789”. *)
  let with_flat_settings b params = ("flat_settings", Param.bool_to_string b) :: params

  (** Whether to include default settings, including settings used
      within OpenSearch plugins, in the response. Default is false. *)
  let with_include_defaults str params = ("include_defaults", str) :: params

  (** If true, OpenSearch does not include missing or closed indexes in
      the response. *)
  let with_ignore_unavailable b params =
    ("ignore_unavailable", Param.bool_to_string b) :: params
  ;;

  (** Whether to return information from the local node only instead of
      the cluster manager node. Default is false. *)
  let with_local b params = ("local", Param.bool_to_string b) :: params

  (** How long to wait for a connection to the cluster manager node.
      Default is 30s. *)
  let with_cluster_manager_timeout d params =
    ("cluster_manager_timeout", Duration.to_string d) :: params
  ;;

  let get index params = new_req `GET (Fmt.str "/%s/_settings" index) params

  let get_setting index setting params =
    new_req `GET (Fmt.str "/%s/_settings/%s" index setting) params
  ;;
end

(** [https://opensearch.org/docs/latest/api-reference/index-apis/shrink-index/]

    The shrink index API operation moves all of your data in an existing
    index into a new index with fewer primary shards. *)
module Shirnk = struct
  (** Specifies the number of active shards that must be available
      before OpenSearch processes the request. Default is 1 (only the
      primary sharDuration.to_string d). Set to all or a positive integer.
      Values greater than 1 require replicas. For example, if you specify a
      value of 3, the index must have two replicas distributed across two
      additional nodes for the request to succeed. *)
  let with_wait_for_active_shards str params = ("wait_for_active_shards", str) :: params

  (** How long to wait for a connection to the cluster manager node.
      Default is 30s. *)
  let with_cluster_manager_timeout d params =
    ("cluster_manager_timeout", Duration.to_string d) :: params
  ;;

  (** How long to wait for the request to return a response. Default is
      30s. *)
  let with_timeout d params = ("timeout", Duration.to_string d) :: params

  (** When set to false, the request returns immediately instead of
      after the operation is finished. To monitor the operation status, use
      the Tasks API with the task ID returned by the request. Default is
      true. *)
  let with_wait_for_completion b params =
    ("wait_for_completion", Param.bool_to_string b) :: params
  ;;

  (** The explicit task execution timeout. Only useful when
      wait_for_completion is set to false. Default is 1h. *)
  let with_task_execution_timeout d params =
    ("task_execution_timeout", Duration.to_string d) :: params
  ;;

  let post src dst params = new_req `POST (Fmt.str "/%s/_shrink/%s" src dst) params
end

(** [https://opensearch.org/docs/latest/api-reference/index-apis/split/]

    The split index API operation splits an existing read-only index into
    a new index, cutting each primary shard into some amount of primary
    shards in the new index. *)
module Split = struct
  (** The number of active shards that must be available before
      OpenSearch processes the request. Default is 1 (only the primary
      sharDuration.to_string d). Set to all or a positive integer. Values
      greater than 1 require replicas. For example, if you specify a value
      of 3, the index must have two replicas distributed across two
      additional nodes for the operation to succeed. *)
  let with_wait_for_active_shards str params = ("wait_for_active_shards", str) :: params

  (** How long to wait for a connection to the cluster manager node.
      Default is 30s. *)
  let with_cluster_manager_timeout d params =
    ("cluster_manager_timeout", Duration.to_string d) :: params
  ;;

  (** How long to wait for the request to return. Default is 30s. *)
  let with_timeout d params = ("timeout", Duration.to_string d) :: params

  (** When set to false, the request returns immediately instead of
      after the operation is finished. To monitor the operation status, use
      the Tasks API with the task ID returned by the request. Default is
      true. *)
  let with_wait_for_completion b params =
    ("wait_for_completion", Param.bool_to_string b) :: params
  ;;

  (** The explicit task execution timeout. Only useful when
      wait_for_completion is set to false. Default is 1h. *)
  let with_task_execution_timeout d params =
    ("task_execution_timeout", Duration.to_string d) :: params
  ;;

  let post src dst params = new_req `POST (Fmt.str "/%s/_split/%s" src dst) params
end

(** [https://opensearch.org/docs/latest/api-reference/index-apis/stats/]
    The Index Stats API provides index statistics. For data streams, the
    API provides statistics for the stream’s backing indexes. By default,
    the returned statistics are index level. To receive shard-level
    statistics, set the level parameter to shards.

    When a shard moves to a different node, the shard-level statistics for
    the shard are cleared. Although the shard is no longer part of the
    node, the node preserves any node-level statistics to which the shard
    contributed. *)
module Stats = struct
  let get index params = new_req `GET (Fmt.str "/%s/_stats" index) params

  let get_metric index metric params =
    new_req `GET (Fmt.str "/%s/_stats/%s" index metric) params
  ;;
end

(** [https://opensearch.org/docs/latest/api-reference/index-apis/update-settings/]
    You can use the update settings API operation to update index-level
    settings. You can change dynamic index settings at any time, but
    static settings cannot be changed after index creation. For more
    information about static and dynamic index settings, see Create index.

    Aside from the static and dynamic index settings, you can also update
    individual plugins’ settings. To get the full list of updatable
    settings, run GET <target-index>/_settings?include_defaults=true. *)
module UpdateSettings = struct
  (** Whether to ignore wildcards that don’t match any indexes. Default
      is true. *)
  let with_allow_no_indices b params =
    ("allow_no_indices", Param.bool_to_string b) :: params
  ;;

  (** Expands wildcard expressions to different indexes. Combine
      multiple values with commas. Available values are all (match all
      indexes), open (match open indexes), closed (match closed indexes),
      hidden (match hidden indexes), and none (do not accept wildcard
      expressions), which must be used with open, closed, or both. Default
      is open. *)
  let with_expand_wildcards str params = ("expand_wildcards", str) :: params

  (** How long to wait for a connection to the cluster manager node.
      Default is 30s. *)
  let with_cluster_manager_timeout d params =
    ("cluster_manager_timeout", Duration.to_string d) :: params
  ;;

  (** Whether to preserve existing index settings. Default is false. *)
  let with_preserve_existing b params =
    ("preserve_existing", Param.bool_to_string b) :: params
  ;;

  (** How long to wait for a connection to return. Default is 30s. *)
  let with_timeout d params = ("timeout", Duration.to_string d) :: params

  let put index params = new_req `PUT (Fmt.str "/%s/_settings" index) params
end
