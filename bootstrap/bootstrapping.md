# Cluster Bootstrapping

## Flux

### Apply Configuration

Some files have to be decrypted first
sops --decrypt ./bootstrap/age-key.sops.yaml | kubectl apply -f -

helmfile -f "/helmfile.d/flux.yaml sync --hide-notes
