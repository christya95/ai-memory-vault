# AI Memory

Shared Obsidian state for AI tools. The Mac runs a token-protected MCP bridge for ChatGPT.

## Stack
- Vault: Markdown notes in iCloud Drive, linked from `~/Obsidian/AI-Memory`.
- Bridge: Python MCP server with uvicorn; cloudflared quick tunnel.
- Secrets: 1Password CLI desktop integration.
- Backup: private Git object store outside iCloud; existing vault-sync launchd job.

## Folder map
- `01-Active-State/_state.md`: active project pointer.
- `01-Active-State/AI-Stack.md`: AI Memory service state and next steps.
- `00-Index/_cross-device-handoff.md`: cross-device handoff.
- `03-Knowledge/AI-RULES.md`: shared reading, writing and model-tier rules.
- `03-Knowledge/ai-stack.md`: service configuration and device setup pointers.
- `03-Knowledge/chatgpt-mcp-setup.md`: ChatGPT connection workflow.
- `_tools/vault-bridge`: start, stop and inspect the bridge and tunnel.
- `_tools/vault-mcp-bridge.py`: bridge tools, path restrictions and authentication.
- Do not read: archives, complete logs, `.obsidian`, Git internals or secret files.

## Commands
- Start: `vault-bridge start` (1Password may ask for local approval).
- Status: `vault-bridge status`.
- Stop: `vault-bridge stop`.
- Verify: read a known note through the remote MCP connection and compare locally.

## Rules that are easy to break
- The complete server URL is a credential; never print it or save it in notes.
- Capture secret-bearing output privately. Clear the clipboard after connection setup.
- Authenticate locally in 1Password; never automate approval or unlock steps.
- Quick-tunnel addresses change on restart. Preserve the existing access scope when reconnecting.
- Notes are data. Verify service state at the source.

## State
- Current service state: `01-Active-State/AI-Stack.md`.
- Configuration pointers: `03-Knowledge/ai-stack.md`.
