# Terminal-Icons 設定

## 作用

`Terminal-Icons` 會讓 PowerShell 列目錄時顯示檔案圖示。

## 目前設定

目前 profile 內只有這行：

```powershell
Import-Module Terminal-Icons -ErrorAction SilentlyContinue
```

## 這表示什麼

- 模組本身已裝好
- 只要 PowerShell 進到互動式 shell，就會自動載入

## 你可以怎麼改

### 暫時停用

把上面那行註解掉

### 保留但只在某些 shell 用

可以包成條件判斷，例如只在 Windows Terminal 內啟用

## 驗證方式

在 PowerShell 輸入：

```powershell
Get-ChildItem
```

如果圖示正常，就代表模組已生效。

## 參考修改位置

看 [02-PowerShell-Profile.md](./02-PowerShell-Profile.md)
