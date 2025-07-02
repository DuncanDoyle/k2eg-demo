#!/bin/sh

printf "\nDeploying quickstart ...\n"
kubectl apply -f quickstart.yaml

printf "\nDeploying Kong2EG resources ...\n"
kubectl apply -f kong2eg-generated-resources.yaml

