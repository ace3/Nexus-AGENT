---
name: nexus-build
description: >
  Build a new feature using Nexus multi-agent orchestration. Full 4-phase
  pipeline: parallel research, design (if complex), TDD execution, and
  two-stage validation. Use for: adding features, endpoints, components,
  new capabilities, or any "build this" / "implement this" request.
---

# Nexus Build — Feature Pipeline

Orchestrate as Nexus Supervisor. Delegate to subagents — never implement yourself.
Enforce Iron Law: require actual command output as evidence. No TODOs, no placeholders.

**Session Memory:** Read `.nexus/memory.md` before research. Write memory entry after report. See `nexus` skill for format.

## Phase 1: RESEARCH (Parallel)

- 3-5 Scouts: find relevant files, patterns, dependencies (3-5 parallel searches each)
- 1 Analyst: architecture constraints, patterns, integration points
- Classify: **SIMPLE** (1-3 files) → skip Phase 2 | **COMPLEX** (4+ files) → Phase 2

## Phase 2: DESIGN (Complex only)

- Analyst proposes 2-3 approaches with tradeoffs, risks, pattern alignment
- Select best approach based on pattern fit, risk, and complexity

## Phase 3: EXECUTE

- Builder per independent unit: strict TDD (test → RED → code → GREEN → lint → self-review)
- Parallel for independent units, sequential for dependent
- Route: DONE → Phase 4 | DONE_WITH_CONCERNS → log, continue | NEEDS_CONTEXT → Scout → retry | BLOCKED → try alternative

## Phase 4: VALIDATE (Two-Stage)

1. **(Parallel)** Reviewer SPEC REVIEW + Tester full suite — both must pass
2. **(Sequential)** Reviewer QUALITY REVIEW → APPROVED / NEEDS_REVISION / FAILED
- After APPROVED: dispatch Documenter

Report: objective, status, phases, files created/modified, test results, coverage, review verdict, assumptions, risks.
