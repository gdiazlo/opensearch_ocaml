### Prepare the data

Download and unzip all CVEs as published by the CVE project.

```bash
curl -L -o/tmp/main.zip https://github.com/CVEProject/cvelistV5/archive/refs/heads/main.zip

unzip /tmp/main.zip -d /tmp/
```

### Prepare environment

- Set up your environment variables:

```bash
OPENSEARCH_HOSTS=https://localhost:9200
OPENSEARCH_USER=admin
OPENSEARCH_PASSWORD=StrongPasswordOrOpenSearchWontStart
```

- Start a local OpenSearch instance using docker-compose

```bash
tools/ $ docker compose up -d
```

### Upload this data to opensearch

Run the bulk_upload executable to upload the data to OpenSearch.

```bash
dune exec -- ./bu.exe
```
