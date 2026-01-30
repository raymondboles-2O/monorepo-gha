#!/usr/bin/env bash

set -euo pipefail

REPO=${1:-}
BEFORE=${2:-}
SHA=${3:-}

git remote set-url origin "https://github.com/${REPO}"
git fetch --no-tags --depth=1 origin main || true

# try diff against origin/main, otherwise fall back to before..sha
CHANGED=$(git diff --name-only origin/main...HEAD || git diff --name-only "${BEFORE}" "${SHA}" || true)
printf '%s\n' "Changed files:" '%s\n' "$CHANGED"

if printf '%s\n' "$CHANGED" | grep -q '^apps/next/'; then
  echo "next=true" >> "$GITHUB_OUTPUT"
else
  echo "next=false" >> "$GITHUB_OUTPUT"
fi

if printf '%s\n' "$CHANGED" | grep -q '^apps/nuxt/'; then
  echo "nuxt=true" >> "$GITHUB_OUTPUT"
else
  echo "nuxt=false" >> "$GITHUB_OUTPUT"
fi
