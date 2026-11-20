# AGENTS.md template (repo map)

Copy to a project root as `AGENTS.md`. Keep it under 100 lines. Paths and names only: an agent reads this instead of exploring.

```markdown
# <Project>

One or two sentences: what it does and for whom.

## Stack
- Backend: <language, framework, version>
- Database: <MongoDB version, database name, how it is reached>
- Frontend: <framework or "server-rendered templates">
- Deploy: <where and how>

## Folder map
- `src/<pkg>/<area>/`: <what lives here, one line>
- `src/<pkg>/<area>/`: <...>
- `tests/`: <layout, fixtures folder>
- `docs/`: <which file holds current state>
- Do not read: <generated folders, large files, logs>

## Data (MongoDB)
- `<collection>`: <what one document is>. Key fields: `<field>`, `<field>`. Indexes: `<fields>`.
- `<collection>`: <...>
- Schema source: `<path to models or validators>`

## Key routes
- `GET /<path>`: <handler file>, <what it returns>
- `POST /<path>`: <handler file>, <what it changes>

## Commands
- Setup: `<command>`
- Run: `<command>`
- Test: `<command>` (one test: `<command>`)
- Lint: `<command>`

## Rules that are easy to break
- <rule, one line>

## State
- Current state and next steps: `~/Obsidian/AI-Memory/01-Active-State/<Project>.md`
- Token rules: `~/Obsidian/AI-Memory/03-Knowledge/AI-RULES.md`
```
