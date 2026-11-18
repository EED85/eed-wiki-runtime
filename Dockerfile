ARG SANDBOX_VERSION=1.0.0
FROM ghcr.io/eed85/eed-mistral-sandbox:${SANDBOX_VERSION}

USER root
COPY .vibe/skills/ /opt/eed-wiki-runtime/skills/
COPY docker/entrypoint.sh /usr/local/bin/eed-wiki-runtime-entrypoint
COPY licenses/graphify/ /usr/share/licenses/graphify/
COPY THIRD_PARTY_NOTICES.md /usr/share/doc/eed-wiki-runtime/THIRD_PARTY_NOTICES.md
RUN chmod 0755 /usr/local/bin/eed-wiki-runtime-entrypoint

USER vscode
RUN uv tool install 'graphifyy[openai]' && \
    uv tool install cruft

ENTRYPOINT ["/usr/local/bin/eed-wiki-runtime-entrypoint"]
CMD ["sleep", "infinity"]
