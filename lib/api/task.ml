(** [https://opensearch.org/docs/latest/api-reference/tasks/]

    A task is any operation you run in a cluster. For example, searching
    your data collection of books for a title or author name is a task.
    When you run OpenSearch, a task is automatically created to monitor
    your cluster’s health and performance. For more information about all
    of the tasks currently executing in your cluster, you can use the
    tasks API operation. *)

open Req

(** The following request returns information about all of your tasks *)
module Get = struct
  (** A comma-separated list of node IDs or names to limit the returned
      information. Use _local to return information from the node you’re
      connecting to, specify the node name to get information from specific
      nodes, or keep the parameter empty to get information from all nodes. *)
  let with_nodes nodes params = ("nodes", nodes) :: params

  (** A comma-separated list of actions that should be returned. Keep
      empty to return all. *)
  let with_actions actions params = ("actions", actions) :: params

  (** Returns detailed task information. (Default: false) *)
  let with_detailed b params = ("detailed", Param.bool_to_string b) :: params

  (** Returns tasks with a specified parent task ID
      (node_id:task_number). Keep empty or set to -1 to return all. *)
  let with_parent_task_id str params = ("parent_task_id", str) :: params

  (** Waits for the matching tasks to complete. (Default: false) *)
  let with_wait_for_completion b params =
    ("wait_for_completion", Param.bool_to_string b) :: params
  ;;

  (** Groups tasks by parent/child relationships or nodes. (Default:
      nodes) *)
  let with_group_by str params = ("group_by", str) :: params

  (** An explicit operation timeout. (Default: 30 seconds) *)
  let with_timeout d params = ("timeout", Duration.to_string d) :: params

  (** The time to wait for a connection to the primary node. (Default:
      30 seconds) *)
  let with_cluster_manager_timeout d params =
    ("cluster_manager_timeout", Duration.to_string d) :: params
  ;;

  let get params = new_req `GET "/_tasks" params
  let get_id id params = new_req `GET (Fmt.str "/_tasks/%s" id) params
end

module Cancel = struct
  let post params = new_req `POST "/_tasks/_cancel" params
  let post_id id params = new_req `GET (Fmt.str "/_tasks/%s/_cancel" id) params
end
