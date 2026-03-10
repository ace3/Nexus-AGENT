# Nexus Protocols

## Contents

- [Status Protocol](#status-protocol) | [Evidence Gates](#evidence-gates) | [Debug Protocol](#debug-protocol) | [Self-Review](#self-review) | [Task Sizing](#task-sizing)

---

## Status Protocol

Every agent response begins with exactly one status code:

| Status | Meaning | Action |
|--------|---------|--------|
| `DONE` | Complete | Next phase |
| `DONE_WITH_CONCERNS` | Complete, flagging issues | Log concerns, continue |
| `NEEDS_CONTEXT` | Missing info | Scout → re-dispatch |
| `BLOCKED` | Cannot proceed | Alternative approach; user escalation last resort |

**Restrictions:** Scout → DONE/NEEDS_CONTEXT only. Reviewer → DONE=APPROVED / DONE_WITH_CONCERNS=NEEDS_REVISION / BLOCKED=FAILED.

---

## Evidence Gates

**Iron Law: Evidence Over Claims.** Re-dispatch any agent missing required evidence.

| Agent | Required Evidence |
|-------|-------------------|
| Builder | Actual test + lint output |
| Tester | Test runner output with pass/fail + coverage |
| Reviewer | `file:line` references for all claims |
| Analyst | `file:line` references for architectural claims |

---

## Debug Protocol

Builder max 3 cycles. Per cycle:
1. **INVESTIGATE** — Full error + stack trace, exact line
2. **PATTERN MATCH** — Error type (import, type, assertion, runtime)
3. **HYPOTHESIZE** — One hypothesis, smallest test change
4. **FIX & VERIFY** — Minimal fix, run failing test, then full suite

After 3 failures → BLOCKED with: what tried, what observed, best hypothesis.

---

## Self-Review

Agents verify own work before reporting. If any check fails → redo.

- **Builder:** Test matches requirement? Edge cases? Actually ran tests? No TODOs?
- **Analyst:** Actually read files? Codebase-specific? Missed integration points?
- **Tester:** Tests executed? Numbers match output? Full suite?

---

## Task Sizing

- 2-5 min per agent task, 1 feature/function per Builder
- Max 10 parallel agents per phase, sequential for dependent tasks
- Break oversized tasks into subtasks before dispatching
