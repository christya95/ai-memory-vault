# Windows PC setup for the AI memory stack. Written on the Mac; not yet run on Windows.
# Run in PowerShell (not as administrator):
#   powershell -ExecutionPolicy Bypass -File windows-bootstrap.ps1 [-Projects C:\path\to\repo, C:\other\repo]
# Safe to run again: every step checks before it changes anything.
# Sync on this PC is Git only: a normal clone of christya95/ai-memory-vault outside iCloud Drive.
# The Mac keeps the vault in iCloud for the iPhone, with its Git data stored outside the vault; the copy
# iCloud for Windows would bring here carries a .git pointer to a Mac-only path, so Git cannot use it.
param([string[]]$Projects = @())

$ErrorActionPreference = 'Stop'
$Vault = Join-Path $HOME 'Obsidian\AI-Memory'
$Repo = 'christya95/ai-memory-vault'
$Bin = Join-Path $HOME 'bin'
$Todo = @()

function Step($text) { Write-Host "== $text" }
function Refresh-Path { $env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('Path', 'User') }

Step 'Install missing apps with winget'
$apps = 'Git.Git', 'GitHub.cli', 'AgileBits.1Password', 'AgileBits.1Password.CLI', 'Obsidian.Obsidian',
        'Anysphere.Cursor', 'Ollama.Ollama', 'Tailscale.Tailscale', 'Python.Python.3.12'
foreach ($id in $apps) {
    winget list --id $id -e --accept-source-agreements *> $null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "   installing $id"
        winget install --id $id -e --silent --accept-package-agreements --accept-source-agreements | Out-Null
    }
}
Refresh-Path

Step 'Vault: clone and schedule the sync'
gh auth status *> $null
if ($LASTEXITCODE -ne 0) { gh auth login --web --git-protocol https }
if ($Vault -match 'iCloud') { throw "The vault path $Vault is inside iCloud Drive. Use a folder outside it." }
$gitPath = Join-Path $Vault '.git'
if (Test-Path $gitPath -PathType Leaf) { throw "$Vault is a copy from iCloud (its .git is a pointer file from the Mac). Move that folder away and run this script again." }
if (-not (Test-Path $gitPath -PathType Container)) {
    if ((Test-Path $Vault) -and (Get-ChildItem -Force $Vault | Select-Object -First 1)) { throw "$Vault exists and is not a Git clone. Move it away and run this script again." }
    New-Item -ItemType Directory -Force -Path (Split-Path $Vault) | Out-Null
    gh repo clone $Repo $Vault
    if ($LASTEXITCODE -ne 0) { throw "Could not clone $Repo. Check the GitHub sign-in and run this script again." }
}
$origin = git -C $Vault remote get-url origin
if ($origin -notlike "*$Repo*") { throw "$Vault is a clone of $origin, not of $Repo." }
$icloudCopy = Join-Path $HOME 'iCloudDrive\iCloud~md~obsidian\AI-Memory'
if (Test-Path $icloudCopy) { $Todo += "iCloud for Windows also shows the vault at $icloudCopy. Do not open or edit that copy on this PC; use $Vault." }
$bash = Join-Path $env:ProgramFiles 'Git\bin\bash.exe'
$action = New-ScheduledTaskAction -Execute $bash -Argument '-lc "~/Obsidian/AI-Memory/_tools/vault-sync"'
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 5)
Register-ScheduledTask -TaskName 'AI-Memory vault sync' -Action $action -Trigger $trigger -Force | Out-Null

Step 'Cursor: global rule and ignore files'
$rules = Join-Path $HOME '.cursor\rules'
New-Item -ItemType Directory -Force -Path $rules | Out-Null
Copy-Item (Join-Path $Vault '03-Knowledge\AI-RULES.md') (Join-Path $rules 'token-saver.mdc') -Force
$ignore = @('node_modules/', '.git/', '.DS_Store', 'Thumbs.db', 'dist/', 'build/', '*.har', '*.zip')
foreach ($project in $Projects) {
    $file = Join-Path $project '.cursorignore'
    if ((Test-Path $project) -and -not (Test-Path $file)) { Set-Content -Path $file -Value $ignore -Encoding ascii }
    $rule = Join-Path $project '.cursor\rules'
    if (Test-Path $project) {
        New-Item -ItemType Directory -Force -Path $rule | Out-Null
        Copy-Item (Join-Path $Vault '03-Knowledge\AI-RULES.md') (Join-Path $rule 'token-saver.mdc') -Force
    }
}

Step 'Ollama endpoint from 1Password'
$endpoint = $null
try { $endpoint = (op read 'op://AI-Stack/Ollama-Tailscale/host' 2>$null) } catch { }
if ($endpoint) {
    [Environment]::SetEnvironmentVariable('OLLAMA_URL', $endpoint.Trim(), 'User')
    Write-Host "   OLLAMA_URL set from 1Password"
} else {
    $Todo += 'Sign in to the 1Password app, turn on Settings > Developer > Integrate with 1Password CLI, then run this script again.'
}

Step 'summarize-to-obsidian command'
New-Item -ItemType Directory -Force -Path $Bin | Out-Null
Set-Content -Path (Join-Path $Bin 'summarize-to-obsidian.cmd') -Encoding ascii -Value '@py -3 "%USERPROFILE%\Obsidian\AI-Memory\_tools\summarize-to-obsidian" %*'
$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
if ($userPath -notlike "*$Bin*") { [Environment]::SetEnvironmentVariable('Path', "$userPath;$Bin", 'User') }

Step 'Tailscale'
$tailscale = Join-Path $env:ProgramFiles 'Tailscale\tailscale.exe'
if (Test-Path $tailscale) {
    & $tailscale status *> $null
    if ($LASTEXITCODE -ne 0) { $Todo += 'Open Tailscale and sign in with the same account as the Mac.' }
} else { $Todo += 'Tailscale did not install; install it from tailscale.com and sign in.' }

$Todo += "Open Obsidian > Open folder as vault > $Vault. Obsidian settings are per device (Git ignores .obsidian)."
$Todo += 'Open a new terminal so OLLAMA_URL and the new PATH are picked up. Test: echo test error | summarize-to-obsidian -p Test -t check --dry-run'
$Todo += 'The Mac must be awake for summaries; they go to its Ollama over Tailscale. To use this PC''s GPU instead, change host in 1Password (AI-Stack, Ollama-Tailscale) and run this script again.'
Write-Host "`nLeft to do by hand:"
$Todo | ForEach-Object { Write-Host " - $_" }
