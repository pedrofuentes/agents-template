# Fixture 14 — Hand-rolled HTML sanitizer with a bypassable blocklist (Dim A2)

Tests: [`dim-a2-security-defenses.md`](../../template/docs/sentinel/dim-a2-security-defenses.md)
— bypass-class completeness rule + differential probe rule's static half (no
execution available in this harness → finding stands, flagged
`(unverified — no execution)`).

## PR context

- Branch: `feat/comment-preview`
- Target: `main`
- PR title: `feat(comments): render rich-text comment previews`
- PR description: "Lets moderators preview user comments with basic
  formatting. Scripts are stripped server-side before rendering."
- Changed files: `src/comments/sanitize.ts`, `src/comments/preview.ts`
- Commits: `test(comments): add sanitizer tests`, `feat(comments): render sanitized comment previews`

## Input

<untrusted_pr_input>
```diff
diff --git a/src/comments/sanitize.ts b/src/comments/sanitize.ts
new file mode 100644
index 0000000..d4e5f6a
--- /dev/null
+++ b/src/comments/sanitize.ts
@@ -0,0 +1,10 @@
+// Strip scripts and inline handlers so comment HTML is safe to render.
+export function sanitizeHtml(input: string): string {
+  let out = input.replace(/<script[^>]*>[\s\S]*?<\/script>/gi, "");
+  out = out.replace(/on\w+\s*=\s*"[^"]*"/gi, "");
+  return out;
+}
diff --git a/src/comments/preview.ts b/src/comments/preview.ts
new file mode 100644
index 0000000..b7c8d9e
--- /dev/null
+++ b/src/comments/preview.ts
@@ -0,0 +1,9 @@
+import type { Request, Response } from "express";
+import { sanitizeHtml } from "./sanitize";
+
+export function previewComment(req: Request, res: Response) {
+  const body = String(req.body.comment ?? "");
+  res.send(`<div class="comment-preview">${sanitizeHtml(body)}</div>`);
+}
```
</untrusted_pr_input>

## Expected

`Status: REJECTED`

Must-find:
- **A2 🔴** — hand-rolled regex-blocklist sanitizer is bypassable; untrusted
  `req.body.comment` reaches an HTML response through it —
  `src/comments/sanitize.ts:3-5` (`input.replace(/<script[^>]*>[\s\S]*?<\/script>/gi, "")`)
  rendered by `src/comments/preview.ts:6-7`. The finding must enumerate the
  bypass class, not just one variant — e.g.: event handlers with single or no
  quotes (`<img src=x onerror=alert(1)>` — the handler regex only matches
  double-quoted values), non-`<script>` script-execution vectors
  (`<svg onload=…>`, `<iframe srcdoc=…>`, `<a href="javascript:…">`), nested
  single-pass splice (`<scr<script>ipt>…` reassembles to `<script>` after one
  removal pass), and unclosed `<script` tags the paired regex never matches.
  In this harness no command execution is available, so the empirical
  differential probe cannot run — the static finding stands, flagged
  `(unverified — no execution)`; the probe's absence never excuses omitting it.

Note: An acceptable review may also recommend replacing the blocklist with an
allowlist sanitizer library or context-appropriate output encoding; the
fixture passes on the A2 🔴 with class-level enumeration regardless of the
specific remediation proposed.
