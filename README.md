# Nexus - Autonomous Multi-Agent System for GitHub Copilot

A streamlined multi-agent orchestration system for VS Code Copilot that executes complete, production-ready solutions autonomously with parallel agent coordination.

> **Inspired by** [Github-Copilot-Atlas](https://github.com/bigguy345/Github-Copilot-Atlas) - simplified for autonomous execution without user approval gates.

## 🎯 Core Philosophy

**Execute complete, production-ready solutions immediately. Test until passing. No clarifications unless critical.**

- ✅ **Autonomous Planning** - Plans and executes in one request
- ✅ **Parallel Execution** - Up to 10 agents working simultaneously
- ✅ **Test-Driven** - Strict TDD (red-green-refactor) enforced
- ✅ **No User Prompts** - Agent mode from start to finish
- ✅ **Reliability Layer** - Status-based escalation, evidence gates, self-review checkpoints

## 📋 Agent Architecture

### Main Orchestrator

**Nexus** (`Nexus.agent.md`) - THE AUTONOMOUS ORCHESTRATOR
- Model: Claude Sonnet 4.6
- Plans complete execution strategy
- Delegates to specialized sub-agents
- Coordinates parallel execution
- Routes subagent status codes (`DONE` / `DONE_WITH_CONCERNS` / `NEEDS_CONTEXT` / `BLOCKED`)
- Enforces evidence-based verification gates
- Validates and reports results
- **No user approval gates** - fully autonomous

### Specialized Sub-Agents

1. **Scout-subagent** (`Scout-subagent.agent.md`) - THE RAPID DISCOVERER
   - Model: Gemini 3 Flash (Preview)
   - Rapid file/usage discovery
   - **ALWAYS** 3-5 parallel searches
   - Read-only exploration
   - Status: `DONE` / `NEEDS_CONTEXT`

2. **Analyst-subagent** (`Analyst-subagent.agent.md`) - THE ARCHITECTURE EXPERT
   - Model: GPT-5.4
   - Deep architecture analysis
   - Design proposals (2-3 approaches with tradeoffs)
   - Self-review checkpoint before reporting
   - Status: All 4 codes

3. **Builder-subagent** (`Builder-subagent.agent.md`) - THE TDD IMPLEMENTER
   - Model: Claude Sonnet 4.6
   - Strict TDD workflow with self-review checkpoint
   - Structured debugging protocol (max 3 cycles)
   - Mandatory evidence (actual test/lint output)
   - Status: All 4 codes

4. **Reviewer-subagent** (`Reviewer-subagent.agent.md`) - THE QUALITY GATEKEEPER
   - Model: GPT-5.4
   - Three review modes: SPEC REVIEW / QUALITY REVIEW / FULL REVIEW
   - Two-stage validation (spec compliance then code quality)
   - Status: `DONE`→APPROVED / `DONE_WITH_CONCERNS`→NEEDS_REVISION / `BLOCKED`→FAILED

5. **Tester-subagent** (`Tester-subagent.agent.md`) - THE VALIDATION SPECIALIST
   - Model: Claude Sonnet 4.6
   - Evidence verification step before reporting
   - Mandatory evidence (actual test runner output)
   - Status: All 4 codes

## 🚀 Installation

### Prerequisites

- **VS Code Insiders** (recommended for latest agent features)
- **GitHub Copilot** subscription with multi-agent support
- **VS Code Settings** (required):

```json
{
  "chat.customAgentInSubagent.enabled": true,
  "github.copilot.chat.responsesApiReasoningEffort": "high"
}
```

### Quick Install (Recommended)

Run the installer script — it auto-detects your OS and VS Code variant:

```bash
# Clone the repository
git clone https://github.com/nicholasgasior/nexus.git
cd nexus

# Install everything (VS Code agents + Claude Code skills)
./install.sh

# Or install selectively
./install.sh --agents-only       # Only VS Code custom agents
./install.sh --skills-only       # Only Claude Code skills
./install.sh --vscode stable     # Target stable VS Code (default: auto-detect)
./install.sh --dry-run            # Preview changes without installing
./install.sh --uninstall          # Remove all installed agents and skills
```

Supports **macOS**, **Linux**, and **Windows** (Git Bash / WSL / MSYS2).

### Manual Installation

1. **Locate your VS Code prompts directory:**

   - **Windows**: `%APPDATA%\Code - Insiders\User\prompts\`
   - **macOS**: `~/Library/Application Support/Code - Insiders/User/prompts/`
   - **Linux**: `~/.config/Code - Insiders/User/prompts/`

   *(Remove "- Insiders" if using regular VS Code)*

2. **Copy agent files:**

   ```bash
   cp *.agent.md "/path/to/Code - Insiders/User/prompts/"
   ```

3. **Symlink skills (for Claude Code):**

   ```bash
   mkdir -p ~/.claude/skills
   for dir in skills/*/; do
     ln -sf "$(pwd)/$dir" ~/.claude/skills/$(basename "$dir")
   done
   ```

4. **Reload VS Code:**

   Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac) → "Developer: Reload Window"

## 📖 Usage

### Basic Usage

Simply invoke Nexus with your development task:

```
@Nexus Add user authentication with JWT tokens
```

Nexus will:
1. Analyze the task
2. Create execution plan
3. Design phase (complex tasks: Analyst proposes approaches)
4. Execute implementation in parallel
5. Two-stage validation (spec review, then quality review)
6. Report completion

**No further input needed** - it runs completely autonomously.

### Example Workflow

```
User: @Nexus Add user authentication with JWT tokens

Nexus:
[Analyzing task...]

PHASE 1: RESEARCH (Parallel)
  → Scout: Find auth files (5 parallel searches)
  → Scout: Find middleware files (5 parallel searches)
  → Analyst: Analyze auth architecture
  
  Results: 12 files found, current auth = session-based

PHASE 2: DESIGN (Complex tasks only)
  → Analyst: Propose approaches with tradeoffs
  → Nexus: Select approach based on pattern alignment, risk, complexity

  Results: Hybrid JWT approach selected (add alongside existing sessions)

PHASE 3: IMPLEMENTATION (Parallel)
  → Builder: JWT generation with tests (TDD)
  → Builder: JWT validation with tests (TDD)

  Results: DONE - 2 files created, 15 tests written, all passing (evidence attached)

PHASE 4: VALIDATION (Two-Stage)
  Stage 1 (parallel):
    → Tester: Run all auth tests
    → Reviewer: SPEC REVIEW - verify implementation matches requirements
  Stage 2 (sequential):
    → Reviewer: QUALITY REVIEW - code quality, security

  Results: SPEC_PASS, APPROVED, 23/23 tests passing, 94% coverage

## EXECUTION COMPLETE ✅

Status: COMPLETED
Files Created: auth/jwt.py, middleware/jwt_auth.py, tests/test_jwt.py
Tests: 23/23 passing
Coverage: 94%
Ready for Deployment: YES

Assumptions Made:
- Using existing auth framework
- Following current code style
- TDD approach enforced

Risks Identified:
- Breaking change if endpoints use old auth
- Secret key rotation needed
```

### Advanced Usage

#### Parallel Feature Development

```
@Nexus Implement these features in parallel:
1. User profile management
2. Email notifications
3. Search with filters
```

#### Complex Refactoring

```
@Nexus Refactor authentication module to use dependency injection while maintaining backward compatibility
```

#### Bug Fixes with Tests

```
@Nexus Fix race condition in order processing that causes double charges. Add tests to prevent regression.
```

## 🔧 Configuration

### Adjust Parallel Limits

By default, Nexus uses up to 10 parallel agents per phase. This is configured in the agent file but can be adjusted based on your system:

- **3-5 agents**: Conservative (slower but safer)
- **10 agents**: Default (balanced)
- **15+ agents**: Aggressive (faster but resource-intensive)

### Model Selection

Each agent uses a specific model optimized for its role:

- **Nexus**: Claude Sonnet 4.6 (orchestration reasoning)
- **Scout**: Gemini 3 Flash (speed for discovery)
- **Analyst**: GPT-5.4 (deep analysis)
- **Builder**: Claude Sonnet 4.6 (code quality)
- **Reviewer**: GPT-5.4 (thoroughness)
- **Tester**: Claude Sonnet 4.6 (execution)

These can be changed in the YAML frontmatter of each `.agent.md` file.

## ✨ Key Features

### 1. Context Conservation

**Problem**: Traditional agents waste 80-90% of context on raw file reading.

**Solution**: 
- Scouts return summaries, not raw files
- Builders focus on changed files only
- Reviewers examine diffs
- Analysts provide recommendations, not data dumps

**Result**: 70-80% more context for actual reasoning.

### 2. Parallel Execution

**Workflow**:
```
Phase 1: Research
├─ Scout 1: Auth files
├─ Scout 2: Middleware files  ← All run simultaneously
├─ Scout 3: Test files
└─ Analyst: Architecture

Phase 2: Design (complex tasks only)
└─ Analyst: 2-3 approaches    ← Nexus selects best fit

Phase 3: Implementation
├─ Builder 1: JWT generation  ← Run in parallel if independent
└─ Builder 2: JWT validation

Phase 4: Validation (two-stage)
├─ Stage 1 (parallel):
│  ├─ Reviewer: Spec review   ← Does it match requirements?
│  └─ Tester: Test execution
└─ Stage 2 (sequential):
   └─ Reviewer: Quality review ← Code quality, security
```

**Performance**: 2-8x faster than sequential execution.

### 3. Test-Driven Development

**Every** implementation follows:

```
1. Write test (must fail) ← Red
2. Write minimal code     ← Green
3. Run test (must pass)   ← Green
4. Lint & format          ← Refactor
5. Next feature           ← Repeat
```

**No exceptions** - Builder enforces this strictly.

### 4. Autonomous Operation

**Traditional**: Plan → Ask approval → Implement → Ask approval → Review → Ask approval

**Nexus**: Plan → Implement → Validate → Report

**Zero user interaction** during execution.

### 5. Reliability Layer

**Status-Based Escalation**: Subagents report structured statuses (`DONE`, `DONE_WITH_CONCERNS`, `NEEDS_CONTEXT`, `BLOCKED`) — Nexus routes each appropriately instead of binary pass/fail.

**Evidence-Based Verification**: "Iron Law: Evidence Over Claims" — never accept "should work." Builder and Tester must attach actual command output. Reports without evidence trigger re-dispatch.

**Self-Review Checkpoints**: Builder, Analyst, and Tester verify their own work before reporting (did I actually run it? does it match the requirement? any TODOs left?).

**Structured Debugging**: Builder follows a 4-phase protocol (Investigate → Pattern Match → Hypothesize → Fix) with max 3 cycles before escalating as BLOCKED.

### 6. Production Ready

- ✅ Comprehensive error handling
- ✅ Security audits
- ✅ Test coverage requirements
- ✅ Linting and formatting
- ✅ Type hints and documentation

### 7. Session Memory

**Problem**: Each invocation starts cold — no knowledge of prior decisions, patterns, or unfinished work.

**Solution**: File-based persistence in `.nexus/` at the project root:

```
.nexus/
├── memory.md       # Rolling log of last 50 sessions (auto-pruned)
├── architecture.md # Discovered patterns, conventions, tech stack
├── decisions.md    # Key decisions with rationale and date
└── backlog.md      # Unfinished work and follow-ups
```

**How it works**: Nexus reads all four files before Phase 1 to load prior context. After the final report, it appends a structured entry to `memory.md` and updates the other files with any new findings. The directory is created automatically on first run.

**Result**: Continuity across sessions — Nexus remembers your conventions, prior choices, and open items without re-discovering them every time.

## 📊 Comparison to Alternatives

### vs Atlas (Original)

| Feature | Atlas | Nexus |
|---------|-------|-------|
| User Approval | Multiple gates | Zero gates |
| Agents | 6+ specialized | 5 core agents |
| Execution | Semi-autonomous | Fully autonomous |
| Handoffs | Manual/prompted | Automatic |
| Best For | Interactive development | Agent-mode execution |

### vs Sequential Execution

| Metric | Sequential | Nexus |
|--------|-----------|-------|
| Time | O(N × avg_time) | O(longest_phase) |
| Typical speedup | 1x | 2-8x |
| Context usage | High waste | 70% conserved |

## 🎓 How It Works

### Phase 1: Research (Parallel)

```
Nexus launches:
  3-5 Scouts (parallel file discovery)
  1-2 Analysts (architecture review)

Scouts use multiple parallel searches:
  #search authentication semantic
  #search jwt token grep
  #search login endpoint semantic
  ...

Analysts provide strategic recommendations:
  - Current architecture analysis
  - Integration points
  - Recommended approach
  - Risks and mitigations
```

### Phase 2: Design (Complex tasks only)

```
For complex tasks (4+ files, architectural changes):
  Analyst proposes 2-3 approaches with tradeoffs
  Nexus selects based on: pattern alignment, risk, complexity

Skipped for simple tasks (1-3 files, clear path)
```

### Phase 3: Implementation (Parallel where possible)

```
Nexus launches Builders based on independence:
  Independent features → Parallel builders (1 feature per builder)
  Dependent features → Sequential builders

Each Builder follows strict TDD:
  1. Write test (RED)
  2. Verify test fails
  3. Write code (GREEN)
  4. Verify test passes
  5. Lint & format
  5.5. Self-review (verify tests match requirements)
  6. Next feature

Builder reports include mandatory evidence:
  - Actual test output (not summaries)
  - Actual lint output
```

### Phase 4: Validation (Two-Stage)

```
Stage 1 (parallel):
  Reviewer: SPEC REVIEW - does implementation match requirements?
  Tester: Run full test suite with evidence

  → If SPEC_FAIL: stop, report back
  → If SPEC_PASS: proceed to Stage 2

Stage 2 (sequential):
  Reviewer: QUALITY REVIEW
    ✓ Correctness
    ✓ Test coverage
    ✓ Code quality
    ✓ Security
    ✓ Performance
    ✓ Maintainability

  → APPROVED / NEEDS_REVISION / FAILED
```

### Final Report

```
Nexus synthesizes results:
  Status: ✅ COMPLETED
  Files: Created/Modified list
  Tests: X/X passing
  Coverage: Y%
  Ready: YES/NO
  Assumptions: [list]
  Risks: [list]
```

## 🔍 Best Practices

### 1. Clear Objectives

**Good**:
```
@Nexus Add rate limiting to API endpoints with 100 req/min per user, Redis-based
```

**Less Good**:
```
@Nexus Make the API faster
```

### 2. Specify Constraints

```
@Nexus Add caching but don't introduce new dependencies
```

### 3. Request Multiple Features

```
@Nexus Implement:
1. User authentication with JWT
2. Email verification flow
3. Password reset with tokens
```

Nexus will execute in parallel where possible.

### 4. Let It Run

Don't interrupt - Nexus will:
- Make reasonable assumptions
- Document them clearly
- Proceed autonomously
- Report results

## ⚠️ Known Limitations

1. **Requires VS Code Insiders** - Best support for agent features
2. **GitHub Copilot subscription** - Multi-agent support needed
3. **Memory between sessions requires `.nexus/` directory** — auto-created on first run
4. **Context window limits** - Very large codebases may hit limits
5. **Model availability** - Requires access to specified models

## 🛠️ Troubleshooting

### Issue: Agents not appearing

**Solution**:
1. Check file location in prompts directory
2. Ensure `.agent.md` extension
3. Reload VS Code window
4. Check YAML frontmatter syntax

### Issue: Sub-agents not delegating

**Solution**:
1. Verify `chat.customAgentInSubagent.enabled: true`
2. Check VS Code Insiders version
3. Ensure agent file names match exactly (case-sensitive)

### Issue: Slow execution

**Solution**:
1. Check model availability
2. Verify network connection
3. Consider reducing parallel agent count
4. Check system resources

## 📝 Contributing

To add custom agents:

1. Create `YourAgent-subagent.agent.md`
2. Add YAML frontmatter with model, tools, description
3. Define role and workflow
4. Add to Nexus delegation instructions
5. Test with sample tasks

See existing agents as templates.

## 🔌 Universal Skills Directory

The `skills/` directory provides Nexus as a **universal skill format** that works across multiple AI coding tools.

### Skill Format

Each skill is a `SKILL.md` file with YAML frontmatter (`name`, `description`) and markdown body. Heavy content lives in `references/` files loaded on demand.

### Skill Inventory

| Skill | Directory | Description |
|-------|-----------|-------------|
| `nexus` | `skills/nexus/` | Main orchestrator — 4-phase workflow, agent roster, status protocol |
| `nexus-build` | `skills/nexus-build/` | Build a new feature (research → design → TDD execute → validate) |
| `nexus-debug` | `skills/nexus-debug/` | Debug and fix bugs (research → fix with 3 debug cycles → validate) |
| `nexus-review` | `skills/nexus-review/` | Code review (research → two-stage review with 7-category scoring) |
| `nexus-refactor` | `skills/nexus-refactor/` | Refactor code (dependency map → plan → execute → validate behavior) |
| `nexus-test` | `skills/nexus-test/` | Add tests (find coverage gaps → write tests → validate quality) |
| `nexus-docs` | `skills/nexus-docs/` | Write documentation (research → document → verify accuracy) |

### Installation by Tool

**Claude Code:**
```bash
# Symlink into Claude Code skills directory
mkdir -p ~/.claude/skills
ln -s "$(pwd)/skills/nexus" ~/.claude/skills/nexus
ln -s "$(pwd)/skills/nexus-build" ~/.claude/skills/nexus-build
ln -s "$(pwd)/skills/nexus-debug" ~/.claude/skills/nexus-debug
ln -s "$(pwd)/skills/nexus-review" ~/.claude/skills/nexus-review
ln -s "$(pwd)/skills/nexus-refactor" ~/.claude/skills/nexus-refactor
ln -s "$(pwd)/skills/nexus-test" ~/.claude/skills/nexus-test
ln -s "$(pwd)/skills/nexus-docs" ~/.claude/skills/nexus-docs
```

**GitHub Copilot:**
```bash
# Copy SKILL.md files as .agent.md into VS Code prompts directory (adapt content as needed)
# Skills are tool-agnostic, so the instructions work across agents
```

**OpenAI Codex / OpenCode:**
```bash
# Symlink into .agents/skills/ directory
mkdir -p .agents/skills
ln -s "$(pwd)/skills/nexus" .agents/skills/nexus
# Repeat for each pipeline skill
```

### Directory Structure

```
skills/
├── nexus/                      # Main orchestrator
│   ├── SKILL.md                # Entry point
│   └── references/
│       ├── agents.md           # Full agent definitions
│       ├── pipelines.md        # Pipeline workflows
│       └── protocols.md        # Status protocol, evidence gates, debug protocol
├── nexus-build/SKILL.md        # Build feature pipeline
├── nexus-debug/SKILL.md        # Debug & fix pipeline
├── nexus-review/SKILL.md       # Code review pipeline
├── nexus-refactor/SKILL.md     # Refactor pipeline
├── nexus-test/SKILL.md         # Add tests pipeline
└── nexus-docs/SKILL.md         # Write docs pipeline
```

## 📄 License

MIT License - See LICENSE file

## 🙏 Acknowledgments

Inspired by:
- [Github-Copilot-Atlas](https://github.com/bigguy345/Github-Copilot-Atlas) by bigguy345
- [copilot-orchestra](https://github.com/ShepAlderson/copilot-orchestra) by ShepAlderson

## 📞 Support

- **Issues**: Open a GitHub issue
- **Questions**: Check documentation in each `.agent.md` file
- **Examples**: See Usage section above

## 📜 Changelog

### 2026-03-10

- **Compress agent prompts by 74%** — Removed obvious LLM knowledge, kept only Nexus-specific procedures for optimal token efficiency (`31544fa`)
- **Add universal skills/ directory** — Nexus as reusable skills across Claude Code, GitHub Copilot, and OpenAI Codex with optimized multi-agent orchestration (`0d643c9`)
- **Add reliability layer** — Status-based escalation (4 codes), evidence gates, self-review checkpoints, and structured debugging protocol with max 3 cycles (`0df518f`)
- **Update agent models** — Claude Sonnet 4.5 → 4.6, GPT-5.2 → 5.4 (`cd97209`)

### 2026-02-03

- **Initial commit** — Core multi-agent system with Nexus orchestrator, Scout, Analyst, Builder, Reviewer, and Tester sub-agents (`e9c199c`)

---

**Built for autonomous software development** 🚀
