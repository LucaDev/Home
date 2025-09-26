#!/usr/bin/env python3
import yaml
from pathlib import Path
import sys
import traceback

def transform_traefik_to_envoy(doc):
    metadata_name = doc["metadata"]["name"]
    plugin = doc["spec"]["plugin"]["traefik-oidc-auth"]
    provider = plugin["Provider"]

    client_secret = provider.get("ClientSecret", "")
    secret_name = client_secret
    if client_secret.startswith("urn:k8s:secret:"):
        parts = client_secret.split(":")
        if len(parts) >= 4:
            secret_name = parts[3]

    envoy_doc = {
        "apiVersion": "gateway.envoyproxy.io/v1alpha1",
        "kind": "SecurityPolicy",
        "metadata": {
            "name": metadata_name
        },
        "spec": {
            "targetRefs": [
                {
                    "group": "gateway.networking.k8s.io",
                    "kind": "HTTPRoute",
                    "name": provider["ClientId"]
                }
            ],
            "oidc": {
                "provider": {
                    "issuer": provider["Url"]
                },
                "clientID": provider["ClientId"],
                "clientSecret": {
                    "name": secret_name
                },
                "redirectURL": "/",
                "logoutPath": "/logout"
            }
        }
    }
    return envoy_doc

def process_file(path: Path):
    try:
        with open(path, "r") as f:
            docs = list(yaml.safe_load_all(f))

        new_docs = []
        for doc in docs:
            if not isinstance(doc, dict):
                continue
            if doc.get("kind") == "Middleware":
                new_docs.append(transform_traefik_to_envoy(doc))

        if new_docs:
            with open(path, "a") as f:
                f.write("\n")
                yaml.safe_dump_all(new_docs, f, sort_keys=False, explicit_start=True)
            print(f"✅ Updated {path} with {len(new_docs)} SecurityPolicy objects.")
        else:
            print(f"ℹ️  No Middleware objects in {path}, skipped.")
    except Exception as e:
        print(f"⚠️  Skipping {path} due to error: {e}", file=sys.stderr)
        traceback.print_exc(limit=1, file=sys.stderr)

def main():
    for path in Path(".").rglob("*"):
        if path.is_file() and path.suffix in [".yaml", ".yml"]:
            process_file(path)

if __name__ == "__main__":
    main()
