## Opensearch client in Ocaml

This repository contains an [OpenSearch](https://opensearch.org)
client written in Ocaml.

It is modeled after their official clients published in their [GitHub
organization](https://github.com/opensearch-project/)

This client is unreleased as it is a work in progress.

## Dependencies

The client is built using common Ocaml community libraries:

- (Eio)[https://github.com/ocaml-multicore/eio]
- (Cohttp)[https://github.com/mirage/ocaml-cohttp/]
- (Yojson)[https://github.com/ocaml-community/yojson]

## Usage

For now, see the tests. The client API will probably change over time until the
first released version.

## To do

We follow the [OpenSearch APIreference](https://opensearch.org/docs/latest/api-reference/)
to implement the client. Our aim is to provide a client as complete
as possible.


- [ ] [Analyze API](https://opensearch.org/docs/latest/api-reference/analyze-apis/)
- [ ] [CAT API](https://opensearch.org/docs/latest/api-reference/cat/index/)
- [x] [Cluster](https://opensearch.org/docs/latest/api-reference/cluster-api/index/)
- [x] [Count](https://opensearch.org/docs/latest/api-reference/count/)
- [x] [Document](https://opensearch.org/docs/latest/api-reference/document-apis/index/)
- [ ] [Explain](https://opensearch.org/docs/latest/api-reference/explain/)
- [ ] [Index](https://opensearch.org/docs/latest/api-reference/index-apis/index/)
- [ ] [Ingest](https://opensearch.org/docs/latest/api-reference/ingest-apis/index/)
- [ ] [Multi-search](https://opensearch.org/docs/latest/api-reference/multi-search/)
- [ ] [Nodes](https://opensearch.org/docs/latest/api-reference/nodes-apis/index/)
- [ ] [Profile](https://opensearch.org/docs/latest/api-reference/profile/)
- [ ] [Ranking evaluation](https://opensearch.org/docs/latest/api-reference/rank-eval/)
- [ ] [Remnote cluster](https://opensearch.org/docs/latest/api-reference/remote-info/)
- [ ] [Scripts](https://opensearch.org/docs/latest/api-reference/script-apis/index/)
- [ ] [Scroll](https://opensearch.org/docs/latest/api-reference/scroll/)
- [ ] [Search](https://opensearch.org/docs/latest/api-reference/search/)
- [ ] [Search temapltes](https://opensearch.org/docs/latest/api-reference/search-template/)
- [ ] [Snapshots](https://opensearch.org/docs/latest/api-reference/snapshots/index/)
- [ ] [Tasks](https://opensearch.org/docs/latest/api-reference/tasks/)
