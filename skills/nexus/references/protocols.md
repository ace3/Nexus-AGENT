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

---

## Session Memory Protocol

### Directory Structure

```
.nexus/
├── memory.md       # Rolling log — last 50 entries, auto-pruned
├── architecture.md # Discovered patterns, conventions, tech stack
├── decisions.md    # Key decisions with rationale and date
└── backlog.md      # Unfinished work, follow-ups, known issues
```

### Read Procedure (before Phase 1)

1. Check if `.nexus/` exists. If not, skip — no prior context.
2. Read all four files if present. Missing files are fine — skip them.
3. Extract: recent task context, established patterns, open follow-ups, prior decisions affecting this task.
4. Incorporate into research and design phases.

### Write Procedure (after final report)

1. Create `.nexus/` if it doesn't exist.
2. Append a new entry to `memory.md` using the format below.
3. Update `architecture.md` if new patterns, conventions, or stack details were discovered.
4. Append to `decisions.md` if a significant decision was made (approach, library, pattern).
5. Update `backlog.md` with unfinished items or required follow-ups; remove completed items.

### Pruning Rules

- After appending, count `###` headers in `memory.md`.
- If count exceeds 50, remove oldest entries until exactly 50 remain.
- Preserve the full content of the 50 most recent entries.

### Entry Format

```markdown
### [DATE] — [TASK_SUMMARY]
- **Status**: COMPLETED/PARTIAL/FAILED
- **Key Decisions**: [list]
- **Patterns Discovered**: [list or "none"]
- **Files Changed**: [list]
- **Follow-ups**: [list or "none"]
```

### Rules

- No sensitive data (secrets, credentials, PII).
- No duplication of what's already in code comments or docs.
- Keep entries concise — one bullet per item, no prose paragraphs.
- `architecture.md` is cumulative; update in-place rather than appending duplicates.
- `decisions.md` is append-only; never remove prior decisions.
