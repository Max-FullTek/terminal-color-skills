# 遠端重建與 Agent 交接指南

更新日期：2026-04-30

## 目的

這份文件是給「另一台 Windows 電腦上的 agents」看的搬家指南。

目標不是把這台電腦的所有原始設定檔無腦覆蓋到新電腦，而是讓 agent 依照目前偏好的外觀與工具鏈，在新電腦上安全重建：

- Windows Terminal 顏色、透明度、字體與 PowerShell profile
- Oh My Posh theme 與 theme 切換指令
- PSReadLine、Terminal-Icons、zoxide、fzf、ripgrep、broot
- Codex CLI 與 GitHub Copilot CLI wrapper
- VS Code / Copilot 相關設定的安全搬移方式

## 重要安全規則

不要提交或直接搬移下列原始檔：

- `%USERPROFILE%\.codex\auth.json`
- `%USERPROFILE%\.codex\history.jsonl`
- `%USERPROFILE%\.codex\sessions`
- `%USERPROFILE%\.codex\logs_*.sqlite*`
- `%APPDATA%\Code\User\settings.json` 的完整原檔
- Windows Terminal `settings.json` 的完整原檔，除非已確認 SSH host、IP、profile 名稱可以公開

目前 VS Code user settings 內有 Copilot MCP server 的環境變數 token。遠端 repo 只能放「設定摘要」或「redacted 範本」，不要把原始 token 寫進 repo。

## 目前本機基準

### 工具版本

| 工具 | 目前版本 | 安裝方式 |
| --- | --- | --- |
| PowerShell | `7.6.1` | winget |
| Oh My Posh | `29.12.0` | winget |
| zoxide | `0.9.9` | winget |
| fzf | `0.72.0` | winget |
| ripgrep | `15.1.0` | winget |
| broot | `1.56.2` | winget |
| Codex CLI | `@openai/codex 0.125.0` | npm global |
| GitHub Copilot CLI | `@github/copilot 1.0.39` | npm global |

新電腦可以直接裝最新版，不需要刻意鎖舊版。若要完全復刻，才指定版本。

### 主要路徑

| 項目 | 路徑 |
| --- | --- |
| PowerShell profile | `%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1` |
| Windows Terminal settings | `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json` |
| Oh My Posh themes | `%LOCALAPPDATA%\Programs\oh-my-posh\themes` |
| Codex config | `%USERPROFILE%\.codex\config.toml` |
| VS Code user settings | `%APPDATA%\Code\User\settings.json` |
| broot launcher | `%APPDATA%\dystroy\broot\config\launcher\powershell\br.ps1` |
| broot skin | `%APPDATA%\dystroy\broot\config\skins\codex-muted-green.hjson` |

winget portable package 有時不會立刻出現在已開啟 shell 的 `PATH`。若新裝後目前 tab 找不到 `zoxide`、`fzf`、`rg` 或 `broot`，先開新 Windows Terminal tab，再判斷是否真的安裝失敗。

## 新電腦建議流程

### 1. 先備份目標機現有設定

在 home 電腦執行：

```powershell
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"

if (Test-Path $PROFILE) {
    Copy-Item $PROFILE "$PROFILE.bak.$stamp" -Force
}

$wtSettings = Join-Path $env:LOCALAPPDATA "Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (Test-Path $wtSettings) {
    Copy-Item $wtSettings "$wtSettings.bak.$stamp" -Force
}

$vscodeSettings = Join-Path $env:APPDATA "Code\User\settings.json"
if (Test-Path $vscodeSettings) {
    Copy-Item $vscodeSettings "$vscodeSettings.bak.$stamp" -Force
}
```

### 2. 安裝必要工具

```powershell
winget install --id Microsoft.PowerShell --exact --accept-source-agreements --accept-package-agreements
winget install --id JanDeDobbeleer.OhMyPosh --exact --accept-source-agreements --accept-package-agreements
winget install --id ajeetdsouza.zoxide --exact --accept-source-agreements --accept-package-agreements
winget install --id junegunn.fzf --exact --accept-source-agreements --accept-package-agreements
winget install --id BurntSushi.ripgrep.MSVC --exact --accept-source-agreements --accept-package-agreements
winget install --id Dystroy.broot --exact --accept-source-agreements --accept-package-agreements
npm install -g @openai/codex @github/copilot
```

字型需安裝 `FiraCode Nerd Font Mono`。若 `winget search FiraCode` 找不到，請從 Nerd Fonts 官方釋出版手動安裝 FiraCode Nerd Font，然後重新開 Windows Terminal。

PowerShell module：

```powershell
Install-Module -Name PSReadLine -Scope CurrentUser -Force
Install-Module -Name Terminal-Icons -Scope CurrentUser -Force
```

### 3. 套用 Windows Terminal 外觀

只搬移必要外觀設定，不搬移私人 SSH profiles。

`profiles.defaults` 目標值：

```json
{
  "backgroundImage": null,
  "backgroundImageOpacity": 0.2,
  "font": {
    "cellHeight": "1.3",
    "face": "FiraCode Nerd Font Mono",
    "size": 14,
    "weight": "medium"
  },
  "opacity": 40,
  "padding": "15",
  "scrollbarState": "hidden",
  "useAcrylic": true
}
```

