(lang dune 3.14)

(name opensearch)

(generate_opam_files true)

(source
 (github gdiazlo/opensearch-ocaml))

(authors "Gabriel Díaz")

(maintainers "Gabriel Díaz")

(license Apache)

(documentation https://github.com/gdiazlo/opensearch-ocaml)

(package
 (name opensearch)
 (synopsis "An OpenSearch client written in Ocaml")
 (description "This is a client for OpenSearch, including indexing, searching and managing the cluster")
 (depends ocaml dune)
 (tags
  (topics "opensearch" )))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
