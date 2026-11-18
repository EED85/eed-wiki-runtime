---
title: Concept — anatomy of a Vibe skill
tags: [concept, vibe, skill-format]
sources: [raw/vibe-skill-creator-SKILL.md]
created: 2026-11-17
updated: 2026-11-17
---

# Anatomy of a Vibe skill

From [vibe-skill-creator](../sources/vibe-skill-creator.md).

## Structure

```
<skills-dir>/<slug>/
└── SKILL.md            # YAML frontmatter + markdown instructions
    └── support files   # md, txt, csv, json, yaml — referenced by relative path
```

## Frontmatter schema

- `name` (required): `^[a-z0-9]+(-[a-z0-9]+)*$`, 1–64 chars; should match the
  directory name. Never reuse a built-in (`vibe:*`) or existing name — the
  collision is silently skipped and the skill will not load.
- `description` (required): 1–1024 chars; say *when* to load. It is the only
  text the model sees before selecting the skill, so write it as routing text.
- `user-invocable` (optional, default `true`): `false` makes the skill
  model-only — hidden from the `/` menu and not reachable via `/skill-name`.
- `allowed-tools` (optional, experimental): space-delimited pre-approved tools.
- `license`, `compatibility`, `metadata` (optional): metadata only; `metadata`
  is a flat string-to-string map (e.g. `display-name`).
- Never invent frontmatter keys (`visibility`, `defaultEnabled`, ... are not
  part of the schema and are ignored).

## Scopes and discovery (first match wins)

1. `skill_paths` entries from `config.toml`
2. `.vibe/skills/` — project scope (requires a trusted folder)
3. `.agents/skills/` — project scope (requires a trusted folder)
4. `~/.vibe/skills/` — user global
5. `~/.agents/skills/` — user global

This repo uses project scope: `.vibe/skills/<slug>/`.

## Lifecycle

- **Create**: write `.vibe/skills/<slug>/SKILL.md` with valid frontmatter.
- **Update**: edit in place; preserve useful guidance, keep the diff minimal.
- **Delete**: remove the whole skill directory, not just `SKILL.md`.
- **Pickup**: a running session picks up new/edited skills on its own; if it
  does not (sandboxed session, file watcher off), tell the user to run `/reload`.
