# fzf 設定

## 作用

`fzf` 是模糊搜尋工具，適合：

- 找檔案
- 篩選清單
- 搭配其他命令做互動式選擇

## 目前設定

目前 profile 只在 `rg` 與 `fzf` 都存在時做一個保守整合：

```powershell
if ((Get-Command rg -ErrorAction SilentlyContinue) -and (Get-Command fzf -ErrorAction SilentlyContinue)) {
    $env:FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git"'
    $env:FZF_CTRL_T_COMMAND = $env:FZF_DEFAULT_COMMAND
}
```

## 這代表什麼

- `fzf` 預設找檔案時會用 `rg`
- 會包含 hidden 檔案
- 會略過 `.git`

## 你可以怎麼改

### 不想搜尋 hidden 檔

改成：

```powershell
$env:FZF_DEFAULT_COMMAND = 'rg --files --glob "!.git"'
```

### 想加預覽

之後可以再加：

```powershell
$env:FZF_DEFAULT_OPTS = '--height 60% --layout=reverse --border'
```

### 想配合 `bat` 做檔案預覽

第三階段裝 `bat` 後可以再接：

```powershell
$env:FZF_DEFAULT_OPTS = '--preview "bat --color=always --style=numbers --line-range=:200 {}"'
```

## 目前還沒做的部分

- 沒有加 PowerShell 專屬熱鍵綁定
- 沒有加預覽視窗
- 沒有接歷史命令互動搜尋

## 參考修改位置

看 [02-PowerShell-Profile.md](./02-PowerShell-Profile.md)
