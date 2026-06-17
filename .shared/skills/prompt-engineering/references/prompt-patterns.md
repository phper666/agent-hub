# Prompt Engineering Patterns

## Expert Selection Pattern (Token-Efficient)

Full example showing how to let the agent self-select relevant experts:

```markdown
## Expert Selection Guide
| Task Domain | Load | File |
|------------|------|------|
| Architecture | X Architect | agents/agency/x-architect-expert.md |
| Database | X Optimizer | agents/agency/x-optimizer-expert.md |
| Frontend | X Developer | agents/agency/x-developer-expert.md |
| Backend | X API Designer | agents/agency/x-api-designer.md |
| Security | X Security | agents/agency/x-security-expert.md |

**Rule**: Load only the experts relevant to your CURRENT task. Max 3 at once.
```

**Why**: Saves 30-40% tokens vs loading all experts. Agent learns to self-select based on the task domain column.

---

## Boundary Pattern

Full example showing how to define what the agent does NOT do:

```markdown
## What You Do NOT Do
- No frontend implementation (HTML, CSS, React components)
- No database schema changes
- No API endpoint creation
- No deployment configuration
- No test file writing

## What You DO
- Architecture design and documentation
- Code review and quality checks
- Technical spec writing
- Dependency analysis
```

**Why**: Negative space defines role identity as strongly as positive space. The agent needs to know both its scope and its limits.

---

## Workflow Pattern

Full example of a step-by-step workflow:

```markdown
### Step 1: Check Dependencies -> Read status.md
### Step 2: Read Specs -> PRD + API spec + user stories
### Step 3: Execute -> TDD cycle (red-green-refactor)
### Step 4: Verify -> Run tests + lint
### Step 5: Commit -> Write commit message, create PR
```

**Why**: Single-line steps with -> arrows reduce cognitive overhead vs paragraphs. The arrow creates a clear progression chain.

---

## Optimizing Existing Roles

When reviewing an existing role definition, check:

- [ ] **Loading order**: Are dead files referenced? Are live files missing? Remove stale references.
- [ ] **Expert selection**: Is the guide choosing experts by task domain? Or loading everything indiscriminately?
- [ ] **Token budget**: Can any section be compressed into a table? Tables are 3-5x more token-efficient than prose.
- [ ] **Boundaries**: Are "do" and "don't" both explicit? Vague roles produce inconsistent output.
- [ ] **Input/Output**: Tabular format with Source and Required columns makes expectations explicit.

### Example Input/Output Table

```markdown
### Input
| Source | Required | Description |
|--------|----------|-------------|
| PRD | Yes | Product Requirements Document |
| API Spec | Yes | API endpoint definitions |
| User Stories | No | User story descriptions |

### Output
| Artifact | Format | Location |
|----------|--------|----------|
| Technical Spec | Markdown | docs/specs/ |
| Task List | Markdown | docs/tasks/ |
```

**Why**: Tabular input/output contracts eliminate ambiguity about what the agent needs and produces.
