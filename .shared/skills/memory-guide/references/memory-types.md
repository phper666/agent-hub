# Memory Types

## 1. Static Facts

Long-term stable user information:

```
- User is a senior engineer
- Prefers dark mode
- Uses Vim
- Likes TypeScript
- Prefers functional programming
```

## 2. Dynamic Context

Recent activity and temporary information:

```
- Currently working on auth migration
- Debugging rate limit issues
- Has an exam today (temporary)
- Discussed API design last week
```

## 3. Project Context

Project-specific information:

```
- Project: agent-hub
- Tech stack: Bash, YAML
- Current phase: Phase 2
- Completed: 6 roles, CLI tool
```

---

## Memory Management Principles

### 1. Auto-extract

AI should automatically extract important information from conversation:

**What to extract**:
- ✅ User preferences ("I like...", "I prefer...")
- ✅ Project info ("We are working on...", "Tech stack is...")
- ✅ Decision records ("We decided...", "Chose X because...")
- ✅ Problems and solutions ("Encountered X issue, solved with Y")

**What NOT to extract**:
- ❌ Casual chat
- ❌ Temporary debug info
- ❌ Duplicate information
- ❌ Noise

### 2. Time Awareness

Memory should understand temporal relationships:

```
User: "I live in New York"
→ Memory: User lives in New York

User: "I just moved to San Francisco"
→ Memory: User lives in San Francisco (overwrites previous memory)
```

### 3. Auto-forget

Temporary information should auto-expire:

```
User: "I have an exam today"
→ Memory: User has an exam today (auto-forget tomorrow)

User: "I completed the project last week"
→ Memory: User completed the project last week (retain)
```

### 4. Conflict Resolution

When new information conflicts with old information:

```
Old memory: User prefers React
New info: I now prefer Vue
→ Update: User prefers Vue (overwrite old memory)
```
