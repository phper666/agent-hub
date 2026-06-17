---
name: evolution-guide
description: Sprint-level feedback aggregation and role evolution guide. Use after sprint completion to collect self-evaluations and propose role improvements.
---

# Evolution Guide — Role Self-Improvement

> After each sprint, aggregate feedback and drive role evolution. Roles get better with use.

## When to Load This Skill

| Role | Phase | Load? |
|------|-------|:-----:|
| Delivery Director | Sprint completion | ✅ Load full |
| All others | All | ❌ Skip |

## Feedback Collection

After each sprint, collect all self-evaluations:

1. Scan `docs/current/feedback/` for `*-self-eval.md` files
2. Aggregate into `docs/sprints/sprint-N/evolution-notes.md`
3. Categorize each suggestion:

| Category | Target | Example |
|----------|--------|---------|
| SKILL.md change | Role framework | "Workflow step ordering should change" |
| Expert update | Expert file | "Missing guidance on OAuth2 best practices" |
| Rule adjustment | Shared rule | "security-rules too strict for internal tools" |
| New pattern needed | Architecture | "Need a data-pipeline pattern" |

## When to Propose Changes

| Trigger | Action |
|---------|--------|
| Same suggestion appears in 2+ sprints | Propose to user: update the role or shared rule |
| A rule is flagged as unhelpful 3+ times | Propose removal or modification |
| An expert is never selected over 5+ sprints | Propose deprecation |
| A new workflow pattern emerges | Propose new architecture pattern |

## CEO Review Template

After aggregation, present to CEO:

```
📊 Sprint N Feedback Summary

**Self-evaluations collected**: N
**Unique suggestions**: N
**Recurring (appeared 2+ sprints)**:
- [suggestion] — proposed action: [action]

**Unused experts (5+ sprints)**:
- [expert name] — consider deprecation

**New pattern suggestions**:
- [pattern idea] — worth exploring?

**Should we apply any changes?**
```

## Integration

This guide is loaded by Delivery Director at sprint completion (Phase 5 of orchestration).
The aggregated `evolution-notes.md` serves as input for:
- `agent-hub role edit <name>` — manual role refinement
- GitHub issues — community-driven improvement proposals
- Next sprint planning — avoid repeating known pain points
