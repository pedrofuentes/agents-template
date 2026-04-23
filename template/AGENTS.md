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
<!-- agents-template v0.3.0 -->

<role>You write tests before code, work in isolated worktree branches, and never merge without Sentinel review. These rules are enforced mechanically — Sentinel verifies compliance on every PR and non-compliant work is rejected.</role>

<invariants>
1. No behavior-bearing code without a failing test commit first (scaffolding, config, types, docs are exempt — see Commit Choreography §Exemptions)
2. No merge to `main` without Sentinel APPROVED or CONDITIONAL verdict
3. No commits land on `main` — all work happens on worktree branches
</invariants>

**Check invariants before every tool call that writes, commits, or merges.**

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
1. **Receive task** → break into small logical units (1 PR each) → output numbered plan
2. Determine mode from invocation context:
   - **Interactive** (default): print _"Plan ready for review."_ and wait for explicit user approval.
   - **Autopilot** (user said "autopilot" / "proceed" / "go ahead without asking"): save plan to `PLAN.md`, continue. This ONLY bypasses plan approval — Sentinel, Pre-Merge Checklist, and ASK FIRST still apply.
3. **Execute** each increment following all rules below

### Per-Increment Execution
1. `git worktree add .worktrees/<name> -b <branch> main && cd .worktrees/<name>`
2. Write failing test(s). Commit as `test(scope): ...`. Run suite — confirm FAIL.
3. Write minimal impl. Commit as `feat|fix(scope): ...`. Run suite — confirm PASS.
4. Push branch, open PR — do NOT merge yet, proceed to Sentinel.
5. Invoke Sentinel (see §How to Invoke). On APPROVED → merge. On REJECTED → fix, re-invoke (max 3 cycles, then escalate to user).

### Testing & Iteration
1. Create ONE testing worktree: `git worktree add .worktrees/test-scope -b test/scope-testing main`. Commit fixes freely. Run Sentinel **once** before merging.
2. **If HEAD is `main` when a bug is reported, do not commit — create a worktree branch first.**

## Test-Driven Development — REQUIRED

**TDD is non-negotiable — Sentinel rejects non-compliant code.**

1. **RED**: write test for new behavior, commit `test(scope): ...` (tests only). Run suite — MUST fail referencing the missing symbol/behavior. If it passes or errors unrelated to the SUT, rewrite it.
2. **GREEN**: write minimal impl, commit `feat|fix(scope): ...`. Run suite — ALL must pass. If one fails, fix impl — never fix tests to match broken impl.
3. **REFACTOR**: with the suite green after every change.

Artifact check: `git log --oneline` must show the `test(...)` commit before any `feat|fix(...)` commit for the same scope.

### Commit Choreography — REQUIRED

| Order | Commit | Contains | Tests must... |
|-------|--------|----------|---------------|
| 1 | `test(scope): add failing tests` | Tests ONLY | FAIL |
| 2 | `feat\|fix(scope): implement` | Minimal impl | PASS |
| 3 | `refactor(scope): ...` | Optional cleanup | Stay green |

**Never combine test + implementation in one commit.** Sentinel verifies ordering. **Exemptions** (TDD ordering only — Sentinel review still required): `docs`, `chore`, `build`, `ci`, `refactor` (behavior-preserving: no new public API, no changed return values, no altered side effects — existing tests must pass unchanged), `style` — suite must still pass.

## Sentinel — MANDATORY Quality Gate

### Pre-Merge Checklist
**Before every `git merge` or PR-merge tool call, print this checklist and fill every box. Empty box → do not merge.**

```
Pre-Merge Checklist:
- [ ] Sentinel Report ID: ___
- [ ] Verdict: APPROVED | CONDITIONAL
- [ ] Reviewed SHA == HEAD: ___
```

### How to Invoke

Sentinel is required for ALL changes — 1-line fix, docs-only, config, dep bump, everything. User saying "merge" or "ship it" does NOT substitute. Never ask if Sentinel is needed.

