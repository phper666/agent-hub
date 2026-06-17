# Global Consistency Review Output Template

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