PowerShell profile 目標值：

```json
{
  "colorScheme": "Warm Sand",
  "commandline": "pwsh.exe -NoLogo -NoProfileLoadTime",
  "guid": "{574e775e-4f2a-5b96-ac1e-a2962a402336}",
  "hidden": false,
  "name": "PowerShell",
  "source": "Windows.Terminal.PowershellCore"
}
```

色彩方案：

```json
{
  "name": "Warm Sand",
  "background": "#202222",
  "foreground": "#D2C4A4",
  "cursorColor": "#E6DBBF",
  "selectionBackground": "#3A3A3A",
  "black": "#232323",
  "red": "#C47E7E",
  "green": "#76968C",
  "yellow": "#B89A60",
  "blue": "#78948B",
  "purple": "#D291AA",
  "cyan": "#14AA84",
  "white": "#B4A68C",
  "brightBlack": "#A0AC9A",
  "brightRed": "#DC5F5F",
  "brightGreen": "#94B89A",
  "brightYellow": "#EBDCB4",
  "brightBlue": "#94AAA4",
  "brightPurple": "#E2A8BB",
  "brightCyan": "#66D9B5",
  "brightWhite": "#F0E8D0"
}
```

保留這組 key binding 行為：

- `shift+enter` 送出 `ESC + Enter`，目前用來配合 broot 回到 shell 後切換資料夾
- `alt+enter` 設為 unbound，避免 Windows Terminal 攔截成全螢幕切換

```json
{
  "actions": [
    {
      "command": {
        "action": "sendInput",
        "input": "\u001b\r"
      },
      "id": "User.sendInput.8F63D3A9"
    }
  ],
  "keybindings": [
    {
      "id": "User.sendInput.8F63D3A9",
      "keys": "shift+enter"
    },
    {
      "id": null,
      "keys": "alt+enter"
    }
  ]
  }
```

### 4. 套用 PowerShell profile 行為

新電腦的 profile 要保留這些行為：

1. 設定 console input/output 為 UTF-8 no BOM
2. 把 `%LOCALAPPDATA%\Microsoft\WinGet\Links` 放到 session `PATH` 前面
3. 把 `%LOCALAPPDATA%\Microsoft\WindowsApps` 補到 session `PATH`
4. 只在互動式 shell 載入增強功能
5. 載入 `PSReadLine`，`PredictionViewStyle` 使用 `InlineView`
6. 載入 `Terminal-Icons`
7. 若 `rg` 和 `fzf` 存在，設定：

```powershell
$env:FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git"'
$env:FZF_CTRL_T_COMMAND = $env:FZF_DEFAULT_COMMAND
```

8. 若 `broot` 存在，載入 broot PowerShell function，並設定 `b` alias 到 `br`
9. 載入 `$PROFILE` 同目錄下的 `Completions` 檔案
10. 使用 Oh My Posh 初始化 prompt
11. 若 `zoxide` 存在，在 Oh My Posh 後初始化 zoxide
12. 定義 `codex` wrapper，呼叫 `%ProgramFiles%\nodejs\codex.ps1`
13. 定義 `copilot` wrapper，呼叫 `%ProgramFiles%\nodejs\copilot.ps1`，並套用 allow/deny 工具參數

重要：Oh My Posh 與 zoxide 都會碰 `prompt`。不要直接寫：

```powershell
zoxide init powershell | Invoke-Expression
```

要先把輸出接成單一字串，且非空才執行：

```powershell
function Invoke-ZoxideInit {
  param([switch]$Force)

  $zoxide = Get-Command zoxide -ErrorAction SilentlyContinue
  if (-not $zoxide) { return }

  if ($Force) {
    $global:__zoxide_hooked = 0
  }

  $zoxideInit = (& $zoxide.Source init powershell) -join "`n"
  if (-not [string]::IsNullOrWhiteSpace($zoxideInit)) {
    Invoke-Expression $zoxideInit
  }
}
```

互動式區塊內建議順序：

```powershell
Invoke-OmpInit
Invoke-ZoxideInit -Force
```

`omp-theme` helper 如果會重載 Oh My Posh，也要在重載後呼叫 `Invoke-ZoxideInit -Force`。

目前 Oh My Posh theme 使用 user-level environment variable：

```powershell
[Environment]::SetEnvironmentVariable("OMP_THEME_NAME", "robbyrussell", "User")
```

目前 profile 內建 `omp-theme` helper，可用：

```powershell
omp-theme current
omp-theme list
omp-theme preview <name>
omp-theme set <name>
omp-theme tour
omp-theme next
omp-theme prev
omp-theme <name>
```

### 4.1 套用 broot skin

broot 有自己的 skin，不會自動吃 Windows Terminal 的 `Warm Sand`。

把 repo 內這份檔案：

```text
skills/terminal-navigation-tools/references/codex-muted-green.hjson
```

複製到目標機：

```text
%APPDATA%\dystroy\broot\config\skins\codex-muted-green.hjson
```

再把 `%APPDATA%\dystroy\broot\config\conf.hjson` 的 dark/unknown import 改成：

```hjson
file: skins/codex-muted-green.hjson
```

如果還是：

```hjson
file: skins/dark-blue.hjson
```

代表 broot 還在用預設藍色皮膚。

若 `broot --install` 出現 symlink 權限錯誤：

```text
Installation check resulted in Permission Denied.
IO Error 用戶端沒有這項特殊權限。 (os error 1314)
```

不要改用別的檔案管理器繞過。請使用者用提升權限重跑 `broot --install`，或使用 broot 官方 fallback：

```powershell
broot --print-shell-function powershell
```

把輸出的 `br` function 放進 profile 互動式區塊，並保留：

```powershell
Set-Alias b br
```

### 5. Codex 設定搬移

可以提交並參考的是 `%USERPROFILE%\.codex\config.toml` 的安全摘要：

```toml
model = "gpt-5.5"
model_reasoning_effort = "high"
approvals_reviewer = "user"

