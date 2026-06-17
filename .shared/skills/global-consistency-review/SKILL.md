---
name: global-consistency-review
description: Cross-file consistency check after batch implementation. Run before handing off to QA. Trigger on: "consistency check", "IS_PASS", "cross-file review", "before QA", "batch complete".
---

# Global Consistency Review (IS_PASS)

> Source: WorkBuddy software-engineer IS_PASS pattern
> Progressive Disclosure: SKILL.md (checklist) → references/review-examples.md (detailed walkthrough)

## When to Load This Skill

| Role | Phase | Load? |
|------|-------|:-----:|
| Frontend | After batch implementation | ✅ Load full |
| Backend | After batch implementation | ✅ Load full |
| QA | Before test execution | ✅ Load references/review-examples.md |
| Architect | After architecture delivery | ⚠️ Read SKILL.md only |
| Designer | All | ❌ Skip |
| PM | All | ❌ Skip |
| Delivery Director | All | ❌ Skip |

## IS_PASS Checklist

After completing all files in a batch, verify:

| # | Check | What to Verify |
|---|-------|---------------|
| 1 | **Imports resolve** | No broken references, no circular dependencies |
| 2 | **Types consistent** | Shared interfaces identical in producer AND consumer files |
| 3 | **Naming consistent** | Same concept = same name across all files |
| 4 | **API contracts match** | Frontend requests match backend endpoints, response types match API spec |
| 5 | **Error handling uniform** | Same pattern everywhere, no mixed styles |
| 6 | **State flows correctly** | Component -> store -> API forms complete cycle |
| 7 | **File structure matches design** | No stray files outside architecture plan |
| 8 | **Dependencies declared** | Every import exists in package file |

## Rules

- IS_PASS: NO -> fix all issues, re-run review. **Maximum 2 rounds.**
- After 2 failed rounds -> escalate to Architect
- Pass the review summary to QA alongside the code

## Output Format

```markdown
## Global Consistency Review
### IS_PASS: YES / NO
### Issues Found (if NO)
| File | Issue | Fix Applied |
|------|-------|-------------|
### Files Modified During Review
### Summary
```

## Progressive Loading

- **SKILL.md (this file)**: IS_PASS checklist and rules. Always safe to load (~40 lines).
- **references/review-examples.md**: Detailed walkthrough of each check with examples. Load when executing a review.
- **references/output-template.md**: Complete output format template. Load when writing review report.
