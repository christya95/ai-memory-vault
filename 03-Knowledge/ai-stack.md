# AI stack

Updated 2026-11-20. No secret is written here or in any config file.

## Parts
- Vault: `~/Obsidian/AI-Memory`. Rules: `03-Knowledge/AI-RULES.md`.
- Location: the vault folder is in iCloud Drive (`~/Library/Mobile Documents/iCloud~md~obsidian/Documents/AI-Memory`); `~/Obsidian/AI-Memory` is a link to it. The iPhone gets it through iCloud.
- Backup and Windows: private Git repository `christya95/ai-memory-vault`. `_tools/vault-sync` runs every 5 minutes on the Mac (launchd `md.obsidian.ai-memory-sync`, log `~/.local/state/ai-memory/sync.log`) and refreshes `~/.cursor/rules/token-saver.mdc`. Git ignores `.obsidian/`. Same line changed on two devices: the syncing device wins, the other version stays in Git history.
- Kept off iCloud, in `~/.local/share/ai-memory/`: the Git object store (`vault.git`; iCloud corrupts a `.git` folder) and the REST plugin folder with its key. The vault holds a `.git` pointer file and a link for each.
- Ollama on the Mac (Ollama app): listens on all interfaces, port 11434, so it answers on the tailnet and also on the local network, with no password. Models: `token-saver` (3B, summaries), `gpt-oss:20b` (tools), `qwen3.8:27b`, `gemma4:26b`, `gemma4:e4b`.
- `summarize-to-obsidian`: compresses a log, diff or note with `token-saver` and saves it here. `OLLAMA_URL` picks the endpoint.
- Local REST API plugin 5.5.2 (Mac only): `https://127.0.0.1:27124`. MCP server `mcp-obsidian==0.2.3` on top of it, for Cursor and Continue.
- Vault bridge for ChatGPT: `_tools/vault-mcp-bridge.py` (4 tools, about 520 tokens of schema, limited writes) behind a `cloudflared` quick tunnel. `vault-bridge start|stop|status|url`. Off unless started.

## 1Password (tag `AI-Stack`)
- `op://AI-Stack/Ollama-Tailscale/host`: the Ollama endpoint every device uses. Change it here to move to another machine.
- `op://AI-Stack/Obsidian-MCP-Tunnel/token`: the bridge token.
- `op://Personal/Obsidian Local REST API/credential`: the REST plugin key.

## Who connects how
- Cursor (Mac): `~/.cursor/mcp.json` (server `obsidian`), `~/.cursor/rules/token-saver.mdc` (a link to `AI-RULES.md`), and a project rule in `.cursor/rules/`. Reads notes by path; MCP is for search.
- ChatGPT app, Codex (Mac): `~/.codex/AGENTS.md`, section "AI memory vault". Reads and edits notes by path.
- ChatGPT web: `chatgpt-mcp-setup.md` and `chatgpt-custom-instructions.md`.
- Ollama chat with vault tools: Continue extension in Cursor, `~/.continue/config.yaml`. Not yet tried in its panel.
- Windows PC: `windows-bootstrap.ps1`. Not yet run.
- iPhone: `iphone-shortcut-blueprint.md`. Not yet built.

## Left to do by hand
ChatGPT
- Paste the two blocks from `chatgpt-custom-instructions.md`.
- `vault-bridge start`, then add the server as in `chatgpt-mcp-setup.md` and run its three checks.

Windows PC
- Copy `windows-bootstrap.ps1` to the PC (it is in the GitHub repository) and run it. Sign in to GitHub, 1Password and Tailscale when it asks.

iPhone
- Build the Shortcut from `iphone-shortcut-blueprint.md`.

Mac
- Cursor, Settings, Models: enable a fast low-cost model next to the main one.
- Decide whether Ollama should stay open to the local network (Ollama app, Settings, "Expose Ollama to the network"). Turning it off also cuts the tailnet; the alternative is `tailscale serve`, not set up.
