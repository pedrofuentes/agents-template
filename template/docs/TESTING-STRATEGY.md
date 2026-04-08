# Testing Strategy

> Extended testing context for AI agents. Referenced from AGENTS.md.
> **The TDD mandate (tests before implementation) is enforced in AGENTS.md and verified by Sentinel.**
> This document covers the details of HOW to test.

---

## Test Types

| Type | Purpose | Location | Runner |
|------|---------|----------|--------|
| Unit | Core logic, pure functions, isolated components | `tests/unit/` or `*.test.ts` | {{Vitest/Jest/pytest}} |
| Integration | Cross-component interactions, API calls, DOM manipulation | `tests/integration/` | {{Vitest/Jest/pytest}} |
| E2E | Critical user flows end-to-end | `tests/e2e/` | {{Playwright/Cypress}} |

## Coverage Requirements

- **New code**: {{COVERAGE_THRESHOLD}}% diff coverage required (lines added/modified in the PR)
- **Project-wide coverage**: must never decrease from the previous merge baseline
- **Critical paths**: 100% coverage required (auth, payments, data mutations)
- **Run coverage**: `{{PACKAGE_MANAGER}} test --coverage`
- **Sentinel verifies coverage thresholds on every PR**

## Test-Only PRs

PRs that only add tests to existing (untested) code use commit type `test(scope)` and are exempt from test-first choreography ordering (there is no `feat`/`fix` to follow). Sentinel verifies the tests are meaningful and pass.

## Testing Patterns

### Mocking
{{Describe your mocking strategy — e.g., dependency injection, test doubles, mock libraries}}

```typescript
// Example: How to mock in this project
{{your mocking example}}
```

### Test Naming Convention
```
describe('{{ModuleName}}', () => {
  it('should {{expected behavior}} when {{condition}}', () => {
    // Arrange → Act → Assert
  });
});
```

### What Must Be Tested
- All public API functions
- Error paths and edge cases (not just happy paths)
- State transitions
- Input validation and boundary conditions

### What Should NOT Be Tested
- Framework internals
- Third-party library behavior
- Implementation details (test behavior, not structure)

## CI Integration

- Tests run automatically on every PR via {{CI system}}
- All tests must pass before Sentinel review begins
- Flaky tests must be fixed immediately, not skipped
