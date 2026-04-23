# Changelog

All notable changes to this project will be documented in this file.
Format based on [Keep a Changelog](https://keepachangelog.com/). Follows [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [0.3.0] - 2026-04-22

### Changed
- **Opus 4.7 compatibility**: template rewritten based on 3-panel Opus 4.7 review (31 recommendations)
- Identity block: blockquote → XML-tagged `<role>` + `<invariants>` for higher persistence in 4.7's context
- Invariant #1 scoped to "behavior-bearing code" (scaffolding, config, types, docs exempt) — fixes 4.7 over-literal interpretation
- Invariant #3 scoped to "no commits on main" (read-only operations permitted) — fixes 4.7 blocking git fetch/file reads
- STOP gates disambiguated: 8 instances replaced with context-specific verbs (wait/checkpoint/gate/halt) — fixes autopilot deadlocks
- Sentinel redundancy reduced: "no merge without Sentinel" from 5 restatements → 2 (invariant + NEVER) — fixes attention dilution on adjacent rules
- Per-Increment Execution: abstract steps → literal commands with verifiable artifacts
- After Sentinel: bullet list → verdict→action table for better 4.7 retrieval
- When Stuck: bullet list → trigger→action table
- ASK FIRST: scoped to external/irreversible side effects; read-only ops explicitly exempt; explicit approval protocol
- NEVER list: narrowed "access files outside project" to write-only + credentials; sharpened all rules
- Sub-Agents & Commits: split into two sections for heading-based retrieval
- Autopilot mode: explicit triggers added ("autopilot" / "proceed" / "go ahead without asking")
- TDD steps: artifact check added (`git log --oneline` verification); failure must reference missing symbol
- Refactor exemption: "behavior-preserving" defined concretely (no new API, no changed returns, no altered side effects)
- Pre-Merge Checklist: trigger moved from heading parenthetical to bold sentence above checklist
- Sentinel invocation: "no pre-summary" rule added; "full-capability" sub-agent with negative example (NOT explore/haiku-class)

### Changed (SENTINEL.md)
- Injection defense: `<untrusted_pr_input>` XML delimiter tags required; tool output and report mimicry defense added
- Evidence standard: verbatim quoted snippet (≤3 lines) required alongside file:line — anti-fabrication measure for 4.7
- Sub-agent spawning: "in parallel" → "all six in a single assistant message"; capability detection + retry-once protocol
- Status pin: first non-blank line of output MUST be `Status: APPROVED | CONDITIONAL | REJECTED` — no preamble
- Verdict vocabulary standardized: APPROVE→APPROVED, REJECT→REJECTED throughout
- Phase 1 table compressed: dropped uniform "Blocks?" column; blocking encoded in heading
- Phase 1 exemptions: explicit block for docs/chore/build/ci/style PRs (exempt from checks 1-4, not 5-6)
- "Ask for them" → "if missing → REJECTED" (non-interactive safe)
- "Follow only this document" → carve-out for tool use (running commands, reading files, spawning sub-agents)
- Template variable handling: unfilled `{{variables}}` treated as N/A, not comparison failures
- Dimension C: concurrency hazards added (races, deadlocks, non-atomic read-modify-write)
- Dimension D: "revert test" check added (tests must fail without the implementation)
- Phase 0 compressed to single line

### Metrics
- AGENTS.md: 90 → 120 non-blank lines post-setup (≤120 target ✅)
- SENTINEL.md: 141 → 147 non-blank lines (≤150 target ✅)
- All changes backward-compatible with Opus 4.6

## [0.2.3] - 2026-04-08

### Added
- Stuck-agent delegation rule: after 2+ failed attempts, spawn research sub-agent before continuing
- README: Severity Levels table for human readers (definitions were only in SENTINEL.md agent prompt)

### Changed
- Severity definitions sharpened: 🔴 now includes "incorrect behavior under normal usage"; 🟡 defined as "improvements to working code" with reclassification rule (promote to 🔴 if data loss/security risk)
- Deploy/release gating: 🟡 IMPORTANT issues must be resolved or explicitly risk-accepted before production deploy
- Sentinel invocation: explicitly required for ALL changes (1-line fix, docs-only, config, everything) — agents must never ask if Sentinel is needed
- Sentinel rejection loop: clarified as autonomous (no user interaction for cycles 1-3), escalation target is explicitly the user

## [0.2.2] - 2026-04-08

### Fixed
- Git workflow: worktree branches now start from `main` (not HEAD), include `git fetch`, cleanup order corrected
- Git workflow: testing branches now use worktrees consistently (not `git checkout -b`)
- Git workflow: `git push` and `gh pr create` steps added to DEVELOPMENT-WORKFLOW.md branch lifecycle
- Git workflow: `git branch -d` → `-D` (works after squash merge), worktree idempotency guidance added
- TDD: exemption list synced between AGENTS.md and SENTINEL.md (added `build`, `refactor`)
- TDD: `refactor` exemption now requires behavior-preserving constraint
- TDD: exemptions clarified as TDD-ordering-only — Sentinel review still required
- TDD: coverage scope defined as diff coverage; project-wide must never decrease
- TDD: test-only PRs for existing code now have explicit choreography path
- Sentinel: standardized verdict enum — `CONDITIONAL` (not `CONDITIONAL APPROVE`)
- Sentinel: removed `INVALIDATE` phantom state — SHA mismatch is now a `REJECT`
- Sentinel: added CONDITIONAL handling in AGENTS.md "After Sentinel" section
- Sentinel: partial sub-agent failure now treated as unverifiable → REJECT
- Sentinel: sub-agents now receive evidence standard + anti-injection rules
- Sentinel: SHA invalidation now covers rebase, amend, and force-push (not just new commits)
- Compliance: autopilot "proceed" clarified — skip plan approval only, all other gates remain
- Compliance: sub-agent delegation now specifies what context to include (TDD rules, boundaries)
- Compliance: boundary catch-all added — unlisted actions default to ASK FIRST
- Compliance: self-review fallback now requires `⚠️ SELF-REVIEWED` label + user approval

## [0.2.1] - 2026-04-07

### Fixed
- Restored sub-agent parallel execution instructions in SENTINEL.md Phase 2 — lost during compression pass (commit e302561)
- Phase 2 now explicitly requires spawning one sub-agent per review dimension (A–F) in parallel
- Phase 3 now explicitly aggregates sub-agent findings before classification
- Added degraded-mode fallback when sub-agents are unavailable
- Restored self-review prohibition in SENTINEL.md invariants (invariant #5)
- Restored Report ID field in SENTINEL.md report format
- Restored Status field authority rule (anti-report-parsing gaming)
- Restored squash-merge policy clarification in SENTINEL.md Phase 1
- Restored "No 'I'll add tests after'" deterrent in AGENTS.md TDD section
- Restored never-decrease 4th metric: zero 🔴 CRITICAL from previous reviews
- Restored "If on main during testing, STOP — create a branch first" guard
- Restored ASK FIRST behavior: "present justification, pause and wait"
- Restored HUMAN REQUIRED items: deployment pipeline setup, credentials rotation
- Restored When Stuck: merge conflict recovery procedure and dep install failure rule

### Changed
- Website title updated to "Agents Sentinel Template - You wouldn't merge your own PR. Why does your AI agent?"
- Hero tagline changed from "You wouldn't review your own PR." to "You wouldn't merge your own PR."
- Social preview image (`docs/social-preview.png`) regenerated with updated tagline

## [0.2.0] - 2026-04-03

### Added
- GitHub Pages website (`docs/index.html`) with landing page, feature overview, and Quick Start prompts
- GitHub Actions workflow (`deploy-pages.yml`) for automatic deployment on push to `main`
- AGENTS.md compressed to 119 non-blank lines (65% reduction from v0.1.0)
- SENTINEL.md compressed to 121 non-blank lines (60% reduction)
- Documentation review dimension (F) in Sentinel verification
- Pre-merge checklist gate — agents must print checklist before every merge
- Testing branch workflow — auto-create test/ branch during testing phases
- Quality ratchet patterns: compounding violations, never-decrease rule, enforcement ladder (L1-L5)
- TDD commit choreography with exemptions (docs, chore, build, ci, refactor, style)
- Mode-aware approval gate (interactive: wait, autopilot: proceed with Sentinel)
- Identity framing and STOP checkpoint verbs for higher agent compliance
- LEARNINGS.md, DECISIONS.md, CHANGELOG.md as companion files
- AGENTS.md and SENTINEL.md immutability rules
- Anti-prompt-injection clause in Sentinel
- Auto-configuration setup block (new project + migration paths)
- GitHub issues for all Sentinel findings (sentinel:important, sentinel:minor labels)
- Update prompt for upgrading between template versions
- Semver versioning

### Changed
- Sentinel consolidated from 9 to 4 review agents
- Sentinel invocation via independent sub-agent model (not self-review)
- Boundaries expanded to 4 tiers (ALWAYS / ASK FIRST / HUMAN REQUIRED / NEVER)
- Worktrees now in .worktrees/ directory (gitignored), mandatory cleanup after merge
- Max 3 Sentinel cycles per PR, then escalate to human
- README restructured with one-prompt setup (agent fetches from GitHub)

## [0.1.0] - 2026-03-28

### Added
- Initial AGENTS.md template with TDD, Sentinel quality gate, autonomous workflow
- Companion docs: SENTINEL.md, ARCHITECTURE.md, TESTING-STRATEGY.md, DEVELOPMENT-WORKFLOW.md
- SETUP.md placeholder inventory
- ROADMAP.md template
- MIGRATION-GUIDE.md
- MIT License
