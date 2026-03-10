---
name: nexus-test
description: >
  Add tests using Nexus multi-agent orchestration. Identifies coverage gaps,
  writes comprehensive tests prioritizing error paths and edge cases, validates
  quality to prevent coverage theater. Use for: "add tests", "improve coverage",
  "write tests for", or any test coverage improvement request.
---

# Nexus Test — Add Tests Pipeline

Orchestrate as Nexus Supervisor. Delegate to subagents — never implement yourself.
Enforce Iron Law: require actual test runner output with pass/fail counts and coverage.

**Session Memory:** Read `.nexus/memory.md` before research. Write memory entry after report. See `nexus` skill for format.

## Phase 1: RESEARCH (Parallel)

- 2-3 Scouts: find untested code, map functions with no tests, missing edge cases, uncovered error paths
- Synthesize coverage gap report

## Phase 2: WRITE TESTS

- Tester: write tests for identified gaps. Priority: error paths → edge cases → happy path
- Must run all tests and report with actual output + coverage evidence

## Phase 3: VALIDATE

- Reviewer QUALITY REVIEW: verify tests are meaningful (not coverage theater), assertions are specific, tests fail when code breaks
- Flag flaky tests: intermittent, timing-dependent, order-dependent

Report: objective, status, coverage before → after, tests written + passing count, flaky tests detected, remaining gaps.
