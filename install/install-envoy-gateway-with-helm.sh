#!/bin/sh

helm install eg oci://docker.io/envoyproxy/gateway-helm \
  --version v1.4.1 \
  --set config.envoyGateway.extensionApis.enableBackend=true \
  -n envoy-gateway-system \
  --create-namespace