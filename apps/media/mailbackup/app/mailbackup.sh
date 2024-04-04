#!/bin/bash

RCFILES="/config/*"
for rcfile in $RCFILES; do
    echo "Processing ${rcfile}..."

    filename=$(basename -- "${rcfile}")

    mkdir -p "/data/Luca/Email/${filename}/new"
    mkdir -p "/data/Luca/Email/${filename}/cur"
    mkdir -p "/data/Luca/Email/${filename}/tmp"

    getmail --getmaildir "/data/Luca/Email/${filename}/" --rcfile "/config/${filename}"
done
