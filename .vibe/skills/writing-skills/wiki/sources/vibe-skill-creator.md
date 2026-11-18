---
title: Source — Vibe built-in skill-creator SKILL.md
tags: [source, vibe, skill-format]
sources: [raw/vibe-skill-creator-SKILL.md]
created: 2026-11-17
updated: 2026-11-17
---

# vibe:skill-creator (snapshot)

Source: built-in Vibe skill `vibe:skill-creator`, snapshotted 2026-11-17 to
`raw/vibe-skill-creator-SKILL.md`.

## Key takeaways

- A skill is a directory containing a `SKILL.md` (YAML frontmatter + markdown
  body). The `description` is always visible for routing; the body loads only
  after the skill is selected. User-invocable skills are reachable via
  `/skill-name`.
- Discovery order (first match wins): `skill_paths` in `config.toml` →
  `.vibe/skills/` → `.agents/skills/` → `~/.vibe/skills/` →
  `~/.agents/skills/`. Project scope requires a trusted folder.
- Frontmatter: `name` (required, `^[a-z0-9]+(-[a-z0-9]+)*$`, 1–64 chars, should
  match the directory name), `description` (required, 1–1024 chars, say *when*
  to load), optional `user-invocable`, `allowed-tools`, `license`,
  `compatibility`, `metadata`. Do not invent keys; name collisions with built-in
  (`vibe:*`) or existing skills are silently skipped.
- Keep `SKILL.md` focused on durable instructions; support files (md, txt, csv,
  json, yaml) live in the same directory and are referenced by relative path.
- Create/update/delete: write `<skills-dir>/<slug>/SKILL.md`; delete removes the
  whole directory. Sessions pick up changes automatically, otherwise `/reload`.

See [skill anatomy](../concepts/skill-anatomy.md).
