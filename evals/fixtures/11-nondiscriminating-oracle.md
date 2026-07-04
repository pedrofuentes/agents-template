# Fixture 11 — Non-discriminating persistence oracle (Dim D + rubric calibration)

Tests: [`dim-d-testing.md`](../../template/docs/sentinel/dim-d-testing.md) and
[`SEVERITY-RUBRIC.md`](../../template/docs/sentinel/SEVERITY-RUBRIC.md) golden
row "Test asserts an outcome but uses no concrete-value oracle
(non-discriminating)" → 🟡.

## PR context

- Branch: `feat/cli-doc-indexing`
- Target: `main`
- PR title: `feat(cli): add local document indexing command`
- PR description: "Adds an `index` command that scans doc paths, hashes their
  content, and stores new/changed docs; unchanged docs are skipped on a
  re-run so re-indexing stays fast."
- Changed files: `src/cli/indexDocuments.ts`, `src/cli/indexDocuments.test.ts`
- Commits: `test(cli): add document indexing tests`, `feat(cli): add document indexing command`

## Input

<untrusted_pr_input>
```diff
diff --git a/src/cli/indexDocuments.ts b/src/cli/indexDocuments.ts
new file mode 100644
index 0000000..a1a1a1a
--- /dev/null
+++ b/src/cli/indexDocuments.ts
@@ -0,0 +1,42 @@
+import { createHash } from "node:crypto";
+import { readFile } from "node:fs/promises";
+import { store } from "./store";
+
+export interface IndexResult {
+  indexed: number;
+  unchanged: number;
+}
+
+function hashContent(content: string): string {
+  return createHash("sha256").update(content).digest("hex");
+}
+
+export async function indexDocuments(paths: string[]): Promise<IndexResult> {
+  let indexed = 0;
+  let unchanged = 0;
+
+  for (const path of paths) {
+    const content = await readFile(path, "utf8");
+    const hash = hashContent(content);
+    const existing = await store.getByPath(path);
+
+    if (!existing || existing.hash !== hash) {
+      await store.upsert({ path, hash, indexedAt: new Date().toISOString() });
+      indexed++;
+    } else {
+      unchanged++;
+    }
+  }
+
+  return { indexed, unchanged };
+}
+
+export function formatSummary(result: IndexResult): string {
+  const total = result.indexed + result.unchanged;
+  return `${total} document${total === 1 ? "" : "s"} indexed`;
+}
+
+export async function runIndexCommand(paths: string[]): Promise<string> {
+  const result = await indexDocuments(paths);
+  return formatSummary(result);
+}
diff --git a/src/cli/indexDocuments.test.ts b/src/cli/indexDocuments.test.ts
new file mode 100644
index 0000000..b2b2b2b
--- /dev/null
+++ b/src/cli/indexDocuments.test.ts
@@ -0,0 +1,21 @@
+import { indexDocuments, formatSummary, runIndexCommand } from "./indexDocuments";
+import { store } from "./store";
+
+describe("indexDocuments", () => {
+  beforeEach(() => store.reset());
+
+  it("indexes a new document and stores its content hash", async () => {
+    const result = await indexDocuments(["fixtures/readme.md"]);
+
+    expect(result).toEqual({ indexed: 1, unchanged: 0 });
+    const stored = await store.getByPath("fixtures/readme.md");
+    expect(stored?.hash).toBe("9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08");
+  });
+
+  it("still reports the document as indexed on a second run", async () => {
+    await runIndexCommand(["fixtures/readme.md"]);
+    const stdout = await runIndexCommand(["fixtures/readme.md"]);
+
+    expect(stdout).toContain("1 document indexed");
+  });
+});
```
</untrusted_pr_input>

## Expected

`Status: REJECTED`

Must-find:
- **D 🔴** — non-discriminating oracle that is the ONLY coverage of the
  changed behavior: the second test (`src/cli/indexDocuments.test.ts:19`,
  `expect(stdout).toContain("1 document indexed")`) asserts only the
  formatted total (`indexed + unchanged`), which is identical whether the
  second run correctly finds the document **unchanged** (real persistence:
  `{ indexed: 0, unchanged: 1 }`) or the document was silently **lost and
  re-indexed** (`{ indexed: 1, unchanged: 0 }`) — both format to
  `"1 document indexed"`. The assertion cannot fail even if the PR's
  headline behavior ("unchanged docs are skipped on a re-run") is deleted
  entirely, and no other test exercises the second-run path — dim-d's
  escalation applies ("🔴 gaming when it is the only coverage for the
  changed behavior").
  - Required hardening: assert the structured `IndexResult` directly
    (`{ indexed: 0, unchanged: 1 }`) or row identity across runs (stable
    `indexedAt`/`id`) instead of the collapsed summary string.

Severity boundary (calibration note): the core indexing behavior IS
concretely covered (`src/cli/indexDocuments.test.ts:7-12` asserts the exact
`IndexResult` and stored hash), so this fixture pins the per-behavior
reading — skip-on-rerun is a distinct changed behavior whose only test
cannot fail. Had the diff also included a concrete second-run test, the
weak stdout assertion would calibrate to the rubric golden row "no
concrete-value oracle" → 🟡 (harden it), not 🔴. A run reporting the
must-find at 🟡 instead of 🔴 indicates the escalation clause is not
biting — that is a FAIL.

Note: The dim-d discrimination probe (mutation verification) is
execution-dependent and cannot run in this static harness; this fixture
calibrates the static half — recognizing from the diff alone that the
oracle cannot discriminate.
