# Spec Writing Standards

## Good Spec

```markdown
## User Registration

### Input
- email: string (required, valid email format)
- password: string (required, min 8 chars, includes uppercase, lowercase, and digits)

### Processing
1. Validate email format
2. Check if email already registered
3. Encrypt and store password
4. Generate verification token
5. Send verification email

### Output
- Success: Return user ID, redirect to verification page
- Failure: Return error message (email exists / format error)

### Acceptance Criteria
- [ ] Show error on invalid email format
- [ ] Show error if email already exists
- [ ] Send verification email after successful registration
- [ ] Verification email valid for 24 hours
```

## Bad Spec

```markdown
## User Registration

Users can register an account, just enter email and password.
```

**Issues**:
- ❌ No input format requirements
- ❌ No processing logic
- ❌ No output definition
- ❌ No acceptance criteria

---

## Best Practices

### DO (Recommended)

- ✅ Define spec before starting to code
- ✅ Spec should be clear enough to generate code
- ✅ Include acceptance criteria for verification
- ✅ Focus on product scenarios, not just technical implementation

### DON'T (Avoid)

- ❌ Change requirements while coding
- ❌ Vague spec that cannot be verified
- ❌ Focus only on technology, ignore user value
- ❌ Skip spec and code directly
