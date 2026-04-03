# Changelog

All notable changes to this project will be documented in this file.
Format based on [Keep a Changelog](https://keepachangelog.com/). Follows [Semantic Versioning](https://semver.org/).

## [0.2.0] - 2026-04-03

### Added
- AGENTS.md compressed to 119 non-blank lines (65% reduction from v0.1.0)
- SENTINEL.md compressed to 121 non-blank lines (60% reduction)
- Documentation review dimension (F) in Sentinel verification
- Pre-merge checklist gate — agents must print checklist before every merge
- Testing branch workflow — auto-create test/ branch during testing phases
- Quality ratchet patterns: compounding violations, never-decrease rule, enforcement ladder (L1-L5)
- TDD commit choreography with exemptions (docs, chore, build, ci, refactor, style)
- Mode-aware approval gate (interactive: wait, autopilot: proceed with Sentinel)
- Identity framing and STOP checkpoint verbs for higher agent compliance
- LEARNINGS.md, DECISIONS.md, CHANGELOG.md as companion files
- AGENTS.md and SENTINEL.md immutability rules
- Anti-prompt-injection clause in Sentinel
- Auto-configuration setup block (new project + migration paths)
- GitHub issues for all Sentinel findings (sentinel:important, sentinel:minor labels)
- Update prompt for upgrading between template versions
- Semver versioning

### Changed
- Sentinel consolidated from 9 to 4 review agents
- Sentinel invocation via independent sub-agent model (not self-review)
- Boundaries expanded to 4 tiers (ALWAYS / ASK FIRST / HUMAN REQUIRED / NEVER)
- Worktrees now in .worktrees/ directory (gitignored), mandatory cleanup after merge
- Max 3 Sentinel cycles per PR, then escalate to human
- README restructured with one-prompt setup (agent fetches from GitHub)

## [0.1.0] - 2026-03-28

### Added
- Initial AGENTS.md template with TDD, Sentinel quality gate, autonomous workflow
- Companion docs: SENTINEL.md, ARCHITECTURE.md, TESTING-STRATEGY.md, DEVELOPMENT-WORKFLOW.md
- SETUP.md placeholder inventory
- ROADMAP.md template
- MIGRATION-GUIDE.md
- MIT License
