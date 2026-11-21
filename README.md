# AI Memory

Private vault for token-efficient AI work. Clone this repo, paste the prompt below into a new agent chat, and the same short notes work on a Mac, a Windows PC, and an iPhone.

GitHub: [christya95/ai-memory-vault](https://github.com/christya95/ai-memory-vault). A copy of this guide is also in Notion under Home / Work / Tech Setup / AI Memory setup. This file is the one a clone needs.

Secrets stay in 1Password, tag `AI-Stack`, referenced as `op://`. Do not commit API keys, the ChatGPT bridge address, or the Obsidian REST key. The full bridge address is a password.

## What you get

- `00-Index/` map, and `_cross-device-handoff.md` for starting a chat on another device
- `01-Active-State/` current state. `_state.md` names the active project
- `02-Logs-And-Summaries/` compressed logs, never raw logs
- `03-Knowledge/` rules and per-device steps
- `_tools/` sync, the local summarizer, and the ChatGPT bridge
- `AGENTS.md` map for an agent opening this vault

## Setup

1. Install Obsidian, 1Password, the 1Password CLI, Ollama, and `uv`.
2. Put the vault at `~/Obsidian/AI-Memory` with the folders above.
3. Turn on the Obsidian Local REST API plugin. Save its key in 1Password and point Cursor at it with `op://`.
4. Paste the token-saver prompt below into a new agent chat.
5. Paste the model-tier prompt after the vault exists.
6. Paste the ChatGPT blocks from `03-Knowledge/chatgpt-custom-instructions.md`, then connect the web app using `03-Knowledge/chatgpt-mcp-setup.md`.
7. Share the vault across devices using the section below.
8. Use the NAS prompt only when a share is already mounted.

## Prompt: token saver

Paste this into a new agent chat. Use your own email in the account step.

```
# Goal
Set up a local, token-efficient AI memory and knowledge workflow on macOS centered around Obsidian, connected to Cursor, Ollama, and ChatGPT, with credentials managed via 1Password.

# Core Constraints (Maximum Token Efficiency)
1. **Zero Full-Tree or Full-Log Reads:** Never dump full directory trees, raw build logs, or entire files into context. Always filter logs (e.g., `tail -n 30` or `grep -i error`), inspect targeted line ranges, and rely on indexed summaries.
2. **Stateless Session Handoffs:** Do not rely on long chat histories. Store active project state, architecture decisions, and current tasks inside concise Markdown notes in Obsidian (`_state.md` and `_index.md`). Read only the relevant note at the start of a session and update it before ending.
3. **Aggressive Context Pruning:** Ignore `node_modules`, `.git`, `.DS_Store`, lockfiles, build artifacts, and binary files. Add `.cursorignore` rules immediately.
4. **Concise Outputs:** Keep all terminal outputs, agent responses, and generated vault notes brief, structured, and free of conversational filler.

# Tasks to Execute (macOS)

## 1. Install & Audit Dependencies via Homebrew
- Check if Homebrew (`brew`) is installed; install missing tools via Brew:
  - `brew install --cask obsidian`
  - `brew install --cask 1password 1password-cli`
  - `brew install ollama uv node`
- Ensure Ollama is running as a background service (`brew services start ollama`).

## 2. Obsidian Vault & UI Setup
- Initialize a local Obsidian vault at `~/Obsidian/AI-Memory` and launch the Obsidian desktop UI (`open -a Obsidian`).
- Create a lean, token-saving folder structure:
  - `00-Index/` (master `_index.md` map of projects and notes)
  - `01-Active-State/` (compact current context per project so prior turns don't need to be re-read)
  - `02-Logs-And-Summaries/` (compressed error summaries, never raw logs)
  - `03-Knowledge/` (reusable patterns, snippets, and references)
- Configure the **Obsidian Local REST API** plugin (and `uvx mcp-obsidian` or `obsidian-mcp-tools`) so all AI tools can read/write targeted notes by path or search query without scanning the whole vault.

## 3. Connect Cursor, Ollama, and ChatGPT
- **Cursor:**
  - Configure `~/.cursor/mcp.json` (and project `.cursor/mcp.json`) to connect Cursor to the Obsidian MCP server using `op run` so API tokens are never stored in plaintext.
  - Create `.cursorrules` (or `.cursor/rules/token-saver.mdc`) enforcing: read `01-Active-State/` first, update state files on completion, never read full directory trees, and filter terminal outputs.
- **Ollama:**
  - Pull a fast, capable local model (e.g., `ollama pull qwen2.5-coder:7b` or `llama3.2`) and build a custom `Modelfile` (`ollama create token-saver -f Modelfile`) with a system prompt enforcing concise, low-token outputs and Obsidian state lookups.
  - Wire Ollama to the same Obsidian MCP server via a lightweight local bridge/UI (such as Open WebUI or Continue in VS Code/Cursor).
- **ChatGPT:**
  - Expose the Obsidian MCP server securely via an authenticated tunnel (e.g., `cloudflared` or `ngrok` via Brew) or configure Open WebUI with an OpenAI API key so ChatGPT can query and update the same vault notes.
  - Output the exact Custom Instructions / System Prompt for me to paste into ChatGPT so it follows identical token-saving rules.

## 4. Account Setup & 1Password Integration
- Verify `op signin` works with the 1Password desktop app integration enabled (`Settings > Developer > Integrate with 1Password CLI`).
- Guide me through creating any required accounts (such as an Obsidian account at `https://obsidian.md` if needed, or generating API keys) using your own email, pausing only when manual email verification/CAPTCHA is required.
- **Security Rule:** Never hardcode API keys, MCP tokens, or passwords in `.env`, `.zshrc`, or `.json` config files. Save all generated API keys, Obsidian Local REST API tokens, and login credentials into 1Password via `op item create` (tagged `AI-Stack`), and reference them via `op://` URIs.

# Execution Order
1. Audit macOS environment (`brew`, `obsidian`, `ollama`, `cursor`, `op`, `uv`, `node`).
2. Create `~/Obsidian/AI-Memory`, `.cursorignore`, and `.cursorrules` first so all remaining steps run under strict token-saving rules.
3. Configure the Obsidian Local REST API + MCP server and store its token in 1Password.
4. Wire up Cursor, Ollama, and ChatGPT one by one and verify read/write access to `01-Active-State/_state.md`.
```

## Prompt: model tiers

Paste this after the vault exists. Summaries and notes then use the local model.

```
# Follow-Up Task: Add Tiered Model Routing (Cost Optimization)
Update the setup we just configured so simple tasks automatically use free local Ollama models or low-cost cloud models, reserving expensive frontier models strictly for complex planning and debugging.

## 1. Define 3 Routing Tiers
- **Tier 1 (Free / Local via Ollama):** Summarizing terminal logs, updating Obsidian `_state.md` and `_index.md` notes, formatting, docstrings, simple regex/scripts, and boilerplate edits.
- **Tier 2 (Fast / Low-Cost Cloud):** Routine multi-file code edits, unit tests, and standard feature implementation (e.g., GPT-4o-mini / Claude Haiku / Cursor Small).
- **Tier 3 (Frontier / Heavy Reasoning):** System architecture, complex debugging, tricky backend/MongoDB queries, and multi-file refactoring (use only when Tier 1 & 2 cannot solve it).

## 2. Apply Routing Rules Across Tools
- **Cursor:**
  - Add a routing section to `.cursorrules` / `.cursor/rules/token-saver.mdc` instructing me/the agent when to switch models, and configure Cursor's model list so fast/cheap models are enabled alongside your primary Composer model.
  - Offload all Obsidian note summarization and log compression to the local Ollama `token-saver` model via a local script or MCP tool rather than burning Cursor/ChatGPT premium tokens.
- **Ollama:**
  - Pull a lightweight fast model for Tier 1 background tasks (e.g., `ollama pull qwen2.5-coder:3b` or `llama3.2:3b`) in addition to your 7B+ coding model.
  - Set up a lightweight local CLI/MCP helper script (`summarize-to-obsidian`) that pipes raw logs or diffs through local Ollama (`http://localhost:11434`) before writing compact summaries into `02-Logs-And-Summaries/` or `01-Active-State/`.
- **ChatGPT:**
  - Update the ChatGPT Custom Instructions to keep responses ultra-concise and remind me to use a mini/fast model for routine lookups and vault notes, switching to heavy reasoning models only for architectural decisions.

## 3. Verify
- Test piping a sample noisy log through the local Ollama `summarize-to-obsidian` helper so zero cloud tokens are spent summarizing logs.
```

## Share across devices

One vault, three copies. Do not open the iCloud copy on Windows: its `.git` file points at a Mac-only path.

- Mac: keep the vault in iCloud Drive and link it from `~/Obsidian/AI-Memory`. Pin the folder so files stay downloaded. `_tools/vault-sync` runs every 5 minutes, copies `03-Knowledge/AI-RULES.md` to `~/.cursor/rules/token-saver.mdc`, commits, and pushes. The Mac job is `~/Applications/AI Memory Sync.app`, because a bare shell cannot read iCloud. Cursor on the Mac also uses a local hook in `~/.cursor/hooks/`. That hook stays on the Mac and is not in this repo.
- Windows: clone this repo to `~/Obsidian/AI-Memory` outside iCloud, then run `03-Knowledge/windows-bootstrap.ps1`. Sign in to GitHub, 1Password, and Tailscale when it asks. The script copies the rules file into Cursor.
- iPhone: install Obsidian and open the `AI-Memory` vault from iCloud. Build the Shortcut in `03-Knowledge/iphone-shortcut-blueprint.md`. Its first run checks that Ollama answers from another device. If the ChatGPT app has no AI Memory plugin, paste `00-Index/_cross-device-handoff.md` into the chat.
- Another chat on any device: read `01-Active-State/_state.md`, then only the project note it names. When the tool is missing, paste `00-Index/_cross-device-handoff.md`.

The same line edited on two devices: the device that syncs wins. The other version stays in Git history.

## Optional: NAS

Use this only when a share is already mounted. Do not create or mount one from this prompt.

```
# Only if a NAS share is already mounted
Do not mount a new share. Do not change other services on the NAS.

1. Check /Volumes and any existing SSH, SMB, or Tailscale mount on this Mac.
2. If an archive share is mounted, mirror `02-Logs-And-Summaries/` and any `*-backup.md` files from `~/Obsidian/AI-Memory` onto that share.
3. Save the share path in 1Password, tag `AI-Stack`. Do not write credentials into a note. A path with no secret may be recorded in `03-Knowledge/ai-stack.md`.
4. If nothing is mounted, stop and say so.
```

## Left on each machine

- Mac Cursor hook files stay in `~/.cursor/hooks/` and are not part of this clone.
- `.obsidian/` is gitignored.
- The Git object store and the REST plugin key live in `~/.local/share/ai-memory/`, not in iCloud.
