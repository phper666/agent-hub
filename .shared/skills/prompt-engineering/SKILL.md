---
name: prompt-engineering
description: Prompt optimization for LLM quality, token efficiency, and role clarity. Use when designing or optimizing Agent instructions, SKILL.md files, and system prompts.
---

# Prompt Engineering Guide

> Optimize prompt design for LLM quality, token efficiency, and role clarity.
> Progressive Disclosure: SKILL.md (patterns) -> references/prompt-patterns.md (detailed examples)

## When to Load This Skill

| Role | Task Domain | Load? |
|------|------------|:-----:|
| All | Creating new SKILL.md | ✅ Load full |
| All | Optimizing existing role | ✅ Load full |
| All | Reviewing prompt quality | ✅ Load references/prompt-patterns.md |
| All | Other work | ❌ Skip |

## Core Principles

1. **Structure Before Content**: Frontmatter -> Load order -> Workflow. Agent needs identity first.
2. **Token Efficiency**: Tables beat paragraphs. One idea per line. Cut fluff.
3. **Role Clarity**: "You do X, you don't do Y" — positive + negative boundaries.

## Key Patterns

### Expert Selection Pattern
```markdown
## Expert Selection Guide
| Task Domain | Load | File |
|------------|------|------|
```
Saves 30-40% tokens. Agent self-selects relevant experts.

### Boundary Pattern
```markdown
## What You Do NOT Do
- No frontend implementation
- No database changes
```
Negative space defines role as strongly as positive space.

### Workflow Pattern
```markdown
### Step 1: Check Dependencies -> Read status.md
### Step 2: Read Specs -> PRD + API spec
### Step 3: Execute -> TDD cycle
```
Single-line steps with -> arrows reduce cognitive overhead.

## Optimization Checklist

When reviewing an existing role definition:
- [ ] Loading order: Dead files? Missing live files?
- [ ] Expert selection: Choosing by task domain?
- [ ] Token budget: Can sections become tables?
- [ ] Boundaries: "Do" and "Don't" both explicit?
- [ ] Input/Output: Tabular format with Source and Required columns

## Progressive Loading

- **SKILL.md (this file)**: Core principles, key patterns summary, optimization checklist. Always safe (~50 lines).
- **references/prompt-patterns.md**: Detailed pattern examples with full code. Load when designing new prompts.
