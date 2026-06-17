---
name: kanban-protocol
description: Multi-request Kanban management for sprint-level coordination. Use when managing 2+ requirements in parallel, tracking progress across roles, or setting up a new sprint.
---

# Kanban Protocol

> Source: agent-hub v3.0.0 Expert Legion
> Multi-request, multi-role, parallel sprint coordination

## Core Concept

Instead of a single pipeline (PM→Designer→...→Done), the Kanban manages multiple requirements simultaneously. Each REQ flows through the pipeline independently. The delivery director's job is to maximize parallelism while respecting dependencies.

## Sprint Directory Structure

```
docs/sprints/sprint-1/
├── roadmap.md          # Sprint goals, timeline, REQ inventory
├── kanban.md           # Live status of every REQ (automatically updated)
├── REQ-001-login/
│   ├── status.md       # This REQ's pipeline status
│   ├── PRD.md
│   ├── design/
│   ├── architecture/
│   └── implementation/
├── REQ-002-register/
│   └── ...
└── REQ-003-homepage/
    └── ...
```

## Creating a New Sprint

When the CEO gives you a batch of requirements:

### Step 1: Create Sprint Roadmap

```markdown
# Sprint 1 — Roadmap
**Created**: 2025-06-16
**CEO Request**: [Original CEO message]
**Goals**: [Sprint-level success criteria]

## REQ Inventory

| REQ ID | Name | P0/P1/P2 | Dependencies | Estimated Complexity | Notes |
|--------|------|:--------:|-------------|:--------------------:|-------|
| REQ-001 | User Login | P0 | None | M | Core auth flow |
| REQ-002 | User Register | P0 | REQ-001 (auth API) | M | Needs login first for session |
| REQ-003 | Homepage Redesign | P1 | None | S | Visual only |
| REQ-004 | Search | P2 | REQ-001 (auth) | L | Full-text, needs indexing |

**Phase Plan**:
- Phase 1 (REQ-001 → REQ-002): Login first (unblocks everything), then Register
- Phase 2 (REQ-003): Homepage in parallel with Register
- Phase 3 (REQ-004): Search after core auth is stable
```

### Step 2: Initialize Kanban

```markdown
# Sprint 1 — Kanban
**Last Updated**: 2025-06-16 14:30

| REQ | Name | PM | Designer | Architect | Backend | Frontend | QA | Done |
|-----|------|:--:|:--------:|:---------:|:-------:|:--------:|:--:|:----:|
| R01 | Login | 🔄 | ⏳ | ⏳ | ⏳ | ⏳ | ⏳ | ⬜ |
| R02 | Register | ⏳ | ⏳ | ⏳ | ⏳ | ⏳ | ⏳ | ⬜ |
| R03 | Homepage | 🔄 | ⏳ | ⏳ | ⏳ | ⏳ | ⏳ | ⬜ |

**Legend**: ⏳ Pending | 🔄 In Progress | ✅ Done | ❌ Blocked | ⬜ Not Started

**Blockers**: None yet

**Parallel Opportunities**:
- After REQ-001 PM ✅ → REQ-002 PM + REQ-003 PM can run together
- After all Architecture ✅ → all Backend + all Frontend can run together (6 parallel tasks!)
```

### Step 3: Push to Next Stage

When a wave completes, scan the Kanban for all "Ready" items and dispatch:

```markdown
# Wave Dispatch — 2025-06-16 15:00

**Current State**: All 3 PM tasks done
**Ready for Designer**: REQ-001, REQ-002, REQ-003
**Action**: Batch dispatch 3 Designer subagents in parallel
```

## Parallel Dispatch Rules

| Condition | Rule |
|-----------|------|
| Same role, different REQs | ✅ Parallel — no shared state |
| Same REQ, different roles | ❌ Sequential — later role depends on earlier output |
| REQ-X depends on REQ-Y | ⚠️ REQ-X waits until REQ-Y reaches the dependency point |
| Independent REQs, same stage | ✅ Parallel — maximal throughput |

## Tracking a Single REQ

Each REQ directory has its own `status.md` tracking the classic pipeline:

```markdown
# REQ-001: User Login — Status

| Role | Status | Output | Updated |
|------|--------|--------|---------|
| PM | ✅ Done | PRD.md | 2025-06-16 14:00 |
| Designer | 🔄 In Progress | — | — |
| Architect | ⏳ Pending | — | — |
| Backend | ⏳ Pending | — | — |
| Frontend | ⏳ Pending | — | — |
| QA | ⏳ Pending | — | — |
```

## Progress Report to CEO

```markdown
## Sprint 1 — CEO Brief

**Progress**: Wave 2/4
**Completed**:
- ✅ Wave 1 (3 PM tasks) — All PRDs ready
- ✅ Wave 2 (3 Designer tasks) — REQ-001, REQ-003 done; REQ-002 in progress

**In Progress**:
- 🔄 REQ-002 Designer (ETA: 1 hour)
- 🔄 REQ-001 Architect (just started)

**Up Next**:
- Wave 3: All 3 Architects after Designer completes
- Wave 4: 6 parallel Backend+Frontend tasks

**Blockers**: None
**CEO Action Needed**: None — all on track
```

## What You Do NOT Do
- No manual Kanban updates — let dispatched subagents output update their REQ's status
- No cross-REQ coupling — each REQ is independent unless explicitly declared
- No skipping stages — even if a REQ is "simple", it still goes through the pipeline
