# PSReadLine 設定

## 作用

`PSReadLine` 負責：

- 命令列歷史
- 預測補全
- 編輯快捷鍵
- 指令輸入體驗

## 目前設定

目前在 profile 內使用：

```powershell
Import-Module PSReadLine -ErrorAction SilentlyContinue
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle InlineView
```

## 這代表什麼

- 會根據歷史命令提供建議
- 建議以單行形式顯示，不會展開成清單

## 你可以怎麼改

### 如果你覺得預測太吵

改成：

```powershell
Set-PSReadLineOption -PredictionSource None
```

### 如果你想保留預測但改成清單

改成：

```powershell
Set-PSReadLineOption -PredictionViewStyle ListView
```

### 如果你想保留預測但不要在某些 shell 出錯

保持現在這種作法：

- 只在互動式 shell 啟用

## 驗證方式

1. 開一個新 terminal
2. 輸入幾個常用命令
3. 看是否出現歷史建議

## 參考修改位置

看 [02-PowerShell-Profile.md](./02-PowerShell-Profile.md)
