# Templates

This directory contains shared templates used by the `agent-hub generate` command.

## Pattern Templates

Architecture pattern definitions are in `.shared/templates/patterns/`:
- `pipeline` — Sequential workflow (default)
- `fanout` — Parallel dispatch + merge
- `producer-reviewer` — Generate → Review → Iterate

## Adding New Templates

1. Create a YAML file in `.shared/templates/patterns/`
2. Define roles with `name`, `title`, `description`, `depends_on`, `after_complete`
3. Run `agent-hub generate <domain> --pattern <name>`
