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

### Option A: New Project (no existing AGENTS.md)

1. Copy the `template/` contents into your project root:
   ```bash
   cp -r template/* /path/to/your/project/
   # or on Windows:
   # Copy-Item -Recurse template\* C:\path\to\your\project\
   ```
2. Open your AI coding agent (Copilot CLI, Claude Code, Cursor, etc.) in the project
3. Give it this prompt:

   > **Read AGENTS.md and follow the First Run setup instructions. Scan my project files to auto-fill what you can, then ask me for anything you can't infer.**

4. The agent will auto-configure everything, then delete the setup block when done

### Option B: Existing Project (already has AGENTS.md)

1. Copy the `template/` contents into your project root (your existing AGENTS.md will be backed up):
   ```bash
   # Back up first, then copy template
   cp AGENTS.md AGENTS.md.backup
   cp -r template/* /path/to/your/project/
   ```
2. Open your AI coding agent in the project
3. Give it this prompt:

   > **Read AGENTS.md and follow the Migration setup path. My project already has agent configuration files — search for AGENTS.md, CLAUDE.md, .cursorrules, .github/copilot-instructions.md, and any other agent instruction files. Back them all up, extract all project-specific information, and use it to configure this template. Create symlinks for backward compatibility. Ask me to confirm before finalizing.**

4. The agent will read your old AGENTS.md, merge the info into the template, and ask you to confirm

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
