---
title: Source — Karpathy, "LLM Wiki" (gist)
tags: [source, llm-wiki]
sources: [raw/karpathy-llm-wiki.md]
created: 2026-11-17
updated: 2026-11-17
---

# karpathy/llm-wiki.md

Source: <https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f>,
saved verbatim to `raw/karpathy-llm-wiki.md`, fetched 2026-11-17.

## Key takeaways

- RAG re-derives knowledge from scratch on every question; nothing accumulates.
  The llm-wiki instead **compounds**: the LLM incrementally builds and maintains
  a persistent, interlinked markdown wiki that sits between you and the raw
  sources — cross-references, flagged contradictions, and synthesis are already
  in place when you ask.
- Three layers: **raw sources** (immutable source of truth), **the wiki**
  (LLM-owned markdown pages), **the schema** (a config doc such as AGENTS.md /
  CLAUDE.md that makes the agent a disciplined wiki maintainer).
- Operations: **ingest** (read source → summary page → update entity/concept
  pages → index → log; one source may touch 10-15 pages), **query** (answer from
  the wiki with citations; file good answers back as new pages), **lint**
  (contradictions, stale claims, orphans, missing pages/cross-references, data
  gaps).
- Two navigation files: **index.md** (content catalog, read first when
  querying) and **log.md** (append-only chronological log with
  `## [YYYY-MM-DD] op | title` prefixes so `grep "^## \[" log.md | tail -5`
  works).
- Why it works: the bookkeeping (cross-refs, consistency, contradiction flags)
  is what makes humans abandon wikis; for an LLM the maintenance cost is near
  zero. The human curates sources and asks questions; the LLM does everything
  else.

See [llm-wiki pattern](../concepts/llm-wiki-pattern.md) for how this skill
instantiates the pattern.
