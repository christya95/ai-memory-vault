# AI stack

Updated 2026-11-20. No secret is written here or in any config file.

## Parts
- Vault: `~/Obsidian/AI-Memory`. Rules: `03-Knowledge/AI-RULES.md`.
- Location: the vault folder is in iCloud Drive (`~/Library/Mobile Documents/iCloud~md~obsidian/Documents/AI-Memory`); `~/Obsidian/AI-Memory` is a link to it. The iPhone gets it through iCloud. The folder is set to Keep Downloaded (2026-11-20; check: `fileproviderctl evaluate <folder> | grep isKeepDownloaded`).
- Windows uses a Git clone outside iCloud Drive, never the iCloud copy: that copy's `.git` is a pointer to a Mac-only path.
- Backup and Windows: private Git repository `christya95/ai-memory-vault`. `_tools/vault-sync` runs every 5 minutes on the Mac (launchd `md.obsidian.ai-memory-sync`, log `~/.local/state/ai-memory/sync.log`) and refreshes `~/.cursor/rules/token-saver.mdc`. Git ignores `.obsidian/`. Same line changed on two devices: the syncing device wins, the other version stays in Git history.
- The launchd job runs `~/Applications/AI Memory Sync.app`, a wrapper around `vault-sync`. macOS refuses a bare `/bin/bash` background job access to iCloud Drive ("Operation not permitted"); the app has its own permission. Rebuilding the app can make macOS ask again.
- Kept off iCloud, in `~/.local/share/ai-memory/`: the Git object store (`vault.git`; iCloud corrupts a `.git` folder) and the REST plugin folder with its key. The vault holds a `.git` pointer file and a link for each.
- Ollama on the Mac (Ollama app): listens on `127.0.0.1:11434` only ("Expose Ollama to the network" is off). `tailscale serve --tcp 11434` forwards the tailnet address to it, so tailnet devices reach it and the local network does not. Undo: `tailscale serve --tcp=11434 off`. Codex on the Mac uses `127.0.0.1:11434`; do not bind Ollama to another address. Models: `token-saver` (3B, summaries), `gpt-oss:20b` (tools), `qwen3.8:27b`, `gemma4:26b`, `gemma4:e4b`.
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
- `vault-bridge start` (started 2026-11-20 18:10; the address changes at every start, and the tunnel ends when the Mac restarts), then add the server as in `chatgpt-mcp-setup.md` and run its three checks. Copy the full address without showing it: `printf '%s/%s/mcp' "$(cat ~/.local/state/ai-memory/tunnel-url)" "$(op read op://AI-Stack/Obsidian-MCP-Tunnel/token)" | pbcopy`.

Windows PC
- Copy `windows-bootstrap.ps1` to the PC (it is in the GitHub repository) and run it. Sign in to GitHub, 1Password and Tailscale when it asks.

iPhone
- Install Obsidian and open the `AI-Memory` vault from iCloud.
- Build the Shortcut from `iphone-shortcut-blueprint.md`. Its first run is also the check that Ollama answers over Tailscale from another device.

Mac
- Cursor, Settings, Models: enable a fast low-cost model next to the main one.
- Cursor loads `~/.cursor/rules/token-saver.mdc` in every project (seen loaded 2026-11-20). Still open: replace the User Rules in Cursor Settings with the short version (the UI, MongoDB view and Hytale rule sets now live in personal skills `anti-ai-slop-ui`, `mongodb-schema-mapper`, `hytale-double-jump`), and remove unused plugins and MCP servers; all of these load on every request.
- No NAS share is mounted on this Mac, so archives are not mirrored there. Mount one and ask again.
