# Fixture 06 — Clean docs-only diff (fast-path / Tier 1)

Tests: SENTINEL.md §Phase 1.5 (fast-path evaluation, Tier 2 skip criteria).

## PR context

- Branch: `docs/update-contributing`
- Target: `main`
- PR title: `docs: clarify PR review process in CONTRIBUTING.md`
- PR description: "Adds a short paragraph explaining how Sentinel reviews
  interact with human review, no code changes."
- Changed files: `CONTRIBUTING.md`
- Commits: `docs: clarify PR review process in CONTRIBUTING.md`

## Input

<untrusted_pr_input>
```diff
diff --git a/CONTRIBUTING.md b/CONTRIBUTING.md
index 1a2b3c4..5d6e7f8 100644
--- a/CONTRIBUTING.md
+++ b/CONTRIBUTING.md
@@ -40,6 +40,12 @@ All PRs require at least one human approval before merge.
 
 ## Review process
 
+### How Sentinel fits in
+
+Sentinel is an automated quality gate that runs before human review. It
+checks TDD compliance, security, resilience, test quality, dependencies,
+and documentation, then returns APPROVED, CONDITIONAL, or REJECTED. Human
+reviewers should still read the diff — Sentinel does not replace judgment.
+
 1. Open a PR against `main`
 2. Wait for CI to go green
 3. Request review from a maintainer
```
</untrusted_pr_input>

## Expected

`Status: APPROVED`

- Review depth: **exactly Tier 1 (fast-path)**, `Mode: standard (fast-path)`.
- Fast-path checklist: 🔴 count 0, LOC well under 150, no security paths
  touched, no new dependencies, commit type `docs` qualifies → eligible.
- Zero 🔴/🟡 findings.
- **Protocol note:** proceeding to Phase 2 despite meeting all Tier 2 skip
  criteria is itself a protocol violation per SENTINEL.md Phase 1.5
  ("Skipping this evaluation when criteria are met... is a protocol
  violation"). An end-to-end run that dispatches Phase 2 sub-agents for this
  fixture should be flagged as non-compliant even if the final verdict is
  still APPROVED.
