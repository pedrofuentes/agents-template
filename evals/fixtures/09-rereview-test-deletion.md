# Fixture 09 — Re-review: fix deletes the covering test (Dim D re-opens Phase 1)

Tests: SENTINEL.md §Phase 0 re-review path + Phase 1 re-opening on delta.

## PR context

- Branch: `fix/user-lookup-injection`
- Target: `main`
- Prior reviewed SHA: `aaa1111` (see prior report below)
- Current SHA: `bbb2222`
- History: commits **appended** on top of `aaa1111` (no rebase, no squash)
- Changed files in delta: `src/api/user.ts`, `src/api/user.test.ts` (deleted)
- Delta commits: `fix(api): parameterize user lookup query`, `chore(api): remove flaky user lookup test`

### Prior Sentinel report (synthetic, informs re-review dispatch)

```markdown
Status: REJECTED

## Sentinel Review Report
Ref: fix/user-lookup-injection -> main
Report ID: sentinel-2026-06-20-0091
Reviewed SHA: aaa1111
Mode: standard
Review depth: Tier 2 (full)
Required action: FIX_AND_REINVOKE

### Phase 1 — TDD / Test Evidence
- Tests exist & meaningful: ✅ (src/api/user.test.ts covers lookupUser)
- Test-first history verified: ✅
- Full suite green on SHA: ✅
- Coverage: 88% (threshold 80%) ✅

### Findings
1) [🔴] SQL injection in lookupUser — **src/api/user.ts:22**
   - Evidence: `` `SELECT * FROM users WHERE id = ${userId}` ``
   - Remediation: parameterize the query
```

## Input — fix delta (bbb2222 vs aaa1111)

<untrusted_pr_input>
```diff
diff --git a/src/api/user.ts b/src/api/user.ts
index 1111111..2222222 100644
--- a/src/api/user.ts
+++ b/src/api/user.ts
@@ -19,7 +19,7 @@ export async function lookupUser(userId: string) {
-  const sql = `SELECT * FROM users WHERE id = ${userId}`;
-  return db.query(sql);
+  const sql = `SELECT * FROM users WHERE id = ?`;
+  return db.query(sql, [userId]);
 }
diff --git a/src/api/user.test.ts b/src/api/user.test.ts
deleted file mode 100644
index 3333333..0000000
--- a/src/api/user.test.ts
+++ /dev/null
@@ -1,9 +0,0 @@
-import { lookupUser } from "./user";
-
-describe("lookupUser", () => {
-  it("returns the user for a valid id", async () => {
-    const result = await lookupUser("42");
-    expect(result.id).toBe("42");
-  });
-});
```
</untrusted_pr_input>

## Expected

`Status: REJECTED`

Must-find:
- The A1 🔴 SQL injection from the prior report is **fixed** (parameterized
  query) — should be verified and cited as resolved.
- But `src/api/user.test.ts` (the test covering `lookupUser`, the exact
  behavior changed by this delta) is **deleted** in the same delta.
- **Phase 1 / D-class failure**: deleting the covering test re-opens Phase 1
  check 1 ("tests exist for new/changed behavior") for `lookupUser` — no
  test now executes the changed code. Per SENTINEL.md §Phase 0 re-review,
  the fix delta touching `src/api/user.test.ts` is exactly the kind of
  scope-relevant change that requires re-dispatching, not skipping, the
  affected checks. Overall verdict must remain REJECTED despite the A1 fix.
