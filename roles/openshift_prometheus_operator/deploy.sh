#!/bin/bash


#oc login -u system:admin
oc new-project monitoring

oc apply -f files/manifests/prometheus-operator

oc adm policy add-cluster-role-to-user cluster-reader -z prometheus-operator

printf "Waiting for Operator to register custom resource definitions..."
until oc get customresourcedefinitions servicemonitors.monitoring.coreos.com > /dev/null 2>&1; do sleep 1; printf "."; done
echo "Done!"

oc apply -f files/manifests/prometheus

oc expose service prometheus-k8s

oc apply -f files/manifests/alertmanager

# TODO: convert to Route manifest?
oc expose service alertmanager-main
