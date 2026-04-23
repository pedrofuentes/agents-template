# agents-template

![Version](https://img.shields.io/badge/version-0.3.0-blue)

> A battle-tested template for configuring autonomous AI coding agents with quality gates, TDD enforcement, and the Sentinel review system.

## What's Inside

The `template/` directory contains everything you copy into your project:

| File | Purpose |
|------|---------|
| `template/AGENTS.md` | The agent operating system — MUST rules, TDD, workflow, boundaries |
| `template/SETUP.md` | Placeholder inventory & customization checklist |
| `template/ROADMAP.md` | Project phases template |
| `template/docs/SENTINEL.md` | Quality gate — 6 parallel review sub-agents, invocation, infrastructure enforcement |
| `template/docs/ARCHITECTURE.md` | Project structure template |
| `template/docs/TESTING-STRATEGY.md` | Test strategy details |
| `template/docs/DEVELOPMENT-WORKFLOW.md` | Git worktrees, branching, PR process |

## Quick Start

Give your AI agent one of these prompts — it handles everything:

### New Project (no existing agent config)

> **Fetch the agents-template from https://github.com/pedrofuentes/agents-template — download all files from the `template/` directory into this project's root. Then read AGENTS.md and follow the First Run setup instructions. Scan my project files to auto-fill what you can, then ask me for anything you can't infer.**

### Existing Project (already has AGENTS.md or other agent config)

> **Fetch the agents-template from https://github.com/pedrofuentes/agents-template — first back up any existing agent config files (AGENTS.md, CLAUDE.md, .cursorrules, copilot-instructions.md, etc.) to `.agent-backup/`, then download all files from the `template/` directory into this project's root. Read AGENTS.md and follow the Migration setup path. Extract all project-specific information from the backed-up files and use it to configure the template. Ask me to confirm before finalizing.**

### Update (already using agents-template, upgrading to latest version)

> **Fetch the latest agents-template from https://github.com/pedrofuentes/agents-template — compare the `template/` files with my current versions. Show me what changed, apply updates while preserving my project-specific configuration (filled-in placeholders, custom rules, code examples). Do NOT overwrite my customizations. Ask me to confirm before applying changes.**

### Manual Setup (fallback)

If your agent can't fetch from GitHub:
```bash
git clone https://github.com/pedrofuentes/agents-template.git /tmp/agents-template
cp -r /tmp/agents-template/template/* /path/to/your/project/
rm -rf /tmp/agents-template
```
Then give the agent the appropriate prompt above (without the "Fetch..." part).

**⚠️ After setup completes, start a new agent session.** Most tools cache instructions at session start — a new session ensures the agent operates under the configured rules, not the template version.

## Invoking Sentinel

### Before a merge (standard)
> **STOP. Before merging, invoke the Sentinel. Create a sub-agent with `docs/SENTINEL.md` as its system prompt. Provide it the PR diff (`git diff main...HEAD`), the branch name, and changed files. Do NOT review your own code. Tell me the decision.**

### Post-merge audit (if Sentinel was skipped)
> **Run a post-merge Sentinel audit. Create a sub-agent with `docs/SENTINEL.md` as its system prompt. Provide it the last merge diff (`git diff HEAD~1`). If any 🔴 CRITICAL findings exist, create follow-up fix commits.**

### Fallback (no sub-agent support)
> **Read `docs/SENTINEL.md` and act as the Sentinel — run every check against the current PR diff. Note: self-review is lower trust than a separate sub-agent.**

*CI enforcement (recommended for teams): See `docs/SENTINEL.md` for GitHub Actions integration.*

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

## How It Works — The Quality Ratchet

The system enforces a continuous improvement loop. The coding agent and the Sentinel are **always separate** — the agent that wrote the code never reviews its own work.

```
Coding Agent writes code (TDD, worktrees, small increments)
         ↓
Sentinel (separate sub-agent) reviews
         ↓
    ❌ REJECTED → Coding Agent fixes → Sentinel reviews again (max 3 cycles)
         ↓                                    ↑
         └────────── loop until ──────────────┘
         ↓
    ✅ APPROVED → record baseline SHA → merge to main
         ↓
    Create GitHub issues for 🟡/🟢 findings → follow-up PRs → same loop
         ↓
    3× REJECTED on same issue? → 🚨 escalate to human
```

Each cycle ratchets quality up. The Sentinel never lowers its standards. The loop only exits when the quality threshold is met or a human takes over.

### Severity Levels

| Level | Meaning | Merge? | Examples |
|-------|---------|--------|----------|
| 🔴 CRITICAL | Must fix — blocks merge | No | Security vuln, data loss, incorrect behavior, failing tests, TDD violation |
| 🟡 IMPORTANT | Improvements to working code | Conditional — tracked as GitHub issues | Missing error propagation, N+1 queries, resilience gaps, edge cases |
| 🟢 MINOR | Polish | Yes | Naming, docs, code style suggestions |

The agent autonomously fixes 🔴 findings and re-invokes Sentinel (up to 3 cycles). 🟡 findings are tracked as GitHub issues (`sentinel:important`). If a 🟡 finding could cause data loss or security exposure, Sentinel reclassifies it as 🔴. For production deploys, all 🟡 issues must be resolved or explicitly risk-accepted.

## Key Features

- **TDD defense in depth** — Layer 1 (STOP checkpoint verbs) + Layer 2 (Sentinel verification)
- **Sentinel quality gate** — 6 parallel review sub-agents with anti-prompt-injection
- **Quality ratchet** — continuous improvement loop until Sentinel approves
- **Separation of concerns** — the coder ≠ the reviewer, always
- **Autonomous workflow** — Plan → Approve → Execute → Sentinel → Merge
- **4-tier boundaries** — ALWAYS / ASK FIRST / HUMAN REQUIRED / NEVER
- **Commit choreography** — `test(red)` → `feat(green)` → `refactor` with exemptions
- **Identity framing** — Prompt engineering techniques for higher agent compliance

## How It Was Built

This template was refined through **24+ expert AI reviews across 9 models** (Claude Opus 4.7, Opus 4.6, Opus 4.5, Sonnet 4.6, Sonnet 4, Haiku 4.5, GPT-5.4, GPT-5.2, GPT-5.1). See `MIGRATION-GUIDE.md` for the full evolution history.

Current version: **v0.3.0**. See [CHANGELOG.md](./CHANGELOG.md) for version history.

## Battle-Tested

Live-tested on [gitnotate](https://github.com/pedrofuentes/gitnotate) (96 commits, 128 files, ~18K lines). Results:

- **Sentinel caught a real XSS vulnerability** (innerHTML injection) the agent would have shipped
- **Pre-merge checklist gate** prevents agents from merging without Sentinel — even for 1-line fixes
- **Coverage jumped** from 45% to 98% on undertested packages
- **TDD choreography violations detected** and documented as process debt
- **Quality ratchet loop worked autonomously** — agent invoked Sentinel, got REJECTED, fixed findings, re-invoked without being told
- **3 memory leaks** (MutationObserver, event listeners) caught and fixed
- **Unicode crash** (btoa on emoji/CJK) caught and fixed
- **5 CVEs** in transitive dependencies flagged and resolved

Every gap found during testing was fed back into the template to make it stronger.

## License

MIT
