# Fixture 03 — Lockfile resolved-URL swap (Dim E, Dim-E-only lane)

Tests: [`dim-e-dependencies.md`](../../template/docs/sentinel/dim-e-dependencies.md)

Exercises SENTINEL.md's Dim-E-only lane (§Dependency-surface-only PRs): every
changed file is a manifest/lockfile, so A1/A2/B/C/D/F should log
`N/A (no reviewable surface)` and only Dim E dispatches.

## PR context

- Branch: `chore/bump-leftpad`
- Target: `main`
- PR title: `chore(deps): bump left-pad to 1.3.1`
- PR description: "Routine dependency bump picked up by renovate."
- Changed files: `package.json`, `package-lock.json`
- Commits: `chore(deps): bump left-pad to 1.3.1`

## Input

<untrusted_pr_input>
```diff
diff --git a/package.json b/package.json
index 3a3a3a3..4b4b4b4 100644
--- a/package.json
+++ b/package.json
@@ -18,7 +18,7 @@
   "dependencies": {
     "express": "^4.19.2",
-    "left-pad": "1.3.0",
+    "left-pad": "1.3.1",
     "zod": "^3.23.8"
   },
diff --git a/package-lock.json b/package-lock.json
index 5c5c5c5..6d6d6d6 100644
--- a/package-lock.json
+++ b/package-lock.json
@@ -412,9 +412,9 @@
     "node_modules/left-pad": {
-      "version": "1.3.0",
-      "resolved": "https://registry.npmjs.org/left-pad/-/left-pad-1.3.0.tgz",
-      "integrity": "sha512-XvLm4qmnIDaZgcFV/UB6TFm+e6oQBzewFuxJPHNCIesv0z4WuoAsjT7WhEwFMwFHIWuBkgEjyJHmi0OhWnn8xQ=="
+      "version": "1.3.1",
+      "resolved": "https://cdn-mirror-npm.io/left-pad/-/left-pad-1.3.1.tgz",
+      "integrity": "sha512-Q3fF3xkK9wP2vZ1r5N8yqzGZq0Qh6a1cQxYV2m0F2jz3o9m0K7NfV6XxwQxWQKfC2WZbAJqk8fZzQ2C5m6d3wA=="
     },
```
</untrusted_pr_input>

## Expected

`Status: REJECTED`

Must-find:
- **E 🔴** — supply-chain: `left-pad` lockfile entry's `resolved` URL swapped
  from `registry.npmjs.org` to a non-registry host `cdn-mirror-npm.io`, with
  a changed `integrity` hash — `package-lock.json:414-415`. Matches the
  "swapped `resolved` URL / integrity hash" golden 🔴 row in
  [`SEVERITY-RUBRIC.md`](../../template/docs/sentinel/SEVERITY-RUBRIC.md).
- Execution Log should show A1/A2/B/C/D/F as `N/A (no reviewable surface)`
  and Dim E as the only dispatched dimension.
