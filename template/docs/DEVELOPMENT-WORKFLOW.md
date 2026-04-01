# Development Workflow

> Extended workflow context for AI agents. Referenced from AGENTS.md.
> **The MUST rules (TDD, branching, worktrees, incremental development, Sentinel) are enforced in AGENTS.md.**
> This document covers the detailed HOW.

---

## Git Worktrees for Isolation

Every increment MUST use a git worktree for isolation:

```bash
# Create a worktree for a specific feature
git worktree add .worktrees/feature-name feature/feature-name

# List active worktrees
git worktree list

# Remove a worktree when done (after merge)
git worktree remove .worktrees/feature-name
```

### Why Worktrees Are Required
- Prevents interference between parallel work
- Each agent/increment has a clean working directory
- No risk of uncommitted changes from one task affecting another
- Easy cleanup after merge

## Branching Details

### Branch Lifecycle
1. Create worktree + branch from `main`: `git worktree add .worktrees/name feature/name`
2. TDD: write failing tests, implement, refactor
3. Commit following the format in AGENTS.md
4. Push and open a Pull Request
5. Invoke Sentinel for review
6. Address any Sentinel feedback, re-submit
7. On Sentinel approval, merge to `main`
8. Delete the feature branch and remove worktree

### Branch Naming Convention
| Prefix | Use For |
|--------|---------|
| `feature/` | New features |
| `fix/` | Bug fixes |
| `refactor/` | Code refactoring |
| `docs/` | Documentation changes |
| `test/` | Test additions or fixes |
| `chore/` | Build, CI, dependency updates |

## Pull Request Process

### Before Opening a PR
1. All tests pass in the worktree
2. Linting passes
3. Commit messages follow the format
4. PR represents a single logical unit

### PR Title Format
`type(scope): Short description`

### Sentinel Review
→ See [`docs/SENTINEL.md`](./SENTINEL.md) for the full process and invocation methods.

### After Merge
- Delete the feature branch
- Remove the worktree
- Pull latest `main`
- Start next increment from the plan

## Sub-Agent Delegation

### When to Delegate
- Complex research that requires deep analysis
- Documentation generation
- Test data creation or fixture generation
- Performance profiling and optimization analysis
- Security vulnerability assessment

### How to Delegate
- Provide the sub-agent with full context (requirements, constraints, relevant code)
- Each sub-agent works in its own context
- Integrate sub-agent output back into the main work
- All sub-agent output must follow AGENTS.md rules

## Environment Setup

{{Add detailed setup instructions here — IDEs, extensions, environment variables, etc.}}
