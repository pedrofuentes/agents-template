# Fixture 07 — Missing timeout, bounded background job (Dim B, severity calibration)

Tests: [`dim-b-resilience.md`](../../template/docs/sentinel/dim-b-resilience.md)
and [`SEVERITY-RUBRIC.md`](../../template/docs/sentinel/SEVERITY-RUBRIC.md)
golden row "Missing timeout on a non-critical, bounded background call" → 🟡.

## PR context

- Branch: `feat/nightly-avatar-sync`
- Target: `main`
- PR title: `feat(jobs): sync stale user avatars nightly`
- PR description: "Adds a nightly cron job (runs once, off the request path)
  that re-fetches up to 200 stale avatar URLs from the CDN and updates the
  cache table. Not user-facing; failures are retried on the next nightly run."
- Changed files: `src/jobs/syncAvatars.ts`
- Commits: `test(jobs): add avatar sync tests`, `feat(jobs): sync stale user avatars nightly`

## Input

<untrusted_pr_input>
```diff
diff --git a/src/jobs/syncAvatars.ts b/src/jobs/syncAvatars.ts
new file mode 100644
index 0000000..3c3c3c3
--- /dev/null
+++ b/src/jobs/syncAvatars.ts
@@ -0,0 +1,19 @@
+import { fetch } from "undici";
+import { db } from "../db";
+
+// Nightly cron (00:00 UTC), bounded to 200 rows, off the request path.
+// Safe to skip a night on failure; retried automatically on next run.
+export async function syncStaleAvatars(): Promise<void> {
+  const stale = await db.avatars.findStale({ limit: 200 });
+
+  for (const avatar of stale) {
+    try {
+      const res = await fetch(avatar.cdnUrl);
+      if (!res.ok) throw new Error(`CDN returned ${res.status}`);
+      const buf = await res.arrayBuffer();
+      await db.avatars.updateCache(avatar.userId, buf);
+    } catch (err) {
+      console.error(`avatar sync failed for user ${avatar.userId}`, err);
+    }
+  }
+}
```
</untrusted_pr_input>

## Expected

`Status: CONDITIONAL`

Must-find:
- **B 🟡** — missing timeout on `fetch(avatar.cdnUrl)` —
  `src/jobs/syncAvatars.ts:11`. Finding must articulate:
  - **trigger**: CDN request hangs or is slow for one of the 200 stale rows,
  - **mechanism**: no timeout on `fetch`, so the job stalls on that row,
  - **consequence**: nightly job runs long / that night's sync is delayed —
    bounded blast radius (once-nightly, non-request-critical, ≤200 rows,
    auto-retried next run).
  Matches the 🟡 golden row (not 🔴 — no request-path exhaustion, no
  cascading outage; bounded and self-healing).
- Zero 🔴 findings expected.

The `if (!res.ok) throw ...` guard on the fetch response is deliberate — it
forecloses the CDN-error-pages-cached-as-avatar-bytes defect so the only
intended finding in this fixture is the missing timeout.
