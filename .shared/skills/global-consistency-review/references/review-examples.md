# IS_PASS Review Examples

## Check 1: Imports Resolve

**Fail**: `import { fetchUser } from './services/api'` but `services/api.ts` doesn't exist or doesn't export `fetchUser`.

**Pass**: Every import statement points to an existing file with the correct export.

**What to check**:
- Does the target file exist?
- Does it export the symbol being imported?
- Any circular dependencies? (A imports B imports C imports A)

## Check 2: Types Consistent

**Fail**: `api.ts` defines `User { id: number; name: string }` but `hooks.ts` defines `User { id: string; name: string; email: string }`.

**Pass**: Shared types are defined once and used everywhere, or are identical across files.

**What to check**:
- Interface/type definitions for the same concept match exactly
- No `any` types where a concrete type is expected
- Imported types from shared location vs redefined locally

## Check 3: Naming Consistent

**Fail**: `userEmail` in one file, `email_addr` in another, `UserEmail` in a third.

**Pass**: Same concept uses the same name and casing convention everywhere.

**What to check**:
- camelCase vs snake_case consistency
- Same variable/function names for same concepts
- No typos in identifiers (`getUesr` instead of `getUser`)

## Check 4: API Contracts Match

**Fail**: Frontend sends `POST /api/users` with `{ name, email }` but backend expects `{ username, email_address }`.

**Pass**: Frontend request shapes match backend endpoint signatures exactly.

**What to check**:
- Endpoint paths match (no `/api/user` vs `/api/users`)
- Request body fields match
- Response type shape matches what the frontend expects
- HTTP methods match (GET vs POST)

## Check 5: Error Handling Uniform

**Fail**: One file uses `try/catch`, another uses `.catch()`, a third uses error boundaries with a different interface.

**Pass**: All files use the same error handling pattern.

**What to check**:
- Same pattern: `try/catch` or `.catch()` — not mixed
- Error objects have the same shape `{ message, code, status }`
- Error boundaries (if used) follow the same interface

## Check 6: State Flows Correctly

**Fail**: Component dispatches action -> store updates via reducer -> API call never happens -> state never updates from response.

**Pass**: Component -> action -> reducer/slice -> API call -> response -> reducer -> component forms a complete cycle.

**What to check**:
- Every state change has a corresponding action
- Every action has a corresponding handler
- API responses actually update state
- No broken chains in the data flow

## Check 7: File Structure Matches Design

**Fail**: Architecture plan says `src/features/auth/` but files ended up in `src/components/auth/`.

**Pass**: File locations match the agreed architecture plan.

**What to check**:
- Files exist where the plan says they should
- No stray/extra files outside the plan
- Every file has a clear purpose documented in the plan

## Check 8: Dependencies Declared

**Fail**: File uses `import axios from 'axios'` but `axios` is not in `package.json`.

**Pass**: Every third-party import has a corresponding entry in the dependency manifest.

**What to check**:
- All npm/pip/go imports exist in the dependency file
- Correct versions specified
- No missing peer dependencies
