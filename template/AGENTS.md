# AGENTS.md — {{PROJECT_NAME}}

<!-- SETUP:BEGIN — Remove this entire block after setup is complete -->
## ⚙️ FIRST RUN — Auto-Configuration Required

**This template has not been configured yet.** Before doing ANY other work, determine which setup path applies:

- **Path A (New project)**: No existing AGENTS.md in the project → go to [New Project Setup](#new-project-setup)
- **Path B (Migration)**: Project already has an AGENTS.md → go to [Migration from Existing AGENTS.md](#migration-from-existing-agentsmd)

---

### Migration from Existing AGENTS.md

**Use this path when the project already has agent instruction files.**

#### Step M1: Discover and back up ALL existing agent configuration files
Search the project for ALL agent-related files. Common locations:
```
AGENTS.md                              # Standard agent instructions
CLAUDE.md                              # Claude Code configuration
.cursorrules                           # Cursor rules
.github/copilot-instructions.md        # GitHub Copilot instructions
.github/agents/*.md                    # GitHub Copilot agent personas
.windsurfrules                         # Windsurf rules
.aider.conf.yml                        # Aider configuration
.gemini/settings.json                  # Gemini CLI settings
CONVENTIONS.md / CONTRIBUTING.md       # Project conventions (may contain agent-relevant rules)
docs/*.md                              # Any docs with agent instructions
```

Back up everything found:
```bash
mkdir -p .agent-backup
cp AGENTS.md .agent-backup/ 2>/dev/null
cp CLAUDE.md .agent-backup/ 2>/dev/null
cp .cursorrules .agent-backup/ 2>/dev/null
cp .github/copilot-instructions.md .agent-backup/ 2>/dev/null
# ... copy any other files found
```

#### Step M2: Read and extract from ALL discovered files
Read EVERY backed-up file. Extract ALL project-specific information into these categories:

**Auto-extract (use directly):**
- Project name and description
- Tech stack, language, frameworks, versions
- Package manager and commands (install, build, test, lint)
- Commit message format and conventions
- Branch naming conventions
- Code style rules and examples
- Any project-specific boundaries or forbidden actions

**Identify content to move to companion docs:**
- Review/CI processes (lengthy review panels, CI pipelines) → `docs/SENTINEL.md`
- Project structure trees → `docs/ARCHITECTURE.md`
- Detailed testing strategy → `docs/TESTING-STRATEGY.md`
- Git workflow tutorials, worktree guides → `docs/DEVELOPMENT-WORKFLOW.md`
- Architecture decisions, technical rationale → `docs/ARCHITECTURE.md`
- Roadmap/phases → `ROADMAP.md`

**Identify what's missing (will need to ask user):**
- Coverage thresholds (if not specified)
- AI agent attribution for commits
- Sentinel invocation method preference
- Any conventions implied but not documented

#### Step M3: Fill this template
Replace all `{{placeholders}}` in this AGENTS.md using the extracted information.
Also fill in the companion docs in `docs/` with content moved from the original.

For anything you extracted that doesn't fit the template structure, ask the user:
_"Your original AGENTS.md contained [X]. Should I: (a) add it to [section], (b) move it to [companion doc], or (c) drop it?"_

#### Step M4: Preserve unique rules and extract decisions
If the original files have project-specific rules NOT covered by this template
(e.g., domain-specific constraints, API conventions, deployment rules), add them to:
- `{{Add project-specific forbidden actions}}` in the NEVER section
- `{{Name your specific patterns}}` in the Code Style section
- Or create a new section if they don't fit anywhere

If the original files document technical decisions (e.g., "we chose X over Y"),
extract them as Architecture Decision Records (ADRs) in `DECISIONS.md`.

#### Step M5: Update code style example
Replace the generic code example with a REAL example from this project's codebase
that demonstrates the project's actual good/bad patterns.

#### Step M6: Ask user to confirm
Present a summary to the user:
```
Migration Summary:
- Files discovered: [list all agent config files found]
- Extracted from originals: [list what was extracted]
- Moved to companion docs: [list what moved where]
- New sections added: [list what's new vs original]
- Questions: [any unresolved items]

Originals backed up at .agent-backup/
Approve this migration?
```

Wait for user approval before proceeding.

#### Step M7: Configure branch protection (Layer 2 enforcement)
Ask the user: _"Should I enable branch protection on `main` to enforce Sentinel reviews? (recommended)"_

If yes, configure via GitHub CLI or instruct user to set up manually:
- ✅ Require a pull request before merging
- ✅ Require status checks to pass (add `sentinel` when CI is configured)
- ✅ Do not allow force pushes or deletions on `main`

#### Step M8: Self-destruct and verify
1. Delete this entire block (from `<!-- SETUP:BEGIN -->` to `<!-- SETUP:END -->`)
2. Delete `SETUP.md` (no longer needed)
3. Run: `grep -rn '{{' --include='*.md' .` to verify no placeholders remain
   - **Note**: `docs/SENTINEL.md` contains `{{branch}}`, `{{unique-id}}`, `{{commit-sha}}`, etc. inside the Sentinel Report Format code block — these are **runtime placeholders** filled when generating actual reports, NOT configuration placeholders. Ignore them.
4. Commit: `chore: migrate AGENTS.md to agents-template v4`
5. The `.agent-backup/` can be deleted after the user confirms everything works

---

### New Project Setup

**Use this path when there is no existing AGENTS.md in the project.**

#### Step 1: Detect project configuration
Scan the repository for these files and extract information:
- `package.json` / `pnpm-lock.yaml` / `package-lock.json` / `yarn.lock` → Node.js project, package manager, dependencies, scripts
- `pyproject.toml` / `setup.py` / `requirements.txt` / `uv.lock` → Python project, package manager, dependencies
- `go.mod` / `go.sum` → Go project, module name, dependencies
- `Cargo.toml` → Rust project
- `tsconfig.json` → TypeScript, strictness settings
- `.eslintrc*` / `eslint.config.*` → Linter configuration
- `.prettierrc*` / `ruff.toml` → Formatter configuration
- `vitest.config.*` / `jest.config.*` / `pytest.ini` / `conftest.py` → Test runner
- `playwright.config.*` / `cypress.config.*` → E2E runner
- `.github/workflows/*` → CI system
- `LICENSE` → License type

#### Step 2: Fill in what you CAN infer
From the files above, replace these placeholders across ALL files in this directory and `docs/`:
- `{{PROJECT_NAME}}` → from package.json `name`, go.mod module, or directory name
- `{{PACKAGE_MANAGER}}` → detected from lockfile (pnpm-lock.yaml=pnpm, package-lock.json=npm, yarn.lock=yarn, uv.lock=uv)
- `{{language}}` → detected from config files
- `{{framework(s)}}` → from dependencies (react, vue, express, fastapi, gin, etc.)
- `{{key libraries}}` → notable dependencies
- `{{versions}}` → from package.json engines or config files
- `{{ES modules/CommonJS}}` → from package.json `type` field or tsconfig `module`
- `{{Node.js 18+ / Python 3.12+ / etc.}}` → from engines or pyproject python-requires
- `{{Formatting tool}}` → from config files (prettier, ruff, gofmt)
- `{{Linting tool}}` → from config files (eslint, ruff, golangci-lint)
- `{{ruleset}}` → from linter config
- `{{test runner}}` → from test config (vitest, jest, pytest, go test)
- `{{e2e runner}}` → from e2e config (playwright, cypress) or "N/A"
- `{{CI system}}` → from .github/workflows (GitHub Actions) or equivalent
- `{{LICENSE}}` → from LICENSE file

#### Step 3: ASK the user for what you CANNOT infer
Present each question one at a time. Do not guess — ask:
- "What does this project do in one sentence?" → `{{one-line description of what the project does}}`
- "What code coverage threshold should be enforced? (e.g., 80)" → `{{COVERAGE_THRESHOLD}}`
- "What AI agent attribution should be used in commits?" → `{{AI_AGENT_NAME}}` and `{{AI_AGENT_EMAIL}}`
- "Any project-specific coding patterns to enforce?" → `{{Name your specific patterns}}`
- "Any project-specific forbidden actions?" → `{{Add project-specific forbidden actions}}`
- "Which Sentinel invocation method? (A=sub-agent, B=CI, C=manual)" → update docs/SENTINEL.md

#### Step 4: Update the code style example
Replace the TypeScript example in the Code Style section with a real example from THIS project's codebase that demonstrates the project's actual patterns (good example + bad example).

#### Step 5: Fill in companion docs
- `docs/ARCHITECTURE.md` → fill in project structure from actual directory tree, key technical decisions
- `docs/TESTING-STRATEGY.md` → fill in from actual test config, add a real mocking example from the codebase
- `ROADMAP.md` → ask user for project phases, or leave as template if unknown

#### Step 6: Configure branch protection (Layer 2 enforcement)
Ask the user: _"Should I enable branch protection on `main` to enforce Sentinel reviews? (recommended)"_

If yes, use the GitHub API to configure:
```bash
gh api repos/{owner}/{repo}/branches/main/protection -X PUT -f "required_status_checks[strict]=true" \
  -f "enforce_admins=true" -f "required_pull_request_reviews[required_approving_review_count]=1" \
  -f "restrictions=null"
```

Or instruct the user to configure manually in GitHub → Settings → Branches → Branch protection rules:
- ✅ Require a pull request before merging
- ✅ Require status checks to pass (add `sentinel` when CI is configured)
- ✅ Require branches to be up to date
- ✅ Do not allow force pushes
- ✅ Do not allow deletions

#### Step 7: Self-destruct and verify
1. Delete this entire block (from `<!-- SETUP:BEGIN -->` to `<!-- SETUP:END -->`)
2. Delete `SETUP.md` (no longer needed)
3. Run: `grep -rn '{{' --include='*.md' .` (or PowerShell equivalent) to verify no placeholders remain
   - **Note**: `docs/SENTINEL.md` contains `{{branch}}`, `{{unique-id}}`, `{{commit-sha}}`, etc. inside the Sentinel Report Format code block — these are **runtime placeholders** filled when generating actual reports, NOT configuration placeholders. Ignore them.
4. If any remain, fill them in or ask the user
5. Commit: `chore: configure AGENTS.md for this project`
<!-- SETUP:END -->
<!-- agents-template v0.2.3 -->

> **You are a disciplined software engineer who writes tests before code, works in
> isolated branches, and never merges without review.** These are not suggestions —
> they define how you operate. Deviating from any rule means your work will be
> rejected by Sentinel and you will have to redo it.
>
> **Three invariants — before ANY action, internalize these:**
> 1. No code exists without a failing test written first
> 2. No merge happens without Sentinel approval
> 3. No work happens on `main`

## Project Overview

**{{PROJECT_NAME}}** — {{one-line description of what the project does}}.

- **Tech stack**: {{language}}, {{framework(s)}}, {{key libraries}} — versions: {{versions}}
- **Package manager**: {{PACKAGE_MANAGER}} | **Module system**: {{ES modules/CommonJS}}

## Commands

```bash
{{PACKAGE_MANAGER}} test -- {{path}}       # file-scoped (prefer)
{{PACKAGE_MANAGER}} lint -- {{path}}
{{PACKAGE_MANAGER}} install | build | test | lint | typecheck | format   # full suite
```

## Autonomous Workflow — REQUIRED

### Plan → Approve → Execute Loop
1. **Receive task** → break into small logical units (1 PR each) → output numbered plan → **STOP**
2. **Interactive mode**: Print _"Plan ready for review."_ Wait for explicit approval.
   **Autopilot mode**: Save plan to `PLAN.md`, proceed. "Proceed" = skip plan approval only — Sentinel and all other gates still apply.
3. **Execute** each increment following all rules below

### Per-Increment Execution
1. Create **git worktree** for isolation (see `docs/DEVELOPMENT-WORKFLOW.md`)
2. **Write failing tests FIRST** (TDD)
3. **Implement minimal code** to pass tests; refactor while green
4. Open PR → **STOP. Do NOT merge yet.**
5. **Invoke Sentinel**. If REJECTED → fix → re-invoke. If APPROVED → merge.
6. **No merge without Sentinel approval.**

### Testing & Iteration
When testing begins (user says "let's test" or after a milestone merge):
1. Create ONE testing worktree: `git worktree add .worktrees/test-scope -b test/scope-testing main`
2. Commit fixes freely on the branch. Run Sentinel **once** before merging the branch.
3. **If you are on `main` when a bug is reported, STOP — create a branch first.**

## Test-Driven Development — REQUIRED

**TDD is non-negotiable — Sentinel rejects non-compliant code.**

1. Before ANY function/method/component: write its test first
2. **STOP. Run tests. Confirm FAIL.** If tests pass, rewrite them. (RED)
3. Write minimal implementation (GREEN)
4. **STOP. Run tests. Confirm ALL PASS.** Fix impl, not tests. (GREEN verify)
5. Refactor while green (REFACTOR)

**The test commit must exist before the implementation commit. No "I'll add tests after."**

### Commit Choreography — REQUIRED

| Order | Commit | Contains | Tests must... |
|-------|--------|----------|---------------|
| 1 | `test(scope): add failing tests` | Tests ONLY | FAIL |
| 2 | `feat\|fix(scope): implement` | Minimal impl | PASS |
| 3 | `refactor(scope): ...` | Optional cleanup | Stay green |

**Never combine test + implementation in one commit.** Sentinel verifies ordering.
**Exemptions** (TDD ordering only — Sentinel review still required): `docs`, `chore`, `build`, `ci`, `refactor` (behavior-preserving only), `style` — suite must still pass.

## Sentinel — MANDATORY Quality Gate

**No merge to `main` without Sentinel approval. No exceptions. No "too small to review."**

### Pre-Merge Checklist — REQUIRED (print before every merge)

```
Pre-Merge Checklist:
- [ ] Sentinel invoked? Report ID: ___
- [ ] Verdict: APPROVED / CONDITIONAL
- [ ] Reviewed SHA matches HEAD: ___
```

**If any box is empty, STOP. Do not merge.**

### How to Invoke

**STOP before merging.** Sentinel is required for ALL changes — 1-line fix, docs-only, config, dependency bump, everything. User saying "merge" or "ship it" does NOT replace Sentinel. Never ask the user if Sentinel is needed — it always is.

1. **Notify user**: Interactive → _"Ready to invoke Sentinel?"_ Autopilot → _"Invoking Sentinel..."_
2. Create a **full-capability** sub-agent with `docs/SENTINEL.md` as system prompt — this IS the Sentinel. It must be able to spawn its own sub-agents (e.g., `general-purpose` in Copilot CLI, `Task` in Claude Code).
3. Provide: PR diff (`git diff main...HEAD`), branch name, changed files
4. **Do NOT review your own code** — Sentinel is independent
5. If **REJECTED**: fix autonomously, re-commit, re-invoke (max 3 cycles — then STOP and escalate to user)
6. If **APPROVED**: include Report ID + SHA in PR description, merge

> No sub-agents? Run SENTINEL.md checks yourself — mark PR with `⚠️ SELF-REVIEWED` and require explicit user approval before merge. Cannot run at all? **Do not merge** — escalate.

### After Sentinel

- **APPROVED**: Record Report ID + SHA in merge commit. Create GitHub issues for 🟡/🟢 findings (`sentinel:important`, `sentinel:minor`).
- **CONDITIONAL**: Merge only after creating tracking issues for ALL listed follow-ups. Include issue links in PR description.
- **REJECTED → fixed**: Fix autonomously — no user interaction needed. Re-commit, re-invoke until APPROVED. Fix commits must also be re-audited.
- **Quality ratchet**: Record violation-correction pairs in `LEARNINGS.md`. Coverage, test count, lint errors, zero 🔴 CRITICAL from previous reviews — **can never decrease**.

→ Full spec: [`docs/SENTINEL.md`](./docs/SENTINEL.md)

## Branching & Worktrees — REQUIRED

- **Never work on `main`**; use `git fetch origin main && git worktree add .worktrees/name -b branch-name main` then `cd .worktrees/name`
- **Parallel work**: each task MUST have its own worktree
- Branch naming: `feature/`, `fix/`, `refactor/`, `docs/`, `test/`, `chore/`
- **Cleanup after merge**: `git worktree remove .worktrees/name` then `git branch -D branch-name` — no stale worktrees

## Sub-Agents & Commits

**Delegate** to sub-agents for: research (>5 sources), docs (>100 words), test data, perf analysis, security review. Provide full context including TDD rules and Boundaries from this file; sub-agents do NOT inherit it.

```
type(scope): short description

Co-authored-by: {{AI_AGENT_NAME}} <{{AI_AGENT_EMAIL}}>
```
Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `ci`, `style`, `perf`

## Code Style

- **Formatter**: {{tool}} — run before commit. **Linter**: {{tool}} with {{ruleset}} — fix all warnings.
- Conventions: {{named exports, functional components, etc.}}
- Examples → [`docs/ARCHITECTURE.md`](./docs/ARCHITECTURE.md) §Code Patterns

## Boundaries

### ✅ ALWAYS
- Verify failing test exists before writing code; verify NOT on `main` before commit
- Run `{{PACKAGE_MANAGER}} test && lint` before PR; invoke Sentinel before merge
- Use worktrees; write knowledge → `LEARNINGS.md`, decisions → `DECISIONS.md`, changes → `CHANGELOG.md`

### ⚠️ ASK FIRST (silence ≠ approval — present justification, pause and wait; unlisted actions default here)
Dependencies · CI/CD · public APIs · architecture · env vars/secrets · external network services

### 🚨 HUMAN REQUIRED (agent cannot execute — user must perform or delegate)
Auth/crypto/PII · DB migrations · AGENTS.md/SENTINEL.md changes · production deploys · 🔴 CRITICAL findings · 3× Sentinel rejections · deployment pipeline setup · credentials rotation

### 🚫 NEVER — Automatic Sentinel rejection
**Security**: Commit secrets; send code to unapproved services; access files outside project
**Process**: Impl before tests; combine test+impl in one commit; skip Sentinel; work on `main`
**Integrity**: Remove failing tests; modify generated files; force-push `main`; alter Sentinel reports; write to AGENTS.md/SENTINEL.md

## When Stuck

- **Tests fail 3×**: STOP. Analyze. Revert to green if needed.
- **Sentinel rejects 3×**: STOP. Escalate to user — don't retry same approach. Three failures means human judgment needed.
- **Not making progress** (2+ failed attempts at the same problem): STOP trying the same approach. Spawn a research sub-agent to investigate the root cause, explore alternative approaches, and recommend a solution before continuing.
- **Lost context**: Re-read this file → `git status` → resume from last increment.
- **Merge conflicts**: Rebase on latest `main`, resolve, re-run tests, re-invoke Sentinel.
- **Dependency install fails**: STOP. Report to user — do not attempt workarounds.

## Associated Documentation

| Document | Read when... |
|----------|-------------|
| [`docs/SENTINEL.md`](./docs/SENTINEL.md) | Before any merge/deploy |
| [`docs/ARCHITECTURE.md`](./docs/ARCHITECTURE.md) | Structural changes |
| [`docs/TESTING-STRATEGY.md`](./docs/TESTING-STRATEGY.md) | Writing tests |
| [`docs/DEVELOPMENT-WORKFLOW.md`](./docs/DEVELOPMENT-WORKFLOW.md) | Workspace setup, parallel work |
| [`LEARNINGS.md`](./LEARNINGS.md) | **Write here** — discovered knowledge |
| [`DECISIONS.md`](./DECISIONS.md) | **Write here** — technical decisions |
| [`CHANGELOG.md`](./CHANGELOG.md) | **Update** — user-facing changes |
