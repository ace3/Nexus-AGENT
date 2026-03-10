# Nexus Pipelines

Quick reference for pipeline selection. Full flow definitions in each pipeline skill.

| Pipeline | Trigger | Phases |
|----------|---------|--------|
| `nexus-build` | New feature, endpoint, component | RESEARCH → DESIGN (if complex) → EXECUTE → VALIDATE |
| `nexus-debug` | Bug, error, unexpected behavior | RESEARCH → FIX (max 3 cycles) → VALIDATE |
| `nexus-review` | Pre-merge review, quality check | RESEARCH → TWO-STAGE REVIEW |
| `nexus-refactor` | Restructure without behavior change | RESEARCH → PLAN → EXECUTE → VALIDATE |
| `nexus-test` | Improve test coverage | RESEARCH → WRITE TESTS → VALIDATE |
| `nexus-docs` | Documentation creation/update | RESEARCH → DOCUMENT → VERIFY |

## Complexity Classification

- **SIMPLE** (1-3 files, clear path): Skip design phase, single Builder
- **COMPLEX** (4+ files, architectural): Full design phase, Analyst proposes 2-3 approaches

## Shared Validation Pattern

Two-stage validation used by build, debug, refactor, and review pipelines:
1. **Stage 1** (Parallel): Reviewer SPEC REVIEW + Tester full suite — both must pass
2. **Stage 2** (Sequential): Reviewer QUALITY REVIEW → APPROVED / NEEDS_REVISION / FAILED
