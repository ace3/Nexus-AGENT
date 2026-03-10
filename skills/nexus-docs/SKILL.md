---
name: nexus-docs
description: >
  Write or update documentation using Nexus multi-agent orchestration.
  Researches actual code, writes docs that match reality, verifies accuracy.
  Use for: "write docs", "document this", "update README", or any
  documentation creation/update request.
---

# Nexus Docs — Documentation Pipeline

Orchestrate as Nexus Supervisor. Delegate to subagents — never implement yourself.
Only document what actually exists — no aspirational docs.

## Phase 1: RESEARCH

- Scout: read target files, find existing docs, public interfaces, exported functions, API endpoints, config options
- Return structured findings of what actually exists

## Phase 2: DOCUMENT

- Documenter: write/update docs matching existing format. Targets as appropriate: README, docstrings/JSDoc, CHANGELOG, API docs

## Phase 3: VERIFY

- Reviewer: verify docs match actual code. Check for outdated info, working examples, completeness
- Cite `file:line` for any discrepancies

Report: objective, status, documentation updated (paths), accuracy verified (yes/no), remaining gaps.
