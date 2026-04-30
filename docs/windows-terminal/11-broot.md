# broot 設定

## 作用

`broot` 是 terminal 裡的互動式目錄瀏覽工具。

它比 `yazi` 更接近目前的需求：

- 以樹狀方式瀏覽目錄
- 可以直接打字搜尋
- 目前在 Windows Terminal 內用 `Shift+Enter` 回到 shell 並切到選取的目錄
- 功能比完整檔案管理器少一點，學習成本較低

## 安裝狀態

套件來源：

`winget`

套件 ID：

`Dystroy.broot`

目前版本：

`1.56.2`

## profile 整合

目前 profile 會優先載入 `broot` 官方產生的 PowerShell function：

```powershell
br
```

另外也加了一個短 alias：

```powershell
b
```

建議平常用：

```powershell
b
```

如果 `%APPDATA%\dystroy\broot\config\launcher\powershell\br.ps1` 不存在，profile 可以使用 `broot --print-shell-function powershell` 的輸出作為 fallback。這是 broot 官方提供的 PowerShell function，不是自己重寫 cd 流程。

曾遇過 `broot --install` 在 Windows 建立 launcher symlink 時失敗：

```text
Installation check resulted in Permission Denied.
Please relaunch with elevated privilege.
IO Error 用戶端沒有這項特殊權限。 (os error 1314)
```

遇到這種情況，不要硬改其他檔案管理器。先回報狀態，再使用官方 `--print-shell-function powershell` fallback，或請使用者用提升權限重跑 `broot --install`。

## 基本操作

- 直接打字：搜尋目前樹狀目錄中的項目
- `Enter`：進入或開啟選取項目
- `Shift+Enter`：回到 shell，並切到目前選取的目錄
- `Esc`：清除搜尋或返回
- `Ctrl+Q`：離開

## Windows Terminal 的 Enter 快捷鍵設定

Windows Terminal 預設會把 `Alt+Enter` 當成切換全螢幕。

這會造成 broot 類工具很容易和 terminal 自己的快捷鍵衝突。

目前設定是：

- `Alt+Enter` 解除綁定，避免觸發 Windows Terminal 全螢幕
- `Shift+Enter` 送出 `ESC + Enter`，用來配合 broot 返回 shell 並切換到選取資料夾

設定檔位置：

[settings.json](/c:/Users/iwasa/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json)

備份檔：

`C:\Users\iwasa\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json.bak.broot-alt-enter-2026-04-15`

注意：

- 改完後通常需要開新分頁或重開 Windows Terminal
- 如果是在 VS Code integrated terminal，是否攔截 `Shift+Enter` 或 `Alt+Enter` 取決於 VS Code 的鍵盤快捷鍵設定

## 顏色設定

broot 有自己的 skin 設定，不只是吃系統或 Windows Terminal 的配色。

目前預設 skin 是：

`C:\Users\iwasa\AppData\Roaming\dystroy\broot\config\skins\codex-muted-green.hjson`

並在 broot 主設定中啟用：

`C:\Users\iwasa\AppData\Roaming\dystroy\broot\config\conf.hjson`

這份 skin 的方向：

- 暗色背景
- 低飽和灰綠目錄與樹線
- 溫暖米色檔名與狀態列文字
- 搜尋匹配用低飽和玫瑰紅，和目錄灰綠拉開但不刺眼
- 選取列使用低調灰底

如果 broot 看起來還是藍色，很可能是 `conf.hjson` 仍在載入：

```hjson
file: skins/dark-blue.hjson
```

應改成：

```hjson
file: skins/codex-muted-green.hjson
```

未來 agent 應從 repo 的 `skills/terminal-navigation-tools/references/codex-muted-green.hjson` 複製這份 skin 到 broot config。不要只套 Windows Terminal `Warm Sand`，那不會改 broot UI 內部顏色。

設定備份：

`C:\Users\iwasa\AppData\Roaming\dystroy\broot\config\conf.hjson.bak.<timestamp>`

驗證：

```powershell
broot --conf "$env:APPDATA\dystroy\broot\config\conf.hjson" --version
Select-String "$env:APPDATA\dystroy\broot\config\conf.hjson" -Pattern "codex-muted-green"
Test-Path "$env:APPDATA\dystroy\broot\config\skins\codex-muted-green.hjson"
```

## 為什麼不用直接打 broot

直接打：

```powershell
broot
```

可以開啟 UI，但不會自動把 PowerShell 切到你選到的資料夾。

要有 `cd` 回 shell 的能力，請用：

```powershell
b
```

或：

```powershell
br
```

## 參考來源

- https://dystroy.org/broot/
- https://github.com/Canop/broot
- https://learn.microsoft.com/windows/terminal/customize-settings/actions
