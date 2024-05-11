open Req

(** [https://opensearch.org/docs/latest/api-reference/cluster-api/cluster-allocation/]

    The most basic cluster allocation explain request finds an
    unassigned shard and explains why it can’t be allocated to a node.

    If you add some options, you can instead get information on a
    specific shard, including why OpenSearch assigned it to its
    current node. *)
module ClusterAllocationExplain = struct
  (** OpenSearch makes a series of yes or no decisions when trying to
      allocate a shard to a node.
      If this parameter is true, OpenSearch includes the (generally
      more numerous) “yes” decisions in its response. Default is
      false.*)
  let with_include_yes_decisions b params =
    ("include_yes_decisions", Param.bool_to_string b) :: params
  ;;

  (** Whether to include information about disk usage in the response.
      Default is false.*)
  let with_include_disk_info b params =
    ("include_disk_info", Param.bool_to_string b) :: params
  ;;

  let get p = new_req `GET "/_cluster/allocation/explain" p
end

(** [https://opensearch.org/docs/latest/api-reference/cluster-api/cluster-awareness/]

    To control the distribution of search or HTTP traffic, you can use
    the weights per awareness attribute to control the distribution of
    search or HTTP traffic across zones. This is commonly used for
    zonal deployments, heterogeneous instances, and routing traffic
    away from zones during zonal failure. *)
module RoutingAndAwareness = struct
  (** The name of the awareness attribute, usually zone. The attribute
      name must match the values listed
      in the request body when assigning weights to zones. *)
  let get attr p = new_req `GET ("/_cluster/routing/awareness/" ^ attr ^ "weigths") p
end

(** [https://opensearch.org/docs/latest/api-reference/cluster-api/cluster-decommission/]

    The cluster decommission operation adds support decommissioning based on awareness. It greatly
    benefits multi-zone deployments, where awareness attributes, such as zones, can aid in applying
    new upgrades to a cluster in a controlled fashion. This is especially useful during outages,
    in which case, you can decommission the unhealthy zone to prevent replication requests from stalling
    and prevent your request backlog from becoming too large.

    For more information about allocation awareness, see Shard allocation awareness. *)
module Decommission = struct
  (** The name of awareness attribute, usually zone.*)
  let with_awareness_attribute_name str params =
    ("awareness_attribute_name", str) :: params
  ;;

  (** The value of the awareness attribute. For example, if you have
      shards allocated in two different zones, you can give each
      zone a value of zone-a or zoneb. The cluster decommission
      operation decommissions the zone listed in the method.*)
  let with_awareness_attribute_value str params =
    ("awareness_attribute_value", str) :: params
  ;;
end

(**[https://opensearch.org/docs/latest/api-reference/cluster-api/cluster-health/]

   The most basic cluster health request returns a simple status of
   the health of your cluster. OpenSearch expresses cluster health in
   three colors: green, yellow, and red. A green status means all
   primary shards and their replicas are allocated to nodes. A yellow
   status means all primary shards are allocated to nodes, but some
   replicas aren’t. A red status means at least one primary shard is
   not allocated to any node. *)
module Health = struct
  (** Expands wildcard expressions to concrete indexes. Combine multiple
      values with commas. Supported values are all, open, closed,
      hidden, and none. Default is open.*)
  let with_expand_wildcards str params = ("expand_wildcards", str) :: params

  (** The level of detail for returned health information. Supported
      values are cluster,
      indices, shards, and awareness_attributes. Default is cluster. *)
  let with_level str params = ("level", str) :: params

  (** The name of the awareness attribute, for which to return cluster
      health (for example,
      zone). Applicable only if level is set to awareness_attributes.*)
  let awareness_attribute str params = ("awareness_attribute", str) :: params

  (** Whether to return information from the local node only instead of
      from the cluster
      manager node. Default is false.*)
  let with_local b params = ("local", Param.bool_to_string b) :: params

  (** The amount of time to wait for a connection to the cluster manager
      node.
      Default is 30 seconds.*)
  let with_master_timeout d params = ("master_timeout", Duration.to_string d) :: params

  (** The amount of time to wait for a response. If the timeout expires,
      the request fails.
      Default is 30 seconds.*)
  let with_cluster_manager_timeout d params =
    ("cluster_manager_timeout", Duration.to_string d) :: params
  ;;

  (** Wait until the specified number of shards is active before
      returning a response. all for all shards.
      Default is 0. *)
  let with_timeout d params = ("timeout", Duration.to_string d) :: params

  (** Wait for N number of nodes. Use 12 for exact match, >12 and <12 for
      range.*)
  let with_wait_for_active_shards str params = ("wait_for_active_shards", str) :: params

  (** Wait for N number of nodes. Use 12 for exact match, >12 and <12 for
      range.*)
  let wait_for_nodes str params = ("wait_for_nodes", str) :: params

  (** Wait until all currently queued events with the given priority are
      processed. Supported
      values are immediate, urgent, high, normal, low, and languid. *)
  let with_wait_for_events str params = ("wait_for_events", str) :: params

  (** Whether to wait until there are no initializing shards in the
      cluster. Default is false.*)
  let with_wait_for_no_intializing_shards b params =
    ("wait_for_no_initializing_shards", Param.bool_to_string b) :: params
  ;;

  (** Whether to wait until there are no relocating shards in the
      cluster. Default is false.*)
  let with_wait_for_no_relocatinhg_shards b params =
    ("wait_for_no_relocating_shards", Param.bool_to_string b) :: params
  ;;

  (** Wait until the cluster health reaches the specified status or
      better.
      Supported values are green, yellow, and red.*)
  let with_wait_for_status str params = ("wait_for_status", str) :: params

  (** Return the JSON object prettified *)
  let with_pretty b params = ("pretty", Param.bool_to_string b) :: params

  let with_human b params = ("human", Param.bool_to_string b) :: params
  let with_error_trace b params = ("error_trace", Param.bool_to_string b) :: params
  let get p = new_req `GET "/_cluster/health" p
end

(**[https://opensearch.org/docs/latest/api-reference/cluster-api/cluster-settings/]

   The cluster settings operation lets you check the current settings
   for your cluster, review default settings, and change settings.
   When you update a setting using the API, OpenSearch applies it to
   all nodes in the cluster.

   Not all cluster settings can be updated using the cluster settings
   API. You will receive the error message [setting
    [cluster.some.setting], not dynamically updateable] when trying to
   configure these settings through the API. *)
module Settings = struct
  (** Whether to return settings in the flat form, which can improve
      readability, especially for
      heavily nested settings. For example, the flat form of
      ["cluster": { "max_shards_per_node": 500 }] is
      ["cluster.max_shards_per_node": "500"].*)
  let with_flat_settings b params = ("flat_settings", Param.bool_to_string b) :: params

  (** Whether to include default settings as part of the response. This
      parameter is useful for
      identifying the names and current values of settings you want to
      update.*)
  let with_include_defaults b params =
    ("include_defaults", Param.bool_to_string b) :: params
  ;;

  (** The amount of time to wait for a response from the cluster manager
      node. Default is 30 seconds. *)
  let with_cluster_manager_timeout d params =
    ("cluster_manager_timeout", Duration.to_string d) :: params
  ;;

  (** The amount of time to wait for a response from the cluster. Default
      is 30 seconds. *)
  let timeout d params = ("timeout", Duration.to_string d) :: params

  let get p = new_req `GET "/_cluster/settings" p

  (** For a PUT operation, the request body must contain transient or
      persistent, along with the setting you want to update:
      [PUT _cluster/settings { "persistent":{
      "cluster.max_shards_per_node": 500 } }] *)
  let put p = new_req `PUT "/_cluster/settings" p
end

(** [https://opensearch.org/docs/latest/api-reference/cluster-api/cluster-stats/]

    The cluster stats API operation returns statistics about your
    cluster. *)
module Stats = struct
  let get p = new_req `GET "/_cluster/stats" p
end
