# Migration Guide: Old AGENTS.md → v4 Autonomous Agent Operating System

This document maps sections from a typical pre-template AGENTS.md to their new locations in the two-tier system, and documents all new content added.

---

## What Changed (v1 → v4)

| Aspect | v1 (Original) | v4 (New) |
|--------|---------------|----------|
| TDD enforcement | Single rule in AGENTS.md | **Defense in depth**: Layer 1 (AGENTS.md rule) + Layer 2 (Sentinel verification) |
| Review process | 9 agents inline in AGENTS.md (135 lines) | **Sentinel** orchestrates 9 agents, defined in `docs/SENTINEL.md` |
| Merge authority | Implicit (user approves) | **Sentinel has sole authority** — no merge/deploy/release without approval |
| Autonomy model | Not defined | **Plan → Approve → Execute** — autonomous after plan approval |
| Work sizing | "Small PRs" (vague) | **1 PR = 1 logical unit** (one function/component/bugfix) |
| Git worktrees | Optional tutorial | **MUST use** for every increment |
| Sub-agents | Not mentioned | **MUST delegate** for specialized tasks |
| Boundaries | None | **Four-tier**: ALWAYS / ASK FIRST / HUMAN REQUIRED / NEVER with categories |
| Prompt engineering | Not optimized | **Identity framing**, STOP verbs, 3 invariants, checkpoint anchors |
| Review agents | 9 agents inline | **4 consolidated agents** in SENTINEL.md |
| TDD exemptions | All commits need TDD | **docs/chore/refactor/build/ci exempt** |
| Commands | None | **File-scoped + full suite** commands |
| Code examples | None | **✅/❌ code snippets** |

## Line-by-Line Mapping

| Old Section | Old Lines | New Location | Action |
|-------------|-----------|--------------|--------|
| Title + intro | 1-5 | `AGENTS.md` header | **Compressed** + added Sentinel compliance note |
| Project Overview | 7-16 | `AGENTS.md` §Project Overview | **Compressed** — 4 lines |
| TDD Requirement | 20-35 | `AGENTS.md` §TDD + `docs/TESTING-STRATEGY.md` | **Enhanced** — dual-layer enforcement |
| Incremental Development | 38-44 | `AGENTS.md` §Incremental Development | **Compressed** + defined "1 logical unit" |
| GitHub Flow Branching | 47-63 | `AGENTS.md` §Branching + `docs/DEVELOPMENT-WORKFLOW.md` | **Split** — rule stays, tutorial moves |
| Git Worktrees tutorial | 66-82 | `docs/DEVELOPMENT-WORKFLOW.md` | **Moved** + made REQUIRED (not optional) |
| Commit Message Format | 86-97 | `AGENTS.md` §Commit Format | **Kept** — already concise |
| Pre-Merge Review intro | 100-106 | `AGENTS.md` §Sentinel | **Replaced** — now Sentinel mandatory pointer |
| 9 Review Sub-Agents | 108-217 | `docs/SENTINEL.md` §Review Agent Definitions | **Moved** — orchestrated by Sentinel |
| Review Workflow diagram | 219-235 | `docs/SENTINEL.md` §Verification Process | **Replaced** — Sentinel 4-phase process |
| Code Style & Standards | 239-248 | `AGENTS.md` §Code Style | **Enhanced** — added ✅/❌ examples |
| Project Structure tree | 250-278 | `docs/ARCHITECTURE.md` | **Moved** — agents discover structure |
| Key Technical Decisions | 282-289 | `docs/ARCHITECTURE.md` | **Moved** — architectural docs |

## What Was ADDED (not in original)

| New Section | Location | Why Critical |
|-------------|----------|-------------|
| **Autonomous Workflow** | `AGENTS.md` §Autonomous Workflow | Defines plan→approve→execute loop for autonomy |
| **TDD Layer 2 (Sentinel)** | `AGENTS.md` §TDD + `docs/SENTINEL.md` | Defense in depth — Sentinel catches TDD violations |
| **Sentinel quality gate** | `AGENTS.md` §Sentinel + `docs/SENTINEL.md` | Sole authority for merge/deploy/release |
| **Sentinel report format** | `docs/SENTINEL.md` §Report Format | Structured output for consistent review communication |
| **Priority system** | `docs/SENTINEL.md` §Prioritization | 🔴/🟡/🟢 classification of findings |
| **Deploy/release gating** | `docs/SENTINEL.md` §Deploy & Release | Sentinel gates not just merges but deploys/releases |
| **Setup commands** | `AGENTS.md` §Commands | #1 most impactful section per research |
| **File-scoped commands** | `AGENTS.md` §Commands | Faster feedback loops |
| **Boundaries** | `AGENTS.md` §Boundaries | ALWAYS/ASK FIRST/HUMAN REQUIRED/NEVER four-tier system |
| **Code style examples** | `AGENTS.md` §Code Style | ✅/❌ code snippets |
| **Sub-agent delegation** | `AGENTS.md` §Sub-Agent Delegation | When and how to delegate |
| **Increment sizing rule** | `AGENTS.md` §Incremental Development | 1 PR = 1 logical unit |

## Size Comparison

| Metric | Old AGENTS.md | New AGENTS.md | Change |
|--------|---------------|---------------|--------|
| Total lines | 289 | 174 | **40% reduction** |
| Review panel lines in AGENTS.md | 135 (47%) | 7 (Sentinel pointer) | **95% reduction** |
| Core areas covered | 4 of 6 | **6 of 6** | Complete |
| Enforcement layers | 1 (rules only) | **2 (rules + Sentinel)** | Defense in depth |
| Autonomy model | undefined | **Fully defined** | Plan→Execute→Sentinel |

## Complete File Inventory

| File | Lines | Purpose |
|------|-------|---------|
| `README.md` | ~60 | Project overview, quick-start, customization guide |
| `AGENTS.md` | ~210 | MUST rules — the agent's operating system |
| `docs/SENTINEL.md` | ~280 | Sentinel spec — verification, 4 review agents, priority, reports |
| `docs/ARCHITECTURE.md` | ~50 | Project structure, technical decisions |
| `docs/TESTING-STRATEGY.md` | ~85 | Test types, coverage, patterns, TDD verification details |
| `docs/DEVELOPMENT-WORKFLOW.md` | ~58 | Worktrees, branching, PR process, sub-agent delegation |
| `MIGRATION-GUIDE.md` | this file | Migration mapping, what changed, what was added |
