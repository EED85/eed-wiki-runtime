---
title: Wiki index
tags: [index]
sources: []
created: 2026-11-17
updated: 2026-11-17
---

# Index

Catalog of every page in this wiki. Read this first on any query, then drill
into the relevant pages. Updated on every ingest.

## Sources

- [karpathy-llm-wiki](sources/karpathy-llm-wiki.md) — Karpathy's llm-wiki gist:
  persistent LLM-maintained wiki (raw sources / wiki / schema; ingest, query,
  lint; index.md + log.md).
- [vibe-skill-creator](sources/vibe-skill-creator.md) — Vibe built-in
  `skill-creator` skill: SKILL.md frontmatter schema, discovery order, support
  files, lifecycle.

## Concepts

- [llm-wiki pattern](concepts/llm-wiki-pattern.md) — RAG re-derives per query;
  the wiki compounds. Three layers, three operations, two navigation files.
  This skill is an instantiation of the pattern for writing skills in this repo.
- [skill anatomy](concepts/skill-anatomy.md) — what a Vibe skill is: SKILL.md
  frontmatter fields and constraints, scopes, discovery order, support files.
- [knowledge graph (graphifyy)](concepts/knowledge-graph-graphifyy.md) — the
  repo-wide graph at `graphify-out/`: build/update/query commands, output files,
  edge confidence tags.

## Entities

- `writing-skills` — this skill (`.vibe/skills/writing-skills/`). The first
  entity page; add one per skill as more are created in this repo.
