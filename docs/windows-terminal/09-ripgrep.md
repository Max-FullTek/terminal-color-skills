# ripgrep 設定

## 作用

`ripgrep` 是全文搜尋工具，常用來：

- 搜專案內文字
- 搭配 `fzf` 當檔案清單來源
- 取代比較慢的 `findstr` / `grep`

## 目前設定

目前沒有特別在 profile 裡替 `rg` 建 alias。
主要調整是把 winget 相關路徑放到 PATH 前面，讓 `rg` 優先指向 winget 安裝版，而不是 VS Code / ChatGPT extension 內建版。

目前實機常見路徑是 winget portable package 目錄：

```text
C:\Users\iwasa\AppData\Local\Microsoft\WinGet\Packages\BurntSushi.ripgrep.MSVC_Microsoft.Winget.Source_8wekyb3d8bbwe\ripgrep-15.1.0-x86_64-pc-windows-msvc\rg.exe
```

不要在 profile 寫死這個長路徑。用 PATH 與 `Get-Command rg` 驗證即可。

## 常用指令

```powershell
rg TODO
rg "class User"
rg --files
rg --files | fzf
```

## 你可以怎麼改

### 想排除更多目錄

常見做法是加 `.rgignore`

### 想讓搜尋固定包含 hidden

可以自訂 function：

```powershell
function rgh { rg --hidden --glob "!.git" @args }
```

### 想確認目前吃到哪個 `rg`

```powershell
Get-Command rg
rg --version
```

## 這份設定的重點

因為你原本 shell 先抓到 VS Code 內建的 `rg`，所以目前是用 PATH 順序修正，讓你自己的環境先吃到 winget 版本。

## 參考修改位置

看 [02-PowerShell-Profile.md](./02-PowerShell-Profile.md)
