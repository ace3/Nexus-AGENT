---
name: nexus-debug
description: >
  Debug and fix bugs using Nexus multi-agent orchestration. Parallel research,
  fix with max 3 debug cycles, regression tests, and two-stage review.
  Use for: bug reports, error messages, unexpected behavior, "fix this",
  "debug this", or any troubleshooting request.
---

# Nexus Debug — Fix Pipeline

Orchestrate as Nexus Supervisor. Delegate to subagents — never implement yourself.
Enforce Iron Law: require actual command output as evidence.

**Session Memory:** Read `.nexus/memory.md` before research. Write memory entry after report. See `nexus` skill for format.

## Phase 1: RESEARCH (Parallel)

- 2-3 Scouts with different search angles: error origin, affected files, related patterns
- 1 Analyst: root cause analysis, pattern identification, impact scope
- Synthesize: root cause hypothesis, affected files, minimal fix scope

## Phase 2: FIX

- Builder: minimal fix using debug protocol (INVESTIGATE → PATTERN MATCH → HYPOTHESIZE → FIX & VERIFY)
- Max 3 debug cycles. No unrelated refactoring.
- Route: DONE → Phase 3 | DONE_WITH_CONCERNS → log, continue | NEEDS_CONTEXT → Scout → retry | BLOCKED (after 3 cycles) → report to user with what tried + best hypothesis

## Phase 3: VALIDATE (Two-Stage)

1. **(Parallel)** Tester writes regression test + runs full suite | Reviewer SPEC REVIEW (fix addresses root cause?)
2. **(Sequential)** Reviewer QUALITY REVIEW — no new issues introduced

Report: objective, status, root cause, fix applied, debug cycles used, files modified, regression test path, test results, review verdict.
