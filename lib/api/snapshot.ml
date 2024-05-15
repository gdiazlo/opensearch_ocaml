open! Req

(**[https://opensearch.org/docs/latest/api-reference/snapshots/index/]

   The snapshot APIs allow you to manage snapshots and snapshot
   repositories. *)

(** [https://opensearch.org/docs/latest/api-reference/snapshots/create-repository/]

    You can register a new repository in which to store snapshots or
    update information for an existing repository by using the snapshots
    API.

    There are two types of snapshot repositories:

    File system (fs): For instructions on creating an fs repository, see
    Register repository shared file system. [https://opensearch.org/docs/latest/tuning-your-cluster/availability-and-recovery/snapshots/snapshot-restore/#shared-file-system]

    Amazon Simple Storage Service (Amazon S3) bucket (s3): For
    instructions on creating an s3 repository, see Register repository
    Amazon S3. [https://opensearch.org/docs/latest/tuning-your-cluster/availability-and-recovery/snapshots/snapshot-restore/#amazon-s3]

    For instructions on creating a repository, see Register repository.
    [https://opensearch.org/docs/latest/opensearch/snapshots/snapshot-restore#register-repository] *)
module RegisterRepository = struct
  let post id params = new_req `POST (Fmt.str "/_snapshot/%s" id) params
end

(** [https://opensearch.org/docs/latest/api-reference/snapshots/get-snapshot-repository/]

    Retrieves information about a snapshot repository.

    To learn more about repositories, see Register repository.

    You can also get details about a snapshot during and after snapshot
    creation. See Get snapshot status. *)
module Get = struct
  (** Whether to get information from the local node. Optional, defaults
      to false. *)
  let with_local b params = ("local", Param.bool_to_string b) :: params

  (** Amount of time to wait for a connection to the master node.
      Optional, defaults to 30 seconds. *)
  let with_cluster_manager_timeout d params =
    ("cluster_manager_timeout", Duration.to_string d) :: params
  ;;

  let get id params = new_req `GET (Fmt.str "/_snapshot/%s" id) params
end

(** [https://opensearch.org/docs/latest/api-reference/snapshots/delete-snapshot-repository/]
    Deletes a snapshot repository configuration.

    A repository in OpenSearch is simply a configuration that maps a
    repository name to a type (file system or s3 repository) along with
    other information depending on the type. The configuration is backed
    by a file system location or an s3 bucket. When you invoke the API,
    the physical file system or s3 bucket itself is not deleted. Only the
    configuration is deleted.

    To learn more about repositories, see Register or update snapshot
    repository. *)
module Delete = struct
  let delete id params = new_req `DELETE (Fmt.str "/_snapshot/%s" id) params
end

(** [https://opensearch.org/docs/latest/api-reference/snapshots/verify-snapshot-repository/]
    Verifies that a snapshot repository is functional. Verifies the
    repository on each node in a cluster.

    If verification is successful, the verify snapshot repository API
    returns a list of nodes connected to the snapshot repository. If
    verification failed, the API returns an error.

    If you use the Security plugin, you must have the manage cluster
    privilege.*)
module Verify = struct
  (** Amount of time to wait for a connection to the master node.
      Optional, defaults to 30s. *)
  let with_cluster_manager_timeout d params =
    ("cluster_manager_timeout", Duration.to_string d) :: params
  ;;

  (** The period of time to wait for a response. If a response is not
      received before the timeout value, the request fails and returns an
      error. Defaults to 30s. *)
  let with_timeout d params = ("timeout", Duration.to_string d) :: params

  let post id params = new_req `POST (Fmt.str "/_snapshot/%s/_verify" id) params
end

(** [https://opensearch.org/docs/latest/api-reference/snapshots/create-snapshot/]

    Creates a snapshot within an existing repository.

    To learn more about snapshots, see Snapshots.

    To view a list of your repositories, see Get snapshot repository. *)
module Create = struct
  (** Whether to wait for snapshot creation to complete before
      continuing. If you include this parameter, the snapshot definition is
      returned after completion. *)
  let with_wait_for_completion b params =
    ("wait_for_completion", Param.bool_to_string b) :: params
  ;;

  let post repository id params =
    new_req `POST (Fmt.str "/_snapshot/%s/%s" repository id) params
  ;;
end

(** [https://opensearch.org/docs/latest/api-reference/snapshots/get-snapshot/]

    Retrieves information about a snapshot. *)
module Get = struct
  (** Whether to show all, or just basic snapshot information. If true,
      returns all information. If false, omits information like start/end
      times, failures, and shards. Optional, defaults to true. *)
  let with_verbose b params = ("verbose", Param.bool_to_string b) :: params

  (** How to handle snapshots that are unavailable (corrupted or
      otherwise temporarily can’t be returned). If true and the snapshot is
      unavailable, the request does not return the snapshot. If false and
      the snapshot is unavailable, the request returns an error. Optional,
      defaults to false. *)
  let with_ignore_unavailable b params =
    ("ignore_unavailable", Param.bool_to_string b) :: params
  ;;

  let get repository id params =
    new_req `GET (Fmt.str "/_snapshot/%s/%s" repository id) params
  ;;
end

(** [https://opensearch.org/docs/latest/api-reference/snapshots/delete-snapshot/]

    Deletes a snapshot from a repository. *)
module Delete = struct
  let delete repository id params =
    new_req `DELETE (Fmt.str "/_snapshot/%s/%s" repository id) params
  ;;
end

(** [https://opensearch.org/docs/latest/api-reference/snapshots/get-snapshot-status/]

    Returns details about a snapshot’s state during and after snapshot
    creation.*)
module GetStatus = struct
  (** How to handles requests for unavailable snapshots. If false, the request returns an error for unavailable snapshots. If true, the request ignores unavailable snapshots, such as those that are corrupted or temporarily cannot be returned. Defaults to false. *)
  let with_ignore_unavailable b params =
    ("ignore_unavailable", Param.bool_to_string b) :: params
  ;;

  let get params = new_req `GET "/_snapshot//_status" params

  let get_repository_status repository params =
    new_req `GET (Fmt.str "/_snapshot/%s/_status" repository) params
  ;;

  let get_repository_snapshot_status repository id params =
    new_req `GET (Fmt.str "/_snapshot/%s/%s/_status" repository id) params
  ;;
end

(** [https://opensearch.org/docs/latest/api-reference/snapshots/restore-snapshot/]

    Restores a snapshot of a cluster or specified data streams and
    indices.

    If open indexes with the same name that you want to restore already
    exist in the cluster, you must close, delete, or rename the indexes.
    See Example request for information about renaming an index. See Close
    index for information about closing an index. *)
module Restore = struct
  (** Whether to wait for snapshot restoration to complete before continuing. *)
  let with_wait_for_completion b params =
    ("wait_for_completion", Param.bool_to_string b) :: params
  ;;

  let post repository id params =
    new_req `POST (Fmt.str "/_snapshot/%s/%s/_restore" repository id) params
  ;;
end
