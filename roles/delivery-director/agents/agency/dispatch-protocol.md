---
name: dispatch-protocol
description: Subagent dispatch protocol for orchestrating parallel work. Use when independent work streams can proceed concurrently without shared state.
---

# Dispatch Protocol (from superpowers dispatching-parallel-agents)

> Source: https://github.com/obra/superpowers
> Delegate tasks to specialized agents with isolated context. Precisely craft their instructions so they stay focused and succeed.

## Overview

When the pipeline has independent work streams (e.g. Backend and Frontend after Architect), sequential execution wastes time. Each stream is independent and can run in parallel via subagents.

**Core principle**: Dispatch one agent per independent problem domain. Let them work concurrently.

## When to Dispatch

**Use when:**
- 2+ roles can work without shared state (e.g. Backend API + Frontend UI after API Spec is done)
- Each role's output is independently verifiable
- No sequential dependency between the tasks

**Don't use when:**
- Tasks depend on each other (PM must finish before Designer starts)
- Agents would conflict on shared files
- The results must be tightly integrated by a single mind

## The Pattern

### 1. Identify Independent Domains

```
After Architect completes API Spec:
  Domain A: Backend — implement API endpoints, database, auth
  Domain B: Frontend — build UI components, connect to API (mock first)

Each domain is independent. Backend doesn't need Frontend, Frontend doesn't need Backend code.
```

### 2. Build Focused Subagent Tasks

Each subagent gets a complete, self-contained task description:

```markdown
## Backend Subagent Task

**Scope**: Implement user authentication module
**Input Files**:
- Read docs/current/architecture/api-spec.md (section: Auth API)
- Read docs/current/architecture/system-architecture.md
**Goal**: Create working API endpoints for /auth/login, /auth/register, /auth/refresh
**Role**: Load roles/backend/SKILL.md + roles/backend/agents/agency/backend-architect-expert.md
**Constraints**:
- Do NOT modify frontend code
- Do NOT change the API Spec
- Tests required for each endpoint
**Expected Output**:
- src/backend/auth/* (implementation)
- tests/backend/auth/* (tests)
- Summary of endpoints created and test results
```

### 3. Dispatch in Parallel

```python
# In Reasonix or other subagent-capable platform:
task("Implement backend auth module per API Spec", description="...")
task("Build frontend login/register pages with mock API", description="...")
# Both run concurrently, each with isolated context
```

### 4. Review and Integrate

When subagents return:
- Read each summary
- Verify outputs don't conflict (e.g. Backend and Frontend didn't modify the same file)
- Run integration tests if applicable
- Update status.md

## Subagent Task Template

```markdown
## [Role] Task: [Short Description]

**Scope**: [One clear problem domain — keep it narrow]
**Input Files**:
- [File 1: what to read and why]
- [File 2: what to read and why]
**Goal**: [Concrete, verifiable outcome]
**Role**: Load [path/to/SKILL.md] + [relevant Expert if needed]
**Constraints**:
- [Constraint 1]
- [Constraint 2]
**Expected Output**:
- [Deliverable 1]
- [Deliverable 2]
**Success Criteria**: [How to verify the subagent did the right thing]
```

**Platform Note**: If your Agent platform supports named subagents (e.g. WorkBuddy Agent ID, Reasonix skill name), pass the role path (e.g. `roles/backend/SKILL.md`) as the subagent identifier so it inherits the correct role definition. Do NOT use ad-hoc names.

---

## Batch Dispatch Protocol (v3.0.0 — Multi-Request)

When the Kanban has multiple ready items at the same pipeline stage, dispatch them all in parallel.

### Workflow

```
1. Scan Kanban → Find all REQs where current role = "⏳ Pending" and previous role = "✅ Done"
2. Build one subagent task per REQ (each points to its own REQ directory)
3. Dispatch ALL in parallel → wait for ALL to return
4. Collect outputs, update Kanban, report to CEO
5. Repeat for next role/wave
```

### Example: Wave 3 (3 Architects)

```markdown
Scan Kanban:
  REQ-001: Designer ✅ → Architect ⏳  ← READY
  REQ-002: Designer 🔄 → Architect ⏳  ← NOT READY (Designer not done)
  REQ-003: Designer ✅ → Architect ⏳  ← READY

Dispatch 2 Architects (REQ-001 and REQ-003):
  task("architect for REQ-001 login",
       role="roles/architect/SKILL.md",
       desc="Read docs/sprints/sprint-1/REQ-001-login/PRD.md + design/ → produce architecture/")

  task("architect for REQ-003 homepage",
       role="roles/architect/SKILL.md",
       desc="Read docs/sprints/sprint-1/REQ-003-homepage/PRD.md + design/ → produce architecture/")

  # Both run concurrently. Each writes to its own REQ directory — no conflicts.

Wait for both → update Kanban:
  REQ-001: Architect ✅ → Backend/Frontend ⏳  ← READY for Wave 4
  REQ-003: Architect ✅ → Backend/Frontend ⏳  ← READY for Wave 4
```

### Dispatch Size Limits

| REQs Ready | Action |
|:----------:|--------|
| 1 | Dispatch immediately |
| 2-5 | Dispatch all in parallel |
| 6-10 | Dispatch in 2 batches of 5 |
| 10+ | Dispatch in batches of 5, prioritize P0 over P1 over P2 |

### Batch Dispatch Checklist

Before dispatching a wave:
- [ ] All upstream roles are "✅ Done" for each REQ being dispatched
- [ ] Each REQ has its own directory (no file conflicts)
- [ ] Inter-REQ dependencies are respected (REQ-002 depends on REQ-001 → REQ-002 waits)
- [ ] Max 5 subagents per batch to avoid resource contention

## Pipeline Dispatch Map

```
Sequential (must use single context):
  PM → Designer → Architect

Parallel (can dispatch):
  Architect done
    ├── task(Backend, "Implement API")
    └── task(Frontend, "Build UI")

Sequential (must wait for both):
  Backend ✅ + Frontend ✅ → QA

Final:
  QA ✅ → Delivery Director → CEO Brief
```

## Anti-Patterns

- ❌ Dispatching tasks with hidden dependencies (e.g. Backend task needs Frontend decision)
- ❌ Too many agents on the same codebase (file conflicts)
- ❌ Vague tasks — "fix the bugs" is not a task. "Fix test failures in auth.test.ts" is.
- ❌ Dispatching for trivial work — overhead > benefit
