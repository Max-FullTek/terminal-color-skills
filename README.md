# Terminal Color Skills

這個 repo 是一組給 Codex / agents 使用的 Windows 終端機美化與重建 skills。

它現在包含兩層：

1. **主流程 skill**：負責盤點優先順序，帶 agents 依序執行。
2. **子項 skills**：各自處理 Windows Terminal、PowerShell profile、Oh My Posh、導航工具、AI CLI wrapper 等小範圍工作。

目標是讓另一台 Windows 電腦上的 agent 可以安全重建目前偏好的終端機環境，而不是直接複製本機完整設定檔。

## 安裝入口

如果安裝器支援一次載入多個 skills，可以使用 repo 根目錄。

如果安裝器要求指定單一 skill path，請依照下方列表安裝 `skills/<skill-name>`，至少先安裝主入口 `skills/terminal-beautify-main` 與你要執行的子項 skills。

如果只想套用 Windows Terminal 色票，請安裝這個子路徑：

```text
https://github.com/Max-FullTek/terminal-color-skills/tree/main/skills/terminal-color-skills
```

如果要讓 agent 執行完整美化流程，請從主 skill 開始：

```text
Use $terminal-beautify-main to audit, rebuild, and beautify this Windows terminal environment.
```

## Skills 總覽

建議執行順序如下。

| 順序 | Skill | 作用 |
| --- | --- | --- |
| 入口 | `terminal-beautify-main` | 主流程入口。負責安排盤點、備份、Windows Terminal、PowerShell、Oh My Posh、工具與 AI CLI wrappers 的執行順序。 |
| 1 | `terminal-audit-backup` | 先盤點目前機器狀態並備份設定檔，避免 agents 直接覆蓋本機設定。 |
| 2 | `windows-terminal-appearance` | 套用 Windows Terminal 外觀設定，例如字型、字級、透明度、acrylic、padding、scrollbar 與快捷鍵。 |
| 3 | `terminal-color-skills` | 套用 bundled `Warm Sand` 色票，只管理 Windows Terminal `schemes` 與指定 profile 的 `colorScheme`。 |
| 4 | `powershell-profile-core` | 建立安全的 PowerShell profile 基礎架構，例如 UTF-8、PATH fallback、互動式 shell guard、completions 載入。 |
| 5 | `powershell-readline-icons` | 安裝與設定 PSReadLine、Terminal-Icons、歷史命令預測與互動式輸入體驗。 |
| 6 | `oh-my-posh-setup` | 安裝與初始化 Oh My Posh，設定 `OMP_THEME_NAME`、session preview 與 `omp-theme` helper 流程。 |
| 7 | `terminal-navigation-tools` | 安裝與串接 zoxide、fzf、ripgrep、broot，包含 `FZF_DEFAULT_COMMAND` 與 `b` / `br` 流程。 |
| 8 | `ai-cli-terminal-wrappers` | 設定 Codex CLI 與 GitHub Copilot CLI 的 PowerShell wrappers，但不搬移 auth、tokens、logs 或 sessions。 |

## 主流程如何運作

`terminal-beautify-main` 是 orchestrator。

它不應該塞滿所有設定細節，而是告訴 agent：

1. 先用 `terminal-audit-backup` 盤點與備份。
2. 再用 `windows-terminal-appearance` 套 Windows Terminal 外觀。
3. 再用 `terminal-color-skills` 套 `Warm Sand` 色票。
4. 再用 `powershell-profile-core` 建立 profile 基礎。
5. 再用 `powershell-readline-icons` 補互動式輸入與圖示。
6. 再用 `oh-my-posh-setup` 套 prompt。
7. 再用 `terminal-navigation-tools` 補導航與搜尋工具。
8. 最後用 `ai-cli-terminal-wrappers` 整合 Codex / Copilot CLI。

如果其中任何一步失敗，agent 應該停下來回報：

- 卡在哪一個 phase
- 已經改了哪些檔案
- 已經建立哪些備份
- 下一步需要使用者決定什麼

## 安全規則

這個 repo 只能存放安全文件、redacted 摘要與可公開的 skills。

不要提交或搬移：

- Codex `auth.json`
- Codex `history.jsonl`
- Codex `sessions`
- Codex `logs_*.sqlite*`
- Codex `state_*.sqlite*`
- `.sandbox-secrets`
- VS Code user settings 原始檔，尤其是含 token 或 MCP 設定的版本
- Windows Terminal 完整 `settings.json`，除非已確認沒有私人 SSH profiles、主機名稱、IP 或其他敏感資訊
- 本機備份檔，例如 `*.bak.*`

