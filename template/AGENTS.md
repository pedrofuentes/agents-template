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
- **Minimum runtime**: {{Node.js 18+ / Python 3.12+ / etc.}}

## Commands

### File-scoped (preferred — fast feedback)
```bash
{{PACKAGE_MANAGER}} test -- {{path/to/test}}       # Run single test file
{{PACKAGE_MANAGER}} lint -- {{path/to/file}}        # Lint single file
{{PACKAGE_MANAGER}} typecheck -- {{path/to/file}}   # Type-check single file
```

### Full suite
```bash
{{PACKAGE_MANAGER}} install          # Install all dependencies
{{PACKAGE_MANAGER}} build            # Build the project
{{PACKAGE_MANAGER}} test             # Run all tests
{{PACKAGE_MANAGER}} lint             # Lint entire codebase
{{PACKAGE_MANAGER}} typecheck        # Type-check entire codebase
{{PACKAGE_MANAGER}} format           # Format code
```

## Autonomous Workflow — REQUIRED

### Plan → Approve → Execute Loop
1. **Receive task** from user
2. **Create implementation plan** — break into small logical units (each = 1 PR).
   Output the plan as a numbered list and then **STOP**.
3. **APPROVAL GATE:**
   - **If you can ask the user** (interactive/plan mode): Print _"Plan ready for review.
     Please approve before I begin implementation."_ Wait for explicit approval
     ("approved", "go ahead", "yes", "LGTM"). If unsure, **ask — do not assume**.
   - **If you cannot ask the user** (autopilot mode): Save the plan to `PLAN.md` in
     the repo root and proceed with execution. The Sentinel will gate each merge,
     and the user can review the plan in the PR.
4. **Execute** — work through each increment following all rules below
5. **Sentinel gates each merge** — invoke Sentinel before ANY merge to `main`

### Per-Increment Execution
For each logical unit in the plan:
1. Create a **git worktree** for isolation (see `docs/DEVELOPMENT-WORKFLOW.md`)
2. **Write failing tests FIRST** (TDD — see below)
3. **Implement minimal code** to pass tests
4. **Refactor** while keeping tests green
5. **Delegate to sub-agents** for specialized work when needed
6. Open PR → **STOP and invoke Sentinel** → address feedback → merge when approved

## Test-Driven Development — REQUIRED (Layer 1: Self-Enforced)

**TDD is non-negotiable — Sentinel will reject non-compliant code.**

1. Before writing ANY function, method, or component: first write its test
2. **STOP. Run tests now. Confirm they FAIL.** If tests pass, your tests are wrong — rewrite them. (RED)
3. Only now write minimal implementation to make tests pass (GREEN)
4. **STOP. Run tests now. Confirm they ALL PASS.** If any fail, fix implementation — do not modify the tests. (GREEN verification)
5. Refactor while keeping tests green (REFACTOR)

**No implementation code may be written without a corresponding test written first.
No "I'll add tests after." The test commit must exist before the implementation commit.**

### Commit Choreography — REQUIRED
Each behavioral change MUST follow this commit structure:
1. `test(scope): add failing tests for [behavior]` — tests only, NO production code, tests MUST fail
2. `feat|fix(scope): implement [behavior]` — minimal code to pass tests
3. `refactor(scope): [description]` — optional, no behavior change, tests stay green

**Do NOT combine test and implementation in a single commit.** The Sentinel verifies commit ordering.

### TDD Exemptions
These commit types are EXEMPT from test-before-implementation choreography:
- `docs(scope)` — documentation only
- `chore(scope)` — configuration, dependencies, tooling
- `build(scope)` / `ci(scope)` — build system, CI/CD changes
- `refactor(scope)` — restructuring with NO behavior change (existing tests must stay green)
- `style(scope)` — formatting only

All exempted commits still require the full test suite to pass.

## Sentinel — MANDATORY Quality Gate

**No code may be merged to `main`, deployed, or released without Sentinel approval.**

### How to Invoke (do this before EVERY merge — no exceptions)

