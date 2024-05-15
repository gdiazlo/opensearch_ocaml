open Req

(**[https://opensearch.org/docs/latest/api-reference/script-apis/index/]

   The script APIs allow you to work with stored scripts. Stored scripts
   are part of the cluster state and reduce compilation time and enhance
   search speed. The default scripting language is Painless.*)

(** [https://opensearch.org/docs/latest/api-reference/script-apis/create-stored-script/]
    Creates or updates a stored script or search template. *)
module Create = struct
  (** Context in which the script or search template is to run. To
      prevent errors, the API immediately compiles the script or template in
      this context. *)
  let with_context str params = ("context", str) :: params

  (** Amount of time to wait for a connection to the cluster manager.
      Defaults to 30 seconds. *)
  let with_cluster_manager_timeout d params =
    ("cluster_manager_timeout", Duration.to_string d) :: params
  ;;

  (** The period of time to wait for a response. If a response is not
      received before the timeout value, the request fails and returns an
      error. Defaults to 30 seconds. *)
  let with_timeout d params = ("timeout", Duration.to_string d) :: params

  let put id params = new_req `PUT (Fmt.str "/_scripts/%s" id) params
end

(** [https://opensearch.org/docs/latest/api-reference/script-apis/exec-stored-script/]

    Runs a stored script written in the Painless language.

    OpenSearch provides several ways to run a script; the following
    sections show how to run a script by passing script information in the
    request body of a GET <index>/_search request. *)
module ExecuteStored = struct end

(** [https://opensearch.org/docs/latest/api-reference/script-apis/get-stored-script/]

    Retrieves a stored script. *)
module Get = struct
  (** Amount of time to wait for a connection to the cluster manager.
      Defaults to 30 seconds. *)
  let with_cluster_manager_timeout d params =
    ("cluster_manager_timeout", Duration.to_string d) :: params
  ;;

  let get id params = new_req `GET (Fmt.str "/_scripts/%s" id) params
end

(** [https://opensearch.org/docs/latest/api-reference/script-apis/delete-script/]

    Deletes a stored script *)
module Delete = struct
  (** Amount of time to wait for a connection to the cluster manager.
      Defaults to 30 seconds. *)
  let with_cluster_manager_timeout d params =
    ("cluster_manager_timeout", Duration.to_string d) :: params
  ;;

  (** The period of time to wait for a response. If a response is not
      received before the timeout value, the request fails and returns an
      error. Defaults to 30 seconds. *)
  let with_timeout d params = ("timeout", Duration.to_string d) :: params

  let delete id params = new_req `DELETE (Fmt.str "/_scripts/%s" id) params
end

(** [https://opensearch.org/docs/latest/api-reference/script-apis/get-script-contexts/]
    Retrieves all contexts for stored scripts. *)
module GetContext = struct
  let get params = new_req `GET "/_scripts_context" params
end

(** [https://opensearch.org/docs/latest/api-reference/script-apis/get-script-language/]

    The get script language API operation retrieves all supported script
    languages and the contexts in which they may be used. *)
module Language = struct
  let get params = new_req `GET "/_script_language" params
end

(** [https://opensearch.org/docs/latest/api-reference/script-apis/exec-script/]

    The Execute Painless script API allows you to run a script that is not
    stored.*)
module Execute = struct
  let post params = new_req `POST "/_scripts/painless/_execute" params
end
