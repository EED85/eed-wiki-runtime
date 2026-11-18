# eed-wiki-runtime

The wiki-generic runtime layer for Mistral Vibe. It inherits the sandbox
container, adds Graphify and wiki-maintenance skills, and keeps wiki-specific
content out of the image.

## Image contract

The Dockerfile pins `ghcr.io/eed85/eed-mistral-sandbox:1.0.0` by default.
Versioned releases are published to
`ghcr.io/eed85/eed-wiki-runtime:<version>`. When the sandbox repository
publishes a new version, its workflow can dispatch a rebuild here; the runtime
image is published with the tag `sandbox-<sandbox-version>`.

The first GHCR publish is private by default. Change the package visibility to
**Public** in GitHub Packages before using it from a public wiki repository.
The sandbox repository must have a `WIKI_RUNTIME_DISPATCH_TOKEN` secret with
permission to dispatch workflows in this repository for automatic rebuilds.

## Run locally

Copy `.env.example` to `.env` and set `MISTRAL_API_KEY`. Graphify defaults to
the Mistral OpenAI-compatible endpoint and uses that key unless a separate
`OPENAI_API_KEY` is provided:

```powershell
Copy-Item .env.example .env
docker compose up -d --build ai
docker compose exec ai vibe
```

By default, the repository directory is mounted at `/workspace`. Set
`WIKI_PATH` in `.env` to a wiki clone's path to use this runtime with that
content repository instead. `vibe-home` persists Vibe state; the entrypoint
installs the image's global skills into that volume on container startup.

## Use with a wiki repository

The [eed-wiki-template](https://github.com/EED85/eed-wiki-template) generates
content-only Obsidian vaults. Open a generated vault in VS Code and choose
**Reopen in Container**. Its Dev Container uses a pinned, prebuilt runtime
image; it does not build a local Docker image.

The runtime provides the global `wiki-hosting` and `writing-skills` skills.
The wiki's own project-local skill should have a distinct name and contain
only domain-specific vocabulary, taxonomy, and language.

## Update the base image

For a versioned runtime release, publish a matching Git tag, for example
`0.1.0`. To build against a different sandbox version, run the
**Publish wiki runtime** workflow manually and specify both image tags.
`graphify-out/` is generated locally and is ignored by Git.
