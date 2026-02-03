# Quick Start Guide - Nexus Multi-Agent System

Get your autonomous agent system running in 5 minutes.

## ⚡ Installation (60 seconds)

### Step 1: Find your prompts directory

**Windows**:
```
%APPDATA%\Code - Insiders\User\prompts\
```

**macOS**:
```
~/Library/Application Support/Code - Insiders/User/prompts/
```

**Linux**:
```
~/.config/Code - Insiders/User/prompts/
```

*(Using regular VS Code? Remove "- Insiders" from path)*

### Step 2: Copy agent files

```bash
# Download or clone this repo
git clone <your-repo>

# Copy ALL .agent.md files to your prompts directory
cp *.agent.md "/path/to/Code - Insiders/User/prompts/"
```

### Step 3: Enable required settings

Open VS Code Settings (JSON) and add:

```json
{
  "chat.customAgentInSubagent.enabled": true,
  "github.copilot.chat.responsesApiReasoningEffort": "high"
}
```

### Step 4: Reload VS Code

`Ctrl+Shift+P` → "Developer: Reload Window"

## ✅ Verify Installation

Open Copilot Chat and type:
```
@Nexus
```

You should see **Nexus** appear in the autocomplete.

## 🚀 First Task

Try this simple example:

```
@Nexus Add input validation to the user registration form - check email format, password strength (min 8 chars), and username uniqueness
```

You'll see:
1. **Analysis** - Nexus plans the execution
2. **Research Phase** - Scouts find files, Analyst reviews architecture  
3. **Implementation Phase** - Builders write code with tests (TDD)
4. **Validation Phase** - Reviewer checks quality, Tester runs tests
5. **Report** - Complete summary with deployment readiness

**All autonomous - no prompts from you!**

## 📋 What Just Happened?

```
Phase 1: RESEARCH (5 parallel agents)
  ├─ Scout: Find form files (5 searches)
  ├─ Scout: Find validation code (5 searches)
  └─ Analyst: Review validation patterns
  
  Time: ~2 seconds
  Found: 8 relevant files

Phase 2: IMPLEMENTATION (2 parallel agents)
  ├─ Builder: Email validation (TDD)
  └─ Builder: Password validation (TDD)
  
  Time: ~3 seconds
  Created: 2 files, 12 tests, all passing

Phase 3: VALIDATION (2 parallel agents)
  ├─ Reviewer: Code quality check
  └─ Tester: Run all tests
  
  Time: ~1 second
  Result: APPROVED, 12/12 tests passing

Total Time: ~6 seconds
Ready: YES ✅
```

## 🎯 Common Use Cases

### Add Feature
```
@Nexus Add pagination to the products list API with page size controls
```

### Fix Bug
```
@Nexus Fix the race condition in checkout that allows duplicate orders
```

### Refactor
```
@Nexus Refactor database queries to use connection pooling
```

### Add Tests
```
@Nexus Add comprehensive tests for the payment processing module
```

### Security
```
@Nexus Add rate limiting to prevent brute force attacks on login
```

## 🔧 Understanding the Agents

### Nexus (Main Orchestrator)
- Plans the entire execution
- Delegates to specialized agents
- Coordinates parallel execution
- **You only interact with Nexus**

### Scout (Discovery)
- Finds relevant files super fast
- Uses 3-5 parallel searches
- Read-only, returns summaries

### Analyst (Strategy)
- Analyzes architecture
- Recommends approaches
- Identifies constraints and risks

### Builder (Implementation)
- Writes code using strict TDD
- Tests first, always
- Production-ready output

### Reviewer (Quality)
- Reviews code quality
- Checks security
- Approves or requests changes

### Tester (Validation)
- Runs all tests
- Reports coverage
- Analyzes failures

## 📊 Interpreting Results

### ✅ COMPLETED
```
Status: ✅ COMPLETED
Ready for Deployment: YES
```
→ **Code is production-ready, all tests passing**

### ⚠️ NEEDS REVISION
```
Status: ⚠️ PARTIAL
Reviewer: NEEDS REVISION (1 blocking issue)
```
→ **Minor issues to fix, not deployment-ready yet**

### ❌ FAILED
```
Status: ❌ FAILED
Tests: 8/15 passing
```
→ **Significant issues, requires attention**

## 💡 Pro Tips

### 1. Be Specific
**Better**: "Add JWT authentication with 1-hour expiry and refresh tokens"  
**Not**: "Improve security"

### 2. Let It Run
Don't interrupt - Nexus will document assumptions and proceed autonomously.

### 3. Batch Related Tasks
```
@Nexus Implement these in parallel:
1. User profile CRUD
2. Avatar upload
3. Email verification
```

### 4. Check the Report
Nexus documents:
- Assumptions made
- Risks identified
- Files changed
- Tests added
- Deployment readiness

### 5. Trust the TDD
Every Builder follows red-green-refactor. Code has tests.

## 🔍 Troubleshooting

**Q: Agents not showing up?**  
A: 
1. Check files are in correct prompts directory
2. Reload VS Code window
3. Verify `.agent.md` extension

**Q: Nexus not delegating to sub-agents?**  
A: 
1. Enable `chat.customAgentInSubagent.enabled`
2. Use VS Code Insiders
3. Reload window

**Q: Execution seems slow?**  
A: 
1. First run may be slower (model loading)
2. Check network connection
3. Complex tasks naturally take longer

**Q: Want to see what's happening?**  
A: Nexus reports each phase as it executes:
```
PHASE 1: RESEARCH (Parallel)
  → Scout: Finding files...
  → Analyst: Analyzing architecture...
```

## 📚 Next Steps

1. **Try a real task** in your codebase
2. **Read the agents** - Open `.agent.md` files to see how they work
3. **Customize** - Modify agents for your workflow
4. **Scale up** - Try complex multi-feature tasks

## 🎓 Learning More

- **README.md** - Full documentation
- **Nexus.agent.md** - Main orchestrator logic
- **Builder-subagent.agent.md** - TDD workflow details
- **Scout-subagent.agent.md** - Parallel search strategy

## ⚙️ Advanced Configuration

### Change Model (in .agent.md file)
```yaml
model: Claude Sonnet 4.5 (copilot)  # Change to your preference
```

### Adjust Parallel Limits (in Nexus.agent.md)
```
Maximum: 10 parallel sub-agents per phase  # Edit this
```

### Add Custom Agent
1. Copy existing `-subagent.agent.md`
2. Modify for your needs
3. Add to Nexus delegation list

---

## 🚀 You're Ready!

Start with:
```
@Nexus Add comprehensive logging to all database operations
```

Watch it plan, execute, and deliver production-ready code autonomously.

**No user prompts needed. Just results.** ✨
