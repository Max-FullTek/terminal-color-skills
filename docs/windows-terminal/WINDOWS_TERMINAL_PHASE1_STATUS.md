# Windows Terminal 第一階段強化狀態與執行流程

更新日期：2026-04-30

## 最新執行結果

2026-04-14 已完成第一階段處理：

- 已備份 PowerShell Profile 與 Windows Terminal `settings.json`
- 已用 `winget` 完成 `Oh My Posh 29.10.0` 安裝。2026-04-30 已更新到 `29.12.0`
- 已更新 `Microsoft.PowerShell_profile.ps1`
- 已移除舊的自訂 `prompt`
- 已改成互動式 shell 才載入 `PSReadLine`、`Terminal-Icons`、completions、`Oh My Posh`
- 已補上 `WindowsApps` 路徑 fallback，避免 `oh-my-posh.exe` 在部分 shell 找不到

目前第一階段可視為已完成。`Oh My Posh` 現在使用 `OMP_THEME_NAME` / `OMP_THEME_SESSION_NAME` 決定 theme；找不到對應 theme 檔時，才改用 `oh-my-posh init pwsh` 的預設初始化流程。

2026-04-14 已完成第二階段處理：

- 已安裝 `zoxide 0.9.9`
- 已安裝 `eza 0.23.4`
- 已安裝 `fzf 0.71.0`。2026-04-30 已更新到 `0.72.0`
- 已安裝 `ripgrep 15.1.0 (MSVC)`
- 已將 `C:\Users\iwasa\AppData\Local\Microsoft\WinGet\Links` 前置加入 session `PATH`
- 已讓 `rg` 優先使用 winget 安裝版，而非 VS Code 內建版
- 已在互動式 shell 中加入 `zoxide init powershell`。後續已校正：不能直接 pipe 到 `Invoke-Expression`，必須先 join 成完整腳本
- 已在互動式 shell 中加入 `eza` 常用快捷函式：`l`、`ll`、`la`、`lt`
- 已設定 `fzf` 預設檔案來源為 `rg --files --hidden --follow --glob "!.git"`

2026-04-15 已調整工具取捨：

- 已移除 `eza`
- 已移除 profile 中的 `eza` 快捷函式：`l`、`ll`、`la`、`lt`
- 已安裝後又移除 `yazi`
- 已安裝 `broot 1.56.2`
- 已新增 `br` function 與 `b` alias，用來啟動 `broot`
- 後續已改成使用 `Shift+Enter` 送出 `ESC + Enter`，回到 shell 後切到選取資料夾
- 已解除 Windows Terminal 的 `Alt+Enter` 全螢幕快捷鍵，避免誤觸全螢幕

2026-04-15 已調整 Codex CLI 可讀性：

- 根因：Windows Terminal 全域預設為 `opacity: 40` 且 `useAcrylic: true`，Codex CLI 的 dim/gray ANSI 文字在半透明背景上對比不足
- 已還原 Windows Terminal 透明背景策略，PowerShell 繼續繼承全域 `opacity: 40`、`useAcrylic: true`
- 已移除 PowerShell profile 的 `Codex Clear`、`opacity: 100`、`useAcrylic: false` 覆蓋
- 當時曾在 PowerShell profile 新增 colorless `codex` wrapper
- 備份檔：`settings.json.bak.restore-transparency.20260415-190301`
- 備份檔：`Microsoft.PowerShell_profile.ps1.bak.codex-no-color.20260415-190301`

2026-04-29 已補上遠端重建文件與狀態校正：

- 新增 agent 搬家指南：`docs/windows-terminal/13-遠端重建與-Agent-交接.md`
- 新增 root 入口：`AGENTS.md`
- 新增 `.gitignore`，避免誤提交 Codex auth/logs、VS Code 原始 settings、Windows Terminal 原始 settings 或備份檔
- 目前 Oh My Posh user theme：`robbyrussell`
- 目前 Codex CLI npm 套件：`@openai/codex 0.125.0`
- 目前 profile 的 `codex` wrapper 只轉呼叫 npm shim，不再設定 `NO_COLOR=1`
- 目前 Windows Terminal 解除 `Alt+Enter` 全螢幕綁定，並使用 `Shift+Enter` 送出 `ESC + Enter` 給 broot 流程

