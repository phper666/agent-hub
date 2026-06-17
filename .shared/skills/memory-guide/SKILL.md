---
name: memory-guide
description: Memory management guide for persistent context across conversations. Use when starting a session, ending a session, or when asked to remember/recall user facts or project context.
---

# Memory Management Guide (based on supermemory 27k stars)

> Source: https://github.com/supermemoryai/supermemory
> Progressive Disclosure: SKILL.md (core) → references/memory-types.md (details) → references/memory-format.md (storage)

## When to Load This Skill

| Role | Phase | Load? |
|------|-------|:-----:|
| PM | Session start | ✅ Load full |
| PM | During work | ⚠️ Read SKILL.md only |
| Designer | Session start | ✅ Load full |
| Frontend | Session start | ✅ Load full |
| Backend | Session start | ✅ Load full |
| QA | Session start | ✅ Load full |
| Delivery Director | Sprint start/end | ✅ Load full + references |
| Router | Session start | ⚠️ Read SKILL.md only |

## Core Principles

1. **Auto-extract**: AI should automatically extract important facts from conversation
2. **Time-aware**: New facts override old ones (e.g., "I moved to SF" replaces "I live in NY")
3. **Auto-forget**: Temporary info expires (e.g., "I have an exam today" → expires tomorrow)
4. **Conflict resolution**: New info wins over old info

## What to Save
- ✅ User preferences ("I prefer TypeScript", "I use Vim")
- ✅ Project info ("tech stack is Bash + YAML")
- ✅ Decision records ("we chose X because of Y")
- ✅ Problem → solution pairs

## What NOT to Save
- ❌ Small talk, casual chat
- ❌ Temporary debug info
- ❌ Duplicate information
- ❌ Noise

## Progressive Loading

- **SKILL.md (this file)**: Core principles, when-to-load, save/don't-save rules. Always safe to load (~30 lines).
- **references/memory-types.md**: Detailed memory categories with examples. Load when setting up a new session context.
- **references/memory-format.md**: Markdown and YAML storage format examples. Load when implementing memory storage.
