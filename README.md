# agents-template

> A battle-tested template for configuring autonomous AI coding agents with quality gates, TDD enforcement, and the Sentinel review system.

## What's Inside

The `template/` directory contains everything you copy into your project:

| File | Purpose |
|------|---------|
| `template/AGENTS.md` | The agent operating system — MUST rules, TDD, workflow, boundaries |
| `template/SETUP.md` | Placeholder inventory & customization checklist |
| `template/ROADMAP.md` | Project phases template |
| `template/docs/SENTINEL.md` | Quality gate — 4 review agents, invocation, infrastructure enforcement |
| `template/docs/ARCHITECTURE.md` | Project structure template |
| `template/docs/TESTING-STRATEGY.md` | Test strategy details |
| `template/docs/DEVELOPMENT-WORKFLOW.md` | Git worktrees, branching, PR process |

## Quick Start

1. Copy the `template/` contents into your project root
2. Follow `SETUP.md` to replace all `{{placeholders}}`
3. Choose your Sentinel invocation method (see below)
4. Run the verification command in SETUP.md to confirm no placeholders remain

## Which Sentinel Method?

| Your Setup | Method | Notes |
|------------|--------|-------|
| Copilot CLI or Claude Code | Method A (sub-agent) | Convenient for dev; lower trust |
| CI/CD (GitHub Actions) | **Method B (recommended)** | Production-grade enforcement |
| Cursor, Windsurf, other | Method C (manual) | Always works |
| Solo project, no CI | Method C | Start here, upgrade later |

## Supported Stacks

| Stack | Package Manager | Test Runner | Formatter | Linter |
|-------|----------------|-------------|-----------|--------|
| TypeScript/Node | pnpm / npm | Vitest / Jest | Prettier | ESLint |
| Python | uv / pip | pytest | ruff | ruff |
| Go | (native) | go test | gofmt | golangci-lint |

## Key Features

- **TDD defense in depth** — Layer 1 (STOP checkpoint verbs) + Layer 2 (Sentinel verification)
- **Sentinel quality gate** — 4 consolidated review agents with anti-prompt-injection
- **Autonomous workflow** — Plan → Approve → Execute → Sentinel → Merge
- **4-tier boundaries** — ALWAYS / ASK FIRST / HUMAN REQUIRED / NEVER
- **Commit choreography** — `test(red)` → `feat(green)` → `refactor` with exemptions
- **Identity framing** — Prompt engineering techniques for higher agent compliance

## How It Was Built

This template was refined through **24 expert AI reviews across 8 different models** (Claude Opus 4.6, Opus 4.5, Sonnet 4.6, Sonnet 4, Haiku 4.5, GPT-5.4, GPT-5.2, GPT-5.1). See `MIGRATION-GUIDE.md` for the full evolution history.

## License

MIT
