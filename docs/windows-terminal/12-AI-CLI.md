# AI CLI 工具

這份文件記錄 Windows 本機安裝的 AI CLI 工具：OpenAI Codex CLI 與 GitHub Copilot CLI。

## 目前狀態

- Codex CLI：已安裝，版本 `@openai/codex 0.125.0`
- GitHub Copilot CLI：已安裝，版本 `GitHub Copilot CLI 1.0.39`
- 安裝位置：兩者都由 npm 全域安裝到 `C:\Program Files\nodejs`
- 使用環境：Windows 本機 PowerShell，不使用 WSL workspace
- Windows Terminal 透明背景維持原狀，PowerShell profile 內提供 `codex` 與 `copilot` wrapper

## 指令解析狀態

目前 PowerShell 會優先使用 npm 全域版：

```powershell
Get-Command -All codex,copilot
```

預期前幾個結果：

```text
C:\Program Files\nodejs\codex.ps1
C:\Program Files\nodejs\copilot.ps1
```

注意：本機也有 VS Code ChatGPT extension 附帶的 `codex.exe`，但它排在 npm 全域版後面，所以目前不會優先被呼叫。

## Codex CLI

用途：OpenAI 的本機 coding agent，可在目前專案資料夾讀檔、改檔、跑指令。

啟動：

```powershell
codex
```

第一次啟動時，依畫面登入 ChatGPT 帳號或設定 API key。

更新：

```powershell
npm i -g @openai/codex@latest
```

檢查版本：

```powershell
codex --version
```

## GitHub Copilot CLI

用途：GitHub 的 terminal-native AI coding assistant，可做專案理解、命令列問答、agentic coding workflow。

啟動：

```powershell
copilot
```

第一次進入後輸入：

```text
/login
```

接著依畫面登入 GitHub 帳號。

更新：

```powershell
copilot update
```

或用 npm 重新安裝最新版：

```powershell
npm install -g @github/copilot
```

檢查版本：

```powershell
copilot --version
```

## 非互動式用法

Copilot CLI 支援直接丟 prompt：

```powershell
copilot -p "Give me an overview of this project."
```

只輸出回答、適合腳本：

```powershell
copilot -sp "In Git, how can I apply a commit from another branch?"
```

Codex CLI 的非互動模式可之後再依需求設定，先以互動模式 `codex` 為主。

## Codex CLI wrapper

目前 profile 內的 `codex` wrapper 會優先呼叫 npm 全域安裝的 PowerShell shim：

```powershell
function codex {
    $codexScript = (Get-Command codex.ps1 -ErrorAction SilentlyContinue | Select-Object -First 1).Source
    if (-not $codexScript) {
        $codexScript = Join-Path $env:ProgramFiles "nodejs\codex.ps1"
    }
    if (-not (Test-Path $codexScript)) {
        throw "codex.ps1 npm shim not found. Run: npm install -g @openai/codex"
    }
    & $codexScript @args
}
```

修改後新開 Windows Terminal tab 會自動套用；既有 tab 可執行 `. $PROFILE`。

## Copilot CLI wrapper

目前 profile 內的 `copilot` wrapper 會呼叫 npm 全域安裝的 PowerShell shim，並採保守預設：不加 `--allow-all-*`，只保留刪除、搬移、寫檔與 registry 類 deny 規則。

```powershell
function copilot {
    $copilotScript = (Get-Command copilot.ps1 -ErrorAction SilentlyContinue | Select-Object -First 1).Source
    if (-not $copilotScript) {
        $copilotScript = Join-Path $env:ProgramFiles "nodejs\copilot.ps1"
    }
    if (-not (Test-Path $copilotScript)) {
        throw "copilot.ps1 npm shim not found. Run: npm install -g @github/copilot"
    }
    & $copilotScript `
        '--deny-tool=shell(Remove-Item:*)' `
        '--deny-tool=shell(Move-Item:*)' `
        '--deny-tool=shell(Set-Content:*)' `
        '--deny-tool=shell(Out-File:*)' `
        '--deny-tool=shell(reg:*)' `
        '--deny-tool=shell(del:*)' `
        '--deny-tool=shell(erase:*)' `
        '--deny-tool=shell(rd:*)' `
        '--deny-tool=shell(rmdir:*)' `
        '--deny-tool=shell(rm:*)' `
        @args
}
```

只有在使用者明確要求 broad agent mode 時，才加入 `--allow-all-tools`、`--allow-all-paths`、`--allow-all-urls`。即使加入，也要保留 deny 規則。

## 安裝紀錄

Codex CLI 使用官方 npm 套件安裝：

```powershell
npm i -g @openai/codex@latest
```

GitHub Copilot CLI 原本嘗試使用 WinGet：

```powershell
winget install --id GitHub.Copilot --exact --accept-source-agreements --accept-package-agreements
```

但 WinGet 安裝流程在本機卡住，因此改用 GitHub 官方也支援的 npm 安裝方式：

```powershell
npm install -g @github/copilot
```
