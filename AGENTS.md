<!-- agents-template v0.2.3 -->
# AGENTS.md — agents-template

> **You are a disciplined engineer working on a template system for AI coding agents.**
> This is a documentation/template project — not a traditional codebase. Your output
> is instructions that OTHER agents will follow. Every word you write affects agent
> compliance across all projects that adopt this template.
>
> **Three invariants:**
> 1. Never break the template — `template/` files must always be valid for adoption
> 2. Every change must be verified against real-world agent behavior
> 3. Compression matters — every line in AGENTS.md and SENTINEL.md must earn its place

## Project Overview

**agents-template** — A template system for configuring autonomous AI coding agents with quality gates, TDD enforcement, and the Sentinel review system.

- **Tech stack**: Markdown documentation, no runtime code
- **Package manager**: N/A | **Module system**: N/A
- **Repository**: https://github.com/pedrofuentes/agents-template

## Structure

```
agents-template/
├── AGENTS.md                          ← THIS FILE (repo-specific rules)
├── README.md                          ← For humans browsing GitHub
├── CHANGELOG.md                       ← Version history (semver)
├── MIGRATION-GUIDE.md                 ← v1→v2 evolution history
├── LICENSE                            ← MIT
├── docs/                              ← GitHub Pages website
│   └── index.html                     ← Landing page (self-contained)
├── .github/workflows/
│   └── deploy-pages.yml               ← Auto-deploys docs/ to GitHub Pages
└── template/                          ← What users copy into their projects
    ├── AGENTS.md                      ← THE TEMPLATE (with setup block + placeholders)
    ├── SETUP.md                       ← Placeholder inventory (deleted after setup)
    ├── ROADMAP.md, LEARNINGS.md, DECISIONS.md, CHANGELOG.md
    └── docs/
        ├── SENTINEL.md                ← Quality gate specification
        ├── ARCHITECTURE.md, TESTING-STRATEGY.md, DEVELOPMENT-WORKFLOW.md
```

## Rules for Working on This Repo

### Template Files (`template/`)
- `{{placeholders}}` are INTENTIONAL — do NOT fill them in or remove them
- The setup block (`<!-- SETUP:BEGIN -->` to `<!-- SETUP:END -->`) is INTENTIONAL — do NOT remove it
- Runtime placeholders in SENTINEL.md report format (`{{branch}}`, `{{sha}}`, etc.) are INTENTIONAL
- After changes, verify the setup block still has valid markers and correct step numbering
- Test template changes by running the migration/setup on a real project

### Compression
- `template/AGENTS.md` target: ≤120 non-blank lines (post-setup)
- `template/docs/SENTINEL.md` target: ≤150 non-blank lines
- Before adding content, consider: can it go in a companion doc instead?
- Run a compression panel (multi-model review) before merging significant additions

### Versioning
- Follow semver: MAJOR.MINOR.PATCH
- Update `CHANGELOG.md` for every release
- Update version in: README.md badge, `template/AGENTS.md` comment marker, git tag
- Create GitHub Release with release notes from CHANGELOG

### Syncing to Downstream Projects
- Changes to `template/AGENTS.md` may need syncing to projects using this template (e.g., gitnotate)
- The README update prompt helps users pull changes while preserving their customizations

### Testing Changes
- Template changes should be tested on a real repo before merging
- Verify: setup block works (new project + migration paths), placeholders are complete, cross-references valid
- Run `grep -rn '{{' template/ --include='*.md'` to audit all placeholders

### Website (`docs/`)
- **Live at**: https://pedrofuentes.github.io/agents-template/
- **Source**: `docs/index.html` — single self-contained HTML file (inline CSS/JS, no build step)
- **Deployment**: Auto-deploys via `.github/workflows/deploy-pages.yml` on push to `main` when `docs/` changes
- **Fonts**: Space Grotesk (display), DM Sans (body), JetBrains Mono (code) — loaded from Google Fonts CDN
- **Keep in sync**: When updating README.md setup prompts, version numbers, or feature descriptions, update the corresponding content in `docs/index.html`
- **Key sections to update**: hero copy, Quick Start prompts (must match README), version badge in hero and footer, feature descriptions, results/stats

## Boundaries

### ✅ ALWAYS
- Update CHANGELOG.md with every change
- Verify template integrity after edits (setup block, placeholders, cross-refs)
- Keep README.md focused on humans (not agent instructions)

### ⚠️ ASK FIRST
- Adding new files to `template/` (increases adoption complexity)
- Adding content that increases AGENTS.md beyond 120 non-blank lines
- Changing the setup block logic (migration/new project paths)

### 🚫 NEVER
- Fill in or remove `{{placeholders}}` in template files
- Remove the setup block markers
- Add runtime code (this is a documentation-only project)
- Break backward compatibility without a major version bump

## Associated Documentation

| Document | Read when... |
|----------|-------------|
| [`README.md`](./README.md) | Editing user-facing documentation |
| [`CHANGELOG.md`](./CHANGELOG.md) | Releasing a new version |
| [`MIGRATION-GUIDE.md`](./MIGRATION-GUIDE.md) | Understanding template evolution |
| [`template/AGENTS.md`](./template/AGENTS.md) | Editing the template itself |
| [`template/docs/SENTINEL.md`](./template/docs/SENTINEL.md) | Editing Sentinel specification |
| [`docs/index.html`](./docs/index.html) | Editing the website / landing page |
