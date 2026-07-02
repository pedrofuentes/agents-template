#!/usr/bin/env bash
# Automated repo checks — automates the manual rules in AGENTS.md
# (§Versioning, §Compression, §Testing Changes, §Template Files).
# Pure bash/grep/sed/awk; no dependencies. Run from the repo root.
set -u
cd "$(dirname "$0")/.."

FAIL=0
pass() { printf 'PASS  %s\n' "$1"; }
fail() { printf 'FAIL  %s\n' "$1"; FAIL=1; }

# ── 1. Version sync (AGENTS.md §Versioning) ─────────────────────────────────
V=$(grep -m1 -oE '^## \[[0-9]+\.[0-9]+\.[0-9]+\]' CHANGELOG.md | tr -d '#[] ')
if [ -z "$V" ]; then
  fail "version: could not read latest version from CHANGELOG.md"
else
  ok=1
  grep -q "version-${V}-blue" README.md || { fail "version: README badge is not ${V}"; ok=0; }
  grep -q "Current version: \*\*v${V}\*\*" README.md || { fail "version: README 'Current version' line is not v${V}"; ok=0; }
  [ "$(head -1 AGENTS.md)" = "<!-- agents-template v${V} -->" ] || { fail "version: AGENTS.md line-1 marker is not v${V}"; ok=0; }
  n=$(grep -c "agents-template v${V}" template/AGENTS.md) || true
  [ "$n" -eq 3 ] || { fail "version: template/AGENTS.md has ${n} occurrences of 'agents-template v${V}' (want 3: marker + 2 commit examples)"; ok=0; }
  n=$(grep -c "v${V}" docs/index.html) || true
  [ "$n" -ge 2 ] || { fail "version: docs/index.html has ${n} occurrences of v${V} (want >=2: hero badge + footer)"; ok=0; }
  [ "$ok" -eq 1 ] && pass "version: all surfaces at v${V}"
fi

# ── 2. Placeholder audit (AGENTS.md §Testing Changes / §Template Files) ─────
# Setup placeholders are {{ALL_CAPS}}; every one used in template/ must be in
# SETUP.md's inventory. GitHub Actions ${{ }} expressions ({{ github.* }}) and
# free-text scaffold placeholders in companion docs are out of scope.
ok=1
while IFS= read -r tok; do
  grep -qF "$tok" template/SETUP.md || { fail "placeholders: $tok used in template/ but missing from SETUP.md inventory"; ok=0; }
done < <(grep -rhoE '\{\{[A-Z0-9_]+\}\}' template/ --include='*.md' | sort -u)
# Reverse: every placeholder SETUP.md documents must still exist in template/.
while IFS= read -r tok; do
  case "$tok" in '{{ '*|'{{{'*) continue ;; esac
  grep -rqF --include='*.md' --exclude='SETUP.md' "$tok" template/ \
    || { fail "placeholders: $tok documented in SETUP.md but no longer used in template/"; ok=0; }
done < <(grep -oE '\{\{[^}]+\}\}' template/SETUP.md | sort -u)
# Runtime placeholders promised by SETUP.md §Verification must exist in SENTINEL.md.
for tok in '{{branch}}' '{{sha}}' '{{unique-id}}' '{{timestamp}}' '{{X}}' '{{N}}' '{{call}}' '{{variable}}' '{{id or N/A}}'; do
  grep -qF "$tok" template/docs/SENTINEL.md \
    || { fail "placeholders: runtime placeholder $tok listed in SETUP.md exception but absent from SENTINEL.md"; ok=0; }
done
[ "$ok" -eq 1 ] && pass "placeholders: setup inventory and runtime allowlist consistent"

# ── 3. Line budgets (AGENTS.md §Compression) ────────────────────────────────
n=$(sed '/^<!-- SETUP:BEGIN/,/^<!-- SETUP:END -->$/d' template/AGENTS.md | grep -c .)
if [ "$n" -le 135 ]; then pass "budget: template/AGENTS.md post-setup ${n}/135 non-blank lines"
else fail "budget: template/AGENTS.md post-setup ${n}/135 non-blank lines — over budget"; fi
n=$(grep -c . template/docs/SENTINEL.md)
if [ "$n" -le 178 ]; then pass "budget: SENTINEL.md ${n}/178 non-blank lines"
else fail "budget: SENTINEL.md ${n}/178 non-blank lines — over budget"; fi

