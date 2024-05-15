open! Req

(**[https://opensearch.org/docs/latest/api-reference/remote-info/]

   This operation provides connection information for any remote
   OpenSearch clusters that you’ve configured for the local cluster, such
   as the remote cluster alias, connection mode (sniff or proxy), IP
   addresses for seed nodes, and timeout settings.

   The response is more comprehensive and useful than a call to
   _cluster/settings, which only includes the cluster alias and seed
   nodes. *)
module Info = struct
  let get params = new_req `GET "/_remote/info" params
end