2026-04-30 已完成 skills 化後的實機重建與文件校正：

- 已安裝 / 驗證 `PowerShell 7.6.1`
- 已安裝 / 驗證 `Oh My Posh 29.12.0`
- 已安裝 / 驗證 `zoxide 0.9.9`
- 已安裝 / 驗證 `fzf 0.72.0`
- 已安裝 / 驗證 `ripgrep 15.1.0`
- 已安裝 / 驗證 `broot 1.56.2`
- 已安裝 / 驗證 `@openai/codex 0.125.0`
- 已安裝 / 驗證 `@github/copilot 1.0.39`
- 已修正 zoxide 初始化方式：不再使用 `zoxide init powershell | Invoke-Expression`，改為先接成完整字串再執行
- 已確認 Oh My Posh 先初始化，zoxide 後初始化，且 `omp-theme` 切換後需重新掛 zoxide hook
- 已補回 broot skin：`codex-muted-green.hjson`
- 已確認 broot 主設定應載入 `skins/codex-muted-green.hjson`，不是 `skins/dark-blue.hjson`
- 已新增踩坑紀錄：`docs/windows-terminal/14-疑難排解與踩坑紀錄.md`

## 目的

這份文件提供給後續 agents 直接參考，用來判斷這台 Windows 開發環境在「第一階段必裝」的完成度，並依照固定流程補齊缺項。

第一階段範圍：

1. PowerShell 7
2. PSReadLine
3. Oh My Posh
4. Terminal-Icons

第二階段範圍：

1. zoxide
2. broot
3. fzf
4. ripgrep

## 目前狀態快照

### 1. PowerShell

- 狀態：已安裝
- 版本：`7.6.1`
- 路徑：`C:\Program Files\PowerShell\7\pwsh.exe`

### 2. PSReadLine

- 狀態：已安裝
- PowerShell 7 版本：`2.4.5`
- 路徑：`C:\Program Files\PowerShell\7\Modules\PSReadLine\PSReadLine.psd1`
- Windows PowerShell 另有舊版：`2.0.0`

### 3. Terminal-Icons

- 狀態：已安裝
- 版本：`0.11.0`
- 路徑：`C:\Users\iwasa\Documents\PowerShell\Modules\Terminal-Icons\0.11.0\Terminal-Icons.psd1`

### 4. Oh My Posh

- 狀態：已安裝
- 版本：`29.12.0`
- 可執行 alias：`C:\Users\iwasa\AppData\Local\Microsoft\WindowsApps\oh-my-posh.exe`

### 5. zoxide

- 狀態：已安裝
- 版本：`0.9.9`
- 路徑：`C:\Users\iwasa\AppData\Local\Microsoft\WinGet\Packages\ajeetdsouza.zoxide_Microsoft.Winget.Source_8wekyb3d8bbwe\zoxide.exe`

### 6. eza

- 狀態：已移除
- 原因：與 `Terminal-Icons` 功能重疊，實際用途不夠有感

### 7. fzf

- 狀態：已安裝
- 版本：`0.72.0`
- 路徑：`C:\Users\iwasa\AppData\Local\Microsoft\WinGet\Packages\junegunn.fzf_Microsoft.Winget.Source_8wekyb3d8bbwe\fzf.exe`

### 8. ripgrep

- 狀態：已安裝
- 版本：`15.1.0`
- 路徑：`C:\Users\iwasa\AppData\Local\Microsoft\WinGet\Packages\BurntSushi.ripgrep.MSVC_Microsoft.Winget.Source_8wekyb3d8bbwe\ripgrep-15.1.0-x86_64-pc-windows-msvc\rg.exe`

### 9. yazi

- 狀態：已移除
- 原因：互動方式與搜尋體驗不夠符合需求

### 10. broot

- 狀態：已安裝
- 版本：`1.56.2`
- 路徑：`C:\Users\iwasa\AppData\Local\Microsoft\WinGet\Packages\Dystroy.broot_Microsoft.Winget.Source_8wekyb3d8bbwe\x86_64-pc-windows-gnu\broot.exe`
- profile function：`br`
- profile alias：`b`
- skin：`%APPDATA%\dystroy\broot\config\skins\codex-muted-green.hjson`

## PowerShell Profile 現況

Profile 路徑：

`C:\Users\iwasa\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`

目前重點內容：

