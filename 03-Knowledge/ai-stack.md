# AI stack

Set up 2026-11-20. No secret is written here or in any config file.

## Parts
- Vault: `/Users/joss/Obsidian/AI-Memory`, open in Obsidian.
- Local REST API plugin 5.5.2: `https://127.0.0.1:27124`, this computer only. Its key is in 1Password: `op://Personal/Obsidian Local REST API/credential` (tag `AI-Stack`). The plugin keeps its own copy in `.obsidian/`, which `.cursorignore` hides from agents.
- MCP server: `mcp-obsidian==0.2.3`, started as `op run --no-masking -- uvx mcp-obsidian==0.2.3` with the `op://` reference in its environment. Loading all 15 tools costs about 2.4k tokens.
- Ollama (the Ollama app, port 11434): `token-saver` (3B, summaries), `gpt-oss:20b` (tools, chat).
- `summarize-to-obsidian` (`_tools/`, linked into `~/.local/bin`): pipes a log, diff or note through `token-saver` and saves the summary here.

## Who connects how
- Cursor: `~/.cursor/mcp.json` (server `obsidian`) and the rule `.cursor/rules/token-saver.mdc` in each project. Reads notes by path; MCP is for search.
- ChatGPT app, Codex: `~/.codex/AGENTS.md` section "AI memory vault". Reads and edits notes by path. No MCP server registered, to avoid the 2.4k tokens per session. To add it anyway: `codex mcp add obsidian --env OBSIDIAN_API_KEY="op://Personal/Obsidian Local REST API/credential" -- /opt/homebrew/bin/op run --no-masking -- /opt/homebrew/bin/uvx mcp-obsidian==0.2.3`.
- ChatGPT on the web: no access to this computer. Paste the state note in, paste the update back. Custom instructions below.
- Ollama: `summarize-to-obsidian` writes here. For chat with vault tools: the Continue extension in Cursor, `~/.continue/config.yaml` (`gpt-oss:20b` plus the same MCP server). Configured, not yet tried in its panel.

## Tiers
- Tier 1, local, free: log and diff summaries, note compression (`summarize-to-obsidian`), docstrings, simple regex, boilerplate (a local Ollama model). Formatting is the formatter, no model.
- Tier 2, fast cloud model: routine edits across files, unit tests, standard features.
- Tier 3, frontier model: architecture, hard debugging, tricky database queries, large refactors, anything that sends or submits.
- Move up a tier only when the lower one failed on the problem.

## ChatGPT custom instructions
```
Be brief. Answer first, in at most 5 short lines unless I ask for more. No preamble, no recap, no closing offer.
Code: show only the changed lines with enough context to place them. Never reprint a whole file.
Do not ask me to paste whole logs, files or directory trees. Ask for the 30 lines around the error or the one function.
My project state lives in an Obsidian vault with notes _index.md and _state.md. If I paste a state note, treat it as the full context and do not ask for chat history. When a session changes that state, end with a block titled "State update" of at most 8 lines that I can paste back: what is true now, what is next.
Never include passwords, keys or tokens in a state update.
Model reminder: if my request is a routine lookup, a note, formatting or boilerplate and I am on a heavy reasoning model, say once in one line that a mini or fast model is enough. If it is architecture, a hard bug or a risky change and I am on a mini model, say once that a reasoning model fits better.
If you are unsure, say so in one line rather than guessing.
```
