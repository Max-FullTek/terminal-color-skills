# Windows Terminal 設定

## 設定檔位置

[settings.json](/c:/Users/iwasa/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json)

## 目前已套用的重點

- 預設 profile 是 PowerShell 7
- 字型已設成 `FiraCode Nerd Font Mono`
- 字級是 `14`
- `cellHeight` 是 `1.3`
- `opacity` 是 `40`
- `useAcrylic` 是 `true`
- PowerShell profile 使用 `Warm Sand` 色票
- `Shift+Enter` 會送出 `ESC + Enter`，給 broot 回 shell 並切換資料夾
- `Alt+Enter` 已解除綁定，避免誤觸 Windows Terminal 全螢幕
- 已有常用快捷鍵：
  `Ctrl+C`、`Ctrl+V`、`Ctrl+Shift+F`、`Alt+Shift+D`

## 你通常會改哪些欄位

### 改預設 shell

看 `defaultProfile`

### 改字型與字級

看：

```json
"profiles": {
  "defaults": {
    "font": {
      "face": "FiraCode Nerd Font Mono",
      "size": 14,
      "cellHeight": "1.3"
    }
  }
}
```

### 改快捷鍵

看 `actions` 與 `keybindings`

## 目前不建議自動改的項目

1. PowerShell 管理員專用 profile
2. 常用分頁切換快捷鍵
3. 字體縮放快捷鍵
4. WSL 與 PowerShell profile 的視覺區分

這些可能牽涉私人 profile、SSH profile 或個人快捷鍵習慣，agent 不應在沒有明確需求時主動改。

## 修改後如何驗證

1. 開新分頁確認預設 shell
2. 看字型是否仍能正確顯示 Nerd Font 圖示
3. 測試快捷鍵是否如預期
