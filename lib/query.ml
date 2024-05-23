(** [https://opensearch.org/docs/latest/query-dsl/query-filter-context/]

    Queries consist of query clauses, which can be run in a filter context
    or query context. A query clause in a filter context asks the question
    “Does the document match the query clause?” and returns matching
    documents. A query clause in a query context asks the question “How
    well does the document match the query clause?”, returns matching
    documents, and provides the relevance of each document in the form of
    a relevance score. *)

(** OpenSearch client does not include query builders for their clients anymore. *)
