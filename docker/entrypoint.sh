#!/bin/sh
set -eu

mkdir -p "${HOME}/.vibe/skills"
cp -R /opt/eed-wiki-runtime/skills/. "${HOME}/.vibe/skills/"

exec "$@"
