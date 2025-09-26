#!/usr/bin/env python3
from pathlib import Path
import sys
import traceback
from ruamel.yaml import YAML

yaml = YAML()
yaml.preserve_quotes = True
yaml.width = 4096   # prevent forced line wraps
yaml.indent(mapping=2, sequence=4, offset=2)

def transform_ingress_to_route(values):
    ingress = values.get("ingress", {})
    services = values.get("service", {})

    if not isinstance(ingress, dict):
        return {}

    route = {}
    for name, ing in ingress.items():
        hosts = []
        if "hosts" in ing:
            for h in ing["hosts"]:
                if isinstance(h, dict) and "host" in h:
                    hosts.append(h["host"])
        if not hosts:
            continue

        # try to resolve backendRefs from service definition
        svc_port_num = None
        if name in services:
            svc = services[name]
            ports = svc.get("ports", {})
            if ports and isinstance(ports, dict):
                # take the first defined port entry
                first_key = list(ports.keys())[0]
                port_info = ports[first_key]
                if isinstance(port_info, dict) and "port" in port_info:
                    svc_port_num = port_info["port"]

        route[name] = {
            "hostnames": hosts,
            "parentRefs": [
                {
                    "name": "envoy",
                    "namespace": "networking",
                    "sectionName": "https"
                }
            ]
        }

        if svc_port_num:
            route[name]["rules"] = [
                {
                    "backendRefs": [
                        {
                            "name": name,
                            "port": svc_port_num
                        }
                    ]
                }
            ]

    return route

def process_file(path: Path):
    try:
        with open(path, "r") as f:
            docs = list(yaml.load_all(f))

        changed = False
        for doc in docs:
            if not isinstance(doc, dict):
                continue
            if doc.get("kind") == "HelmRelease":
                values = doc.get("spec", {}).get("values", {})
                if "ingress" in values:
                    route_section = transform_ingress_to_route(values)
                    if route_section:
                        values.yaml_set_comment_before_after_key("route", before="\n")
                        values["route"] = route_section
                        doc["spec"]["values"] = values
                        changed = True

        if changed:
            with open(path, "w") as f:
                yaml.explicit_start = True   # ensures "---" before each doc
                yaml.dump_all(docs, f)
            print(f"✅ Updated {path} with route section(s).")
        else:
            print(f"ℹ️  No ingress found in {path}, skipped.")

    except Exception as e:
        print(f"⚠️  Skipping {path} due to error: {e}", file=sys.stderr)
        traceback.print_exc(limit=1, file=sys.stderr)

def main():
    for path in Path(".").rglob("*"):
        if path.is_file() and path.suffix in [".yaml", ".yml"]:
            process_file(path)

if __name__ == "__main__":
    main()
