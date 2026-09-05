#!/usr/bin/env bash
# Regenerates the "Current Applications" tree in README.md from the actual
# contents of apps/ (2 levels deep, directories only), so the README can't
# drift from reality. Run `task readme:generate` to update, or pass --check
# (used by pre-commit) to fail if README.md is out of date.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
README="${ROOT_DIR}/README.md"
APPS_DIR="${ROOT_DIR}/apps"
START_MARKER="<!-- app-tree:start -->"
END_MARKER="<!-- app-tree:end -->"
CHECK_MODE=false

if [[ "${1:-}" == "--check" ]]; then
  CHECK_MODE=true
fi

generate_block() {
  echo '```'
  echo "> tree -d -L 2 apps/"
  echo "apps/"

  local top_dirs top_total top_i=0
  top_dirs="$(find "${APPS_DIR}" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort)"
  top_total="$(printf '%s\n' "${top_dirs}" | sed '/^$/d' | wc -l)"

  while IFS= read -r top; do
    [[ -z "${top}" ]] && continue
    top_i=$((top_i + 1))
    local top_prefix="├── " child_prefix="│   "
    if [[ "${top_i}" -eq "${top_total}" ]]; then
      top_prefix="└── "
      child_prefix="    "
    fi
    echo "${top_prefix}${top}"

    local subs sub_total sub_i=0
    subs="$(find "${APPS_DIR}/${top}" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort)"
    sub_total="$(printf '%s\n' "${subs}" | sed '/^$/d' | wc -l)"
    while IFS= read -r sub; do
      [[ -z "${sub}" ]] && continue
      sub_i=$((sub_i + 1))
      if [[ "${sub_i}" -eq "${sub_total}" ]]; then
        echo "${child_prefix}└── ${sub}"
      else
        echo "${child_prefix}├── ${sub}"
      fi
    done <<< "${subs}"
  done <<< "${top_dirs}"

  echo '```'
}

new_block="$(generate_block)"

# The tree block spans multiple lines; passed via -v it would need shell/awk
# escaping that differs between GNU and BSD awk. Passing it through the
# environment instead (read via ENVIRON) sidesteps that entirely.
new_readme="$(APP_TREE_BLOCK="${new_block}" awk -v start="${START_MARKER}" -v end="${END_MARKER}" '
  $0 == start { print; print ENVIRON["APP_TREE_BLOCK"]; skip=1; next }
  $0 == end { skip=0 }
  skip { next }
  { print }
' "${README}")"

if [[ "${CHECK_MODE}" == true ]]; then
  if [[ "${new_readme}" != "$(cat "${README}")" ]]; then
    echo "README.md app tree is out of date. Run: task readme:generate" >&2
    exit 1
  fi
  echo "README.md app tree is up to date."
else
  printf '%s\n' "${new_readme}" > "${README}"
  echo "README.md app tree updated."
fi
