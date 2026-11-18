---
name: wiki-hosting
description: Use when ingesting sources into a repository wiki, answering questions from wiki content, maintaining wiki structure, or refreshing its Graphify knowledge graph.
---

# Wiki hosting

This skill provides wiki-generic workflows. The repository's own skill supplies
domain-specific taxonomy and language; keep those concerns separate.

## Repository contract

Wiki projects keep immutable source material in `raw/` and the maintained wiki
in `wiki/`:

- `wiki/index.md` catalogs source summaries and concepts.
- `wiki/log.md` is an append-only operation log.
- `wiki/sources/` contains concise, attributed summaries of raw sources.
- `wiki/entities/`, `wiki/concepts/`, and `wiki/synthesis/` contain the
  interlinked final wiki.
- `raw/assets/` stores source images and attachments.

Use relative Markdown links for wiki cross-references. Preserve the source
files in `raw/`; add a corrected or newer source as a new file rather than
rewriting an existing one. Put domain-specific rules in the project's skill.

## Ingest

1. Read the domain skill and `wiki/index.md` before editing.
2. Save the source under `raw/` with a descriptive filename. Record its URL,
   author, and access date in the corresponding `wiki/sources/` page.
3. Summarize claims without copying large passages. Separate source statements
   from interpretation and link claims to the source summary.
4. Create or update the relevant entity, concept, and synthesis pages. Record
   disagreements and link both sides rather than silently choosing one.
5. Update `wiki/index.md` and append an `ingest` entry to `wiki/log.md`.
6. If the documentation changed, refresh the graph with `graphify extract .`.

## Query

Start with `wiki/index.md`, then read only the pages that address the question.
Use `graphify query "<question>"` to find connected pages and cite the wiki
files in the answer. Save substantial, reusable findings as a new synthesis
page and append a `query` entry to `wiki/log.md`.

## Lint

When asked to lint, check for broken links, missing index entries, orphaned
pages, stale claims, contradictions, and missing provenance. Fix findings,
refresh the graph if wiki files changed, and append a `lint` entry to
`wiki/log.md`.

## Graphify

The runtime image provides the `graphify` CLI through the `graphifyy[openai]`
package. Graphify extracts code locally and can use the configured
OpenAI-compatible endpoint for documents:

- `OPENAI_API_KEY` supplies the API key.
- `OPENAI_BASE_URL` selects the API endpoint (default:
  `https://api.mistral.ai/v1`).
- `OPENAI_MODEL` selects the model (default: `mistral-large-latest`).

Run `graphify extract .` after wiki edits, `graphify update .` after code-only
edits, and `graphify query "<question>"` to navigate the graph. Generated
`graphify-out/` files are derived data and should not be committed.
