#!/bin/sh
set -eu

OPENAI_API_KEY="${OPENAI_API_KEY:-${MISTRAL_API_KEY:-}}"
export OPENAI_API_KEY

mkdir -p "${HOME}/.vibe/skills"
cp -R /opt/eed-wiki-runtime/skills/. "${HOME}/.vibe/skills/"

exec "$@"
