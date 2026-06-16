---
name: systematic-debugging
description: Use when encountering any bug, test failure, or unexpected behavior. Execute before proposing a fix.
---

# Systematic Debugging

> Source: superpowers (159k+ stars)
> Applies to QA, Frontend, Backend roles

## Overview

Fixing things randomly wastes time and introduces new bugs. Hasty patches only mask deeper issues.

**Core Principle**: Always find the root cause before attempting a fix. Fixing symptoms is failure.

## Iron Rule

No fix proposal without root cause investigation.

## When to Use

Any technical issue:
- Test failures
- Production bugs
- Unexpected behavior
- Performance issues
- Build failures
- Integration problems

## Four Phases

You must complete each phase before moving to the next.

### Phase 1: Root Cause Investigation

Before attempting any fix:

1. **Read the error carefully**
   - Don't skip errors or warnings
   - Read the full stack trace
   - Note line numbers, file paths, error codes

2. **Reproduce reliably**
   - Can you trigger it consistently?
   - What are the exact reproduction steps?
   - Does it reproduce every time?

3. **Check recent changes**
   - What change may have caused this?
   - `git diff`, recent commits
   - New dependencies, config changes

4. **Trace the data flow**
   - Where did the bad value originate?
   - Who called with the bad value?
   - Trace upstream until the root source is found

### Phase 2: Pattern Analysis

Find the pattern, then fix:

1. **Find a working example**
2. **Compare with the reference implementation**
3. **Identify the difference**
4. **Understand dependencies**

### Phase 3: Hypothesis and Verification

**Scientific method:**

1. **Single hypothesis**
   - Clearly state: "I believe X is the root cause because Y"

2. **Minimal test**
   - Make the smallest change to verify your hypothesis
   - Change only one variable at a time

3. **Verify before proceeding**
   - Worked? Yes → Go to Phase 4
   - Didn't work? Form a new hypothesis

### Phase 4: Implementation

Fix the root cause, not the symptom:

1. **Create a failing test**
   - Minimal reproduction
   - Must have a test before fixing

2. **Single fix**
   - Fix the identified root cause
   - Change only one thing at a time

3. **Verify the fix**
   - Tests passing now?
   - No other tests broken?

4. **If 3+ attempts fail: question the architecture**
   - Stop and ask fundamental questions
   - Should you refactor or keep patching?

## Debugging Principles

- Don't guess, investigate
- Don't change multiple things at once
- Measure, don't assume
- One variable at a time
- Write it down
- Test your fix
- Say "I don't know"

## Final Check

- [ ] Root cause identified and documented
- [ ] Fix addresses root cause, not symptom
- [ ] Verification test proves fix is effective
- [ ] No new issues introduced

---

## Bug Fix Closure (from Rules 2.1 bug-fix)

> Complete workflow from investigation → Issue → branch → fix → verify → commit

### 1. Create Issue

```markdown
**Bug Title**: [Component/Module] Short descriptive title

**Environment**:
- OS: [macOS 14 / Windows 11 / Ubuntu 22.04]
- App Version: [v2.1.0]
- Runtime: [Node 20 / Python 3.12 / Java 21]

**Steps to Reproduce**:
1. [Exact step 1]
2. [Exact step 2]
3. [Exact step 3]

**Expected**: [What should happen]
**Actual**: [What actually happens]

**Error Log**:
` ` `
[Full stack trace + key context]
` ` `

**Priority**: High / Medium / Low
**Labels**: bug, [module]
```

### 2. Branch and Fix

```bash
# Create fix branch from main
git checkout -b fix/issue-<id>-<short-description>

# Run full test suite after fix
npm test  # or pytest / go test ./...
```

### 3. Commit

```bash
git commit -m "🐛 fix(<scope>): <short description> (#<issue-id>)

- Fix: <root cause in one sentence>
- Test: <new test if any>
- Regression: All tests pass

Fixes #<issue-id>"
```

### 4. Debug Log Template

```markdown
## Debug Log: [Bug Title]

**Found**: YYYY-MM-DD
**Reporter**: @username
**Severity**: Critical / High / Medium / Low

### Symptom
[User-visible abnormal behavior]

### Root Cause
[Root cause confirmed after systematic 4-phase investigation]

### Fix
[Minimal change + code diff]

### Verification
- [ ] Bug no longer reproducible
- [ ] Regression test added
- [ ] Full test suite passes
- [ ] Affected roles notified
```
