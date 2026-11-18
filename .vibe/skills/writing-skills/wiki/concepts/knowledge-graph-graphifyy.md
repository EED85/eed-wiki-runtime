---
title: Concept — repo knowledge graph via graphifyy
tags: [concept, graphify, knowledge-graph]
sources:
  - https://pypi.org/project/graphifyy/
  - https://github.com/Graphify-Labs/graphify
created: 2026-11-17
updated: 2026-11-17
---

# Knowledge graph (graphifyy)

The whole repo is mapped to a queryable knowledge graph at `graphify-out/` using
[graphifyy](https://pypi.org/project/graphifyy/) — the PyPI package name has a
double y; the CLI command it installs is `graphify` (plus `graphify-mcp`).
Apache-2.0, by Graphify-Labs.

## Pipeline

Detect (walks the folder, honours `.gitignore` and `.graphifyignore`) → Extract
(code: local tree-sitter AST, deterministic, no API key; docs/papers/images:
optional LLM semantic pass) → Resolve (binds calls/imports/inheritance across
files; unbindable edges marked `AMBIGUOUS`, never guessed) → Cluster (Leiden
community detection) → Report.

## Commands used in this repo (run from the repo root)

| Task | Command |
| --- | --- |
| Build the graph | `graphify extract .` |
| Offline / code-only build | `graphify extract . --code-only` (or `GRAPHIFY_BACKEND=none`) |
| LLM backend | auto-detected from API keys; override with `--backend <name>` or `GRAPHIFY_BACKEND`; any OpenAI-compatible endpoint via `OPENAI_BASE_URL` + `OPENAI_MODEL` + `OPENAI_API_KEY` |
| Refresh after code edits | `graphify update .` (AST only, no LLM) |
| Refresh after doc edits | re-run `graphify extract .` (incremental via `manifest.json` + `cache/`) |
| Ask a question | `graphify query "how are skills discovered in this repo?"` (`--depth 1-6`, `--budget N` tokens, `--seed <node>`) |
| Inspect structure | `graphify explain "SKILL.md"`, `graphify path "A" "B"`, `graphify affected "X"`, `graphify god-nodes` |
| Read one markdown section | `graphify section "README.md#Development container"` |
| Exports | `graphify export html\|svg\|graphml\|wiki\|obsidian\|neo4j ...` |

Exit codes for `query` / `path` / `explain`: `0` answer, `3` ambiguous name
(candidates listed), `4` no matching node.

## Output (`graphify-out/`)

- `graph.json` — nodes, edges, communities; every edge tagged `EXTRACTED`
  (read from source), `INFERRED` (derived), or `AMBIGUOUS` (several targets) —
  trust accordingly.
- `GRAPH_REPORT.md` — god nodes, communities, surprising connections, suggested
  questions.
- `graph.html` — interactive graph view (browser).
- `manifest.json` + `cache/` — file hashes and per-file AST cache for
  incremental rebuilds.

`.graphifyignore` at the repo root excludes `graphify-out/`, `uv.lock`, `.git/`
so the graph never ingests its own output.

## How the writing-skills workflow uses it

Before reading whole files, ask the graph (`graphify query ...`), then read only
the cited sections (`graphify section ...`). After writing or updating a skill,
run `graphify update .` (or `graphify extract .` after doc changes) and append a
`skill` entry to [log.md](../log.md).
