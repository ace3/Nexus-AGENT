# Nexus - Autonomous Multi-Agent System for GitHub Copilot

A streamlined multi-agent orchestration system for VS Code Copilot that executes complete, production-ready solutions autonomously with parallel agent coordination.

> **Inspired by** [Github-Copilot-Atlas](https://github.com/bigguy345/Github-Copilot-Atlas) - simplified for autonomous execution without user approval gates.

## 🎯 Core Philosophy

**Execute complete, production-ready solutions immediately. Test until passing. No clarifications unless critical.**

- ✅ **Autonomous Planning** - Plans and executes in one request
- ✅ **Parallel Execution** - Up to 10 agents working simultaneously  
- ✅ **Test-Driven** - Strict TDD (red-green-refactor) enforced
- ✅ **No User Prompts** - Agent mode from start to finish

## 📋 Agent Architecture

### Main Orchestrator

**Nexus** (`Nexus.agent.md`) - THE AUTONOMOUS ORCHESTRATOR
- Model: Claude Sonnet 4.5
- Plans complete execution strategy
- Delegates to specialized sub-agents
- Coordinates parallel execution
- Validates and reports results
- **No user approval gates** - fully autonomous

### Specialized Sub-Agents

1. **Scout-subagent** (`Scout-subagent.agent.md`) - THE RAPID DISCOVERER
   - Model: Gemini 3 Flash (Preview)
   - Rapid file/usage discovery
   - **ALWAYS** 3-5 parallel searches
   - Read-only exploration
   - Returns structured file lists

2. **Analyst-subagent** (`Analyst-subagent.agent.md`) - THE ARCHITECTURE EXPERT
   - Model: GPT-5.2
   - Deep architecture analysis
   - Pattern identification
   - Constraint documentation
   - Strategic recommendations

3. **Builder-subagent** (`Builder-subagent.agent.md`) - THE TDD IMPLEMENTER
   - Model: Claude Sonnet 4.5
   - Strict TDD workflow
   - Test first, always
   - Production-ready code
   - Lint and format

4. **Reviewer-subagent** (`Reviewer-subagent.agent.md`) - THE QUALITY GATEKEEPER
   - Model: GPT-5.2
   - Code quality review
   - Security audit
   - Test coverage check
   - APPROVED/NEEDS_REVISION/FAILED

5. **Tester-subagent** (`Tester-subagent.agent.md`) - THE VALIDATION SPECIALIST
   - Model: Claude Sonnet 4.5
   - Test execution
   - Coverage reporting
   - Failure analysis
   - Performance metrics

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

### Installation Steps

1. **Locate your VS Code prompts directory:**

   - **Windows**: `%APPDATA%\Code - Insiders\User\prompts\`
   - **macOS**: `~/Library/Application Support/Code - Insiders/User/prompts/`
   - **Linux**: `~/.config/Code - Insiders/User/prompts/`

   *(Remove "- Insiders" if using regular VS Code)*

2. **Copy agent files:**

   ```bash
   # Clone or download this repository
   git clone <your-repo>
   
   # Copy agent files to prompts directory
   cp *.agent.md "/path/to/Code - Insiders/User/prompts/"
   ```

3. **Reload VS Code:**

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
3. Execute phases in parallel
4. Validate results
5. Report completion

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

PHASE 2: IMPLEMENTATION (Parallel)
  → Builder: JWT generation with tests (TDD)
  → Builder: JWT validation with tests (TDD)
  
  Results: 2 files created, 15 tests written, all passing

PHASE 3: VALIDATION (Parallel)
  → Reviewer: Review JWT implementation
  → Tester: Run all auth tests
  
  Results: APPROVED, 23/23 tests passing, 94% coverage

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

- **Nexus**: Claude Sonnet 4.5 (orchestration reasoning)
- **Scout**: Gemini 3 Flash (speed for discovery)
- **Analyst**: GPT-5.2 (deep analysis)
- **Builder**: Claude Sonnet 4.5 (code quality)
- **Reviewer**: GPT-5.2 (thoroughness)
- **Tester**: Claude Sonnet 4.5 (execution)

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

Phase 2: Implementation
├─ Builder 1: JWT generation  ← Run in parallel if independent
└─ Builder 2: JWT validation

Phase 3: Validation
├─ Reviewer: Code quality     ← Always parallel
└─ Tester: Test execution
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

### 5. Production Ready

- ✅ Comprehensive error handling
- ✅ Security audits
- ✅ Test coverage requirements
- ✅ Linting and formatting
- ✅ Type hints and documentation

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

### Phase 2: Implementation (Parallel where possible)

```
Nexus launches Builders based on independence:
  Independent features → Parallel builders
  Dependent features → Sequential builders

Each Builder follows strict TDD:
  1. Write test (RED)
  2. Verify test fails
  3. Write code (GREEN)
  4. Verify test passes
  5. Lint & format
  6. Next feature
```

### Phase 3: Validation (Always Parallel)

```
Nexus launches in parallel:
  Reviewer: Quality audit
  Tester: Test execution

Reviewer checks:
  ✓ Correctness
  ✓ Test coverage
  ✓ Code quality
  ✓ Security
  ✓ Performance
  ✓ Maintainability

Tester validates:
  ✓ All tests passing
  ✓ Coverage metrics
  ✓ Performance
  ✓ No flaky tests
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
3. **No memory between sessions** - Each invocation is independent
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

---

**Built for autonomous software development** 🚀
