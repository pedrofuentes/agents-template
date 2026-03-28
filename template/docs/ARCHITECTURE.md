# Architecture

> Extended architectural context for AI agents. Referenced from AGENTS.md.

---

## Project Structure

{{Replace with your actual project structure}}

```
{{PROJECT_NAME}}/
├── packages/
│   ├── core/                    ← Shared core library
│   │   ├── src/
│   │   └── tests/
│   ├── {{package-1}}/           ← {{description}}
│   │   ├── src/
│   │   └── tests/
│   └── {{package-2}}/           ← {{description}}
│       ├── src/
│       └── tests/
├── docs/                        ← Associated documentation
├── AGENTS.md                    ← Agent instructions (MUST rules)
├── ROADMAP.md                   ← Project phases and plan
├── LICENSE
├── README.md
└── package.json                 ← Monorepo root
```

## Key Technical Decisions

{{Document the rationale behind major technical choices}}

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Monorepo strategy | {{pnpm workspaces}} | {{shared code between packages}} |
| {{Decision 2}} | {{Choice}} | {{Why}} |
| {{Decision 3}} | {{Choice}} | {{Why}} |

## Module Boundaries

{{Describe how packages/modules relate to each other}}

- `core/` — Shared logic, no dependencies on other packages
- `{{package-1}}/` — Depends on `core/`, provides {{what}}
- `{{package-2}}/` — Depends on `core/`, provides {{what}}

## Data Flow

{{Describe how data moves through the system if relevant}}

## Key Files

{{List files that agents should know about for orientation}}

| File | Purpose |
|------|---------|
| `{{path}}` | {{description}} |
| `{{path}}` | {{description}} |
