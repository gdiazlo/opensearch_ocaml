open Req

(** [https://opensearch.org/docs/latest/api-reference/nodes-apis/index/]

    The nodes API makes it possible to retrieve information about individual nodes within your cluster. *)

(** [https://opensearch.org/docs/latest/api-reference/nodes-apis/nodes-info/]

    The nodes info API represents mostly static information about your cluster’s nodes, including but not limited to:

    - Host system information

    - JVM

    - Processor Type

    - Node settings

    - Thread pools settings

    - Installed plugins *)

module Info = struct
  (** Specifies whether to return the settings object of the response in
      flat format. Default is false. *)
  let with_flat_settings b params = ("flat_settings", Param.bool_to_string b) :: params

  (** Sets the time limit for node response. Default value is 30s. *)
  let with_timeout d params = ("timeout", Duration.to_string d) :: params

  let get params = new_req `GET "/_nodes" params
  let get_node node params = new_req `GET (Fmt.str "/_node/%s" node) params
  let get_metric metric params = new_req `GET (Fmt.str "/_node/%s" metric) params

  let get_node_metric node metric params =
    new_req `GET (Fmt.str "/_node/%s/%s" node metric) params
  ;;
end

(** [https://opensearch.org/docs/latest/api-reference/nodes-apis/nodes-stats/]

    The nodes stats API returns statistics about your cluster. *)
module Stats = struct
  (** The fields to include in completion statistics. Supports
      comma-separated lists and wildcard expressions. *)
  let with_completion_fields str params = ("completion_fields", str) :: params

  (** The fields to include in fielddata statistics. Supports
      comma-separated lists and wildcard expressions. *)
  let with_fielddata_fields str params = ("fielddata_fields", str) :: params

  (** The fields to include. Supports comma-separated lists and wildcard
      expressions. *)
  let with_fields str params = ("fields", str) :: params

  (** A comma-separated list of search groups to include in the search
      statistics. *)
  let with_groups str params = ("groups", str) :: params

  (** Specifies whether statistics are aggregated at the cluster, index,
      or shard level. Valid values are indices, node, and shard. *)
  let with_level str params = ("level", str) :: params

  (** Sets the time limit for node response. Default is 30s. *)
  let with_timeout d params = ("timeout", Duration.to_string d) :: params

  (** If segment statistics are requested, this field specifies to
      return the aggregated disk usage of every Lucene index file. Default
      is false. *)
  let with_include_segment_file_sizes b params =
    ("include_segment_file_sizes", Param.bool_to_string b) :: params
  ;;

  let get params = new_req `GET "/_nodes/stats" params

  (** [node] is a comma-separated list of nodeIds used to filter results.
      Supports node filters. Defaults to _all.*)
  let get_node node params = new_req `GET (Fmt.str "/_nodes/%s/stats" node) params

  (** [metric] is a comma-separated list of metric groups that are
      included in the response. For example, jvm,fs. See the following list
      of all index metrics. Defaults to all metrics.*)
  let get_metric metric params = new_req `GET (Fmt.str "/_nodes/stats/%s" metric) params

  (** [node] is a comma-separated list of nodeIds used to filter results.
      Supports node filters. Defaults to _all.

      [metric] is a comma-separated list of metric groups that are
      included in the response. For example, jvm,fs. See the following list
      of all index metrics. Defaults to all metrics. *)
  let get_node_metric node metric params =
    new_req `GET (Fmt.str "/_nodes/%s/stats/%s" node metric) params
  ;;

  (** [metric] is a comma-separated list of metric groups that are
      included in the response. For example, jvm,fs. See the following list
      of all index metrics. Defaults to all metrics

      [index_metric] is a comma-separated list of index metric groups that
      are included in the response. For example, docs,store. See the
      following list of all index metrics. Defaults to all index metrics.*)
  let get_metric_index metric index_metric params =
    new_req `GET (Fmt.str "/_nodes/stats/%s/%s" metric index_metric) params
  ;;

  (** [node] is a comma-separated list of nodeIds used to filter results.
      Supports node filters. Defaults to _all.

      [metric] is a comma-separated list of metric groups that are
      included in the response. For example, jvm,fs. See the following list
      of all index metrics. Defaults to all metrics.

      [index_metric] is a comma-separated list of index metric groups that
      are included in the response. For example, docs,store. See the
      following list of all index metrics. Defaults to all index metrics.*)
  let get_node_metrics_index node metric index_metric params =
    new_req `GET (Fmt.str "/_nodes/%s/stats/%s/%s" node metric index_metric) params
  ;;
end

(** [https://opensearch.org/docs/latest/api-reference/nodes-apis/nodes-hot-threads/]

    The nodes hot threads endpoint provides information about busy JVM
    threads for selected cluster nodes. It provides a unique view of the
    of activity each node. *)
module HotThread = struct
  (** The number of samples of thread stacktraces. Defaults to 10. *)
  let with_snapshots i params = ("snapshots", Param.int_to_string i) :: params

  (** The interval between consecutive samples. Defaults to 500ms. *)
  let with_interval d params = ("interval", Duration.to_string d) :: params

  (** The number of the busiest threads to return information about.
      Defaults to 3. *)
  let with_threads i params = ("threads", Param.int_to_string i) :: params

  (** Don’t show threads that are in known idle states, such as waiting
      on a socket select or pulling from an empty task queue. Defaults to
      true. *)
  let with_ignore_idle_threads b params =
    ("ignore_idle_threads", Param.bool_to_string b) :: params
  ;;

  (** Supported thread types are cpu, wait, or block. Defaults to cpu. *)
  let with_type str params = ("type", str) :: params

  (** Sets the time limit for node response. Default value is 30s. *)
  let with_timeout d params = ("timeout", Duration.to_string d) :: params

  let get params = new_req `GET "/_nodes/hot_threads" params
  let get_node node params = new_req `GET (Fmt.str "/_nodes/%s/hot_threads" node) params
end

(** [https://opensearch.org/docs/latest/api-reference/nodes-apis/nodes-usage/]

    The nodes usage endpoint returns low-level information about REST
    action usage on nodes.*)
module Usage = struct
  (** Sets the time limit for a response from the node. Default is 30s. *)
  let with_timeout d params = ("timeout", Duration.to_string d) :: params

  (** Sets the time limit for a response from the cluster manager.
      Default is 30s. *)
  let with_cluster_manager_timeout d params =
    ("cluster_manager_timeout", Duration.to_string d) :: params
  ;;

  let get params = new_req `GET "/_nodes/usage" params

  (** [node] is a comma-separated list of nodeIds used to filter results.
      Supports node filters. Defaults to _all. *)
  let get_node node params = new_req `GET (Fmt.str "/_nodes/%s/usage" node) params

  (** [metric] The metrics that will be included in the response. You can
      set the string to either _all or rest_actions. rest_actions returns
      the total number of times an action has been called on the node. _all
      returns all stats from the node. Defaults to _all. *)
  let get_metric metric params = new_req `GET (Fmt.str "/_nodes/usage/%s" metric) params

  (**[node] is a comma-separated list of nodeIds used to filter results.
     Supports node filters. Defaults to _all.

     [metric] The metrics that will be included in the response. You can
     set the string to either _all or rest_actions. rest_actions returns
     the total number of times an action has been called on the node. _all
     returns all stats from the node. Defaults to _all. *)
  let get_node_metric node metric params =
    new_req `GET (Fmt.str "/_nodes/%s/usage/%s" node metric) params
  ;;
end

(** [https://opensearch.org/docs/latest/api-reference/nodes-apis/nodes-reload-secure/]
    The nodes reload secure settings endpoint allows you to change secure
    settings on a node and reload the secure settings without restarting
    the node. *)

module ReloadSecureSetting = struct
  let post params = new_req `POST "/_nodes/reload_secure_settings" params

  (** [node] A comma-separated list of nodeIds used to filter results. Supports
      node filters. Defaults to _all.*)
  let post_node node params =
    new_req `POST (Fmt.str "/_nodes/%s/reload_secure_settings" node) params
  ;;
end
