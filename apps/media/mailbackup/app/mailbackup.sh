#!/bin/bash

RCFILES="/config/*"
for rcfile in $RCFILES; do
    echo "Processing ${rcfile}..."

    filename=$(basename -- "${rcfile}")

    mkdir -p "/data/Email/${filename}/new"
    mkdir -p "/data/Email/${filename}/cur"
    mkdir -p "/data/Email/${filename}/tmp"

    getmail --rcfile "/config/${filename}"
done
