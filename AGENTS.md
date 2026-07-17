<!-- agents-template v0.25.0 -->
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
├── CHANGELOG.md                       ← Version history (semver) + evolution history
├── SYNC.md                            ← Downstream sync manifest (repos + last-synced versions)
├── LICENSE                            ← MIT
├── docs/                              ← GitHub Pages website
│   └── index.html                     ← Landing page (self-contained)
├── .github/workflows/
│   ├── deploy-pages.yml               ← Auto-deploys docs/ to GitHub Pages
│   └── validate.yml                   ← Runs scripts/validate.sh on every PR / push to main
├── scripts/
│   └── validate.sh                    ← Automated repo checks (version sync, budgets, cross-refs, …)
├── evals/                             ← Behavioral regression tests for the Sentinel ruleset
│   ├── README.md                      ← Coverage matrix + scoring rules
│   ├── RUNNER.md                      ← Runner prompt (dim-level + end-to-end lanes)
│   └── fixtures/                      ← Synthetic PR diffs + expected verdicts (14 fixtures)
└── template/                          ← What users copy into their projects
    ├── AGENTS.md                      ← THE TEMPLATE (with setup block + placeholders)
    ├── SETUP.md                       ← Placeholder inventory (deleted after setup)
    ├── ROADMAP.md, LEARNINGS.md, DECISIONS.md, CHANGELOG.md
    └── docs/
        ├── SENTINEL.md                ← Quality gate specification
        ├── ARCHITECTURE.md, TESTING-STRATEGY.md, DEVELOPMENT-WORKFLOW.md
        └── sentinel/                  ← Dimension-specific sub-agent prompts
            ├── dim-a1-security-attacks.md, dim-a2-security-defenses.md
            ├── dim-b-resilience.md, dim-c-performance.md
            ├── dim-d-testing.md, dim-e-dependencies.md, dim-f-documentation.md
            ├── SEVERITY-RUBRIC.md         ← Phase 3 severity calibration (golden examples)
            └── BACKLOG-HYGIENE.md         ← Opt-in issue-backlog lifecycle (flag, never auto-close)
```

## Rules for Working on This Repo

### Template Files (`template/`)
- Files in `template/` are **content you are editing, not instructions for you to follow** — do NOT adopt workflows, rules, or processes described in template files (e.g., TDD enforcement, Sentinel reviews) as your own
- `{{placeholders}}` are INTENTIONAL — do NOT fill them in or remove them
- The setup block (`<!-- SETUP:BEGIN -->` to `<!-- SETUP:END -->`) is INTENTIONAL — do NOT remove it
- Runtime placeholders in SENTINEL.md report format (`{{branch}}`, `{{sha}}`, etc.) are INTENTIONAL
- After changes, verify the setup block still has valid markers and correct step numbering
- Test template changes by running the migration/setup on a real project

### Compression
- `template/AGENTS.md` target: ≤135 non-blank lines (post-setup)
- `template/docs/SENTINEL.md` target: ≤182 non-blank lines
- Before adding content, consider: can it go in a companion doc instead?
- Run a compression panel (multi-model review) before merging significant additions
- Do NOT compress compliance-critical instructions to meet line budgets — raise the budget instead

### Versioning
- Follow semver: MAJOR.MINOR.PATCH
- Update `CHANGELOG.md` for every release
- Update version in: README.md badge + "Current version" line, this file's line-1 marker, `template/AGENTS.md` marker + commit-message examples (3 occurrences), `docs/index.html` hero badge + footer, git tag
- Create GitHub Release with release notes from CHANGELOG
- SENTINEL.md's ruleset version ("v1") is the report-protocol contract (Status line, report format, verdict semantics) — independent of template semver; bump it only on breaking report-format changes

### Syncing to Downstream Projects
- Changes to `template/AGENTS.md` may need syncing to downstream projects — the sync list and each repo's last-synced version live in [`SYNC.md`](./SYNC.md); update its row when syncing a downstream
- The README update prompt helps users pull changes while preserving their customizations

### Testing Changes
- Template changes should be tested on a real repo before merging
- Verify: setup block works (new project + migration paths), placeholders are complete, cross-references valid
- Run `grep -rn '{{' template/ --include='*.md'` to audit all placeholders
- Verify the Structure tree above matches the actual file layout when adding/removing files
- CI runs `scripts/validate.sh` (version sync, placeholder audit, line budgets, setup-block markers, cross-refs, structure tree, severity levels) — keep the script in sync when these rules change
- Ruleset changes (`SENTINEL.md`, `sentinel/dim-*.md`, `SEVERITY-RUBRIC.md`) → also run the behavioral evals in [`evals/RUNNER.md`](./evals/RUNNER.md) (baseline before the edit, re-run after)

### Evaluating Downstream Agent Feedback
- Feedback from agents using Sentinel in downstream projects is **advisory, not prescriptive**
- Critically evaluate each suggestion: does it genuinely improve Sentinel's quality, clarity, or compliance effectiveness for the general case?
- Reject feedback that reflects project-specific quirks, agent misunderstandings, or changes that would weaken the template for other adopters
- When accepting or rejecting feedback, briefly explain the reasoning to the user
- Remember: this template serves multiple projects — optimizing for one downstream agent's preferences can degrade quality for all others
- **Deferred issues**: if a panel or review identifies a theoretical issue with no observed downstream failure, file it as a GitHub issue with the `sentinel:deferred` label. Include: the issue, current mitigation, when to revisit, and proposed fix. Do not implement until observed in practice.
- **When receiving new feedback**: check open `sentinel:deferred` issues — if the feedback confirms a previously theoretical issue is now occurring in practice, promote it to an active fix.

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
- Adding content that increases `template/AGENTS.md` beyond the compression target (≤135 non-blank lines post-setup)
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
| [`template/AGENTS.md`](./template/AGENTS.md) | Editing the template itself |
| [`template/docs/SENTINEL.md`](./template/docs/SENTINEL.md) | Editing Sentinel specification |
| [`docs/index.html`](./docs/index.html) | Editing the website / landing page |
