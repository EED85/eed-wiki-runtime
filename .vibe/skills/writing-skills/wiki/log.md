# Log

Append-only chronological record of everything that happened to this wiki.
Prefix each entry `## [YYYY-MM-DD] <op> | <title>` (ops: `ingest`, `query`,
`lint`, `skill`) so `grep "^## \[" wiki/log.md | tail -5` shows recent activity.

## [2026-11-17] skill | writing-skills created

- Created this skill at `.vibe/skills/writing-skills/` following the llm-wiki
  pattern (schema = SKILL.md, wiki = `wiki/`, raw = `raw/`).
- Sources ingested below; concept pages created; `index.md` initialized.

## [2026-11-17] ingest | karpathy/llm-wiki.md

- Added raw source `raw/karpathy-llm-wiki.md`
  (gist `442a6bf555914893e9891c11519de94f`, fetched 2026-11-17).
- Created `wiki/sources/karpathy-llm-wiki.md` and
  `wiki/concepts/llm-wiki-pattern.md`.

## [2026-11-17] ingest | vibe:skill-creator SKILL.md

- Snapshotted built-in `vibe:skill-creator` into `raw/vibe-skill-creator-SKILL.md`.
- Created `wiki/sources/vibe-skill-creator.md` and
  `wiki/concepts/skill-anatomy.md`.

## [2026-11-17] ingest | graphifyy docs

- Created `wiki/concepts/knowledge-graph-graphifyy.md` from the graphifyy PyPI
  page and Graphify-Labs/graphify README.
- Built the repo knowledge graph: `graphify extract .` -> `graphify-out/`
  (`graph.json`, `GRAPH_REPORT.md`, `graph.html`).
