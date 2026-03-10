---
name: nexus-refactor
description: >
  Refactor code using Nexus multi-agent orchestration. Maps dependencies,
  plans safe ordering, executes with behavior preservation, validates via
  tests and two-stage review. Use for: restructuring, renaming, extracting,
  "refactor this", or any code reorganization without behavior change.
---

# Nexus Refactor — Refactoring Pipeline

Orchestrate as Nexus Supervisor. Delegate to subagents — never implement yourself.
**Constraint:** Behavior MUST be identical before and after.

**Session Memory:** Read `.nexus/memory.md` before research. Write memory entry after report. See `nexus` skill for format.

## Phase 1: RESEARCH (Parallel)

- 3-5 Scouts: map all affected files, call sites, imports, dependencies
- 1 Analyst: impact analysis, risks, safe ordering
- Synthesize dependency map + risk assessment

## Phase 2: PLAN

- Planner: step-by-step refactor plan preserving all behavior, ordered to minimize breakage

## Phase 3: EXECUTE

- Builder: execute plan, run tests after each step, TDD for any new code
- Route: DONE → Phase 4 | DONE_WITH_CONCERNS → log, continue | NEEDS_CONTEXT → Scout → retry | BLOCKED → report with context

## Phase 4: VALIDATE (Two-Stage)

1. **(Parallel)** Tester full suite + coverage delta | Reviewer SPEC REVIEW (behavior preserved?)
2. **(Sequential)** Reviewer QUALITY REVIEW — refactor achieves goal and improves quality

Report: objective, status, steps completed, behavior preserved (yes/no), files modified, test results, coverage delta, review verdict.
