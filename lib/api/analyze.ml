open Req

(** [https://opensearch.org/docs/latest/api-reference/analyze-apis/]

    The Analyze API allows you to perform text analysis, which is the
    process of converting unstructured text into individual tokens
    (usually words) that are optimized for search.

    The Analyze API analyzes a text string and returns the resulting
    tokens.

    Note: If you use the Security plugin, you must have the manage index
    privilege. If you only want to analyze text, you must have the manage
    cluster privilege.*)

(** The name of the analyzer to apply to the text field. The analyzer
    can be built in or configured in the index. If analyzer is not
    specified, the analyze API uses the analyzer defined in the mapping of
    the field field.

    If the field field is not specified, the analyze
    API uses the default analyzer for the index.

    If no index is specified or the index does not have a default analyzer, the analyze
    API uses the standard analyzer. *)

let with_analyzer str params = ("analyzer", str) :: params

(** Array of token attributes for filtering the output of the explain
    field. *)

let with_attributes str params = ("attributes", str) :: params

(** Array of character filters for preprocessing characters before the
    tokenizer field. *)

let with_char_filter str params = ("char_filter", str) :: params

(** If true, causes the response to include token attributes and
    additional details. Defaults to false. *)

let with_explain b params = ("explain", Param.bool_to_string b) :: params

(** Field for deriving the analyzer.

    If you specify field, you must also specify the index path parameter.

    If you specify the analyzer field, it overrides the value of field.

    If you do not specify field, the analyze API uses the default analyzer for the index.

    If you do not specify the index field, or the index does not have a
    default analyzer, the analyze API uses the standard analyzer. *)

let with_field str params = ("field", str) :: params

(** Array of token filters to apply after the tokenizer field. *)

let with_filter str params = ("filter", str) :: params

(** Normalizer for converting text into a single token. *)

let with_normalizer str params = ("normalizer", str) :: params

(** Tokenizer for converting the text field into tokens. *)

let with_tokenizer str params = ("tokenizer", str) :: params
let get params = new_req `GET "/_analyze" params
let get_index index params = new_req `GET (Fmt.str "/%s/_analyze" index) params
let post params = new_req `POST "/_analyze" params
let post_index index params = new_req `POST (Fmt.str "/%s/_analyze" index) params
