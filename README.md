## Opensearch client in Ocaml

This repository contains an [OpenSearch](https://opensearch.org)
client written in Ocaml.

It is modeled after their official clients published in their [GitHub
organization](https://github.com/opensearch-project/)

This client is unreleased as it is a work in progress.

## Dependencies

The client is built using common Ocaml community libraries:

- [Eio](https://github.com/ocaml-multicore/eio)
- [Cohttp](https://github.com/mirage/ocaml-cohttp/)
- [Yojson](https://github.com/ocaml-community/yojson)

## Usage

For now, see the tests. The client API will probably change over time until the
first released version.


## Tests

Until we create a mock, we use mitmproxy and a real OpenSearch cluster
for testing. All tests try to call mitmproxy which then redirects to
the opensearch backend listening on https://localhost:9200.

In mitmproxy we can see the requests and responses manually, as the
tests only check whether the response was not an HTTP error code.

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
- [X] [Index](https://opensearch.org/docs/latest/api-reference/index-apis/index/)
- [X] [Ingest](https://opensearch.org/docs/latest/api-reference/ingest-apis/index/)
- [ ] [Multi-search](https://opensearch.org/docs/latest/api-reference/multi-search/)
- [X] [Nodes](https://opensearch.org/docs/latest/api-reference/nodes-apis/index/)
- [ ] [Profile](https://opensearch.org/docs/latest/api-reference/profile/)
- [ ] [Ranking evaluation](https://opensearch.org/docs/latest/api-reference/rank-eval/)
- [ ] [Remnote cluster](https://opensearch.org/docs/latest/api-reference/remote-info/)
- [ ] [Scripts](https://opensearch.org/docs/latest/api-reference/script-apis/index/)
- [ ] [Scroll](https://opensearch.org/docs/latest/api-reference/scroll/)
- [X] [Search](https://opensearch.org/docs/latest/api-reference/search/)
- [X] [Search temapltes](https://opensearch.org/docs/latest/api-reference/search-template/)
- [ ] [Snapshots](https://opensearch.org/docs/latest/api-reference/snapshots/index/)
- [X] [Tasks](https://opensearch.org/docs/latest/api-reference/tasks/)

OpenSearch has a lot of objects which conform the payload for a lot of APIs. We should implement builders for the most important ones:

- [ ] [Query DSL](https://opensearch.org/docs/latest/query-dsl/)
- [ ] [Ingest processors](https://opensearch.org/docs/latest/ingest-pipelines/processors/index-processors/)
- [ ] [Aggregations](https://opensearch.org/docs/latest/aggregations/)
- [ ] [Search plugins](https://opensearch.org/docs/latest/search-plugins/)

A nice addition would be to add support to the stantard OpenSearch plugins APIs:

- [ ] [Security plugin](https://opensearch.org/docs/latest/security/)
- [ ] [Observability plugin](https://opensearch.org/docs/latest/observing-your-data/)
- [ ] [Reporting](https://opensearch.org/docs/latest/reporting/)
- [ ] [Machine learning](https://opensearch.org/docs/latest/ml-commons-plugin/)
