# Spec Development Phases

## Phase 1: Constitution (Project Principles)

Define project governance principles and development guidelines:

```markdown
## Project Principles

### Code Quality
- Test coverage >= 80%
- All PRs must pass code review
- Follow SOLID principles

### User Experience
- Mobile-first
- Accessibility (WCAG 2.1 AA)
- Response time < 200ms

### Security
- All input must be validated
- Sensitive data encrypted at rest
- Follow principle of least privilege
```

## Phase 2: Specify (Product Spec)

Describe what to build, focusing on "what" and "why":

```markdown
## Product Spec: User Authentication System

### Target Users
- New users registering
- Users who forgot their password
- Users needing secure login

### Core Scenarios
1. **User Registration**
   - User enters email and password
   - System validates email format
   - System sends verification email
   - User clicks link to complete registration

2. **User Login**
   - User enters email and password
   - System validates credentials
   - System generates JWT Token
   - User gains access

3. **Forgot Password**
   - User enters email
   - System sends reset link
   - User sets new password
   - System confirms change

### Acceptance Criteria
- [ ] Redirect to home page after successful registration
- [ ] Show error message on login failure
- [ ] Password reset link valid for 24 hours
- [ ] All operations logged to audit trail
```

## Phase 3: Plan (Implementation Plan)

Break the spec into executable implementation steps:

```markdown
## Implementation Plan

### Step 1: Database Design
- Users table
- Verification codes table
- Audit logs table

### Step 2: API Design
- POST /api/auth/register
- POST /api/auth/login
- POST /api/auth/forgot-password
- POST /api/auth/reset-password

### Step 3: Frontend Implementation
- Registration page component
- Login page component
- Forgot password page component

### Step 4: Testing
- Unit tests
- Integration tests
- E2E tests
```

## Phase 4: Tasks (Task Breakdown)

Break the plan into specific development tasks:

```markdown
## Task List

### Database Tasks
- [ ] Create users table migration
- [ ] Create verification codes table migration
- [ ] Create audit logs table migration

### API Tasks
- [ ] Implement registration endpoint
- [ ] Implement login endpoint
- [ ] Implement forgot password endpoint
- [ ] Implement reset password endpoint

### Frontend Tasks
- [ ] Create registration page
- [ ] Create login page
- [ ] Create forgot password page

### Test Tasks
- [ ] Write registration endpoint tests
- [ ] Write login endpoint tests
- [ ] Write E2E tests
```
