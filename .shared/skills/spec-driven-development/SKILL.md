---
name: spec-driven-development
description: Spec-driven development methodology. Use when defining specs, plans, and tasks before implementation. Trigger on: "define spec", "write PRD", "create plan", "spec-driven", "constitution", "acceptance criteria".
---

# Spec-Driven Development (based on spec-kit 112k stars)

> Source: https://github.com/github/spec-kit
> Progressive Disclosure: SKILL.md (core) → references/spec-phases.md (4 phases) → references/spec-examples.md (templates)

## When to Load This Skill

| Role | Task Domain | Load? |
|------|------------|:-----:|
| PM | Writing PRD, user stories, acceptance criteria | ✅ Load full + references/spec-phases.md |
| PM | Other | ❌ Skip |
| Designer | Creating design spec, component plan | ✅ Load full |
| Frontend | Technical spec, implementation plan | ✅ Load references/spec-phases.md only |
| Backend | API spec, architecture plan | ✅ Load references/spec-phases.md only |
| QA | Test spec, test plan | ✅ Load full |
| Delivery Director | Sprint planning | ⚠️ Read SKILL.md only |
| Router | All | ❌ Skip |

## Core Principles

1. **Spec First**: Spec is a first-class artifact, not optional documentation
2. **Scenario-Driven**: Focus on product scenarios and predictable outcomes
3. **Progressive Disclosure**: Define high-level spec first, refine gradually
4. **Executable**: Spec should be clear enough to generate code directly

## The 4 Phases (Overview)

| Phase | Output | Owner |
|-------|--------|-------|
| 1. Constitution | Project principles, quality gates | PM |
| 2. Specify | Product spec (what + why) | PM |
| 3. Plan | Implementation plan (how) | PM + Architect |
| 4. Tasks | Actionable task breakdown | PM + All roles |

## Good Spec vs Bad Spec

**Good**: Clear input/output, processing logic, acceptance criteria, edge cases.
**Bad**: Vague one-liner ("users can register with email and password").

> For detailed phase guides and templates, load `references/spec-phases.md`.
> For concrete examples of good vs bad specs, load `references/spec-examples.md`.

## Progressive Loading

- **SKILL.md (this file)**: Core principles, 4-phase overview, when-to-load table. Always safe (~40 lines).
- **references/spec-phases.md**: Detailed breakdown of each phase with templates. Load when writing specs/plans.
- **references/spec-examples.md**: Complete good/bad spec comparison. Load when unsure about spec quality.
