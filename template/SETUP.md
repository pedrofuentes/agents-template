# Setup Checklist — Template Customization

> Complete this checklist to customize the template for your project.

## ⚡ Quick Path (15 min) vs Full Path (60 min)

**Quick Path**: Fill in Project-Level + Tech Stack + Tooling → customize code style → choose Sentinel method → done.
**Full Path**: Everything above + ARCHITECTURE.md structure + ROADMAP.md phases + CI enforcement setup.

## Required Placeholders

### Project Identity
| Placeholder | Replace With | Files |
|-------------|-------------|-------|
| `{{PROJECT_NAME}}` | Your project name | AGENTS.md, ARCHITECTURE.md, DEVELOPMENT-WORKFLOW.md, ROADMAP.md |
| `{{one-line description of what the project does}}` | e.g., "A REST API for task management" | AGENTS.md |
| `{{LICENSE}}` | e.g., MIT | SENTINEL.md |
| `{{AI_AGENT_NAME}}` | e.g., Copilot | AGENTS.md |
| `{{AI_AGENT_EMAIL}}` | e.g., copilot@users.noreply.github.com | AGENTS.md |

### Tech Stack
| Placeholder | Replace With | Files |
|-------------|-------------|-------|
| `{{language}}` | e.g., TypeScript | AGENTS.md |
| `{{framework(s)}}` | e.g., React 18, Vite | AGENTS.md |
| `{{key libraries}}` | e.g., Tailwind CSS | AGENTS.md |
| `{{versions}}` | e.g., TS 5.3, React 18.2 | AGENTS.md |
| `{{PACKAGE_MANAGER}}` | pnpm / npm / yarn / uv | AGENTS.md, SENTINEL.md, TESTING-STRATEGY.md, DEVELOPMENT-WORKFLOW.md |
| `{{ES modules/CommonJS}}` | ES modules / CommonJS | AGENTS.md |
| `{{Node.js 18+ / Python 3.12+ / etc.}}` | Your minimum runtime | AGENTS.md |

### Tooling
| Placeholder | Replace With | Files |
|-------------|-------------|-------|
| `{{Formatting tool}}` | e.g., Prettier / ruff / gofmt | AGENTS.md |
| `{{Linting tool}}` | e.g., ESLint / ruff / golangci-lint | AGENTS.md |
| `{{ruleset}}` | e.g., typescript-eslint strict | AGENTS.md |
| `{{test runner}}` | e.g., Vitest / Jest / pytest / go test | TESTING-STRATEGY.md |
| `{{e2e runner}}` | e.g., Playwright / Cypress | TESTING-STRATEGY.md |
| `{{CI system}}` | e.g., GitHub Actions | TESTING-STRATEGY.md |
| `{{COVERAGE_THRESHOLD}}` | e.g., 80 | SENTINEL.md, TESTING-STRATEGY.md |

### Content (fill as you go)
| Placeholder | Replace With | Files |
|-------------|-------------|-------|
| `{{Name your specific patterns}}` | e.g., "named exports only" | AGENTS.md |
| `{{Add project-specific forbidden actions}}` | e.g., "Use jQuery" | AGENTS.md |
| `{{your mocking example}}` | A code example | TESTING-STRATEGY.md |
| `{{Add detailed setup instructions here — IDEs, extensions, environment variables, etc.}}` | IDE, extensions, env vars setup | DEVELOPMENT-WORKFLOW.md |
| Architecture placeholders | Project structure, decisions, modules | ARCHITECTURE.md |
| Roadmap placeholders | Phases, milestones | ROADMAP.md |

## ✅ Verification

Run this command to find any remaining placeholders:
```powershell
Select-String -Recurse -Path . -Include "*.md" -Pattern '\{\{' | Where-Object { $_.Filename -ne 'SETUP.md' }
```

Or on Unix:
```bash
grep -rn '{{' --include='*.md' . | grep -v 'SETUP.md'
```

When no results are returned (except SETUP.md itself), you're done.

**Exception:** `docs/SENTINEL.md` intentionally retains runtime placeholders in its report format (`{{branch}}`, `{{sha}}`, `{{unique-id}}`, `{{timestamp}}`, `{{X}}`, `{{N}}`, `{{call}}`, `{{variable}}`, `{{id or N/A}}`) — these are filled when Sentinel generates reports, NOT during setup. Leave them intact. Its setup placeholders (`{{COVERAGE_THRESHOLD}}`, `{{PACKAGE_MANAGER}}`) must still be filled.

## After Customization
1. Choose your Sentinel invocation method (A=sub-agent, B=CI, C=manual — the setup block asks this in Step 3)
2. If using CI (Method B), have your pipeline invoke Sentinel with `docs/SENTINEL.md` as its system prompt and gate merges on its `Status:` line (see docs/SENTINEL.md §Deploy / release gating for release gates)
3. Delete this file (SETUP.md) — it's only needed during initial setup

**Note:** The `docs/sentinel/` directory contains dimension-specific sub-agent prompts (A1, A2, B–F). These files require no customization — they are project-type-agnostic and work as-is. Copy them alongside `docs/SENTINEL.md`.
