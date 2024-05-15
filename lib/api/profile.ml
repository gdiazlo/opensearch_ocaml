open! Req

(**[https://opensearch.org/docs/latest/api-reference/profile/]

   The Profile API provides timing information about the execution of
   individual components of a search request. Using the Profile API, you
   can debug slow requests and understand how to improve their
   performance. The Profile API does not measure the following:

   Network latency Time spent in the search fetch phase Amount of time a
   request spends in queues Idle time while merging shard responses on
   the coordinating node The Profile API is a resource-consuming
   operation that adds overhead to search operations.

   To use the Profile API, include the profile parameter set to true in
   the search request sent to the _search endpoint. *)