- 先把 `WinGet Links` 補進當前 session 的 `PATH`，而且放在前面
- 先把 `WindowsApps` 補進當前 session 的 `PATH`
- 只在互動式 shell 載入強化功能
- 互動式 shell 內會載入 `PSReadLine`
- 互動式 shell 內會載入 `Terminal-Icons`
- 互動式 shell 內會在 Oh My Posh 後初始化 `zoxide`
- 互動式 shell 內會提供 `br` function 與 `b` alias 啟動 `broot`
- broot 會使用 `codex-muted-green.hjson` skin，不只依賴 Windows Terminal 色票
- 若 `rg` 與 `fzf` 同時存在，會設定 `FZF_DEFAULT_COMMAND`
- 互動式 shell 內會載入 `Completions` 目錄下的補完腳本
- 互動式 shell 內會初始化 `Oh My Posh`

注意：

- 舊的自訂 `prompt` 已移除
- 目前是用 `Oh My Posh` 接管提示字元
- 非互動 shell 會跳過這些強化設定，避免腳本模式或重導向輸出報錯

## Windows Terminal 現況

設定檔路徑：

`C:\Users\iwasa\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`

檢查結果：

- 預設 shell：已是 `PowerShell`
- `defaultProfile`：`{574e775e-4f2a-5b96-ac1e-a2962a402336}`
- PowerShell profile commandline：`pwsh.exe -NoLogo -NoProfileLoadTime`
- 字型：已設為 `FiraCode Nerd Font Mono`
- 字級：`14`
- cell height：`1.3`
- 已存在多個 profiles
- 可見的 Ubuntu profile 已存在
- PowerShell 管理員 profile：目前未看到獨立 profile
- 已有部分快捷鍵：複製、貼上、搜尋、分割窗格

## 第一階段整體判讀

完成度：`4 / 4`

已完成：

- PowerShell 7
- PSReadLine
- Terminal-Icons
- Windows Terminal 預設 shell 已切到 PowerShell 7
- Windows Terminal 字型已切到 `FiraCode Nerd Font Mono`

目前已完成：

- Oh My Posh 已安裝
- PowerShell Profile 已改為 Oh My Posh 初始化流程
- 非互動 shell 不再套用 prompt 強化，避免驗證、腳本、重導向輸出時報錯

額外注意：

- `winget.exe` 實際存在於 `C:\Users\iwasa\AppData\Local\Microsoft\WindowsApps\winget.exe`
- 只是目前 shell 的 `PATH` 沒有帶進來，所以直接打 `winget` 可能仍找不到
- `POSH_THEMES_PATH` 目前指向的 theme 目錄不存在，因此 profile 已做 fallback，避免載入失敗
- 目前 shell 啟動後，工具優先路徑會以 `WinGet Links` 為主

## 第一階段建議執行流程

### Step 0：先備份現有設定

先備份 PowerShell Profile 與 Windows Terminal 設定檔，避免 agents 直接覆蓋：

```powershell
Copy-Item $PROFILE "$PROFILE.bak.2026-04-14" -Force
Copy-Item "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json.bak.2026-04-14" -Force
```

### Step 1：確認 PowerShell 7 狀態

這台機器目前可直接略過安裝，只需驗證：

```powershell
pwsh --version
```

如果未來在其他機器上需要重做：

```powershell
winget install --id Microsoft.PowerShell --source winget
```

若 `winget` 不可用，改走 Microsoft 官方手動安裝流程。

### Step 2：確認或更新 PSReadLine

目前已安裝，但建議 agents 仍做一次版本確認：

```powershell
Get-Module -ListAvailable PSReadLine | Select-Object Name, Version, Path
```

如需補裝或更新：

```powershell
Install-Module -Name PSReadLine -Scope CurrentUser -Force
```

建議在 Profile 中啟用常用設定：

```powershell
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
```

### Step 3：確認或更新 Terminal-Icons

目前已安裝，且 Profile 已有載入：

```powershell
Get-Module -ListAvailable Terminal-Icons | Select-Object Name, Version, Path
```

如需補裝或更新：

```powershell
Install-Module -Name Terminal-Icons -Scope CurrentUser -Force
```

Profile 需要保留：

```powershell
Import-Module Terminal-Icons
```

### Step 4：安裝 Oh My Posh

