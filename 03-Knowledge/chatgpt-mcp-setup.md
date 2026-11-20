# ChatGPT: connect to the vault over MCP

Tested from the Mac on 2026-11-20 through the public tunnel address: read and write work with the token, 404 without it. Not tested: the ChatGPT side.

## What ChatGPT gets
Four tools from `_tools/vault-mcp-bridge.py`: `list_notes`, `read_note`, `search_notes`, `write_note`. Markdown notes only. It can read the four numbered folders. It can write only under `01-Active-State/`, `02-Logs-And-Summaries/` and to `00-Index/_cross-device-handoff.md`. It cannot change rules, scripts or Obsidian settings.

## Limits to know first
- ChatGPT accepts OAuth or no authentication for a custom MCP server. It has no field for a bearer token. So the token is the first part of the address: anyone who has the full address can read and write those notes. Treat the full address as a password.
- The address changes every time the tunnel starts (free `cloudflared` quick tunnel). After a restart, update the address in ChatGPT.
- OpenAI's docs say custom MCP servers are added on the web and are not offered in the mobile apps. Plus is listed for the web; whether Plus may use write tools is described inconsistently. Test it (below).

## Start it (Mac)
1. `vault-bridge start` (approve the 1Password prompt). It prints `https://<name>.trycloudflare.com/<token>/mcp`.
2. Copy the token: `op read op://AI-Stack/Obsidian-MCP-Tunnel/token | pbcopy`
3. Build the full address by replacing `<token>`. Do not save the full address in a note.
4. `vault-bridge stop` when done. `vault-bridge status` and `vault-bridge url` show the state.

## Add it in ChatGPT (web)
1. Open `https://chatgpt.com/plugins`. If ChatGPT asks for Developer mode, turn it on where it points you (Settings, Apps and Connectors).
2. Plus button, Add custom MCP server. Name: `AI Memory`.
3. Connection: Server URL. Paste the full address.
4. Authentication: No authentication.
5. Accept the risk warning, Create as a plugin, then install it.

## Verify
In a new chat, type `@AI Memory` and send each line:
1. `Use AI Memory read_note on 00-Index/_index.md and show the first 5 lines.`
2. `Use AI Memory write_note, mode append, path 01-Active-State/_state.md, content "- chatgpt-write-check".` Approve the write. On the Mac: `tail -n 1 ~/Obsidian/AI-Memory/01-Active-State/_state.md`, then delete that line.
3. iPhone app: open the same chat, or type `@AI Memory`. If the plugin is not listed, the app does not support it; use `00-Index/_cross-device-handoff.md` by paste instead.

If step 2 is refused while step 1 works, the plan allows read tools only.

## A better route when you want it permanent
OpenAI's Secure MCP Tunnel needs no public address: a `tunnel-client` on the Mac calls out to OpenAI, and access follows your OpenAI account. It needs a `tunnel_id` and a runtime key from your OpenAI Platform account (Platform, tunnel settings). Not set up. Store the key as `op://AI-Stack/OpenAI-Tunnel-Client/credential` and ask an agent to wire `tunnel-client` to the bridge.
