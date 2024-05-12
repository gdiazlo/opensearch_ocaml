(** [https://opensearch.org/docs/latest/api-reference/search-template/]
    You can convert your full-text queries into a search template to
    accept user input and dynamically insert it into your query.

    For example, if you use OpenSearch as a backend search engine for your
    application or website, you can take in user queries from a search bar
    or a form field and pass them as parameters into a search template.
    That way, the syntax to create OpenSearch queries is abstracted from
    your end users.

    When you’re writing code to convert user input into OpenSearch
    queries, you can simplify your code with search templates. If you need
    to add fields to your search query, you can just modify the template
    without making changes to your code. *)
open Req

(**
A search template has two components: the query and the parameters.
Parameters are user-inputted values that get placed into variables.
Variables are represented with double braces in Mustache notation.
When encountering a variable like {{var}} in the query, OpenSearch
goes to the params section, looks for a parameter called var, and
replaces it with the specified value.

You can code your application to ask your user what they want to
search for and then plug that value into the params object at runtime.
*)
let search params = new_req `POST "/_search/template" params

(** To run this search on a specific index, add the index name to the request *)
let search_index index params =
  new_req `POST (Fmt.str "/%s//_search/template" index) params
;;

(** After the search template works the way you want it to, you can save
    the source of that template as a script, making it reusable for
    different input parameters.

    When saving the search template as a script, you need to specify the
    lang parameter as mustache *)
let save name params = new_req `POST (Fmt.str "/_scripts/%s" name) params