搬到新電腦時，應該合併文件中的外觀與 profile snippets，而不是覆蓋整份私人設定。

## 風險控管補強

這些是 agents 執行完整流程時必須特別注意的地方：

- `terminal-audit-backup` 會建立 `.bak.<timestamp>` 備份，但 rollback 不是自動的。agent 回報時必須列出每個備份的完整路徑，方便使用者用 `Copy-Item` 手動還原。
- `windows-terminal-appearance` 寫入 `FiraCode Nerd Font Mono` 前，應先檢查字型是否已安裝。若沒有安裝，Windows Terminal 可能靜默 fallback，Terminal-Icons 也可能顯示成方塊。
- `zoxide init powershell` 會輸出多行 PowerShell 腳本。不要直接 `zoxide init powershell | Invoke-Expression`，要先 `-join "\`n"` 成完整字串並確認非空，否則開 Windows Terminal 可能出現 empty string 或 missing `}` 錯誤。
- Oh My Posh 會接管 `prompt`。如果同時使用 zoxide，先初始化 Oh My Posh，再初始化 zoxide，或在 `omp-theme` 切換後重新跑 zoxide init，避免 zoxide 的 directory hook 被 prompt 重建覆蓋。
- `terminal-navigation-tools` 不只要接上 `b` / `br`，也要套用 broot 自己的 `codex-muted-green` skin。broot 不會自動吃 Windows Terminal 的 `Warm Sand` 色票。
- `broot --install` 在 Windows 上可能因 symlink 權限失敗。若官方 PowerShell launcher 沒產生，可以使用 `broot --print-shell-function powershell` 的輸出作為 fallback，但要明確回報這個狀態。
- `ai-cli-terminal-wrappers` 不應假設 npm global shim 一定在 `C:\Program Files\nodejs`。需先檢查 `npm root -g`、`npm prefix -g` 與 `Get-Command -All codex,copilot`。
- Copilot wrapper 預設應採保守權限，不使用 `--allow-all-*`。若使用者明確要求 broad agent mode，也必須保留刪除、搬移、寫檔與 registry 類 shell deny 規則。

## 重要文件

- Agent 入口說明：[AGENTS.md](./AGENTS.md)
- Windows Terminal 文件索引：[docs/windows-terminal/README.md](./docs/windows-terminal/README.md)
- 遠端重建指南：[docs/windows-terminal/13-遠端重建與-Agent-交接.md](./docs/windows-terminal/13-%E9%81%A0%E7%AB%AF%E9%87%8D%E5%BB%BA%E8%88%87-Agent-%E4%BA%A4%E6%8E%A5.md)
- 疑難排解紀錄：[docs/windows-terminal/14-疑難排解與踩坑紀錄.md](./docs/windows-terminal/14-%E7%96%91%E9%9B%A3%E6%8E%92%E8%A7%A3%E8%88%87%E8%B8%A9%E5%9D%91%E7%B4%80%E9%8C%84.md)
- 目前狀態紀錄：[WINDOWS_TERMINAL_PHASE1_STATUS.md](./docs/windows-terminal/WINDOWS_TERMINAL_PHASE1_STATUS.md)

## Windows Terminal 設定路徑

agents 應依序檢查：

```text
%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
%LOCALAPPDATA%\Microsoft\Windows Terminal\settings.json
```

如果兩個路徑都不存在，agent 應該詢問使用者要編輯哪一份設定檔。

## 色票名稱

目前 canonical 色票名稱是：

```text
Warm Sand
```

`terminal-color-skills` 會把這組色票加入或更新到 Windows Terminal `schemes`，再把指定 profile 的 `colorScheme` 指向 `Warm Sand`。

`theme` 和 `colorScheme` 是不同東西：

- Windows Terminal `colorScheme` 控制文字與 ANSI 顏色。
- Oh My Posh theme 控制 prompt 的外觀。
- broot `skin` 控制 broot UI 內部顏色，預設使用 `codex-muted-green.hjson`，需要另外寫入 `%APPDATA%\dystroy\broot\config\skins` 並在 `conf.hjson` 啟用。

## 建議給 Agent 的一句話

完整重建：

```text
Read the README, then use $terminal-beautify-main to rebuild and beautify this Windows terminal environment safely.
```

只套色票：

```text
Use $terminal-color-skills to apply the bundled Warm Sand scheme to Windows Terminal.
```
