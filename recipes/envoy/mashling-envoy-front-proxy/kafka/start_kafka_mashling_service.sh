#!/bin/bash

cd /apps/${MASHLING_NAME}
./mashling-gateway -c mashling-kafka-definition.json &
envoy -c /etc/service-envoy.json --service-cluster service${SERVICE_NAME}