# ── 4. Setup-block marker integrity ─────────────────────────────────────────
b=$(grep -n '^<!-- SETUP:BEGIN' template/AGENTS.md | cut -d: -f1)
e=$(grep -n '^<!-- SETUP:END -->$' template/AGENTS.md | cut -d: -f1)
if [ "$(echo "$b" | grep -c .)" -eq 1 ] && [ "$(echo "$e" | grep -c .)" -eq 1 ] && [ "$b" -lt "$e" ]; then
  pass "setup-block: exactly one BEGIN/END pair, in order (lines ${b}-${e})"
else
  fail "setup-block: markers damaged (BEGIN at '${b:-none}', END at '${e:-none}')"
fi

# ── 5. Cross-reference validity ─────────────────────────────────────────────
# 5a. Relative markdown links resolve (CHANGELOG excluded — historical prose).
ok=1
while IFS=: read -r src target; do
  case "$target" in http*|\#*|mailto*) continue ;; esac
  t="${target%%#*}"
  [ -e "$(dirname "$src")/$t" ] || { fail "xref: $src links to '$target' which does not exist"; ok=0; }
done < <(grep -rnoE '\]\([^)]+\)' README.md AGENTS.md template/ --include='*.md' \
         | sed -E 's/^([^:]+):[0-9]+:\]\(([^)]+)\)/\1:\2/')
# 5b. "<file>.md §Heading" references: target exists and heading words appear.
while IFS=: read -r src ref; do
  file="${ref%% §*}"; sect="${ref#*§}"
  t="$(dirname "$src")/$file"
  [ -e "$t" ] || t="template/$file"
  [ -e "$t" ] || t="template/docs/$file"
  if [ ! -e "$t" ]; then fail "xref: $src references '$file' which does not exist"; ok=0; continue; fi
  for w in $(echo "$sect" | grep -oE '[A-Za-z-]+' | head -2); do
    grep -qi "$w" "$t" || { fail "xref: $src references '$file §$sect' — '$w' not found in $t"; ok=0; }
  done
done < <(grep -rnoE '[A-Za-z0-9._/-]+\.md §[^),`."]+' README.md AGENTS.md template/ --include='*.md' \
         | sed -E 's/^([^:]+):[0-9]+:/\1:/')
[ "$ok" -eq 1 ] && pass "xref: all relative links and §-references resolve"

# ── 6. Structure tree matches the file layout (AGENTS.md §Testing Changes) ──
tree=$(awk '/^## Structure/{f=1} f&&/^```/{c++; next} c==1{print} c==2{exit}' AGENTS.md)
ok=1
while IFS= read -r name; do
  [ -n "$(find . -name "$name" -not -path './.git/*' -print -quit)" ] \
    || { fail "structure: tree lists '$name' but no such file exists"; ok=0; }
done < <(echo "$tree" | grep -oE '[A-Za-z0-9._-]+\.(md|html|yml|sh)' | sort -u)
while IFS= read -r f; do
  echo "$tree" | grep -qF "$(basename "$f")" \
    || { fail "structure: $f exists but is missing from the AGENTS.md Structure tree"; ok=0; }
done < <(find template -name '*.md')
[ "$ok" -eq 1 ] && pass "structure: tree and file layout agree"

# ── 7. Severity tripwire (deliberate 3-place duplication must stay in sync) ─
ok=1
for f in template/docs/SENTINEL.md template/docs/sentinel/SEVERITY-RUBRIC.md template/docs/sentinel/dim-*.md; do
  for e in 🔴 🟡 🟢; do
    grep -q "$e" "$f" || { fail "severity: $f is missing the $e level"; ok=0; }
  done
done
[ "$ok" -eq 1 ] && pass "severity: all three levels present in SENTINEL.md, SEVERITY-RUBRIC.md, and every dim-*.md"

echo
if [ "$FAIL" -eq 0 ]; then echo "All checks passed."; else echo "Some checks FAILED."; exit 1; fi
