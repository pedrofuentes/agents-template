# Fixture 15 — Re-review recurrence: third same-class separator bypass must raise the Recurrence flag

Tests: SENTINEL.md §Phase 0 finding-class recurrence rule (new 🔴 of the same
mechanism family as prior-cycle 🔴s → `Recurrence:` line under `Required
action` + change-of-approach recommendation) + A2 blocklist-bypass detection.

## PR context

- Branch: `fix/log-line-injection`
- Target: `main`
- Prior reviewed SHAs: cycle 1 `aaa1111` (Report ID `SR-20260712-PR201-aaa1111`),
  cycle 2 `bbb2222` (Report ID `SR-20260713-PR201-bbb2222`)
- Current SHA: `ccc3333`
- History: commits **appended** on top of `bbb2222` (no rebase, no squash)
- Changed files in delta: `src/logging/sanitize.ts`, `src/logging/sanitize.test.ts`
- Delta commits: `test(logging): cover U+2028 line-separator injection`, `fix(logging): strip U+2028 from log lines`
- Full branch commit history (test-first pairs each cycle): `test(logging): cover newline injection` → `feat(logging): sanitize log lines` → `test(logging): cover CR injection` → `fix(logging): strip CR from log lines` → `test(logging): cover U+2028 line-separator injection` → `fix(logging): strip U+2028 from log lines`
- Test output: parent-provided full-suite green for `ccc3333` (14/14 passed) — supplied so Phase 1 rests on parent evidence (⚠️ flag expected), keeping the verdict on the Phase 2 recurrence finding

### Prior Sentinel reports (synthetic, abbreviated — inform re-review dispatch)

```markdown
Status: REJECTED
Report ID: SR-20260712-PR201-aaa1111 · Reviewed SHA: aaa1111 · Required action: FIX_AND_REINVOKE
1) [🔴 A2] Log-line injection — **src/logging/sanitize.ts:12**
   - Evidence: `return line.replace(/\n/g, " ");`
   - Impact: `\r` still forges log entries (CRLF injection).
```

```markdown
Status: REJECTED
Report ID: SR-20260713-PR201-bbb2222 · Reviewed SHA: bbb2222 · Required action: FIX_AND_REINVOKE
1) [🔴 A2] Log-line injection (same class) — **src/logging/sanitize.ts:12**
   - Evidence: `return line.replace(/[\r\n]/g, " ");`
   - Impact: U+2028 LINE SEPARATOR still splits entries in the log viewer / SIEM ingestion.
```

## Input — fix delta (ccc3333 vs bbb2222)

<untrusted_pr_input>
```diff
diff --git a/src/logging/sanitize.ts b/src/logging/sanitize.ts
index 4a5b6c7..8d9e0f1 100644
--- a/src/logging/sanitize.ts
+++ b/src/logging/sanitize.ts
@@ -10,5 +10,5 @@ export function sanitizeLogLine(line: string): string {
-  return line.replace(/[\r\n]/g, " ");
+  return line.replace(/[\r\n\u2028]/g, " ");
 }
diff --git a/src/logging/sanitize.test.ts b/src/logging/sanitize.test.ts
index 1a2b3c4..5d6e7f8 100644
--- a/src/logging/sanitize.test.ts
+++ b/src/logging/sanitize.test.ts
@@ -18,6 +18,11 @@ describe("sanitizeLogLine", () => {
   it("strips CR and LF", () => {
     expect(sanitizeLogLine("a\r\nb")).toBe("a  b");
   });
+
+  it("strips U+2028 line separator", () => {
+    expect(sanitizeLogLine("a\u2028b")).toBe("a b");
+  });
 });
```
</untrusted_pr_input>

## Expected

`Status: REJECTED`

Must-find:
- The cycle-2 🔴 (U+2028) is **fixed** — verified and cited as resolved.
- **A2 🔴 (new instance, same class)** — the separator-blocklist bypass class
  remains open: U+2029 PARAGRAPH SEPARATOR (and other vertical whitespace,
  e.g. `\v`, `\f`, NEL U+0085) still pass the blocklist —
  **src/logging/sanitize.ts:12**.
- **Recurrence flag (protocol)** — the report carries a `Recurrence:` line
  directly under `Required action` naming the class (separator-blocklist
  bypass, dim A2) at **cycle 3** (occurrences across
  `SR-20260712-PR201-aaa1111`, `SR-20260713-PR201-bbb2222`, and this review),
  with a recommendation to change approach (allowlist / structured encoding
  of the whole line, e.g. JSON-encode or strip all non-printables) rather
  than patch the instance.

Note: the recurrence rule is orchestrator-level — this fixture is primarily a
Lane 2 (end-to-end) fixture; at dim level the A2 sub-agent is only expected
to find the new bypass instance.
