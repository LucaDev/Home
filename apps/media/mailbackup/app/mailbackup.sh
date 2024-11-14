#!/bin/bash

RCFILES="/config/*"
for rcfile in $RCFILES; do
    echo "Processing ${rcfile}..."

    filename=$(basename -- "${rcfile}")

    mkdir -p "/data/backup/${filename}/new"
    mkdir -p "/data/backup/${filename}/cur"
    mkdir -p "/data/backup/${filename}/tmp"

    getmail --getmaildir "/data/backup/${filename}/" --rcfile "/config/${filename}"
done
