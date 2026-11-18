---
title: Concept — the llm-wiki pattern
tags: [concept, llm-wiki, knowledge-management]
sources: [raw/karpathy-llm-wiki.md]
created: 2026-11-17
updated: 2026-11-17
---

# The llm-wiki pattern

Distilled from [karpathy-llm-wiki](../sources/karpathy-llm-wiki.md). The
`writing-skills` skill is an instantiation of this pattern for *writing skills
in this repo*.

## Core idea

RAG retrieves chunks per query and re-derives answers every time — nothing
accumulates. The wiki pattern instead **compiles once and keeps current**: a
persistent, interlinked set of markdown pages sits between you and the raw
sources, so cross-references, contradiction flags, and synthesis are already in
place when a question arrives.

## Three layers

| Layer         | In this skill                     | Rule                                            |
| ------------- | --------------------------------- | ----------------------------------------------- |
| Raw sources   | `raw/`                            | Immutable; add, never edit                      |
| The wiki      | `wiki/`                           | Agent-owned; pages + `index.md` + `log.md`      |
| The schema    | `SKILL.md` (the skill itself)     | Conventions + workflows; co-evolve with the wiki |

## Operations

- **Ingest**: source → summary page → update every touched page → `index.md` →
  `log.md`. One source may touch 10-15 pages.
- **Query**: read `index.md` first, drill into pages, answer with citations;
  file substantial answers back as new pages so explorations compound too.
- **Lint**: contradictions between pages, stale claims superseded by newer
  sources, orphan pages, concepts lacking a page, missing cross-references.

## Navigation files

- `index.md` — content-oriented catalog by category; read first on every query;
  updated on every ingest. Works well up to ~100 sources / hundreds of pages.
- `log.md` — append-only chronological record; entries prefixed
  `## [YYYY-MM-DD] op | title`, parseable with `grep "^## \[" log.md | tail -5`.

## On top: knowledge graph

[graphifyy](knowledge-graph-graphifyy.md) maps the whole repo (code via local
AST, docs via LLM) into `graphify-out/graph.json`, queried with
`graphify query|explain|path` — structural navigation that complements the
wiki's content pages.
