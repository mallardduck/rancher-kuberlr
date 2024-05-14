#!/usr/bin/env bash
set -e

: "${IMAGE_REPO:=rancher/kubectl}"
: "${EXISTING_VERSIONS:=''}"

while IFS= read -r RELEASE_VERSION; do
  echo "Checking if image ${IMAGE_REPO}:${RELEASE_VERSION} exists"
  for EXISTING_VERSION in $EXISTING_VERSIONS; do
    if [ "$RELEASE_VERSION" == "$EXISTING_VERSION" ]; then
      echo "Image ${IMAGE_REPO}:${RELEASE_VERSION} already exists, skipping"
      continue 2
    fi
  done

  echo "Image ${IMAGE_REPO}:${RELEASE_VERSION} does not exist, adding to new versions list"
  echo "${RELEASE_VERSION}" >> new-versions.txt
done < base/versions.txt
