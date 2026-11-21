# AI Memory

Private Obsidian vault for one person's AI tools. Notes stay short so Cursor, ChatGPT, and Ollama can resume work without rereading chats, trees, or logs.

GitHub: [christya95/ai-memory-vault](https://github.com/christya95/ai-memory-vault). The Mac copy is in iCloud Drive, linked from `~/Obsidian/AI-Memory`. Windows clones this repo outside iCloud. The setup guide, including the prompts that built this, is in Notion under Home / Work / Tech Setup / [AI Memory setup](https://app.notion.com/p/41fd622408a481368643da7fe297725e).

## Layout

- `00-Index/` map, and the one note used to start a chat on another device
- `01-Active-State/` current state. `_state.md` names the active project
- `02-Logs-And-Summaries/` compressed logs, never raw logs
- `03-Knowledge/` rules, device setup, and the Windows bootstrap script
- `_tools/` sync, the local summarizer, and the ChatGPT bridge
- `AGENTS.md` map for an agent opening this vault

## Not in this repo

- Secrets. Those are in 1Password, tag `AI-Stack`, referenced as `op://`.
- The Mac Cursor hook (`~/.cursor/hooks/`). It stays on the Mac.
- The Git object store and the Obsidian REST plugin key (`~/.local/share/ai-memory/`).
- `.obsidian/` (gitignored).

## Sync

`_tools/vault-sync` runs every 5 minutes. It copies `03-Knowledge/AI-RULES.md` to `~/.cursor/rules/token-saver.mdc`, commits, rebases, and pushes. The same line edited on two devices: the syncing device wins.

On a Mac the job is `~/Applications/AI Memory Sync.app` (launchd `md.obsidian.ai-memory-sync`). A bare shell cannot read the iCloud vault.

## Devices

- Mac: rules in `03-Knowledge/AI-RULES.md`. Cursor reads them through the local hook.
- Windows: run `03-Knowledge/windows-bootstrap.ps1`.
- iPhone: Obsidian via iCloud. Shortcut steps are in `03-Knowledge/iphone-shortcut-blueprint.md`.
- ChatGPT: `03-Knowledge/chatgpt-custom-instructions.md` and `03-Knowledge/chatgpt-mcp-setup.md`. The full bridge address is a password. Do not write it in this repo.
