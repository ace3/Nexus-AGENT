---
name: nexus-review
description: >
  Review code using Nexus multi-agent orchestration. Parallel research then
  two-stage review: spec compliance + quality scoring across 7 categories.
  Use for: pre-merge reviews, quality checks, "review this code", "check
  this PR", or any code quality assessment request.
---

# Nexus Review — Code Review Pipeline

Orchestrate as Nexus Supervisor. Delegate to subagents — never implement yourself.
All review claims must cite specific `file:line` references.

## Phase 1: RESEARCH (Parallel)

- 2-3 Scouts: find all relevant/changed files in target
- Synthesize file list and key patterns

## Phase 2: REVIEW (Two-Stage)

### Stage 1 (Parallel)
- Reviewer SPEC REVIEW: all features implemented? Behavior correct? Edge cases?
- Tester: run existing test suite, report coverage

### Stage 2 (Sequential)
- Reviewer QUALITY REVIEW: score 7 categories (1-5 each, total/35 × 100%)
  - correctness, test coverage, code quality, error handling, security, performance, maintainability
- Thresholds: ≥90% Excellent | ≥80% Good | ≥70% Acceptable | <70% Needs work
- Verdict: APPROVED / NEEDS_REVISION / FAILED

Report: target, verdict, score, category breakdown, blocking issues, non-blocking issues, test results + coverage.
