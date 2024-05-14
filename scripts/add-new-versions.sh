#!/usr/bin/env bash
set -euxo pipefail
RELEASES=$(gh api graphql -F owner='flavio' -F name='kuberlr' -f query='query($name: String!, $owner: String!) {repository(owner: $owner, name: $name) {releases(first: 100) {nodes { tagName, isPrerelease }} }}' | jq -r '.data.repository.releases.nodes[] | select(.isPrerelease != true) | .tagName' | sort -V)
# Including v0.4.3 and higher
INCLUDE_VERSIONS="v0\.[4-9]\.[0-9]+$"
VERSIONS_FILE="${1:-versions.txt}"

ADDED_VERSIONS=()

for RELEASE in $RELEASES; do
  if [[ $RELEASE =~ $INCLUDE_VERSIONS ]]; then
    echo "Version ${RELEASE} matched include versions, checking if already present"
    if ! grep -q "^${RELEASE}$" "${VERSIONS_FILE}"; then
      echo "Version ${RELEASE} not present in versions file ${VERSIONS_FILE}, adding"
      ADDED_VERSIONS+=( "${RELEASE}" )
      echo "${RELEASE}" >> "${VERSIONS_FILE}"
    else
      echo "Version ${RELEASE} already present in versions file ${VERSIONS_FILE}, skipping"
    fi
  else
    echo "Version ${RELEASE} does not match include versions, skipping"
  fi
done

if [ "${#ADDED_VERSIONS[@]}" -gt 0 ]; then
  echo "Added [${#ADDED_VERSIONS[@]}] versions: (${ADDED_VERSIONS[*]})"
  sort -rV -o "${VERSIONS_FILE}" "${VERSIONS_FILE}"
else
  echo "No new versions added"
fi