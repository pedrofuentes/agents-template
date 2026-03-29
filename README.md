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

Just give your AI coding agent one of these prompts — it handles everything:

### New Project (no existing agent config)

> **Fetch the agents-template from https://github.com/pedrofuentes/agents-template — download all files from the `template/` directory into this project's root. Then read AGENTS.md and follow the First Run setup instructions. Scan my project files to auto-fill what you can, then ask me for anything you can't infer.**

### Existing Project (already has AGENTS.md or other agent config)

> **Fetch the agents-template from https://github.com/pedrofuentes/agents-template — first back up any existing agent config files (AGENTS.md, CLAUDE.md, .cursorrules, copilot-instructions.md, etc.) to `.agent-backup/`, then download all files from the `template/` directory into this project's root. Read AGENTS.md and follow the Migration setup path. Extract all project-specific information from the backed-up files and use it to configure the template. Ask me to confirm before finalizing.**

### Manual Setup (fallback)

If your agent can't fetch from GitHub, do it yourself:

1. Clone this repo and copy `template/*` into your project root:
   ```bash
   git clone https://github.com/pedrofuentes/agents-template.git /tmp/agents-template
   cp -r /tmp/agents-template/template/* /path/to/your/project/
   rm -rf /tmp/agents-template
   ```
2. Then give the agent the appropriate prompt above (without the "Fetch..." part)

### ⚠️ After Setup: Start a New Session

Once the agent finishes configuring AGENTS.md, **start a new agent session** before doing any real work. This ensures the agent loads the fully configured AGENTS.md from scratch — not the template version with setup instructions it saw during configuration.

Most tools (Cursor, Windsurf, Claude Code) cache instructions at session start. A new session guarantees the agent operates under the configured rules.

## Invoking Sentinel

### Before a merge (standard)
> **STOP. Before merging, invoke the Sentinel. Create a sub-agent with `docs/SENTINEL.md` as its system prompt — it IS the Sentinel. Provide it the PR diff (`git diff main...HEAD`), the branch name, and list of changed files. The Sentinel will spawn its own review sub-agents, run the full verification process, and return the Sentinel Report. Do NOT review your own code — the Sentinel is a separate agent. Tell me the decision.**

### Post-merge audit (if Sentinel was skipped)
> **Run a post-merge Sentinel audit. Create a sub-agent with `docs/SENTINEL.md` as its system prompt. Provide it the last merge diff (`git diff HEAD~1`). The Sentinel will run the full verification process and produce the Sentinel Report. If any 🔴 CRITICAL findings exist, create follow-up fix commits.**

### Fallback (no sub-agent support)
> **Read `docs/SENTINEL.md` and act as the Sentinel — run every check in the verification process against the current PR diff. Note: self-review is lower trust than a separate sub-agent.**

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
