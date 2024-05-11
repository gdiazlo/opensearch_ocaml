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
