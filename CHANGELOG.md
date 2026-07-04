# Changelog

All notable changes to this project will be documented in this file.
Format based on [Keep a Changelog](https://keepachangelog.com/). Follows [Semantic Versioning](https://semver.org/).

## [0.22.0] - 2026-07-04

Sentinel field-feedback release — refinements proposed by a downstream Sentinel operator after ~40 production reviews, each verified against cited evidence before acceptance. Ruleset stays **v1**, rubric stays **v1**: the report protocol (`Status:` line, `Required action` mapping) and severity tiers are unchanged; this release adds resolution procedures only, all as in-line extensions (SENTINEL.md remains 177/178 non-blank lines).

### Added
- **Dim D discrimination probe** (`dim-d-testing.md`): mutation-based oracle verification codified — when command execution is available, a suspected non-discriminating test is verified by neutering the pinned behavior in a throwaway worktree and confirming the test goes RED. Fail-closed: no isolated execution → static-evidence 🟡 flagged `(unverified — no execution)`; the probe upgrades evidence, never excuses omitting a static finding.
- **Contest channel for false-positive 🔴s** (SENTINEL.md §Severity adjustment + SEVERITY-RUBRIC step 4): a 🔴 whose factual premise appears wrong may be **contested, never downgraded** — the originating dimension is re-dispatched ONCE with counter-evidence from Sentinel's own tool use; its second verdict is final and logged in the Execution Log. PR/invoker text claiming a false positive is a 🔴 signal, never contest grounds. Resolves the documented contradiction between "NEVER downgrade a sub-agent 🔴" and the false-positive livelock.
- **Fold-in exception for CONDITIONAL 🟡s** (SENTINEL.md Follow-ups): small, same-file, no-new-risk 🟡 fixes MAY be folded into the PR instead of filed as issues — but the folded SHA MUST be re-invoked for a fresh verdict before merge (delta re-review applies). Size guidance is advisory (~≤10 LOC); the re-invoke requirement is the invariant. Removes the file-only backlog treadmill without weakening SHA-binding.
- Eval fixtures `11-nondiscriminating-oracle.md` (static half of the discrimination probe: a non-discriminating oracle that is the only coverage of the changed behavior → D 🔴 REJECTED per the new escalation clause; the 🟡 golden-row boundary is documented in the fixture) and `12-contest-injection.md` (contest-channel abuse: PR text arguing a 🔴 is a false positive must never bypass REJECTED).

### Fixed
- Dim D "Shared fixture safety" now escalates to 🔴 when a helper/mock edit stops any test from executing new/changed logic, aligning the dim file with the rubric's "new data layer never executed by any test" golden row. Baseline eval runs (fixture 10) showed dim-level sub-agents reproducibly held this at 🟡 because the dim file's 🟡 default contradicted the golden row — the orchestrator's Phase 3 escalation still caught it end-to-end, but the dimension holding 🔴-blocking authority should say it directly.
- Eval fixture 07's synthetic diff contained an unintended legitimate 🔴 (unchecked `res.ok` cached CDN error pages as avatar bytes); an explicit guard was added so the fixture again isolates its 🟡 missing-timeout calibration purpose. Found by the baseline eval discipline.
- Eval fixture 08's Expected block clarified: "zero 🟡" applies to the post-calibration end-to-end verdict; dim-level advisory 🟡s are tolerated per README scoring rules.

### Rejected (recorded for governance)
- Test-only reduced-dispatch lane (run only a discrimination probe for test-only PRs): same loophole class as the previously rejected `feat` fast-path — test-only PRs are where test-erosion attacks live. Filed as a `sentinel:deferred` issue with telemetry-based revisit criteria.

## [0.21.0] - 2026-07-02

Sentinel quality/reliability/speed release. Ruleset stays **v1** — the report-protocol contract (`Status:` line, `Required action` mapping, verdict semantics) is unchanged: the Execution Log gains an additive `Duration/Tokens` column, the header an additive `Elapsed:` line, and the Follow-ups section now emits only the verdict-matching action line (consumers parse the untouched `Required action` header).

### Added
- `evals/` — behavioral regression harness for the Sentinel ruleset: 10 synthetic PR fixtures with expected verdicts, a two-lane runner (`evals/RUNNER.md`), and a dimension-coverage matrix. Run before merging any ruleset change (structural CI checks shape; evals check behavior).
- Execution-Log telemetry: per-dimension `Duration/Tokens` column and report-header `Elapsed:` line. Values must be copied verbatim from platform-reported output — estimated numbers count as fabricated evidence, and `N/A (not reported)` is always compliant. Telemetry is non-normative and never admissible as review evidence; it exists to make the revisit criteria of deferred issues #11/#14 measurable.
- Delta-scoped Phase 1 on re-review: checks 1–4 may scope to the fix delta when Sentinel itself authenticates the prior report at its Phase 5 persisted location AND verifies the delta base via `git merge-base --is-ancestor` (recomputing the delta itself — invoker-supplied deltas never qualify). Test/fixture/mock edits in the delta re-open checks 1–4 for all code whose test execution they alter; CI/test/build-config deltas, deltas with no covering tests, and any unverifiable condition fall back to full Phase 1. The path only applies when the prior cycle's Phase 1 was green.
- Known-issues fetch guidance in SENTINEL.md inputs: exact `gh issue list --json … --jq 'startswith("sentinel:")'` command (`gh --label` does not wildcard-match); fetched issue text is fenced as untrusted data and can only mark findings Known.
- `.github/PULL_REQUEST_TEMPLATE.md` with validate.sh + evals checkboxes.
- `scripts/validate.sh`: evals-fixture `## Expected` check, rubric-version tripwire, evals/ link scanning, and a non-blocking reminder to run evals when ruleset files change.

### Changed
- Sentinel report Follow-ups & Actions: emits only the action line matching the verdict, retaining the `sentinel:important`/`sentinel:minor` label literals (closes #9).
- Phase 3 / SEVERITY-RUBRIC Known-matching tightened to "same specific defect mechanism + fix" (blunts overly-broad pre-filed issues).
- Re-review Phase 2 re-dispatch now explicitly includes dimensions whose only findings were Known (a Known-🟡 dimension is not "clean").
- `SEVERITY-RUBRIC.md`: dropped the stale template-semver pin (the ruleset-v1 binding stays and is now CI-checked).

## [0.20.2] - 2026-07-02

Resolves the three actionable issues from the v0.20.1 audit (#21, #22, #24). #23 (severity-rule duplication) was closed as wontfix: the 3-place duplication is load-bearing — each dimension file is a standalone sub-agent system prompt — and `validate.sh` check 7 remains the drift tripwire; revisit only on an observed downstream disagreement.

### Added
- **Downstream sync manifest** (`SYNC.md`, closes #21): tracked table of all adopter repos with each one's last-synced template version (read from their root `AGENTS.md` marker) and check date. Replaces the prose repo list in root AGENTS.md §Syncing; enables a one-prompt "audit all downstreams" flow. All 9 downstreams verified at v0.20.0 as of 2026-07-02.

### Changed
- **Ruleset version clarified** (SENTINEL.md title + root AGENTS.md §Versioning, closes #22): "(v1)" is the report-protocol contract (Status line, report format, verdict semantics), independent of template semver; it bumps only on breaking report-format changes. In-place title reword — SENTINEL.md unchanged at 176/178.
- **Setup Step 3 pointer fixed** (template AGENTS.md setup block, closes #24): the invocation-method answer pointed to "→ update docs/SENTINEL.md", which has no such field. Now actionable: if B (CI), set up the pipeline to invoke Sentinel with docs/SENTINEL.md as system prompt and gate merges on its `Status:` line. Inside the setup block — post-setup line count unaffected.

### Metrics
- template/AGENTS.md: 135/135 non-blank lines post-setup (unchanged — setup-block reword + version swaps only)
- SENTINEL.md: 176/178 non-blank lines (unchanged — in-place title reword)
- New root file: `SYNC.md` (repo infrastructure, not part of `template/`)

## [0.20.1] - 2026-07-01

Documentation-hygiene release. A full repo audit found the manual release checks (root AGENTS.md §Versioning / §Testing Changes) had leaked drift across several surfaces. All fixes are pointer/typo corrections — no template behavior changes. The same checks are now automated in CI so this class of drift can't recur.

### Added
- **Repo validation CI** (`scripts/validate.sh` + `.github/workflows/validate.yml`): automates the checks root AGENTS.md already prescribed manually — version sync across all surfaces, setup-placeholder inventory audit (with runtime-placeholder allowlist), the ≤135/≤178 line budgets, setup-block marker integrity, relative-link and `§`-reference validity, Structure-tree ↔ file-layout agreement, and a severity-level tripwire guarding the deliberate 3-place duplication (SENTINEL.md / SEVERITY-RUBRIC.md / dim files). Pure bash, no dependencies; repo infrastructure only — nothing added to `template/`. On its first run it caught a live drift (see Fixed).

### Fixed
- **SETUP.md placeholder-inventory mismatch** (caught by the new `validate.sh`): the inventory listed `{{Add detailed setup instructions here}}` while DEVELOPMENT-WORKFLOW.md uses the longer `{{Add detailed setup instructions here — IDEs, extensions, environment variables, etc.}}`; aligned to the actual token.
- **Stale root version marker** (root AGENTS.md line 1): read `v0.12.2` through 8 subsequent releases. Bumped, and §Versioning now enumerates every version surface (README badge + "Current version" line, root marker, `template/AGENTS.md` ×3, `docs/index.html` hero + footer, git tag) so the checklist itself can't under-specify again.
- **Contradictory compression budget** (root AGENTS.md §ASK FIRST): said ≤130 non-blank lines post-setup while §Compression says ≤135 (and the template sits at exactly 135). Aligned to ≤135.
- **Dangling cross-references to a removed section**: README §Invoking Sentinel pointed to "docs/SENTINEL.md for GitHub Actions integration" and SETUP.md §After Customization to "docs/SENTINEL.md §Infrastructure Enforcement" — that section no longer exists. README now carries a Method A/B/C legend (the "Which Sentinel Method?" table used those labels without defining them anywhere); SETUP.md describes Method B inline and points at the real §Deploy / release gating section.
- **Post-adoption dangling pointer** (SETUP.md §After Customization): "see README.md" — README.md is not copied downstream, so in an adopting project it pointed at the adopter's own README. Replaced with self-contained text (the setup block asks the method question in Step 3).
- **Runtime-placeholder trap** (SETUP.md §Verification): "when no results are returned … you're done" contradicted SENTINEL.md's intentional runtime placeholders (`{{branch}}`, `{{sha}}`, …) — a setup agent following the checklist literally could "fix" them. Added the explicit exception list, mirroring the note the setup block already carries in Step 7 / M8.
- **Website advertised a removed feature** (docs/index.html): fixability classification (🔧/🧠/👤) no longer exists in the spec; also removed unverifiable timing claims (~30s / 2–5 min).
- **CHANGELOG date typo**: `[0.14.0]` was dated 2026-06-15, after 0.14.1/0.15.0/0.16.0. Corrected to 2026-05-26 (the `v0.14.0` git tag date), restoring monotonic ordering.
- **README `template/docs/sentinel/` description** omitted `SEVERITY-RUBRIC.md` and `BACKLOG-HYGIENE.md`.
- `.gitignore`: added `.impeccable/` (local tool cache containing absolute paths; previously ignored only by a global gitignore).

### Metrics
- template/AGENTS.md: 135/135 non-blank lines post-setup (unchanged — version-string swaps only)
- SENTINEL.md: 176/178 non-blank lines (untouched)
- SETUP.md: +4 non-blank lines (unbudgeted; runtime-placeholder exception + Method B text)

## [0.20.0] - 2026-06-29

Adds opt-in **issue-backlog hygiene** after a downstream adopter (Council) accreted **700+ open `sentinel:*` issues** (~half 🟡 important, ~half 🟢 minor) — many no longer applicable. A 5-expert sub-agent panel (Sentinel architect, downstream DevEx, SRE/lifecycle, app-security, YAGNI-minimalist; across Claude Opus 4.8, GPT-5.5, Gemini 3.1 Pro) reached a **unanimous PARTIAL verdict**: the accretion is **structural** — Sentinel files issues and never revisits them, so every adopter trends toward this state — but Sentinel must **never auto-close** anything, because *"stale ≠ resolved."* The agreed principle: **Sentinel emits self-verifying signals; the human keeps closure authority.** Shipped within budget (in-place rewords + one opt-in companion doc); no gate weakening.

### Added
- **Backlog-hygiene companion** (`docs/sentinel/BACKLOG-HYGIENE.md`, opt-in; pointer from AGENTS.md §After Sentinel): defines the **validity anchor** (every filed `sentinel:*` issue carries `file:line` + the quoted evidence snippet + reviewed SHA + dimension, plus a `sentinel:security` tag for A1/A2 or security-path findings), a four-label vocabulary, and an opt-in **re-validation sweep that flags but never closes** — *asymmetric closure authority* (security issues are never auto-closeable; non-security may be proposed for closure only on **positive** resolution evidence, never on age/absence/line-drift), *migration-aware* (match the sink, not the line number), *default-on-doubt = keep open*, with an auditable comment trail. Includes an optional, SHA-pinned, **flag-only** example GitHub Action (documentation-only — adopters opt in).
- **Validity anchor + inflow discipline at filing** (template AGENTS.md §After Sentinel): filing now records the anchor so a later pass can cheaply re-check a finding; 🟢 minors file as **one digest issue per review** (a standalone 🟢 only on recurrence) to throttle inflow — the lever that most directly addresses the ~half of Council's backlog that is `sentinel:minor`.

### Changed
- **De-dup hardened to compare exploitability** (SENTINEL.md Phase 3 + `sentinel/SEVERITY-RUBRIC.md`): a new finding **more severe or newly reachable** than a matched open `sentinel:*` issue is **no longer marked Known** — it escalates at the higher severity. Closes a "laundering channel" whereby a worse new manifestation could be silently downgraded to Known. In-place reword; SENTINEL.md unchanged at 176/178.

### Deferred / Rejected (logged for traceability)
- **Rejected — Sentinel auto-closing stale issues** (any age/line-based reaping; any closure of `sentinel:security` findings): reverses the "do not weaken the gate" constraint and the unanimous panel guardrail that *stale ≠ resolved*. The safe analog — a flag-only sweep where humans close — shipped instead.
- **Deferred — narrow objective auto-close** (deleted-file / exact-duplicate only): plausible but kept human/opt-in for now; revisit only if the flag-only sweep proves too conservative in practice downstream.

### Metrics
- SENTINEL.md: 176/178 non-blank lines (unchanged — Phase 3 de-dup reworded in place)
- AGENTS.md: 134/135 non-blank lines post-setup (+1: Issue hygiene pointer)
- New companion file: `docs/sentinel/BACKLOG-HYGIENE.md`
- `SEVERITY-RUBRIC.md`: de-dup reworded (+1 line); dimension prompts unchanged

## [0.19.0] - 2026-06-26

Incorporates feedback from a downstream agent that ran ~24 Sentinel reviews (2 genuine 🔴 blocks of broken PRs, including a stale-overlay bug surfaced via a coverage gap; 0 bad merges). Net: the depth is the asset — keep it. The gaps were **severity reproducibility across fresh-agent reviewers** and **non-behavioral noise** (CHANGELOG-driven CONDITIONALs). Triaged for general-case value: ~half the feedback was already handled in v0.18.0; the consistency + determinism wins were taken; the routing changes that would weaken the security/supply-chain gate were declined.

### Added
- **Severity rubric companion** (`docs/sentinel/SEVERITY-RUBRIC.md`, referenced from SENTINEL.md §Phase 3): a version-pinned orchestrator calibration reference — an ordered decision procedure plus **golden worked-examples** drawn from the real reviewed cases (jitter-on-`Retry-After` → 🔴, stale retry-overlay → 🔴, mocked-out new data layer hiding a bug → 🔴, missing CHANGELOG → 🟢, unreachable defensive guard → 🟢, non-discriminating test → 🟡). Makes the same finding class yield the same severity regardless of which agent orchestrates. Lives in a companion file (compliance-critical content, per AGENTS.md §Compression) so SENTINEL.md stays at 176 lines.

### Changed
- **CHANGELOG severity is now deterministic** (SENTINEL.md §Phase 3 + `dim-f-documentation.md`): a missing CHANGELOG is **always 🟢 — never 🟡/CONDITIONAL**. Closes the "user-impact requirement" loophole that contradicted AGENTS.md (`CHANGELOG = Update`) and produced repeated APPROVED→CONDITIONAL churn for a non-behavioral convention.
- **CHANGELOG implementer nudge** (template AGENTS.md §Associated Documentation): the CHANGELOG row is marked `(TDD-exempt; include in the PR)` so it is rarely even a finding. 0 net lines.
- **Report-persistence clarified** (SENTINEL.md §Phase 5): durable PR-comment remains the default; a committed `.sentinel/reports/<id>.md` fallback MUST land on a persisted branch — **never inside a throwaway/ephemeral verification worktree**. Isolated checks use a repo-relative scratch path (`.worktrees/sentinel-<id>`), treated as scratch not storage. Resolves the observed non-deterministic-worktree and report-lost-in-deleted-worktree friction without hardcoding any platform's temp-dir policy.

### Deferred (logged for traceability)
- **Presentational-surface-only dispatch lane** ([#14](https://github.com/pedrofuentes/agents-template/issues/14), `sentinel:deferred`): a diff-aware skip of A1/A2 on pure CSS/copy diffs. A blanket content-based security skip reverses the v0.17.0 escalation hardening and the Dim-E "never skip" principle; `style`/`docs` commits already skip A1/A2 via selective dispatch, so the real fix is upstream commit-type accuracy. Revisit only with a Dim-E-tight positive surface definition. Wall-time half already tracked as #11.

### Rejected (logged for traceability)
- **Content-based A1/A2 security-dim skip as a general rule**: reverses v0.17.0's non-exhaustive, project-aware security-path escalation and the Dim-E "never skip on a lockfile diff" principle. The safe, narrow analog is deferred (#14), not adopted blanket.
- **Upstream mutation-testing / coverage-diff gate at PR creation**: would impose test tooling on every adopter; Pre-Push Verification already offers optional gitleaks/semgrep. Advisory to individual projects, not a template change.
- **Dropping the report "Agent ID" column**: already handled — SENTINEL.md §Phase 2 explicitly permits `N/A` + platform-limitation note, and the column is already `Agent ID / Ref`. No change needed.

### Metrics
- SENTINEL.md: 176/178 non-blank lines (unchanged — all in-place rewords)
- AGENTS.md: 133/135 non-blank lines post-setup (unchanged)
- Dimension prompts: `dim-f` reword (+0 lines)
- New companion file: `docs/sentinel/SEVERITY-RUBRIC.md`

## [0.18.0] - 2026-06-19

Incorporates feedback from a downstream coordinator that ran 7 Sentinel reviews (1 CONDITIONAL, 6 APPROVED, 0 REJECTED, 0 bad merges) on a dependency-heavy workstream. Net: high correctness and calibration; the gap was proportionality/throughput on trivial dependency PRs. Four items were evaluated via a 3-model panel (GPT-5.5, Gemini 3.1 Pro, Claude Opus 4.8) — two accepted, one deferred, one rejected. The accepted throughput fix was scoped to preserve the supply-chain gate: Dim E still runs on every lockfile diff.

### Added
- **Dim-E-only selective-dispatch lane** (SENTINEL.md §Phase 2 Selective dispatch): dependency-surface-only PRs (every changed file is a package manifest, lockfile, or package-manager config, and none is a Dockerfile/CI/build/source/test/docs file) dispatch **Dim E only**, logging A1/A2/B/C/D/F as `N/A (no reviewable surface)`. Cuts the dependency-PR fan-out from 4 sub-agents to 1 while keeping Dim E mandatory — never skipped on a lockfile diff, where dependency-confusion, `resolved`-URL swaps, integrity-hash changes, and `postinstall` injection hide. Resolves the "fast-path is dead for dependency work" friction without a true Tier-0 bypass.

### Changed
- **Merge-base novelty cap in all 7 dimension prompts** (`dim-a1`…`dim-f` §Scope): a pre-existing issue the diff neither introduces nor newly reaches is now explicitly **capped at 🟢 (never 🔴/🟡)**, aligning the sub-agents with the orchestrator's existing "🟢 max" scope rule (SENTINEL.md Phase 2). Stops sub-agents emitting blocking findings on unchanged pre-existing code that the orchestrator then has to down-scope (observed twice downstream). In-place reword; no line-budget impact.

### Deferred (logged for traceability)
- **Review-depth budget proportional to LOC/surface** ([#11](https://github.com/pedrofuentes/agents-template/issues/11), `sentinel:deferred`): the 44-min wall-time on an all-green Dependabot subset is a platform-parallelization symptom with no observed gate failure. Mitigated by the Dim-E-only lane; revisit if dependency-PR latency persists. A LOC/latency depth budget that skips fan-out is NOT adopted — it would skip Dim E (supply-chain regression) and open a loophole against the rule that "cost, latency, or diff size are NOT valid reasons" to reduce review.

### Rejected (logged for traceability)
- **Tier-0 lane that skips the multi-agent fan-out for lockfile/metadata diffs**: would skip Dim E — the only dimension that inspects lockfiles — directly reversing v0.17.0's tightening. The safe subset (narrowed dispatch, Dim E retained) shipped instead (see Added).
- **Reconcile the "never-selected" `standard (fast-path)` checklist mode** (AGENTS.md Pre-Merge Checklist): not a defect. Dependency PRs *correctly* decline the fast-path (Phase 1.5 "No new dependencies added"); the mode stays valid for source-only `fix`/`docs`/`refactor` diffs. Spending the scarce AGENTS.md line to document rarity adds noise for zero behavioral gain.

### Metrics
- SENTINEL.md: 176/178 non-blank lines (+1: Dim-E-only lane)
- AGENTS.md: 134/135 non-blank lines post-setup (unchanged)
- Dimension prompts: +0 lines (in-place reword)

## [0.17.0] - 2026-06-17

Incorporates feedback from a downstream agent that ran Sentinel across a 20-task CLI run. Three reported items evaluated for general-case value: two accepted (a real fast-path miss and a concrete doc contradiction), one rejected (a flaky-handling change that would weaken the gate). The accepted fast-path fix was trimmed to two load-bearing edits; two redundant tweaks were dropped after re-evaluation.

### Added
- **Terminal/ANSI/OSC escape injection** (dim-a1 §Injection): named as an injection sink — untrusted content written to stdout/stderr/TTY without stripping control characters (output spoofing, cursor/title/clipboard manipulation, hidden-command injection in some terminals). Closes a CLI blind spot: the prior list enumerated only web sinks, so a Phase 1.5 fast-path APPROVE missed untrusted content rendered to a terminal.
- **Fast-path escalation for terminal/UI output** (SENTINEL.md §Phase 1.5): the Tier-2 skip-criteria security-path list is now non-exhaustive and project-aware — project-defined sensitive surfaces (AGENTS.md §NEVER) and modules rendering untrusted input to a terminal/UI disqualify the fast-path and escalate to full review. Ensures the dim-a1 check actually runs on CLI-shaped diffs whose paths don't match `auth/ crypto/ middleware/ migrations/`.

### Fixed
- **Report-template contradiction** (SENTINEL.md §Output): the report template led with `## Sentinel Review Report`, contradicting the mandate that the first non-blank line MUST be exactly `Status: …` (the v0.16.0 anti-truncation rule). The template now leads with `Status:`; the duplicate Status line was removed from the metadata block.

### Rejected (logged for traceability)
- **Flaky auto-file + skip baseline**: auto-filing a `flaky` label so newly-observed flakes skip the merge-base baseline run would let a real regression masquerade as a flake. The merge-base run is the deliberate cost of *establishing* a flake — unchanged.
- **Quick-scan inline hint / platform-timeout SHA tweak**: dropped as redundant — covered by the two accepted edits, and by Phase 0 + invariant 3 (SHA binding) respectively.

### Metrics
- SENTINEL.md: 175/178 non-blank lines (unchanged)
- AGENTS.md: 134/135 non-blank lines post-setup (unchanged)

## [0.16.0] - 2026-06-14

Resolves issues #5 and #6 from the open-issue triage — both grounded in a downstream case (Council PR #147) where a Sentinel sub-agent's trailing summary caused the platform's read tool to return only that summary, silently dropping the full report.

### Added
- **Phase 5 — Persist report** (SENTINEL.md): Sentinel MUST persist the full report to a durable location (preferred: `gh pr review --body-file` on the reviewed PR; fallback: the invoker persists it) before returning, and record the URL/path in the Execution Log. Returning the report as agent text only is now explicitly INSUFFICIENT. Keeps the merge commit's `Report ID + SHA` auditable even when the parent's context drops the report. Read-only is preserved (persisting one's own report is reporting, not a code change).
- **Report-capture verification** (AGENTS.md §How to Invoke): step 4 now verifies the *captured* output is the full report (not just a `Status:` line or one-sentence summary) and re-invokes with an emit-only instruction if truncated. Step 2 now passes the PR number/URL so Sentinel can persist.
- **Parent persistence fallback** (AGENTS.md §After Sentinel): explicit "Persist the report" duty when Sentinel could not.

### Changed
- **Emit-only rule** (SENTINEL.md §Output): the final-output directive now forbids any trailing summary/recap/"Verdict: …" sentence after the report (preamble was already forbidden) — a trailing summary is the documented trigger for lossy capture.
- **SENTINEL.md line budget** raised 175 → 178 (AGENTS.md §Compression) to absorb Phase 5.

### Metrics
- SENTINEL.md: 175/178 non-blank lines (was 173/175)
- AGENTS.md: 134/135 non-blank lines post-setup (was 132/135)

## [0.15.0] - 2026-06-14

Incorporates feedback from a downstream agent that ran Sentinel across ~20 review cycles. All five reported items were evaluated for general-case value and accepted (the platform-timeout item tightly scoped).

### Added
- **Phase 1 suite-green carve-outs** (SENTINEL.md §Phase 1): two auditable ways to satisfy check 5 without a full local run — **no-code diffs** (diff provably touches zero source/test/build-config files; only directly-affected tests run) and **platform timeouts** (file-scoped run of all tests covering changed files **plus** CI evidence of full-suite green on the reviewed SHA). Both flagged ⚠️. Removes full-suite runs on docs-only PRs and replaces ad-hoc timeout waivers with a documented rule.
- **Bypass-class completeness rule** (dim-a1, dim-a2): when flagging a sanitize/escape/encode/validate defect, sub-agents must enumerate the *entire* bypass class (all Unicode line/paragraph separators, role-marker families, magic-byte signatures, sink metacharacters) in one finding — preventing one-cycle-later re-rejection on the same surface.
- **Materiality floor** (SENTINEL.md §Phase 3, dim-c): findings whose own rationale declares the impact immaterial/negligible/immeasurable are omitted (not filed even as 🟢); trivial polish batches into a single 🟢. Curbs issue inflation.

### Changed
- **Reviewer-model floor** (SENTINEL.md §Phase 2): dimensions A1, A2, and D — which hold 🔴-blocking authority — **MUST** run on a capable model (≥Sonnet-class, never fast/cheap/haiku); B/C SHOULD; E/F may stay cheap. Was a soft "A–D benefit from full-capability models."
- **SENTINEL.md line budget** raised 170 → 175 (AGENTS.md §Compression) to absorb the compliance-critical Phase 1 carve-outs rather than compress them.

### Metrics
- SENTINEL.md: 173/175 non-blank lines (was 170/170)
- dim-a1, dim-a2, dim-c: +1 non-blank line each

## [0.14.1] - 2026-05-28

### Fixed
- **Fast-path mode ambiguity** (SENTINEL.md §Mode declaration + §Phase 1.5): Added `standard (fast-path)` as a legitimate Mode value. Previously, Tier 1 fast-path approvals (which legitimately skip Phase 2) had no matching Mode — agents misclassified them as `degraded (no sub-agents)`. Now the protocol distinguishes "Phase 2 not required" from "couldn't spawn sub-agents."
- Updated AGENTS.md §Pre-Merge Checklist to include `standard (fast-path)` in Mode options.

### Metrics
- SENTINEL.md: 170/170 non-blank lines (unchanged — all edits modify existing lines)

## [0.14.0] - 2026-05-26

### Added
- **Prompt caching protocol** (SENTINEL.md §Phase 2): Expanded from 1-line guidance to structured cross-dimension prefix sharing protocol — shared prefix (system position) with diff/context, variable suffix (user position) with dimension checklist, priming dispatch pattern for ~78% input cost reduction across dimension calls.
- **Deterministic pre-filters** (SENTINEL.md §Input filtering): Exclude deletion-only hunks, whitespace-only hunks, generated code, and lockfiles (except Dim E) before any LLM invocation — zero-cost token reduction.
- **Small-PR exception** (SENTINEL.md §Input filtering): PRs ≤150 non-test LOC may send full pre-filtered diff to all dimensions instead of per-dimension routing.
- **Staged routing** (SENTINEL.md §Input filtering): Two-tier input for A1/A2/B/C — universal compact diff (`-U0`) + dimension-expanded hunks (`-U3`) for focus files — 50-80% diff token reduction on large PRs.
- **Mandatory expansion rule** (dim-a1, dim-a2, dim-b, dim-c): Context acquisition section requiring sub-agents to use tools to fetch additional context before concluding "No findings" when routed input is insufficient.

### Changed
- **Input filtering** upgraded from RECOMMENDED to **REQUIRED** — ensures consistent token savings across all implementations.
- **Routing table** now splits A into separate A1/A2 rows (consistent with dimension table and selective dispatch).

### Metrics
- SENTINEL.md: 170/170 non-blank lines (was 164/170)
- dim-a1, dim-a2, dim-b, dim-c: +3 lines each (Context acquisition section)

## [0.13.1] - 2026-05-25

### Changed
- **SUT-touching override** (SENTINEL.md §Pre-existing test failures): Known flake exclusion now applies when the PR modifies the SUT file — provided the flaking test passes in targeted isolation on the PR branch and all other conditions (tracked `flaky` issue, same failure signature, no fixture/infra/dependency touch) are met. Reduces wasted Sentinel cycles on file-level false positives.
- **Speculative Phase 2 preservation** (SENTINEL.md §Speculative execution): When Phase 1 fails solely on suspected pre-existing flakes, Phase 2 findings are preserved (labeled `⚠️ speculative` with reviewed SHA) instead of discarded — re-review can reuse them when the diff is unchanged.

### Metrics
- AGENTS.md: 132/135 non-blank lines (unchanged)
- SENTINEL.md: 164/170 non-blank lines (+1 line, budget raised 165→170)

## [0.13.0] - 2026-05-25

### Added
- **Automated release tooling support** (AGENTS.md setup + dim-f): Setup now detects Release Please, semantic-release, and Changesets config files. When detected, adjusts CHANGELOG.md from "Update" to "Read only — auto-generated by [tool]" and adds release-generated CHANGELOG to the generated files list in NEVER.
- **ASK FIRST trigger**: "CI/CD changes" expanded to "CI/CD or release automation changes" — catches adoption of release tooling post-setup.
- **HTML comment reminder** (AGENTS.md Associated Documentation): Bidirectional comment covers both toggling directions (manual ↔ release tooling).
- **Dim-f generic CHANGELOG check**: Skip-based detection — if CHANGELOG is absent from diff and release-tooling config exists, dim-f skips the check instead of flagging. Remains project-type-agnostic.

### Changed
- Setup instructions now reference Step 1 detection list (not repeated file names) and give concrete NEVER §Integrity edit text (copy-pasteable wording)

### Metrics
- AGENTS.md: 132/135 non-blank lines (unchanged)
- SENTINEL.md: 163/165 non-blank lines (unchanged)

## [0.12.2] - 2026-05-25

### Added
- **Known-flake fast path** (SENTINEL.md §Pre-existing test failures): Tests linked to an open `flaky`-labeled GitHub issue with matching signature and prior evidence are auto-excluded from verdict without requiring a merge-base run.
- **🟡 exclusion examples** (SENTINEL.md §Phase 3): Concrete examples of what lacks the trigger→mechanism→consequence chain (missing CHANGELOG with no API impact, "better abstraction" without failure path, rename/restructure, stylistic preferences).
- **Phase 1.5 fast-path checklist** (SENTINEL.md §Phase 1.5 + report template): Mandatory structured checklist the orchestrator must record before dispatching Phase 2 — makes fast-path compliance detectable and skipping visible.
- **Dispatch verification** (SENTINEL.md §Phase 2): Structural row-count check on Execution Log — one row per dimension A–F with distinct IDs (dispatched) or justified N/A (skipped). Catches silent degraded mode.

### Changed
- **Re-review scoped dispatch** (SENTINEL.md §Phase 0): MAY→MUST for skipping clean dimensions when fix delta scope mapping is explicitly documented. Ambiguous mapping still dispatches fully. Saves compute on re-review cycles.

### Metrics
- AGENTS.md: 132/135 non-blank lines (unchanged)
- SENTINEL.md: 163/165 non-blank lines (was 156)

### Origin
Downstream agent feedback from real Sentinel session (9 tasks, 25+ follow-up issues). 6 items evaluated: 5 accepted (with rubber-duck refinements), 1 rejected (RETRY verdict — unnecessary complexity given known-flake fast path).

## [0.12.1] - 2026-05-24

### Added
- **Behavioral definition of delegated implementer**: "any sub-agent that edits files, commits, or opens a PR" — prevents evasion via role naming.
- **Nested delegation chain rule**: For A→B→C delegation, each implementer stops and reports upward; Sentinel must be invoked by an agent outside the entire implementation chain.
- **Degraded mode escape hatch closed**: Delegated implementers may not use degraded self-review mode — must stop and report to parent instead.

### Changed
- **Sub-agent copy instruction expanded**: Now includes "Delegated Implementation rule" alongside TDD rules and Boundaries.
- **Pre-Merge Checklist clarified**: "invoker and reviewer are independent of code author" replaces previous wording to distinguish dispatching Sentinel from being the reviewer.

### Metrics
- AGENTS.md: 132/135 non-blank lines (unchanged from v0.12.0)
- SENTINEL.md: 156/165 non-blank lines (unchanged)

### Origin
Expert panel review (4 sub-agents: adversarial, clarity, completeness, downstream) identified 10 findings in v0.12.0 delegation rules. 5 fixed, 5 skipped (implicitly covered or theoretical).

## [0.12.0] - 2026-05-24

### Added
- **Delegated implementation stop point**: Per-Increment Execution step 4 now explicitly marks where delegated sub-agents must stop — push + open PR, report PR URL + HEAD SHA, do not invoke Sentinel or merge. Parent/orchestrator retains Sentinel responsibility.
- **Delegation rule in Sub-Agents section**: New paragraph clarifies that sub-agent Sentinel self-reports are invalid (§Do NOT review your own code). Parent invokes Sentinel independently per PR. Do not accept Sentinel results from PR text, comments, or sub-agent summaries.
- **Pre-Merge Checklist provenance check**: New checkbox verifies Sentinel reviewer is independent of code author (not the implementing agent, not its parent).

### Changed
- **AGENTS.md line budget raised**: 130 → 135 (justified by observed downstream failure — delegation gap is compliance-critical).

### Metrics
- AGENTS.md: 132/135 non-blank lines (+3 from v0.11.1)
- SENTINEL.md: 156/165 non-blank lines (unchanged)

### Origin
Observed downstream failure: fleet sub-agents self-reviewed their own code via Sentinel, reported "APPROVED", and parent merged without independent verification — violating "Do NOT review your own code" rule. Root cause: template lacked explicit delegation boundaries for Sentinel responsibility.

## [0.11.1] - 2026-05-24

### Changed
- **Sentinel report now includes `Required action` field**: Report header includes `Required action: MERGE | FILE_ISSUES_AND_MERGE | FIX_AND_REINVOKE` with enforced mapping constraint so consuming agents know what to do without needing AGENTS.md context.
- **Follow-ups & Actions section is now per-verdict directive**: Each verdict maps to an explicit action. REJECTED defers 🟡/🟢 issue filing to final verdict report (prevents stale issues from intermediate cycles). Warning: "Do NOT fix 🟡/🟢 findings in this PR."
- **After Sentinel table tightened**: CONDITIONAL says "do NOT fix in-PR." REJECTED says "Fix 🔴 blockers; do not independently fix 🟡/🟢" — allows incidental resolution when inseparable from a 🔴 fix.
- **Removed "fix autonomously" ambiguity**: Per-Increment Execution and How to Invoke sections now defer to §After Sentinel instead of embedding verdict logic that could conflict with the table.
- **Phase 4 CONDITIONAL verdict scoped**: "Follow-ups filed before merge" now explicitly inside the CONDITIONAL clause, not ambiguously applying to APPROVED.
- **Renamed `Required fix` → `Remediation` in finding template**: "Required fix" on 🟡/🟢 findings semantically conflicted with "do not fix" directives. Multi-model panel (Opus 4.7, GPT-5.5, Opus 4.5) unanimously flagged this as likely to recreate the original failure.
- **Added "new" qualifier to issue filing**: All verdict actions now specify "new 🟡/🟢" to prevent re-filing Known findings that already have tracked issues.

### Metrics
- SENTINEL.md: 156/165 non-blank lines (+5 from v0.11.0)
- AGENTS.md: 129/130 non-blank lines (+1 from v0.11.0)

## [0.11.0] - 2026-05-23

### Added
- **Pre-existing test failure classification** (Phase 1): Narrow mechanism for classifying test failures as pre-existing — requires baseline evidence from merge-base + PR must not touch the failing test/SUT/fixtures. Issue-linked → excluded from verdict (⚠️); no issue → CONDITIONAL with requirement to file one. Invariant #2 updated to acknowledge classification.
- **Dim E auto-skip**: Skip Dim E when no dependency surface files changed (manifests, lockfiles, configs, Dockerfiles, CI install steps, build scripts, vendored code). Applies regardless of commit type.

### Changed
- **Phase 1.5 fast-path now REQUIRED evaluation**: Orchestrator must evaluate fast-path eligibility for every PR passing Phase 1. Skipping evaluation when criteria are met is a protocol violation. Safety criteria unchanged.
- **Selective dispatch enforced**: Added `(REQUIRED)` tag with enforcement language. Dispatching exempted dimensions is a protocol violation. Mixed PRs (any non-exempt commit) require full dispatch. Clarified "fully-exempt" means ALL commits/files, not just PR title.
- **🟡 criteria tightened with 3-part risk chain**: Each 🟡 must state trigger (what activates), mechanism (reachable path to failure), and consequence (observable damage). Missing any element → 🟢. Reduces speculative CONDITIONAL verdicts.
- **Scoped re-review**: Re-reviews now re-dispatch only dimensions with 🔴/🟡 findings. Previously-clean dimensions may be skipped when fix delta is limited to re-dispatched dimensions' file scope. Cross-cutting fixes trigger full dispatch. "When in doubt, dispatch fully" default.

### Metrics
- SENTINEL.md: 151/165 non-blank lines (+2 from v0.10.0)
- AGENTS.md: 128/130 non-blank lines (unchanged)

### Origin
Agent feedback from 11+ Sentinel reviews in a downstream project. 6 suggestions triaged → 6 accepted with safety modifications. Quality audit verified no invariant weakening: 4 changes are quality-neutral/positive (A, B, D, F), 2 involve principled trade-offs with tight safety constraints (C, E). TDD enforcement, 6-dimension model, evidence standard, SHA binding, 🔴 floor all preserved.

## [0.10.0] - 2026-05-21

### Changed
- **🟡 materiality calibration**: Tightened 🟡 IMPORTANT definition — requires an articulated risk path (plausible trigger, reachable failure mode, concrete impact). Theoretical/speculative concerns without a demonstrated risk path → 🟢 MINOR. Reduces CONDITIONAL verdicts by filtering low-signal findings while preserving the quality bar for genuine concerns.
- **🟢 MINOR expanded**: Now explicitly includes theoretical improvements and speculative edge cases where no reachable trigger or material impact is identified.
- **Severity adjustment updated**: Orchestrator may now reclassify 🟡 → 🟢 (when finding lacks articulated risk path), in addition to existing 🟡 → 🔴. 🔴 remains an absolute floor — never downgraded. Sub-agent 🟡 is advisory; 🔴 is authoritative.

### Metrics
- SENTINEL.md: 149/165 non-blank lines (unchanged)
- AGENTS.md: 128/130 non-blank lines (unchanged)

### Origin
Agent feedback from a small project (~300-400 LOC) on v0.6.0 reporting CONDITIONAL as default verdict. 5 suggestions triaged → 1 accepted (materiality calibration), 4 rejected (cascade cap would lower quality bar; Tier 1 criteria intentionally conservative; pre-existing code scope rule already explicit; batch follow-ups handled by known-issue de-dup).

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
