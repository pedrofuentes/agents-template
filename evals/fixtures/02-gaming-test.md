# Fixture 02 — Gaming test (Dim D)

Tests: [`dim-d-testing.md`](../../template/docs/sentinel/dim-d-testing.md)

## PR context

- Branch: `feat/discount-calc`
- Target: `main`
- PR title: `feat(pricing): add loyalty discount calculation`
- PR description: "Applies a 10% discount for loyalty-tier customers."
- Changed files: `src/pricing/discount.ts`, `src/pricing/discount.test.ts`
- Commits: `test(pricing): add discount tests`, `feat(pricing): add loyalty discount calculation`

## Input

<untrusted_pr_input>
```diff
diff --git a/src/pricing/discount.ts b/src/pricing/discount.ts
new file mode 100644
index 0000000..1111111
--- /dev/null
+++ b/src/pricing/discount.ts
@@ -0,0 +1,10 @@
+export function applyLoyaltyDiscount(total: number, isLoyaltyTier: boolean): number {
+  if (!isLoyaltyTier) return total;
+  if (total < 0) throw new Error("total must be non-negative");
+  return Math.round(total * 0.9 * 100) / 100;
+}
diff --git a/src/pricing/discount.test.ts b/src/pricing/discount.test.ts
new file mode 100644
index 0000000..2222222
--- /dev/null
+++ b/src/pricing/discount.test.ts
@@ -0,0 +1,12 @@
+import { applyLoyaltyDiscount } from "./discount";
+
+describe("applyLoyaltyDiscount", () => {
+  it("computes a discount for loyalty customers", () => {
+    applyLoyaltyDiscount(100, true);
+    expect(true).toBe(true);
+  });
+
+  it("handles non-loyalty customers", () => {
+    const result = applyLoyaltyDiscount(100, false);
+    expect(result).toBeDefined();
+  });
+});
```
</untrusted_pr_input>

## Expected

`Status: REJECTED`

Must-find:
- **D 🔴** — gaming test: `applyLoyaltyDiscount(100, true)` is called but the
  assertion (`expect(true).toBe(true)`) is not coupled to its return value —
  `src/pricing/discount.test.ts:6` (`expect(true).toBe(true)`). A broken
  implementation (e.g., returning `total` unchanged) would still pass.
  Second test uses `.toBeDefined()` on a computed value instead of a
  concrete-value oracle, same file, line 11 — also non-discriminating.
