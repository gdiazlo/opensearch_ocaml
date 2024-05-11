#!/usr/bin/env sh

mitmproxy --mode reverse:https://localhost:9200 -k
