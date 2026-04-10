#!/usr/bin/env bash

set -euo pipefail

input="$(cat)"

command="$(
  printf '%s' "$input" | python3 -c 'import json, sys; print(json.load(sys.stdin).get("tool_input", {}).get("command", ""))'
)"

if [[ -z "$command" ]]; then
  exit 0
fi

reason=""

if [[ "$command" =~ (^|[[:space:];|&()])git[[:space:]]+push([[:space:];|&()]|$) ]]; then
  reason="Explicit approval is required before Claude Code can publish local commits with git push."
elif [[ "$command" =~ (^|[[:space:];|&()])gh([[:space:]]|$) ]] && [[ "$command" =~ (^|[[:space:]])--push([[:space:];|&()]|$) ]]; then
  reason="Explicit approval is required before Claude Code can publish local commits through a gh command that uses --push."
fi

if [[ -z "$reason" ]]; then
  exit 0
fi

python3 - "$reason" <<'PY'
import json
import sys

reason = sys.argv[1]

print(json.dumps({
    "hookSpecificOutput": {
        "hookEventName": "PreToolUse",
        "permissionDecision": "ask",
        "permissionDecisionReason": reason,
    }
}, indent=2))
PY
