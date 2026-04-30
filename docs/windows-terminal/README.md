# Windows Terminal 強化文件索引

這份索引是給你自己與後續 agents 查設定用的入口。

## 先看這份

- [00-總覽.md](./00-%E7%B8%BD%E8%A6%BD.md)

## 分項文件

- [01-Windows-Terminal.md](./01-Windows-Terminal.md)
- [02-PowerShell-Profile.md](./02-PowerShell-Profile.md)
- [03-PSReadLine.md](./03-PSReadLine.md)
- [04-Oh-My-Posh.md](./04-Oh-My-Posh.md)
- [05-Terminal-Icons.md](./05-Terminal-Icons.md)
- [06-zoxide.md](./06-zoxide.md)
- [07-eza.md](./07-eza.md)
- [08-fzf.md](./08-fzf.md)
- [09-ripgrep.md](./09-ripgrep.md)
- [10-Oh-My-Posh-Themes.md](./10-Oh-My-Posh-Themes.md)
- [11-broot.md](./11-broot.md)
- [12-AI-CLI.md](./12-AI-CLI.md)
- [13-遠端重建與-Agent-交接.md](./13-%E9%81%A0%E7%AB%AF%E9%87%8D%E5%BB%BA%E8%88%87-Agent-%E4%BA%A4%E6%8E%A5.md)
- [14-疑難排解與踩坑紀錄.md](./14-%E7%96%91%E9%9B%A3%E6%8E%92%E8%A7%A3%E8%88%87%E8%B8%A9%E5%9D%91%E7%B4%80%E9%8C%84.md)

## 目前狀態

- 階段狀態總表：[WINDOWS_TERMINAL_PHASE1_STATUS.md](./WINDOWS_TERMINAL_PHASE1_STATUS.md)
- 目前生效中的 PowerShell profile：
  [Microsoft.PowerShell_profile.ps1](/c:/Users/iwasa/Documents/PowerShell/Microsoft.PowerShell_profile.ps1)
- Windows Terminal 設定檔：
  [settings.json](/c:/Users/iwasa/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json)

## 你最常會改到的地方

1. 要改 shell 啟動行為：看 [02-PowerShell-Profile.md](./02-PowerShell-Profile.md)
2. 要改 prompt 外觀：看 [04-Oh-My-Posh.md](./04-Oh-My-Posh.md)
3. 要快速換 theme：看 [10-Oh-My-Posh-Themes.md](./10-Oh-My-Posh-Themes.md)
這裡的首選指令是 `omp-theme list`、`omp-theme tour`、`omp-theme next`
4. 要改命令補全與預測：看 [03-PSReadLine.md](./03-PSReadLine.md)
5. 要改快速跳資料夾：看 [06-zoxide.md](./06-zoxide.md)
6. 要用互動式 terminal 檔案管理器：看 [11-broot.md](./11-broot.md)
7. 要改模糊搜尋來源：看 [08-fzf.md](./08-fzf.md)
8. 要查 Codex CLI / GitHub Copilot CLI：看 [12-AI-CLI.md](./12-AI-CLI.md)
9. 要把設定推到遠端、讓另一台電腦的 agents 重建：看 [13-遠端重建與-Agent-交接.md](./13-%E9%81%A0%E7%AB%AF%E9%87%8D%E5%BB%BA%E8%88%87-Agent-%E4%BA%A4%E6%8E%A5.md)
10. 開 Windows Terminal 報錯、broot 顏色不對、工具找不到：看 [14-疑難排解與踩坑紀錄.md](./14-%E7%96%91%E9%9B%A3%E6%8E%92%E8%A7%A3%E8%88%87%E8%B8%A9%E5%9D%91%E7%B4%80%E9%8C%84.md)
