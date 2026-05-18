# Changelog

All notable changes to this project will be documented in this file.
Format based on [Keep a Changelog](https://keepachangelog.com/). Follows [Semantic Versioning](https://semver.org/).

## [0.9.0] - 2026-05-18

### Added
- **Pre-Push Verification gate**: New section in AGENTS.md — agents verify TDD ordering, test suite, lint, and optionally secret scan (gitleaks) and SAST (semgrep) before pushing PRs. Catches ~35% of Sentinel rejections before they happen, saving 2-5 min per PR.
- **Pattern memory**: agents read `LEARNINGS.md` for known Sentinel rejection patterns before each PR, self-checking against historical findings. Compounds over time.
- **Tiered review architecture** (Phase 1.5): Optional fast-path where a single fast-model agent scans for 🔴 blockers only. PRs meeting all skip criteria (<150 LOC, no security-sensitive paths, no new deps, exempt commit types) can be approved at Tier 1. ~45% of PRs skip full Tier 2 review. 10% audit sampling recommended.
- **Speculative Phase 1+2 execution**: Phase 1 (TDD compliance) and Phase 2 (code quality) may start concurrently. Phase 1 failure discards Phase 2 results. Saves 30-60s per review.
- **Diff routing per dimension**: Input filtering table reduces sub-agent tokens — E receives only manifests/lockfiles (~90% reduction), F only docs/CHANGELOG, D only test+impl files. A1/A2/B/C receive full diff minus lockfiles/generated code.
- **Prompt caching guidance**: Dimension prompts placed in system position for provider-side prefix caching (~80% latency reduction on cached reads).
- **Streaming aggregation**: Phase 3 may begin as each sub-agent completes rather than waiting for all.
- **Fix suggestions + fixability classification**: Return format now includes suggested code fixes and 🔧 auto-fixable / 🧠 judgment-needed / 👤 human-required classification. Reduces fix failures by 30-50%.
- **Hybrid tool guidance**: All dimension preambles now accept deterministic tool output (SAST, audit, coverage) as pre-verified evidence, focusing LLM analysis on items not covered by tools.

### Changed
- **Dim A split into A1 + A2**: Security dimension (35 items) split into A1 (Injection + Auth + CI/CD, ~23 items) and A2 (Secrets + Crypto + Web + Input + IO, ~20 items) for better LLM recall. Both run in parallel — no added latency.
- **Line budgets raised**: AGENTS.md 120→130, SENTINEL.md 150→165. Rationale: budgets prevent bloat, not quality-improving additions. Pre-push gate and tiered review are legitimate features that shouldn't be compressed at the expense of compliance-critical instructions.
- **Selective dispatch updated**: references A1,A2 instead of A throughout; added `test→A1,A2,D,F` and `perf→A1,A2,C,D,F` dispatch rules
- **Report format**: added `Review depth: Tier 1 (fast-path) | Tier 2 (full)` field

### Metrics
- AGENTS.md: 120→128 non-blank lines (≤130 target ✅)
- SENTINEL.md: 126→150 non-blank lines (≤165 target ✅)
- Dim A: 1 file (74 lines) → 2 files (A1+A2, better recall)
- 7 dimension files total (A1, A2, B, C, D, E, F)

### Origin
4-agent performance research panel: LLM Inference (Opus 4.7 research), Parallel Systems (GPT-5.4), Quality Gate Design (Opus 4.6), Prompt Engineering (Sonnet 4.6). Key research: Anthropic prompt caching docs, PR-Agent diff compression strategy, CodeRabbit file-level caching, Greptile's failed LLM-as-judge experiment, LLMLingua-2 (Microsoft Research, ACL 2024).

## [0.8.0] - 2026-05-18

### Added
- **Dimension sub-agent files**: Split Phase 2 inline checklists (A–F) into dedicated files under `docs/sentinel/`. Each file is a self-contained sub-agent prompt with evidence standard, prompt-injection defense, scope, detailed checklist, and return format
- **Expert panel review**: 5-agent panel (Opus 4.7, GPT-5.4, Sonnet 4.6, GPT-5.2, Opus 4.6) reviewed all dimensions individually and as a system. Panel findings drove all additions below.

**Dim A — Security (+13 items):**
- Injection: SSTI, log/header injection, open redirect, prototype pollution, ReDoS; framework XSS escape hatches (`dangerouslySetInnerHTML`, `v-html`, `[innerHTML]`)
- Auth: JWT misuse (alg:none, decode vs verify), security event audit logging
- Crypto: TLS verification disabled, timing-safe comparison, hardcoded crypto keys/IVs
- File/IO: zip/tar slip
- NEW section: CI/CD pipeline security (pull_request_target, script injection, action pinning, secrets to forks)
- FP reduction: attacker-reachability justification rule, sink-tracing for insecure randomness, CSRF N/A for bearer-only endpoints
- Severity refinements: insecure randomness, mass assignment, CORS, PII exposure, security headers

**Dim B — Resilience (+7 items):**
- Network: deadline/timeout propagation, graceful shutdown/connection draining, bounded concurrency/backpressure
- NEW section: async job/queue handling (ack-before-process, poison messages/DLQ, bounded concurrency)
- Observability: telemetry cardinality explosion
- Narrowed: PII-in-logs (A owns classification, B flags log-hygiene), missing logs/metrics (specific operations), circuit breakers → "dependency failure containment", rate limiting scoped to public/expensive endpoints
- Removed: configuration drift (not diff-verifiable)

**Dim C — Performance (+6 items):**
- Resource: blocking event loop/request thread, full materialization vs streaming
- Database: cache stampede/dogpile, connection pool saturation
- Architecture: type safety regressions (any, unsafe casts)
- API contracts: data format compatibility (serialization breaking persisted data), expand/contract rollout in migration safety
- Severity recalibrated: coupling/boundaries/duplicated logic → 🟢; feature flag lifecycle → 🟢; Big-O → 🔴 only when on hot path
- Added context note: flag 🟢 when diff insufficient for performance judgment

**Dim D — Testing (+3 items, -2 items, Phase 1 boundary):**
- Added: mock fidelity (stale mocks), test regression ratchet (deleted/weakened tests), shared fixture safety
- Merged: "meaningful assertions" + "assertion specificity" → "assertion quality"
- Removed: "new branches covered" (duplicate of Phase 1 check 4)
- Added Phase 1 boundary preamble: Phase 1 checks execution, Dim D checks semantic coupling
- Scoped: adversarial inputs (trigger condition), edge cases (algorithms/numeric only)
- Cross-ref notes: A owns input validation, C owns testability design, D owns test file quality

**Dim E — Dependencies (+3 items, evidence reframing):**
- Added: dependency source risks (git+, tarballs, file: deps), dependency confusion, lockfile integrity signals
- Reframed: CVE/maintenance/license as "verify evidence present" (AI can't do external lookups)
- Expanded: risky install scripts beyond npm (prepare, install hooks, curl|bash)
- Scoped: bundle size (frontend runtime deps only), minimal scope (concrete signal)

**Dim F — Documentation (+3 items, conditional items):**
- Added: a11y documentation (moved from Dim A), config/env var change docs, i18n readiness (🟢)
- Conditional: DECISIONS.md (only for architectural tradeoffs), LEARNINGS.md (only for discovered constraints)
- Reframed: "README reflects behavior" → behavior-change trigger (flag only when code changes but no docs touched)
- Added: operational impact docs (rollout/rollback, feature flags)

### Changed
- **SENTINEL.md Phase 2**: dispatch instruction specifies PR context (branch, title, description, file list, commit history, tech stack) and model tier guidance (E/F can use fast models)
- **SENTINEL.md Phase 3**: severity floor rule (orchestrator may 🟡→🔴 but NEVER 🔴→🟡); cross-dimension finding consolidation; unified reclassification criteria with Dim B ("data loss, security exposure, cascading outage, or incorrect behavior under normal usage")
- **Selective dispatch expanded**: `test→A,D,F` and `perf→A,C,D,F` added
- **All dimensions**: cross-dimension prefix `[Cross: Dim X]` in return format for findings belonging to other dimensions
- **Dim A return format**: added "Reachability" field (attacker path justification)

### Metrics
- SENTINEL.md: 122→126 non-blank lines (≤150 target ✅)
- 6 dimension files updated with panel-driven improvements

### Origin
5-agent expert panel review: Security Engineering (Opus 4.7), SRE/Systems Architecture (GPT-5.4), Software Testing (Sonnet 4.6), Supply Chain/Technical Writing (GPT-5.2), Systems Architect cross-cutting (Opus 4.6). Consensus findings adopted; per-agent recommendations triaged for signal-to-noise and diff-scope feasibility.

## [0.7.0] - 2026-05-17

### Changed
- **Phase 1 coverage skip for exempt PRs**: fully-exempt PRs (all types except `refactor`) now skip check 6 (coverage threshold). No source code changed → coverage instrumentation is pure overhead. `refactor` retains check 6 because restructuring can shift measured coverage. Ratchet catches regressions on next behavior-bearing PR
- **Selective dispatch expanded**: `chore`/`build`/`ci`-only PRs now dispatch A (security), E (supply chain), F (docs) only — B, C, D skipped. `refactor` retains full A–F. Saves 3 sub-agent invocations (~40% latency reduction) on config/CI PRs without sacrificing the security and supply-chain checks that catch high-value issues (e.g., mutable GH Action refs)
- **Dimension F cross-reference rule**: DECISIONS.md and LEARNINGS.md update checks consolidated — content already documented in another companion doc satisfies the check if cited by path/section (🟢 max, not 🟡). Prevents CONDITIONAL verdicts for documentation bookkeeping
- **Mode declaration fixed**: `standard` mode no longer hardcodes "6 parallel sub-agents" — now reads "all applicable dimensions dispatched in parallel" to align with selective dispatch (partial fix in v0.5.1 only addressed AGENTS.md; SENTINEL.md still had the conflict)

### Metrics
- SENTINEL.md: 148→147 non-blank lines (≤150 target ✅)
- AGENTS.md: 120 non-blank lines unchanged (≤120 target ✅)

### Origin
Changes informed by real-world feedback from 3 Sentinel cycles on Council (downstream project, v0.6.0). Feedback triaged — accepted suggestions refined with rubber-duck review; rejected raw forms that would have removed value (e.g., keeping dim E for chore/ci since it caught the mutable action refs finding).

## [0.6.0] - 2026-05-16

### Added
- **Known Sentinel issues (de-duplication)**: optional input allowing invokers to pass open `sentinel:*` GitHub issues from previous reviews. Findings matching a known issue (same defect mechanism + fix) are classified as **Known** — appear in report for transparency but excluded from verdict count. Prevents the same systemic pattern from being re-flagged across every PR
- **Root cause consolidation**: multiple Phase 2 findings with identical root cause are consolidated into a single finding (citing all locations), reducing issue inflation
- **Verdict calibration**: CONDITIONAL now requires ≥1 *new* 🟡 finding (not Known). If all 🟡 findings match known issues → APPROVED instead of CONDITIONAL. Reserves CONDITIONAL for genuinely new, actionable findings

### Changed
- **Phase 3 ordering**: severity reclassification (🟡→🔴 if data loss/security) now explicitly applies *before* known-issue matching — ensures critical findings can never be suppressed
- **Report format**: findings counts now show `N new / K known` for 🟡; details support `[Known]` marker with issue # citation; follow-ups and actions merged into single section with "new" qualifier to avoid duplicate issue creation
- **Deploy/release gating**: compressed from 4 to 2 non-blank lines (semantics preserved)
- **AGENTS.md §How to Invoke**: invoking agent now queries open `sentinel:*` GitHub issues and passes them as known issues context to Sentinel
- **AGENTS.md compression**: Per-Increment Execution steps 4+5 merged; Testing & Iteration merged to single line; When Stuck table rows consolidated. Post-setup: 123→120 non-blank lines (≤120 target ✅)

### Metrics
- SENTINEL.md: 149→148 non-blank lines (≤150 target ✅)
- AGENTS.md: 123→120 non-blank lines (≤120 target ✅)

### Safeguards
- 🔴 CRITICAL findings can **NEVER** be classified as Known
- Known issues must be verified `sentinel:*` GitHub issues (same defect mechanism + fix — cite issue #)
- Known findings remain visible in the report — nothing is hidden
- Without known issues input, behavior is unchanged (backward-compatible)

## [0.5.1] - 2026-05-16

### Fixed
- **Sentinel selective dispatch conflict**: removed hardcoded "6 sub-agents" from `template/AGENTS.md` §How to Invoke. The count contradicted SENTINEL.md's selective dispatch rule (docs→F, style→D,F), causing agents to always spawn all six dimensions

## [0.5.0] - 2026-05-13

### Added
- **Scope guard** for Phase 2: findings must originate from changed lines or code whose reachability/inputs/trust-boundary is altered by the diff. Pre-existing issues in unchanged code are out of scope (🟢 max) unless the diff newly exposes or depends on them
- **Selective sub-agent dispatch**: PRs with only `docs` or `style` commits dispatch only applicable dimensions (`docs`→F; `style`→D,F) instead of all six. Cross-cutting risk triggers escalation to full A–F. Closes #7
- **Docs severity cap**: Dimension F completeness/staleness findings capped at 🟡 — documentation gaps do not block merge. Policy-weakening or unsafe-instruction changes remain uncapped
- **Re-review mode**: when invoker provides previous Report ID + fix delta, Phase 2 sub-agents review the fix delta instead of the full PR diff. All dimensions still dispatched; previous 🔴 findings explicitly verified as resolved. Reduces re-review cycle time from ~15-50 min to ~5-10 min
- **Test evidence fallback**: test execution timeouts no longer auto-reject. Sentinel accepts parent-provided test output for the reviewed SHA (flagged as `⚠️ parent-provided evidence`); rejects only if no fallback is available

### Changed
- **Cycle limit raised from 3 to 5**: agents get more room on complex PRs where each cycle produces a genuinely different fix before escalating to user
- **Phase 4 severity calibration**: removed "and low-risk" qualifier from CONDITIONAL verdict. 🟡 findings always produce CONDITIONAL (never REJECTED), provided Phase 3 reclassification is applied first. Tightens the intent: if it could cause data loss/security exposure, reclassify as 🔴 — otherwise file as issue and merge
- **Phase 4 decision rules compressed**: four bullets → two for clarity
- **Coverage threshold check**: strengthened skip instruction — if `{{COVERAGE_THRESHOLD}}` still has braces, check is N/A (do not invent a threshold)
- **Deploy/release gating section**: compressed for line budget

## [0.4.1] - 2026-05-07

### Fixed
- Execution log agent ID requirement relaxed for platform compatibility: accept tool-returned ID when available, `N/A` when platform doesn't expose IDs. Tool Call column (proving dispatch) is the primary verification. Prevents self-rejection on compliant runs.
- Sub-agent dispatch now specifies `mode: "background"` which returns real agent IDs from the platform, making the execution log verifiable by default
- Degraded mode now requires quoted dispatch-attempt evidence (exact tool call + verbatim error response). No proof → REJECTED. Makes self-review harder than dispatch, aligning incentives correctly. (Issue #3)
- `test→fix` pair clarified as TDD-compliant in AGENTS.md artifact check — Sentinel must not flag it as irregular. Exemption list unchanged (`fix` without a regression test remains non-compliant). (Issue #4)

## [0.4.0] - 2026-05-05

### Added
- Sentinel sub-agent observability: `Mode:` field and `Phase 2 — Execution Log` section in report format require tool-returned agent IDs, making sub-agent dispatch verifiable
- Invoker verification step: parent agent must confirm Mode declaration and execution log exist before accepting Sentinel report
- Pre-merge checklist: Mode verification line added
- Concrete sub-agent definition: must be a separately-invoked tool call with its own context window; sequential self-review does not qualify
- "Unavailable" defined: only platform technical limitations (tool not present, API error); cost/latency/diff-size are explicitly excluded
- Audit trail: execution log now includes the exact tool call used to spawn each sub-agent, enabling post-hoc verification
- Proof-of-attempt required: must attempt to spawn at least one sub-agent and document the failure before declaring degraded mode

### Changed
- Sentinel Role definition: explicitly includes sub-agent dispatch as mandatory action (not just passive review)
- Mode semantics: three clearly defined modes (standard, degraded-serialized, degraded-no-sub-agents) with degraded modes requiring explicit user approval
- Sub-agent execution rules expanded: logging with tool-returned identifiers is required; missing/fabricated IDs invalidate the entire review → REJECT
- Timeout handling: sub-agent failure now requires retry before REJECT, removing perverse incentive to skip sub-agents entirely

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
