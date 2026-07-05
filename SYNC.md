# Downstream Sync Manifest

Projects that adopted this template. "Last synced" is the `<!-- agents-template vX.Y.Z -->` marker in each repo's root `AGENTS.md`. Update a repo's row whenever you sync it.

**To refresh the whole table**, ask an agent: *"For each repo in SYNC.md, fetch its root AGENTS.md via `gh api repos/pedrofuentes/<repo>/contents/AGENTS.md`, read the agents-template version marker, and update the table."*

| Repo | URL | Last synced | Checked |
|------|-----|-------------|---------|
| gitnotate | https://github.com/pedrofuentes/gitnotate | v0.22.0 | 2026-07-04 |
| Arbol | https://github.com/pedrofuentes/arbol | v0.22.0 | 2026-07-04 |
| Council | https://github.com/pedrofuentes/Council | v0.22.0 | 2026-07-04 |
| stream-deck-ical | https://github.com/pedrofuentes/stream-deck-ical | v0.22.0 | 2026-07-04 |
| stream-deck-github-utilities | https://github.com/pedrofuentes/stream-deck-github-utilities | v0.22.0 | 2026-07-04 |
| stream-deck-cloudflare-utilities | https://github.com/pedrofuentes/stream-deck-cloudflare-utilities | v0.22.0 | 2026-07-04 |
| obsidian-subtitles-md | https://github.com/pedrofuentes/obsidian-subtitles-md | v0.22.0 | 2026-07-04 |
| github-dashboard | https://github.com/pedrofuentes/github-dashboard | v0.21.0 | 2026-07-04 |
| kawsay | https://github.com/pedrofuentes/kawsay | v0.22.0 | 2026-07-04 |

> **github-dashboard**: v0.22.0 sync PR [#724](https://github.com/pedrofuentes/github-dashboard/pull/724) is open (`quality` + `e2e` green), held by the `harness-guard` required check because it touches protected paths (`AGENTS.md`, `docs/SENTINEL.md`). Merges once the cofounder applies the `decision:approved` label — a harness-integrity gate the agent never self-applies. Row bumps to v0.22.0 on merge.
