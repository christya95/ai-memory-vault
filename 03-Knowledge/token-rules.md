# Token rules (every tool)

Vault: `/Users/joss/Obsidian/AI-Memory`.

## Start
1. Read `01-Active-State/_state.md`, then the one project note it names. Project unclear: `00-Index/_index.md`.
2. Open only the files that note names. For anything else, search for the symbol and read the matching line range.

## Never
- List a whole directory tree, read a whole log or a large file, or re-read old chats to rebuild context.
- Read `node_modules`, `.git`, lockfiles, build output, caches, binaries.

## Logs
- Filter first: the last 30 lines, or the lines matching `error`.
- Keep the summary (cause, file, fix) in `02-Logs-And-Summaries/`. Never the raw log.

## Finish
- Update the project's state note in place: rewrite `Now` and `Next`. Keep it under 60 lines.
- Update `_state.md` (active project, last session, one line).
- A finding worth reusing goes in `03-Knowledge/<topic>.md`, under 40 lines.

## Quality guard
- A state note is a pointer, not evidence. The repository wins on any disagreement; fix the note.
- Check at the source anything costly to get wrong: deploy state, whether something was sent or submitted, anything dated.
- A project's own instructions (`AGENTS.md`, required handoff reads) still apply.

## Never store
Secrets, tokens, cookies, private personal data, pasted file contents. Paths and names only.

## Output
Brief and structured. No filler.
