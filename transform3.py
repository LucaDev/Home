#!/usr/bin/env python3
from pathlib import Path
import sys
import traceback
from ruamel.yaml import YAML

yaml = YAML()
yaml.preserve_quotes = True
yaml.width = 4096
yaml.indent(mapping=2, sequence=4, offset=2)

def move_annotations(values):
    """
    Move annotations from ingress.*.annotations to route.*.annotations,
    then delete ingress.
    """
    ingress = values.get("ingress", {})
    route = values.get("route", {})

    changed = False

    if not isinstance(ingress, dict):
        return changed

    for name, ing in ingress.items():
        annotations = ing.get("annotations")
        if annotations:
            if name not in route:
                route[name] = {}
            route[name]["annotations"] = annotations
            changed = True

    if changed:
        values["route"] = route
        del values["ingress"]

    return changed

def process_file(path: Path):
    try:
        with open(path, "r") as f:
            docs = list(yaml.load_all(f))

        any_changes = False
        for doc in docs:
            if not isinstance(doc, dict):
                continue
            if doc.get("kind") == "HelmRelease":
                values = doc.get("spec", {}).get("values", {})
                if "ingress" in values:
                    if move_annotations(values):
                        doc["spec"]["values"] = values
                        any_changes = True

        if any_changes:
            with open(path, "w") as f:
                yaml.explicit_start = True
                yaml.dump_all(docs, f)
            print(f"✅ Moved annotations and removed ingress in {path}")
        else:
            print(f"ℹ️  No ingress annotations found in {path}, skipped.")

    except Exception as e:
        print(f"⚠️  Skipping {path} due to error: {e}", file=sys.stderr)
        traceback.print_exc(limit=1, file=sys.stderr)

def main():
    for path in Path(".").rglob("*"):
        if path.is_file() and path.suffix in [".yaml", ".yml"]:
            process_file(path)

if __name__ == "__main__":
    main()
