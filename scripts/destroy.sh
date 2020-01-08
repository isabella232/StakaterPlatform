#!/bin/bash
NAMESPACES="flux control delivery logging monitoring security tracing istio-system"

kubectl delete --wait=true -R -f platform/flux/

# Delete all helm Releases and corresponding resources
# along with release history in kube-system
helm delete --purge $(helm list --short)

# Remove any remaning platform resources
kubectl delete --wait=true --ignore-not-found -R -f platform/

# Remove remaining PVCs in all namespaces
# for NAMESPACE in $NAMESPACES; do
#   kubectl delete pvc --all -n $NAMESPACE
# done

# Remove Helm Operator
helm delete --purge helm-operator

# Remove Tiller
helm reset --force

# Remove Tiller rbac
kubectl delete serviceaccount tiller --namespace kube-system
kubectl delete clusterrolebinding tiller

# Manually delete helmRelease CRD. Temp fix. Will delete all crds.
kubectl delete crd --all

# Delete all namespaces
kubectl delete namespaces $NAMESPACES