**STOP before merging.** Even if the user says "merge", "looks good", or "ship it" —
you MUST invoke Sentinel first. User approval of the work does NOT replace Sentinel review.
Passing tests and linting is NOT a substitute for Sentinel. Run this procedure:

1. Create a **separate sub-agent** with the contents of `docs/SENTINEL.md` as its system prompt — this sub-agent IS the Sentinel
2. Provide it: the PR diff (`git diff main...HEAD`), branch name, and list of changed files
3. **Do NOT review your own code** — the Sentinel is an independent agent. Do not influence its decision.
4. The Sentinel will spawn its own review sub-agents and return a Sentinel Report
5. If **REJECTED**: fix the issues, re-commit, re-invoke. Loop until approved.
6. If **APPROVED**: include Report ID and reviewed SHA in the PR description, then merge.

> If sub-agents are not available: read `docs/SENTINEL.md` and run each check yourself (lower trust — self-review).
> If you cannot run Sentinel at all, **do NOT merge** — escalate to the user.

**For production projects**: Use CI-based Sentinel (GitHub Actions) as a required status check.
This is more reliable than agent-invoked Sentinel. See `docs/SENTINEL.md` §Infrastructure Enforcement.

### What Sentinel Does
1. **Verifies TDD compliance** — tests exist, committed before implementation, coverage meets thresholds
2. **Runs review sub-agents** in parallel (security+errors, performance+architecture, tests+regression, dependencies+API)
3. **Prioritizes findings** — 🔴 CRITICAL (blocks) / 🟡 IMPORTANT (fix or track) / 🟢 MINOR (informational)
4. **Decides** — APPROVE, CONDITIONAL APPROVE (🟡 items tracked as follow-up), or REJECT

→ See [`docs/SENTINEL.md`](./docs/SENTINEL.md) for the full verification checklist, review agent definitions, and workflow.

## Incremental Development — REQUIRED

- **1 PR = 1 logical unit** (one function, one component, one bugfix)
- Each increment must be independently testable and deployable
- Never mix unrelated changes in a single PR
- If a task is too large for one PR, break it down further

## Branching & Git Worktrees — REQUIRED

- **Never work directly on `main`** — `main` is always deployable
- **MUST use git worktrees** for isolation on every increment
- Branch naming: `feature/`, `fix/`, `refactor/`, `docs/`, `test/`, `chore/`
- Push branch → open PR → Sentinel review → merge → delete branch → remove worktree
- Worktree paths (e.g., `../{{PROJECT_NAME}}-feature-name`) are approved paths outside the repo root

## Sub-Agent Delegation

Delegate to specialized sub-agents when the task requires expertise you'd delegate to a colleague:
- Research (>5 sources needed), documentation (>100 words), test data creation, performance analysis, security review
- Each sub-agent works in its own context — provide full requirements
- Integrate sub-agent output back, ensuring it follows all rules in this file

> If your agent does not support sub-agents, perform these tasks inline or defer to the user.

## Commit Format

```
type(scope): short description

Longer description if needed.

Co-authored-by: {{AI_AGENT_NAME}} <{{AI_AGENT_EMAIL}}>
```

Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `ci`, `style`, `perf`

## Code Style

