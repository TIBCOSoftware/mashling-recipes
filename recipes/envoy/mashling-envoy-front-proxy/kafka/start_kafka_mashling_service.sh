#!/bin/bash

cd /apps/${MASHLING_NAME}
./${MASHLING_NAME} &
envoy -c /etc/service-envoy.json --service-cluster service${SERVICE_NAME}