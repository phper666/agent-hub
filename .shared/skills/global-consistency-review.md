---
name: global-consistency-review
description: Run after completing ALL files in a batch implementation. Systematic cross-file consistency check before handing off to QA.
---

# Global Consistency Review

> Source: WorkBuddy software-engineer IS_PASS pattern
> Run after batch implementation. Catch cross-file issues before QA sees them.

## Overview

Writing files one by one creates invisible cross-file drift — types don't match, imports break, naming diverges. This review catches those before they become QA bugs.

**Core principle**: Every batch of files must pass this gate before handoff. IS_PASS: NO → fix → re-review. Max 2 rounds.

## IS_PASS Checklist

After completing all files in a batch:

| # | Check | What to Verify |
|---|-------|---------------|
| 1 | **Imports resolve** | No broken references. All `import` statements point to existing files. No circular dependencies. |
| 2 | **Types consistent** | Shared interfaces/structs are identical in producer AND consumer files. No `any`. |
| 3 | **Naming consistent** | Same concept = same name. No `userEmail` in file A and `email_addr` in file B. |
| 4 | **API contracts match** | Frontend request shapes match backend endpoint signatures. Response types match API spec. |
| 5 | **Error handling uniform** | Same pattern everywhere (try/catch, error boundaries). Not 3 different styles. |
| 6 | **State flows correctly** | Component tree, store, and API calls form a complete cycle. No broken chains. |
| 7 | **File structure matches design** | No stray files outside the architecture plan. Every file has a reason to exist. |
| 8 | **Dependencies declared** | Every third-party import exists in `package.json` / `go.mod` / `requirements.txt`. |

## Output Format

```markdown
## Global Consistency Review

### IS_PASS: YES / NO

### Issues Found (if NO)
| File | Issue | Fix Applied |
|------|-------|-------------|
| src/services/api.ts | Missing 401 handler | Added auth error interceptor |
| src/hooks/useAuth.ts | Type mismatch with api.ts | Aligned UserResponse interface |

### Files Modified During Review
- src/services/api.ts: Added 401 interceptor
- src/hooks/useAuth.ts: Fixed UserResponse type alignment

### Summary
All 8 checks pass. Ready for QA.
```

## Rules

- Run after completing ALL files in a batch, NOT per-file
- IS_PASS: NO → fix all issues, re-run review. Maximum 2 rounds.
- After 2 failed rounds → escalate to Architect for design review
- Pass the review summary to QA alongside the code
