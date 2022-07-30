#!/bin/bash

# A script to delete a GitHub release if it exists

# Get the release ID
RELEASE_ID=$(curl -sH "Accept: application/vnd.github.v3+json" "${GH_REPO}"/tags/"${TAG}" 2>/dev/null | jq '.id')

if [ "${RELEASE_ID}" != "null" ]; then
     # Delete the release
     curl -su paveloom:"${GH_TOKEN}" \
         -X DELETE \
         -H "Accept: application/vnd.github.v3+json" \
         "${GH_REPO}"/"${RELEASE_ID}"
fi
