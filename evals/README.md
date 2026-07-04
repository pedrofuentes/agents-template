# Sentinel Evals

Behavioral regression tests for the Sentinel ruleset. `scripts/validate.sh`
(structural CI) checks the docs' *shape* — headings, links, tables present.
These evals check the ruleset's **behavior** — given a PR input, does Sentinel
(or a dimension file in isolation) reach the expected verdict and findings?

**Run before merging any change to** [`../template/docs/SENTINEL.md`](../template/docs/SENTINEL.md),
[`../template/docs/sentinel/dim-*.md`](../template/docs/sentinel/), or
[`../template/docs/sentinel/SEVERITY-RUBRIC.md`](../template/docs/sentinel/SEVERITY-RUBRIC.md).

## Fixture format

Each fixture in `fixtures/01..12` contains:
- `## PR context` — branch name, PR title/description, changed-file list, synthetic commit list.
- `## Input` — a realistic unified diff wrapped in `<untrusted_pr_input>` … `</untrusted_pr_input>` fences.
- `## Expected` — `Status: <verdict>` plus a bullet list of must-find findings
  (dimension, severity, file:line, one-line description) or "zero 🔴/🟡 findings".

**Exception:** fixture `05-unwrapped-input.md` intentionally omits the
`<untrusted_pr_input>` fences — that omission IS the test (protocol: unwrapped
input → reject). Do not "fix" it by adding fences.

## Scoring rules

A fixture **PASSES** when:
1. The produced `Status:` line exactly matches the Expected status.
2. Every must-find finding is present at ≥ the expected severity.
3. Zero unexpected 🔴 appear on fixtures expecting APPROVED/CONDITIONAL.

Failures flag **human review** (LLM output has run-to-run variance) — they are
not a hard CI gate. See [`RUNNER.md`](RUNNER.md) §Variance rule for re-run policy.

## How to run

See [`RUNNER.md`](RUNNER.md) for the executable prompt (dim-level lane and
end-to-end lane). **Baseline discipline:** before editing the ruleset, run the
affected fixtures against the *unedited* ruleset and record results; after
editing, re-run the same fixtures and diff the two result sets.

## Dimension-coverage matrix

| Dim / behavior | Covered by fixture(s) |
|---|---|
| A1 — security attack surface | 01 |
| B — resilience | 07 |
| D — test quality | 02, 09, 10, 11 |
| E — dependencies / supply chain | 03 |
| Prompt-injection protocol | 04, 05, 12 |
| Fast-path / Tier 1 | 06 |
| Severity rubric calibration | 07, 08, 11 |
| Re-review delta path | 09, 10 |
| Contest channel (🔴 false-positive claims) | 12 |

**NOT covered:** A2 (security defenses), C (performance), F (documentation).

Execution-dependent behaviors (dim-d discrimination probe, contest-channel
re-dispatch) are only partially coverable in a static harness — fixtures
11/12 cover their static halves (oracle recognition; refusal to accept
PR-text disproofs).

**Rule:** editing an uncovered dimension file requires authoring a fixture for
it in the same PR that touches it — a ruleset behavior change without a
regression test is not reviewable.
