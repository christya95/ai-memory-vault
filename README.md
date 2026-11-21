# 🧠 AI Memory

Give your AI a notebook, not your entire chat history.

This is a small Obsidian vault. Each project keeps one short note about where things stand. The next chat reads that note and gets on with the work. You spend fewer tokens, and you can pick the chat up on another device.

You do not need the same computer, the same apps, or the same accounts as anyone else. Use what you already have. Tell the agent to skip anything you do not want installed.

## 🌱 What you need

| You need | Why |
| --- | --- |
| [Obsidian](https://obsidian.md) | The notebook. It is free for local vaults. |
| One coding agent | Cursor, or another agent that can read a folder. |
| A way to sync a folder | Git, iCloud, Obsidian Sync, or a shared drive. Pick one. |

Nice to have, not required:

- 🤖 A local model such as [Ollama](https://ollama.com), for summaries that cost nothing
- 🔐 A password manager, so keys never land in the repo
- 💬 ChatGPT, if you want the same notes in a browser chat
- 🗄️ A NAS, only if you already have one and want old logs parked there

## 🗂️ The notebook

Create a folder named `AI-Memory` and put these inside it:

| Folder | What goes here |
| --- | --- |
| `00-Index/` | A map of your projects, plus one handoff note for another device |
| `01-Active-State/` | One short "where I am" note per project |
| `02-Logs-And-Summaries/` | Short error summaries. Never a raw log. |
| `03-Knowledge/` | Facts you want to reuse |
| `_tools/` | Small scripts, if you add any |

Start of a chat: open `01-Active-State/_state.md`, then only the one project note it names.

End of a chat: update that note. A later chat should not need this one.

## 🚀 Set it up

1. Install Obsidian and create the vault folder above.
2. Open a new agent chat in that folder.
3. Paste **Prompt 1**. Tell the agent your operating system and which apps you already use.
4. When the vault exists, paste **Prompt 2** if you want cheap or local models for the easy jobs.
5. Sync the folder with whatever you chose in the table above.
6. The NAS prompt is last, and only if a share is already mounted.

Say no if the agent wants to install something you did not ask for.

## ✨ Prompt 1 · build the notebook

```
# Goal
Set up a local, token-efficient AI memory in Obsidian. Connect it to the AI tools I already use. Adapt every step to my operating system. Do not install a program I did not agree to. If I do not have a tool you mention, skip it and tell me what I miss.

# Core Constraints (Maximum Token Efficiency)
1. **Zero Full-Tree or Full-Log Reads:** Never dump full directory trees, raw build logs, or entire files into context. Always filter logs (e.g., `tail -n 30` or `grep -i error`), inspect targeted line ranges, and rely on indexed summaries.
2. **Stateless Session Handoffs:** Do not rely on long chat histories. Store active project state, architecture decisions, and current tasks inside concise Markdown notes in Obsidian (`_state.md` and `_index.md`). Read only the relevant note at the start of a session and update it before ending.
3. **Aggressive Context Pruning:** Ignore `node_modules`, `.git`, `.DS_Store`, lockfiles, build artifacts, and binary files. Add ignore rules for the agent immediately.
4. **Concise Outputs:** Keep all terminal outputs, agent responses, and generated vault notes brief, structured, and free of conversational filler.

# Tasks

## 1. Vault
- Create a vault folder I can open in Obsidian. A good default is `~/Obsidian/AI-Memory`. Use another path if I ask.
- Create:
  - `00-Index/` with `_index.md` (a map of projects) and `_cross-device-handoff.md` (one note to start a chat on another device)
  - `01-Active-State/` with `_state.md` (names the active project) and one short note per project
  - `02-Logs-And-Summaries/` for compressed error summaries, never raw logs
  - `03-Knowledge/` for reusable notes
- Add agent ignore rules for dependencies, git internals, lockfiles, build output, and binaries.

## 2. Connect the tools I already have
- If I use Cursor, add a rule that reads `01-Active-State/` first, updates the state note at the end, never reads a full directory tree, and filters terminal output.
- If I use a local model, point summaries at it so cloud chats are not spent compressing logs.
- If I use ChatGPT, write custom instructions I can paste, matching these rules. If a remote connection needs a token, put the token in my password manager and never in a committed file. The full address of a tunnel is a password. Do not write it in the vault.
- If I use a password manager with a CLI, reference secrets from there. Never hardcode API keys or tokens in `.env`, shell config, or JSON that will be committed.

## 3. Check
- Read and update `01-Active-State/_state.md` once.
- Tell me, in a few lines, what you set up and what you skipped.
```

## 💸 Prompt 2 · spend the expensive model rarely

Paste this after Prompt 1. Skip it if you only use one model and you are happy with that.

```
# Follow-Up: route cheap work to a cheap model
Update the setup so simple tasks use a free local model or a low-cost cloud model. Save the expensive model for hard problems. Skip any model I do not have.

## Tiers
- **Tier 1, free and local:** log summaries, state notes, formatting, docstrings, simple edits.
- **Tier 2, fast and low-cost:** routine multi-file edits, tests, and ordinary features.
- **Tier 3, the strong model:** architecture, a hard bug, or a risky change. Use it when the cheaper ones fail.

## Apply it
- In the agent rules, say which tier a task is, in one line, when it matters.
- If a local model is available, send log and note summaries to it and write the short result into `02-Logs-And-Summaries/` or `01-Active-State/`.
- In ChatGPT custom instructions, ask for a short answer, and remind me to use a fast model for lookups and notes.

## Check
- Run one noisy sample through the local summarizer, if I have one, and show me the short note it wrote.
```

## 📱 More than one device

Keep one vault and let your sync carry it.

- 💻 **Each computer.** Clone or copy this folder. Open it in Obsidian. The agent reads `_state.md` and then one project note.
- 📱 **A phone.** Open the same vault in Obsidian. If the chat app cannot see the vault, paste `_cross-device-handoff.md` into the chat.
- 📝 **A new chat anywhere.** Read the state note. When the tool is missing, paste the handoff note. Do not paste the old chat.

Two devices editing the same line: keep the edit you just made, and leave the other one in git history if you use git.

Write the handoff in a few lines: active project, what is true, what is next. No secrets.

## 🗄️ Optional · you already have a NAS

Skip this if you do not have a NAS, or if nothing is mounted. This prompt does not create a share.

```
# Only if a NAS share is already mounted
Do not mount a new share. Do not change other services on the NAS.

1. Look for a share that is already mounted on this computer.
2. If you find one I use for archives, copy `02-Logs-And-Summaries/` and any `*-backup.md` files from the AI-Memory vault onto that share.
3. Keep passwords out of the vault. A path with no secret may be written in `03-Knowledge/`.
4. If nothing is mounted, stop and say so.
```

## 🔒 Keep this out of the repo

- Passwords, API keys, and tunnel addresses
- Raw logs and old backup notes you do not want an agent to reread
- Your editor's local hook files, if you add any. Those belong on that computer.

A good state note fits on one screen. If it starts looking like a diary, cut it back. ✂️
