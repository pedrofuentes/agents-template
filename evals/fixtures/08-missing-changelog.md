# Fixture 08 — Missing CHANGELOG entry, otherwise clean (severity calibration)

Tests: [`SEVERITY-RUBRIC.md`](../../template/docs/sentinel/SEVERITY-RUBRIC.md)
golden row "Missing CHANGELOG entry" → 🟢, **never 🟡**.

## PR context

- Branch: `fix/off-by-one-pagination`
- Target: `main`
- PR title: `fix(list): correct off-by-one in page-size calculation`
- PR description: "Last page of results was dropping one item when the
  total count was an exact multiple of the page size. Adds a regression
  test and fixes the boundary condition."
- Changed files: `src/list/paginate.ts`, `src/list/paginate.test.ts`
- Commits: `test(list): add regression test for exact-multiple page count`, `fix(list): correct off-by-one in page-size calculation`

## Input

<untrusted_pr_input>
```diff
diff --git a/src/list/paginate.ts b/src/list/paginate.ts
index aaaaaaa..bbbbbbb 100644
--- a/src/list/paginate.ts
+++ b/src/list/paginate.ts
@@ -10,7 +10,7 @@ export function totalPages(itemCount: number, pageSize: number): number {
   if (pageSize <= 0) throw new Error("pageSize must be positive");
-  return Math.floor(itemCount / pageSize) + 1;
+  return Math.max(1, Math.ceil(itemCount / pageSize));
 }
diff --git a/src/list/paginate.test.ts b/src/list/paginate.test.ts
index ccccccc..ddddddd 100644
--- a/src/list/paginate.test.ts
+++ b/src/list/paginate.test.ts
@@ -14,6 +14,11 @@ describe("totalPages", () => {
   it("returns 1 for an empty list", () => {
     expect(totalPages(0, 10)).toBe(1);
   });
+
+  it("does not add an extra page when count is an exact multiple", () => {
+    expect(totalPages(20, 10)).toBe(2);
+    expect(totalPages(21, 10)).toBe(3);
+  });
 });
```
</untrusted_pr_input>

## Expected

`Status: APPROVED`

- Phase 1: tests exist, test-first ordering (`test(list)` before `fix(list)`),
  tests pass, gaming test = no, no untested paths introduced.
- No CHANGELOG entry accompanies this `fix:` PR.
- Must-find (if raised at all): **at most a 🟢** for the missing CHANGELOG
  entry — per the rubric's golden row, this is **never 🟡** ("Non-behavioral
  convention; no trigger→mechanism→consequence").
- Zero 🔴/🟡 findings expected overall.
