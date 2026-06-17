# Memory Storage Format

## Markdown Format

```markdown
# User Memory

## Static Facts
- Senior engineer
- Prefers TypeScript
- Prefers functional programming
- Uses Vim

## Dynamic Context
- Currently working on agent-hub project
- Current phase: Phase 2
- Last discussion: 2024-01-15

## Project Context
### agent-hub
- Tech stack: Bash, YAML
- Status: Phase 2 complete
- Next: Phase 3

## Decision Log
- 2024-01-15: Decided to refactor frontend with Vue
- 2024-01-10: Completed all Phase 2 steps
```

## YAML Format

```yaml
user:
  static_facts:
    - role: senior_engineer
    - prefers: typescript
    - style: functional
    - editor: vim
  dynamic_context:
    - project: agent-hub
    - phase: phase-2
    - last_discussion: 2024-01-15

projects:
  agent-hub:
    stack: [bash, yaml]
    status: phase-2-complete
    next: phase-3

decisions:
  - date: 2024-01-15
    decision: use-vue-for-frontend-refactor
  - date: 2024-01-10
    decision: complete-phase-2
```

---

## Integration with Agent Hub

### Shared Across All Roles

This memory management guide is auto-injected into all roles via `.shared/skills/`:

1. **PM**: Remember product requirements and user feedback
2. **Designer**: Remember design preferences and style guides
3. **Frontend**: Remember tech stack and framework preferences
4. **Backend**: Remember architecture decisions and API design
5. **QA**: Remember testing strategies and quality standards
6. **Router**: Remember user role preferences and project phases

### Usage Guide

1. **Session start**: Load `docs/current/memory.md`
2. **During session**: Actively record important information
3. **Session end**: Update `docs/current/memory.md`

---

## Recommended Tools

### MCP Server

```bash
# Install supermemory MCP server
npx -y install-mcp@latest https://mcp.supermemory.ai/mcp --client claude --oauth=yes
```

### Local Deployment

```bash
# Run supermemory locally
curl -fsSL https://supermemory.ai/install | bash
```

### API Usage

```javascript
import Supermemory from "supermemory";

const client = new Supermemory();

// Store conversation
await client.add({
  content: "User likes TypeScript, prefers functional programming",
  containerTag: "user_123",
});

// Get user profile
const { profile } = await client.profile({
  containerTag: "user_123",
});

// profile.static  → ["likes TypeScript", "prefers functional programming"]
// profile.dynamic → ["currently working on API integration"]
```

---

## Best Practices

### DO (Recommended)

- ✅ Auto-extract important information from conversation
- ✅ Understand temporal relationships, update outdated info
- ✅ Auto-forget temporary information
- ✅ Resolve information conflicts
- ✅ Reference relevant memories in responses
- ✅ Organize memories by project

### DON'T (Avoid)

- ❌ Record all conversation content
- ❌ Keep outdated information
- ❌ Ignore temporal relationships
- ❌ Repeatedly record the same information
- ❌ Record noise and casual chat
- ❌ Mix memories across different projects
