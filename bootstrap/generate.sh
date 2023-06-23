#!/bin/bash
kubectl kustomize \
  --enable-helm \
  --load-restrictor=LoadRestrictionsNone \
  . \
  > ./bootstrap.yaml

yq -n '.cluster.inlineManifests[0].name="bootstrap" | .cluster.inlineManifests[0].contents += loadstr("bootstrap.yaml")' > bootstrap.patch.yaml

sed -i '' 's/\$/\$\$/g'  bootstrap.patch.yaml

rm -rf cilium/charts
