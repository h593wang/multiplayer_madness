#! /bin/bash

tar -czf server.tar.gz server.pck Dockerfile

hathora-cloud deploy \
    --appId app-2fbbeb0b-0e85-4ee3-ad3e-9320f0980d1b \
    --file ./server.tar.gz \
    --roomsPerProcess 1 \
    --planName tiny \
    --transportType udp \
    --containerPort 22222 \
    --env "EULA=TRUE"