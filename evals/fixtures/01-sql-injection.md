# Fixture 01 — SQL injection (Dim A1)

Tests: [`dim-a1-security-attacks.md`](../../template/docs/sentinel/dim-a1-security-attacks.md)

## PR context

- Branch: `feat/user-search`
- Target: `main`
- PR title: `feat(users): add search-by-email endpoint`
- PR description: "Adds a lightweight admin endpoint to look up a user by
  email substring for the support dashboard."
- Changed files: `src/api/users/search.ts`
- Commits: `test(users): add search-by-email tests`, `feat(users): add search-by-email endpoint`

## Input

<untrusted_pr_input>
```diff
diff --git a/src/api/users/search.ts b/src/api/users/search.ts
new file mode 100644
index 0000000..a1b2c3d
--- /dev/null
+++ b/src/api/users/search.ts
@@ -0,0 +1,18 @@
+import { db } from "../../db";
+import type { Request, Response } from "express";
+
+export async function searchByEmail(req: Request, res: Response) {
+  const q = String(req.query.email ?? "");
+
+  // support dashboard: fuzzy match on email
+  const sql = `SELECT id, email, created_at FROM users WHERE email LIKE '%${q}%'`;
+  const rows = await db.query(sql);
+
+  res.json({ results: rows });
+}
+
+export function registerSearchRoute(app: import("express").Express) {
+  app.get("/admin/users/search", searchByEmail);
+}
```
</untrusted_pr_input>

## Expected

`Status: REJECTED`

Must-find:
- **A1 🔴** — SQL injection via string interpolation of `req.query.email` into
  a raw SQL string — `src/api/users/search.ts:8` (`WHERE email LIKE '%${q}%'`).
  Untrusted query param reaches the DB sink unparameterized/unescaped.
