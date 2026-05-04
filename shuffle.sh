#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
config_file="$script_dir/config.env"

if [[ ! -f "$config_file" ]]; then
  echo "shuffle.sh: missing config file: $config_file" >&2
  exit 1
fi

# shellcheck source=/dev/null
source "$config_file"

: "${MEMBERS:?MEMBERS is empty in $config_file}"
: "${WEBHOOK_URL:?WEBHOOK_URL is empty in $config_file}"

IFS=',' read -ra members_arr <<< "$MEMBERS"
mapfile -t shuffled_arr < <(shuf -e "${members_arr[@]}")
shuffled=$(printf '%s, ' "${shuffled_arr[@]}")
shuffled="${shuffled%, }"

payload="$(jq -Rn --arg r "$shuffled" '{r_list:$r}')"

curl --fail -sS -X POST \
  -H 'Content-Type: application/json' \
  -d "$payload" \
  "$WEBHOOK_URL"