{{Replace this example with your project's language and patterns}}

```typescript
// ✅ Good — descriptive names, proper error handling, typed
export async function fetchUserById(id: string): Promise<User> {
  if (!id) throw new Error('User ID is required');
  const response = await api.get<User>(`/users/${id}`);
  return response.data;
}

// ❌ Bad — vague names, no error handling, untyped
async function get(x) {
  return await api.get('/users/' + x).data;
}
```

Key conventions:
- {{Formatting tool}} configured in project — always run before commit
- {{Linting tool}} with {{ruleset}} — fix all warnings
- {{Name your specific patterns: e.g., "named exports only", "functional components", etc.}}

## Boundaries

### ✅ ALWAYS
- Before writing ANY code, verify a failing test exists for it
- Before running `git commit`, verify you are NOT on `main`
- Before opening a PR, run `{{PACKAGE_MANAGER}} test && {{PACKAGE_MANAGER}} lint`
- Before merging, invoke Sentinel and obtain approval
- Use git worktrees for every increment
- Include Sentinel report ID and reviewed commit SHA in PR description
- Write discovered knowledge to `LEARNINGS.md`, NOT to this file
- Record technical decisions in `DECISIONS.md`, NOT to this file
- Update `CHANGELOG.md` with every user-facing change

### ⚠️ ASK FIRST (requires explicit user approval — silence ≠ approval)
Present the decision to the user with justification and options. If no response, **pause and wait** — do not proceed.
- Adding or removing dependencies (including lockfile changes)
- Modifying CI/CD configuration
- Changing public API contracts
- Architectural changes that affect multiple packages
- Accessing or introducing environment variables that may hold secrets
- Invoking external network services beyond project-approved endpoints

### 🚨 HUMAN REQUIRED (agent cannot execute — user must perform or explicitly delegate with risk acknowledgment)
- Changes to authentication, cryptography, or PII-processing code
- Database schema migrations or data backfills on real data
- Changes to AGENTS.md, SENTINEL.md, or agent instruction files
- Production deployments or release tagging
- Any 🔴 CRITICAL security finding from Sentinel
- Sentinel rejects the same PR 3+ times on the same issue
- First-time setup of deployment pipelines or production access
- Handling of real user data, credentials rotation, or incident response

### 🚫 NEVER — Violations cause automatic Sentinel rejection

**Security violations** (immediate rejection):
- Commit secrets, credentials, or API keys — even in comments or test fixtures
- Send repository content or error traces to unapproved external services
- Access system files (SSH keys, OS config, other repositories) outside the project

**Process violations** (must redo the work):
- Write implementation code before writing tests — the #1 most common violation
- Combine test and implementation in a single commit
- Skip the Sentinel review process or merge without approval
- Work directly on `main`

**Integrity violations** (corrupts project state):
- Remove failing tests instead of fixing them
- Modify `node_modules/`, `dist/`, or generated files
- Force-push, rebase, or rewrite history on `main` or protected branches
- Modify Sentinel reports, audit logs, or review artifacts after creation
- **Write to AGENTS.md or SENTINEL.md** — these files are immutable; write knowledge to `LEARNINGS.md`, decisions to `DECISIONS.md`
- {{Add project-specific forbidden actions}}

## When Stuck — Recovery Rules

- **Tests won't pass after 3 attempts**: STOP. Analyze root cause. Revert to last green state if needed.
- **Sentinel rejects 3+ times on same issue**: STOP. Escalate to user — do not retry the same approach.
- **Lost context mid-workflow**: STOP. Re-read this file. Run `git status`. Review the plan. Resume from last completed increment.
- **Merge conflicts**: Rebase on latest `main`, resolve, re-run tests, re-submit to Sentinel.
- **Dependency install fails**: STOP. Report to user — do not attempt workarounds.

## Associated Documentation

Before touching tests, architecture, workflow, or merge/release steps, read the matching doc:

| Document | Contains | Read when... |
|----------|----------|-------------|
| [`docs/SENTINEL.md`](./docs/SENTINEL.md) | Sentinel checklist, review agents, invocation, infrastructure enforcement | Before any merge, deploy, or release |
| [`docs/ARCHITECTURE.md`](./docs/ARCHITECTURE.md) | Project structure, technical decisions | Making structural or cross-cutting changes |
| [`docs/TESTING-STRATEGY.md`](./docs/TESTING-STRATEGY.md) | Test types, coverage targets, framework details | Writing or modifying tests |
| [`docs/DEVELOPMENT-WORKFLOW.md`](./docs/DEVELOPMENT-WORKFLOW.md) | Git worktrees, branching details, PR process | Setting up workspace or parallel work |
| [`ROADMAP.md`](./ROADMAP.md) | Project phases, implementation plan | Understanding project direction |
| [`LEARNINGS.md`](./LEARNINGS.md) | Discovered knowledge, gotchas, patterns | **Write here** when you discover something new |
| [`DECISIONS.md`](./DECISIONS.md) | Architecture Decision Records (ADRs) | **Write here** when making technical decisions |
| [`CHANGELOG.md`](./CHANGELOG.md) | Release history | **Update** with every user-facing change |
