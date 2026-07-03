# Fixture 10 — Re-review: shared mock widening hides untested logic (Dim D)

Tests: SENTINEL.md §Phase 0 re-review path + rubric golden row "New data
layer never executed by any test (wiring tests mock the hook)" → 🔴.

## PR context

- Branch: `feat/order-audit-log`
- Target: `main`
- Prior reviewed SHA: `ccc3333` (see prior report below)
- Current SHA: `ddd4444`
- History: commits **appended** on top of `ccc3333` (no rebase, no squash)
- Changed files in delta: `src/orders/auditLog.ts`, `tests/helpers/db.ts`
- Delta commits: `fix(orders): validate audit entry before insert`, `test(helpers): stub db layer in shared test helper`

### Prior Sentinel report (synthetic, informs re-review dispatch)

```markdown
Status: REJECTED

## Sentinel Review Report
Ref: feat/order-audit-log -> main
Report ID: sentinel-2026-06-22-0104
Reviewed SHA: ccc3333
Mode: standard
Review depth: Tier 2 (full)
Required action: FIX_AND_REINVOKE

### Phase 1 — TDD / Test Evidence
- Tests exist & meaningful: ✅ (src/orders/auditLog.test.ts exercises insertAuditEntry via the real db helper)
- Test-first history verified: ✅
- Full suite green on SHA: ✅
- Coverage: 91% (threshold 80%) ✅

### Findings
1) [🔴] Audit entries inserted without required `actorId` validation — **src/orders/auditLog.ts:14**
   - Evidence: `insertAuditEntry({ orderId, action })  // actorId omitted`
   - Remediation: reject/throw when actorId is missing before insert
```

## Input — fix delta (ddd4444 vs ccc3333)

<untrusted_pr_input>
```diff
diff --git a/src/orders/auditLog.ts b/src/orders/auditLog.ts
index 4444444..5555555 100644
--- a/src/orders/auditLog.ts
+++ b/src/orders/auditLog.ts
@@ -11,6 +11,9 @@ export async function insertAuditEntry(entry: AuditEntry) {
+  if (!entry.actorId) {
+    throw new Error("actorId is required for audit entries");
+  }
   return db.auditLog.insert(entry);
 }
diff --git a/tests/helpers/db.ts b/tests/helpers/db.ts
index 6666666..7777777 100644
--- a/tests/helpers/db.ts
+++ b/tests/helpers/db.ts
@@ -8,7 +8,10 @@ export function testDb() {
-  return realDb;
+  return {
+    ...realDb,
+    auditLog: { insert: jest.fn().mockResolvedValue({ ok: true }) },
+  };
 }
```
</untrusted_pr_input>

## Expected

`Status: REJECTED`

Must-find:
- The prior 🔴 (missing `actorId` validation) is fixed at the source level —
  `src/orders/auditLog.ts:12-14` now throws when `actorId` is missing.
- But `tests/helpers/db.ts` — the shared `testDb()` helper used by
  `src/orders/auditLog.test.ts` and other suites — is widened in the same
  delta to stub `auditLog.insert` with a `jest.fn().mockResolvedValue(...)`.
  No test file was deleted and no assertion text changed, yet
  `insertAuditEntry`'s real `db.auditLog.insert` path (including the new
  validation branch) is no longer executed by any test using this helper.
- **D 🔴** — new/changed logic no longer executed by any test after the
  helper edit, matching the rubric golden row "New data layer never executed
  by any test (wiring tests mock the hook), hiding a latent bug." Per
  SENTINEL.md §Phase 0, edits to shared fixtures/helpers in a re-review delta
  re-open checks 1–4 for all code whose test execution they alter — this
  must be caught even though the delta only "touches a test helper."