優先走官方建議的 `winget`：

```powershell
winget install JanDeDobbeleer.OhMyPosh --source winget
```

如果這台機器仍然沒有 `winget`，使用 Oh My Posh 官方 Windows 安裝腳本：

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))
```

安裝完成後先驗證：

```powershell
Get-Command oh-my-posh
```

### Step 5：調整 PowerShell Profile

目標是保留原本的補完載入邏輯，同時接上 Oh My Posh，並避免舊的 `prompt` 覆蓋新提示字元。

建議整理成這種最小可用版本：

```powershell
$isInteractiveShell = $Host.Name -eq "ConsoleHost" -and -not [Console]::IsInputRedirected -and -not [Console]::IsOutputRedirected

if ($isInteractiveShell) {
    Import-Module PSReadLine -ErrorAction SilentlyContinue
    if (Get-Module PSReadLine) {
        Set-PSReadLineOption -PredictionSource History
        Set-PSReadLineOption -PredictionViewStyle InlineView
    }

    Import-Module Terminal-Icons -ErrorAction SilentlyContinue

    $ompInit = (oh-my-posh init pwsh) -join "`n"
    if (-not [string]::IsNullOrWhiteSpace($ompInit)) {
        Invoke-Expression $ompInit
    }

    $zoxide = Get-Command zoxide -ErrorAction SilentlyContinue
    if ($zoxide) {
        $zoxideInit = (& $zoxide.Source init powershell) -join "`n"
        if (-not [string]::IsNullOrWhiteSpace($zoxideInit)) {
            Invoke-Expression $zoxideInit
        }
    }

    $completionDir = Join-Path (Split-Path -Parent $PROFILE) "Completions"
    if (Test-Path $completionDir) {
        Get-ChildItem $completionDir -Filter *.ps1 -File | ForEach-Object {
            . $_.FullName
        }
    }
}
```

執行重點：

1. 移除或註解掉現有的 `function prompt`
2. 把 Oh My Posh 初始化放在 zoxide 初始化之前
3. 保留 `Terminal-Icons` 與原本的 completions 載入

### Step 6：重新載入並驗證

```powershell
. $PROFILE
Get-Command oh-my-posh
Get-Module PSReadLine, Terminal-Icons -ListAvailable
```

視覺驗證重點：

1. 提示字元是否不再只是 `> `
2. 是否顯示目前路徑
3. 是否顯示 Git branch
4. `Get-ChildItem` 是否有圖示
5. 歷史命令建議是否可用

## 建議 agents 的實際執行順序

1. 只先補 `Oh My Posh`
2. 改 `Microsoft.PowerShell_profile.ps1`
3. 重新載入 Profile
4. 用 `Get-Command` 與畫面輸出驗證
5. 若一切正常，再考慮第二階段工具

## 不建議現在動的部分

- 不要先大改 Windows Terminal `settings.json`
- 不要先清掉現有 completions 載入機制
- 不要保留舊 `prompt` 和 Oh My Posh 並存
- 不要在未備份 Profile 前直接覆寫

## 給 agents 的最短結論

這台機器的第一階段強化已完成。

目前 profile 的策略是：

1. 先把 `WindowsApps` 補進當前 session 的 `PATH`
2. 只在互動式 shell 載入 `PSReadLine`、`Terminal-Icons`、completions、`Oh My Posh`
3. Oh My Posh 使用 `OMP_THEME_NAME` / `OMP_THEME_SESSION_NAME` 決定 theme，找不到 theme 檔才走預設初始化
4. zoxide 在 Oh My Posh 後初始化，避免 prompt hook 被覆蓋

## 參考來源

- Microsoft Learn: PowerShell on Windows
  - https://learn.microsoft.com/en-us/powershell/scripting/install/install-powershell-on-windows?view=powershell-7.5
- PowerShell Gallery: PSReadLine
  - https://www.powershellgallery.com/packages/PSReadLine/
- PowerShell Gallery: Terminal-Icons
  - https://www.powershellgallery.com/packages/Terminal-Icons
- Oh My Posh official Windows install
  - https://ohmyposh.dev/docs/installation/windows
- Oh My Posh official PowerShell prompt setup
  - https://ohmyposh.dev/docs/installation/prompt
- Oh My Posh customization
  - https://ohmyposh.dev/docs/installation/customize
