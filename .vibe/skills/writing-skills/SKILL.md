---
name: writing-skills
description: "Load this skill whenever you create, update, or delete a Vibe skill in this repo, or when ingesting new sources about skill authoring. It applies Karpathy's llm-wiki pattern (raw sources -> persistent interlinked wiki -> schema) with a graphifyy knowledge graph of the repo on top, so skill-authoring knowledge compounds instead of being re-derived on every task."
---

# Writing Skills (llm-wiki style)

This is the general skill for authoring skills in this repository. It follows
the llm-wiki pattern from `raw/karpathy-llm-wiki.md` (Karpathy's gist): instead
of re-reading sources and re-deriving conventions on every request, knowledge
about how skills work here is compiled once into a persistent, interlinked
wiki (`wiki/`) and kept current, with a graphifyy knowledge graph of the repo
(`graphify-out/` at the repo root) layered on top for structural navigation.

## Layout

```
.vibe/skills/writing-skills/
├── SKILL.md                  <- the schema: conventions + workflows (this file)
├── raw/                      <- immutable sources (add only, never edit)
│   ├── karpathy-llm-wiki.md
│   └── vibe-skill-creator-SKILL.md
└── wiki/                     <- LLM-owned, compounding knowledge base
    ├── index.md              <- content-oriented catalog of all wiki pages
    ├── log.md                <- append-only chronological log
    ├── sources/              <- one summary page per raw source
    └── concepts/             <- concept pages (patterns, formats, tools)
```

## Layer 1: raw sources

- Drop new sources (articles, docs, example SKILL.md files, gists) into `raw/`
  under a short slug filename. Raw files are immutable: read them, never edit.
- Record provenance (URL, author, fetch date) in the wiki source page, not by
  editing the raw file.

## Layer 2: the wiki

The agent owns `wiki/` entirely. The user reads it; the agent writes it.

Page conventions:

- Every page starts with YAML frontmatter: `title`, `tags`, `sources`,
  `created`, `updated` (YYYY-MM-DD).
- Cross-reference pages with relative markdown links.
- Flag disagreements inline with `> CONTRADICTION:` linking both pages; the
  newer source wins and the loser gets a `> SUPERSEDED BY:` note.
- `index.md` lists every page by category (sources / concepts / entities) with
  a one-line summary; update it on every ingest.
- `log.md` is append-only with entries prefixed `## [YYYY-MM-DD] <op> | <title>`
  (ops: `ingest`, `query`, `lint`, `skill`), so
  `grep "^## \[" wiki/log.md | tail -5` shows recent activity.

## Layer 3: the schema (this file)

The rules below are the schema: how skills are written in this repo and how the
wiki and graph are maintained. Co-evolve them with the wiki as you learn what
works.

## How to write a skill in this repo

1. **Scope.** Project skills live in `.vibe/skills/<slug>/` (this repo uses
   project scope; it requires a trusted folder). Global skills go to
   `~/.vibe/skills/<slug>/`. Discovery order, first match wins: `skill_paths`
   in `config.toml`, then `.vibe/skills/`, `.agents/skills/`, `~/.vibe/skills/`,
   `~/.agents/skills/`.
2. **Format.** A skill is a directory containing a `SKILL.md`:

   ```yaml
   ---
   name: my-skill          # required: ^[a-z0-9]+(-[a-z0-9]+)*$, 1-64 chars; match the dir name
   description: Load this skill when ...   # required: 1-1024 chars; the ONLY text seen before selection
   # user-invocable: false # optional, default true; false = model-only, hidden from /
   # allowed-tools: ...    # optional, experimental, space-delimited pre-approved tools
   # metadata: {...}       # optional, flat string-to-string map
   ---
   ```

   Never invent frontmatter keys (`visibility`, `defaultEnabled`, ... are
   ignored). Never reuse a built-in (`vibe:*`) or existing skill name — the
   collision is silently skipped and the skill will not load.
3. **Support files.** Keep `SKILL.md` focused on durable instructions. Add
   bulky reference material (md, txt, csv, json, yaml) as support files in the
   same directory, referenced by path relative to the skill directory.
4. **Lifecycle.** Create by writing `<skills-dir>/<slug>/SKILL.md`; update by
   editing in place with a minimal diff; delete by removing the whole skill
   directory, never just `SKILL.md`. A running session picks up new or edited
   skills on its own; if it does not, tell the user to run `/reload`.

## Operations

- **Ingest** (a new source about skill authoring arrives, or a new skill is
  added): read the raw source, write its summary page under `wiki/sources/`,
  create/update every concept or entity page it touches, update `wiki/index.md`,
  append a `log.md` entry. One source may touch 10-15 pages — that is expected.
- **Query** (e.g. "how do I write a skill that ...?"): read `wiki/index.md`
  first, then drill into the relevant pages, and answer with citations to wiki
  pages. File any substantial answer back into the wiki as a new page so
  explorations compound too. Before reading whole repo files, ask the graph
  first (below).
- **Lint** (when asked to health-check): scan `wiki/` for contradictions
  between pages, stale claims superseded by newer sources, orphan pages with no
  inbound links, important concepts lacking their own page, and missing
  cross-references; fix them and append a `lint` log entry.

## Knowledge graph (graphifyy)

The whole repo is mapped to a queryable knowledge graph at `graphify-out/` by
[graphifyy](https://pypi.org/project/graphifyy/) (PyPI package name has a double
y; the CLI command is `graphify`). Details and command reference:
`wiki/concepts/knowledge-graph-graphifyy.md`.

- **Build:** `graphify extract .` from the repo root. Code is parsed locally
  with tree-sitter (deterministic, no API key); docs/papers/media go through an
  LLM backend auto-detected from API keys (`--backend <name>`,
  `GRAPHIFY_BACKEND`; OpenAI-compatible endpoints via `OPENAI_BASE_URL` +
  `OPENAI_MODEL` + `OPENAI_API_KEY`). Fully offline: `--code-only` or
  `GRAPHIFY_BACKEND=none`.
- **Refresh:** after code edits run `graphify update .` (no LLM); after doc
  edits re-run `graphify extract .` (incremental via `manifest.json`/`cache/`).
- **Query instead of grepping:** `graphify query "<question>"`,
  `graphify explain "<node>"`, `graphify path "A" "B"`, `graphify affected "X"`,
  `graphify god-nodes`, `graphify section "README.md#Some Heading"`.
  Exit codes: 0 answer, 3 ambiguous name (candidates listed), 4 no match.
- **Output:** `graphify-out/graph.json` (nodes/edges/communities; every edge
  tagged `EXTRACTED` / `INFERRED` / `AMBIGUOUS`), `GRAPH_REPORT.md`,
  `graph.html`, `manifest.json`, `cache/`. `.graphifyignore` at the repo root
  keeps the graph from ingesting its own output.

## Workflow when asked to write or change a skill

1. Read `wiki/index.md` and `tail wiki/log.md` to see what is already known.
2. `graphify query "<the task>"` to find relevant repo structure; read only the
   cited files/sections.
3. Create or update the skill per the rules above.
4. If you consulted any new source, ingest it: `raw/` + wiki pages + `index.md`
   + `log.md`.
5. Refresh the graph (`graphify update .`, or `graphify extract .` after doc
   changes) and append a `skill` entry to `wiki/log.md`.
