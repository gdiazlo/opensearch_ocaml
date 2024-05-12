open Req

(** [https://opensearch.org/docs/latest/ingest-pipelines/create-ingest/]

    Use the create pipeline API operation to create or update pipelines in
    OpenSearch. Note that the pipeline requires you to define at least one
    processor that specifies how to change the documents. *)
module CreatePipeline = struct
  (** Period to wait for a connection to the cluster manager node.
      Defaults to 30 seconds. *)
  let with_cluster_manager_timeout d params =
    ("cluster_manager_timeout", Duration.to_string d) :: params
  ;;

  (** Period to wait for a response. Defaults to 30 seconds. *)
  let with_timeout d params = ("timeout", Duration.to_string d) :: params

  let create id params = new_req `PUT (Fmt.str "/_ingest/pipeline/%s" id) params
end

(** [https://opensearch.org/docs/latest/ingest-pipelines/simulate-ingest/]
    Use the simulate ingest pipeline API operation to run or test the pipeline. *)
module SimulatePipeline = struct
  (** Verbose mode. Display data output for each processor in the
      executed pipeline. *)
  let with_verbose b params = ("verbose", Param.bool_to_string b) :: params

  let simulate id params =
    new_req `POST (Fmt.str "/_ingest/pipeline/%s/_simulate" id) params
  ;;

  let simulate_last params = new_req `POST "/_ingest/pipeline/_simulate" params
end

(** [https://opensearch.org/docs/latest/ingest-pipelines/get-ingest/]

    Use the get ingest pipeline API operation to retrieve all the
    information about the pipeline. *)
module GetPipeline = struct
  let get_all params = new_req `GET "/_ingest/pipeline/" params
  let get_pipeline id params = new_req `GET (Fmt.str "/_ingest/pipeline/%s" id) params
end

(** [https://opensearch.org/docs/latest/ingest-pipelines/delete-ingest/]

    Use the following request to delete a pipeline. *)
module DeletePipeline = struct
  let delete id params = new_req `DELETE (Fmt.str "/_ingest/pipeline/%s" id) params
  let delete_all params = new_req `DELETE "/_ingest/pipeline/*" params
end