[windows]
sandbox = "elevated"

[features]
multi_agent = true

[tui]
theme = "two-dark"
```

不要提交或搬移：

- `auth.json`
- `history.jsonl`
- `sessions`
- `logs_*.sqlite*`
- `state_*.sqlite*`
- `.sandbox-secrets`

新電腦第一次啟動 Codex 時重新登入即可：

```powershell
codex
```

### 6. Copilot / VS Code 設定搬移

可以搬移的 VS Code user settings 摘要：

```json
{
  "workbench.iconTheme": "material-icon-theme",
  "workbench.colorTheme": "Dark Modern",
  "workbench.statusBar.visible": false,
  "workbench.activityBar.location": "top",
  "window.menuBarVisibility": "compact",
  "editor.fontFamily": "'FiraCode Nerd Font Mono', '微軟正黑體'",
  "editor.fontLigatures": true,
  "editor.letterSpacing": 0.2,
  "editor.fontWeight": "500",
  "editor.fontSize": 15,
  "terminal.integrated.fontFamily": "'FiraCode Nerd Font Mono', '微軟正黑體'",
  "terminal.integrated.fontSize": 16,
  "terminal.integrated.fontWeight": "normal",
  "terminal.integrated.fontWeightBold": "bold",
  "terminal.integrated.letterSpacing": 0.2,
  "terminal.integrated.enableImages": true,
  "terminal.integrated.tabs.defaultColor": "terminal.ansiCyan",
  "terminal.integrated.cursorStyleInactive": "line",
  "terminal.integrated.smoothScrolling": true,
  "terminal.integrated.initialHint": false,
  "terminal.integrated.defaultProfile.windows": "PowerShell",
  "chat.agent.enabled": true,
  "chat.useAgentSkills": true,
  "chat.mcp.gallery.enabled": true,
  "workbench.browser.enableChatTools": true,
  "github.copilot.editor.enableAutoCompletions": true,
  "github.copilot.chat.agent.thinkingTool": true,
  "github.copilot.nextEditSuggestions.enabled": true,
  "gitlens.ai.model": "vscode",
  "gitlens.ai.vscode.model": "copilot:gpt-4.1",
  "chatgpt.localeOverride": "zh-TW"
}
```

Copilot MCP server 若需要 Figma，請在新電腦本機重新設定 token。不要把 token commit 到 repo。

### 7. 驗證

新電腦套用後，開新的 Windows Terminal tab，執行：

```powershell
pwsh --version
oh-my-posh version
omp-theme current
Get-Module -ListAvailable PSReadLine, Terminal-Icons
Get-Command rg,fzf,zoxide,broot,codex,copilot
codex --version
copilot --version
Test-Path "$env:APPDATA\dystroy\broot\config\skins\codex-muted-green.hjson"
Select-String "$env:APPDATA\dystroy\broot\config\conf.hjson" -Pattern "codex-muted-green"
```

視覺驗證：

- Windows Terminal 使用 `FiraCode Nerd Font Mono`
- 背景為 `#202222` 附近的暗綠灰色
- 透明度約 `40`，且 acrylic 開啟
- PowerShell prompt 顯示 Oh My Posh theme
- `ls` / `Get-ChildItem` 有 Terminal-Icons 圖示
- `z` 指令可用
- `b` 可啟動 broot
- broot 顏色為暗底、米色文字、灰綠目錄線，不是預設藍色 `dark-blue`
- `Shift+Enter` 在 broot 中可返回 shell 並切換資料夾
- `Alt+Enter` 不會觸發 Windows Terminal 全螢幕
- VS Code terminal 字體與 Windows Terminal 接近

## 給 agent 的最短指令

如果你是 home 電腦上的 agent，請照這個順序做：

1. 先讀本文件與 `README.md`
2. 備份 home 電腦現有 profile、Windows Terminal settings、VS Code settings
3. 安裝工具與字型
4. 只合併 Windows Terminal 外觀、不要覆蓋私人 SSH profiles
5. 重建 PowerShell profile 行為
6. Codex 只搬安全 config，不搬登入資料與 logs
7. VS Code / Copilot 只搬摘要設定，token 由使用者在本機重新補
8. 執行驗證指令並回報差異
