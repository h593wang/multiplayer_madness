#! /bin/bash

tar -czf server.tgz server.pck Dockerfile

hathora-cloud deploy \
    --appId app-2fbbeb0b-0e85-4ee3-ad3e-9320f0980d1b \
    --file ./server.tgz \
    --roomsPerProcess 1 \
    --planName tiny \
    --transportType tls \
    --containerPort 22222 \
    --token $1