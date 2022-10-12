#!/bin/bash

# A script to delete a GitHub release if it exists

# Get the release ID
RELEASE_ID=$(
    curl \
        -s \
        -H "Accept: application/vnd.github+json" \
        "${GH_REPO}"/releases/tags/"${TAG}" \
        2>/dev/null | jq '.id'
)

if [ "${RELEASE_ID}" != "null" ]; then
    # Delete the release
    curl \
        -su paveloom:"${GH_TOKEN}" \
        -X DELETE \
        -H "Accept: application/vnd.github+json" \
        "${GH_REPO}/releases/${RELEASE_ID}"
    # Delete the tag
    curl \
       -su paveloom:"${GH_TOKEN}" \
       -X DELETE \
       -H "Accept: application/vnd.github+json" \
       "${GH_REPO}/git/refs/tags/${TAG}"
fi
