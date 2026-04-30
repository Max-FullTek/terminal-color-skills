# PowerShell Profile 設定

## 設定檔位置

[Microsoft.PowerShell_profile.ps1](/c:/Users/iwasa/Documents/PowerShell/Microsoft.PowerShell_profile.ps1)

## 這份檔案的角色

這是整套強化的主控台。大多數 CLI 工具不是改 Windows Terminal 本身，而是透過這份 profile 在 PowerShell 啟動時接上。

## 目前結構

目前主要分成這幾段：

1. PATH 前置：
   `WinGet Links`、`WindowsApps`，並在必要時從 User/Machine PATH 重新補進 winget portable package 目錄
2. 互動式 shell 判斷：
   只在真正打指令的終端中載入強化功能
3. 模組與工具初始化：
   `PSReadLine`、`Terminal-Icons`、`Oh My Posh`、`zoxide`、`fzf`、`broot`、補完腳本、AI CLI wrappers

## 為什麼有互動式判斷

這段：

```powershell
$isInteractiveShell = $Host.Name -eq "ConsoleHost" -and -not [Console]::IsInputRedirected -and -not [Console]::IsOutputRedirected
```

用途是避免：

- 腳本模式噴出 `PSReadLine` 錯誤
- 重導向輸出時 `Oh My Posh` 或 `zoxide` 初始化失敗

## 初始化順序

互動式 shell 內建議順序：

1. 載入 `PSReadLine`
2. 載入 `Terminal-Icons`
3. 初始化 Oh My Posh
4. 初始化 zoxide
5. 設定 fzf / rg
6. 載入 broot `br` function 與 `b` alias
7. 載入 completions

Oh My Posh 會建立或替換 `prompt` function。zoxide 也會掛 prompt hook 來紀錄目錄變化，所以要在 Oh My Posh 後初始化 zoxide。`omp-theme preview/set/next/prev/tour` 切換 theme 後，也要重新跑 zoxide init，避免 `z` 的資料庫更新 hook 被新 prompt 覆蓋。

## zoxide 安全寫法

不要直接這樣寫：

```powershell
zoxide init powershell | Invoke-Expression
```

這會把 zoxide 輸出的多行腳本逐行送進 `Invoke-Expression`。開 Windows Terminal 時可能報：

- `Cannot bind argument to parameter 'Command' because it is an empty string.`
- `Missing closing '}' in statement block or type definition.`

請先收成完整字串：

```powershell
$zoxide = Get-Command zoxide -ErrorAction SilentlyContinue
if ($zoxide) {
    $zoxideInit = (& $zoxide.Source init powershell) -join "`n"
    if (-not [string]::IsNullOrWhiteSpace($zoxideInit)) {
        Invoke-Expression $zoxideInit
    }
}
```

## 你最常改的地方

### 新增一個工具初始化

建議放進 `$isInteractiveShell` 區塊內。

### 新增 alias 或 function

也建議放在 `$isInteractiveShell` 內，像現在 broot 的 `br` function 與 `b` alias 就是這樣。

### 補 PATH

如果是 CLI 工具找不到，可以優先在 profile 裡補 PATH，而不是直接去改系統環境變數。

注意：winget 安裝 portable package 後，已開啟的 PowerShell tab 不一定立刻吃到新的 User PATH。驗證時可以開新 Windows Terminal tab，或臨時用 User/Machine PATH 重新組 session PATH。不要只因為舊 tab 找不到 `zoxide` / `fzf` / `broot` 就判斷安裝失敗。

## 改完怎麼測

```powershell
. $PROFILE
```

如果有錯，PowerShell 會直接指出哪一行。

## 目前備份

- [Microsoft.PowerShell_profile.ps1.bak.2026-04-14](/c:/Users/iwasa/Documents/PowerShell/Microsoft.PowerShell_profile.ps1.bak.2026-04-14)
