# Cluster Bootstrapping
## Flux
### Install Flux
kubectl apply --server-side --kustomize ./bootstrap
### Apply Configuration
Some files have to be decrypted first
sops --decrypt ./bootstrap/age-key.sops.yaml | kubectl apply -f -
kubectl apply --server-side --kustomize ./flux/
