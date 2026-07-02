# Sentinel Eval Runner

A prompt document an AI agent executes on demand — not a script. Two lanes.

## Lane 1 — Dim-level (default, cheap)

For a ruleset edit touching dimension file X (or `SEVERITY-RUBRIC.md`): for
each fixture in [`fixtures/`](fixtures/) whose dimension-coverage row includes
X (see [`README.md`](README.md) §matrix), spawn **ONE sub-agent** per fixture
whose complete instructions are:
1. The verbatim content of the dimension file under test (or, for a rubric
   edit, the dimension file(s) that cite the rubric + the rubric itself).
2. The fixture's `## PR context` + `## Input` blocks, unmodified.

Compare the sub-agent's returned findings to the fixture's `## Expected`
block using the scoring rules in `README.md`. Run only fixtures whose
dimensions are touched by the edit under test — do not run the full set for
a single-dimension edit.

## Lane 2 — End-to-end (expensive, 2–3 fixtures max)

Full Sentinel orchestration per [`../template/docs/SENTINEL.md`](../template/docs/SENTINEL.md)
against a fixture (dispatch real Phase 2 sub-agents, run all phases). Use
sparingly — pick the 2–3 fixtures most relevant to the edit (e.g., include 06
if Phase 1.5 changed, 09/10 if the re-review path changed).

Checks **protocol shape only**:
- First non-blank line is exactly `Status: <verdict>`.
- `Required action` maps to the verdict per SENTINEL.md's mapping table.
- Execution Log has one row per dimension A–F (dispatched or `N/A` with
  justification).
- Fast-path checklist present when the fixture is fast-path-eligible.

**Baseline-compatibility constraint:** assert only fields that exist in the
CURRENT ruleset under test. Do not assert optional/newer fields (e.g., an
`Elapsed:` header or a one-line Follow-ups section) that a future edit might
add — the same runner must pass unmodified both before and after the
ruleset edit being evaluated.

## Variance rule

One run per fixture by default. If a fixture **FAILS**, re-run it twice more
(3 total) and let 2/3 majority decide pass/fail. Persistent (2/3) failure on
the calibration fixtures (07, 08) indicates real severity-calibration drift
in the ruleset — not sampling noise — and should block the edit until
resolved, not be waved through as "LLM variance."

## Model guidance

Dim-level sub-agents for A1, A2, or D fixtures MUST use a capable
(≥Sonnet-class) model — never fast/cheap/haiku-class — per SENTINEL.md's
model-tier floor (A1/A2/D hold 🔴-blocking authority). B and C fixtures
SHOULD use full-capability models. E and F fixtures may use fast/cheap
models.

## Reporting

Produce a results table:

| Fixture | Expected | Got | Result | Notes |
|---|---|---|---|---|
| 01-sql-injection | REJECTED / A1 🔴 | … | PASS/FAIL | (majority note if re-run) |

List any fixture that required a majority re-run and why (transient miss vs.
suspected drift).
