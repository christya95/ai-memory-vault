# iPhone Shortcut: compress before you spend tokens

Share a link, PDF or text; a local model on the Mac compresses it for free; you get a short summary to paste or save. Checked from the Mac on 2026-11-20: the same request to the tailnet address turned 4,311 characters into 5 correct lines in 2 seconds. Not checked: the Shortcut itself on the phone. Action names are from recent iOS and may differ slightly.

## Needs
- Tailscale on the iPhone, connected, same account as the Mac. The Mac awake.
- Endpoint: `http://100.120.255.58:11434` (also in 1Password: AI-Stack, Ollama-Tailscale, `host`). It works only inside your tailnet. Shortcuts cannot read 1Password, so type it into the Shortcut; change it there if the endpoint moves.

## Build it (Shortcuts app, new Shortcut named "Compress")
1. Tap the info button: turn on **Show in Share Sheet**. Receive: URLs, Safari web pages, PDFs, Text. If there is no input: **Get Clipboard**.
2. **If** `Shortcut Input` > File Extension **is** `pdf`
   - **Get Text from PDF** (`Shortcut Input`)
3. **Otherwise**
   - **Get URLs from Input** (`Shortcut Input`)
   - **If** `URLs` **has any value**: **Get Article using Safari Reader** (`URLs`), then **Get Details of Safari Reader Article**: Body
   - **Otherwise**: **Get Text from Input** (`Shortcut Input`)
   - **End If**
4. **End If**. Add **Set Variable** `Source` to the result of the branch that ran (add it as the last action inside each branch).
5. **Match Text**: pattern `^[\s\S]{1,20000}` in `Source`. This keeps the first 20,000 characters; the model reads no more than that.
6. **Text**:
   ```
   Compress this into at most 6 short bullet lines. Keep names, numbers and dates. Ignore navigation and adverts.

   [Matches]
   ```
7. **Get Contents of URL**: `http://100.120.255.58:11434/api/generate`. Method POST. Request Body JSON:
   - `model` (Text): `token-saver`
   - `stream` (Boolean): off
   - `prompt` (Text): the Text from step 6
8. **Get Dictionary Value**: `response` from `Contents of URL`.
9. **Copy to Clipboard**, then **Show Result**.

## Optional: save to Obsidian
Only if the vault is on the phone (below). After step 8:
- **URL Encode** the summary.
- **Open URLs**: `obsidian://new?vault=AI-Memory&file=02-Logs-And-Summaries/[Current Date, format yyyy-MM-dd-HHmm]-clip&content=[URL Encoded Text]`

## If it fails
- "Could not connect": Tailscale is off on the phone, or the Mac is asleep.
- Empty result: the page has no Reader view. Select the text on the page and share that instead.

## Vault on the iPhone (optional, not set up)
The vault syncs through a private Git repository (`christya95/ai-memory-vault`); the Mac and the Windows PC sync by themselves. On the iPhone, Git needs an app: Working Copy (clone the repo, link the folder as an Obsidian vault, sync by hand or by automation), or the Obsidian Git community plugin with a GitHub token limited to that one repository, saved in 1Password. Neither was tested. For ChatGPT on the phone you do not need the vault there: paste `00-Index/_cross-device-handoff.md`, or use the AI Memory tool if the app offers it.
