#!/bin/bash

curl -s "http://localhost:6878/server/api?token="$(
        curl -s http://localhost:6878/server/api?method=get_api_access_token |
        grep -oE '[[:xdigit:]]{64}'
    )"&method=search" |
grep -oE '"infohash": "[[:xdigit:]]{40}"'