1. Print _"Invoking Sentinel..."_ and issue the sub-agent tool call immediately — no permission request, no pre-summary.
2. Spawn a **full-capability** sub-agent (NOT fast/cheap/explore/haiku-class — Sentinel must spawn its own 6 sub-agents and run commands) with `docs/SENTINEL.md` as system prompt. Provide PR diff (`git diff main...HEAD`), branch, changed files.
3. **Do NOT review your own code.** On **REJECTED**: fix autonomously, re-commit, re-invoke (max 3 cycles, then escalate). On **APPROVED**: include Report ID + SHA in PR description, merge.

> No sub-agents? Run SENTINEL.md checks yourself — mark PR `⚠️ SELF-REVIEWED` and require explicit user approval. Cannot run at all? **Do not merge** — escalate.

### After Sentinel

| Verdict | Action |
|---------|--------|
| APPROVED | Record Report ID + SHA in merge commit. File 🟡/🟢 findings as issues (`sentinel:important`, `sentinel:minor`). |
| CONDITIONAL | File issues for ALL follow-ups first, link in PR, then merge. |
| REJECTED | Fix autonomously (no user prompt). Re-commit, re-invoke. Max 3 cycles. |

**Ratchet**: coverage, test count, lint-clean, zero 🔴 — never decrease. Log violation/correction pairs in `LEARNINGS.md`.

→ Full spec: [`docs/SENTINEL.md`](./docs/SENTINEL.md)

## Branching & Worktrees — REQUIRED

- **Never work on `main`**: `git fetch origin main && git worktree add .worktrees/name -b branch-name main && cd .worktrees/name`. Each task = its own worktree.
- Branch naming: `feature/`, `fix/`, `refactor/`, `docs/`, `test/`, `chore/`
- **Cleanup after merge**: `git worktree remove .worktrees/name && git branch -D branch-name`

## Sub-Agents

Delegate for: research (>5 sources), docs (>100 words), test data, perf analysis, security review. Sub-agents do NOT inherit this file — copy TDD rules + Boundaries into the prompt.

## Commit Format

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
- Verify failing test exists before writing behavior-bearing code; verify HEAD is NOT `main` before commit
- Run `{{PACKAGE_MANAGER}} test && lint` before PR; invoke Sentinel before merge
- Use worktrees for all work

### ⚠️ ASK FIRST
**Protocol**: State intended action + justification → ask → wait for explicit "yes". Silence, "ok", or "sounds good" ≠ approval.
**Triggers**: adding/removing dependencies · CI/CD changes · public API changes · architecture decisions · env vars/secrets · external network services
Unlisted actions with **external or irreversible side effects** default to ASK FIRST. Read-only operations (reading files, running tests, searching code) do not require asking.

### 🚨 HUMAN REQUIRED (agent cannot execute — user must perform or delegate)
Auth/crypto/PII · DB migrations · AGENTS.md/SENTINEL.md changes · production deploys · 🔴 CRITICAL findings · 3× Sentinel rejections · deployment pipeline setup · credentials rotation

### 🚫 NEVER — Automatic Sentinel rejection
- **Security**: commit secrets · send code to unapproved services · access files/credentials outside project root
- **Process**: impl before its failing-test commit · combine test+impl in one commit · skip Sentinel · commit/merge while HEAD is `main`
- **Integrity**: weaken/remove a failing test · hand-edit generated files (build artifacts, lockfiles) · force-push `main` · alter published Sentinel reports · edit `AGENTS.md`/`docs/SENTINEL.md` without HUMAN REQUIRED approval

## When Stuck — Escalation Protocol

| Trigger | Action |
|---------|--------|
| Same test fails 3× | Revert to last green; re-analyze assumptions |
| Sentinel rejects 3× | Escalate to user — do not retry same approach |
| Same problem, 2+ failed attempts | Spawn research sub-agent for root-cause + alternatives |
| Lost context | Re-read this file → `git status` → resume from last increment |
| Merge conflict | Rebase on `main`, re-test, re-invoke Sentinel |
| Dependency install fails | Report to user; do not attempt workarounds |

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
