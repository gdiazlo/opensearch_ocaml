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
  let get_source index id params = new_req `GET (Fmt.str "%s/_source/%s" index id) params
  let head_source index id params = new_req `GET (Fmt.str "%s/_source/%s" index id) params
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
