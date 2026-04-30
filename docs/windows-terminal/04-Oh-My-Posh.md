# Oh My Posh 設定

## 作用

`Oh My Posh` 負責提示字元外觀，例如：

- 路徑
- Git branch
- 錯誤狀態
- Python venv

## 目前設定方式

目前 profile 會：

1. 找 `oh-my-posh`
2. 先讀目前 session 的 `OMP_THEME_SESSION_NAME`
3. 再讀 User 層級的 `OMP_THEME_NAME`
4. 找到對應 theme 檔時才帶 `--config` 初始化
5. 找不到 theme 檔時走 Oh My Posh 預設初始化，避免 profile 啟動失敗

目前用的是安全寫法：

```powershell
$ompInit = (& $ompPath init pwsh) -join "`n"
if (-not [string]::IsNullOrWhiteSpace($ompInit)) {
    Invoke-Expression $ompInit
}
```

## 為什麼這樣寫

`oh-my-posh init pwsh` 會輸出多行腳本，必須先接成單一字串，不然容易因為被逐行執行而報錯。

## 你可以怎麼改

### 指定永久 theme

優先使用 `omp-theme` helper：

```powershell
omp-theme set robbyrussell
```

### 換其他 theme

```powershell
omp-theme list
omp-theme preview slim
omp-theme set slim
```

若 helper 不可用，才直接設定 User 層級環境變數：

```powershell
[Environment]::SetEnvironmentVariable("OMP_THEME_NAME", "robbyrussell", "User")
```

### 暫時停用

把 `Invoke-Expression $ompInit` 那段先註解掉

## 常見問題

### 開 terminal 就報錯

通常是：

1. `oh-my-posh` 找不到
2. theme 路徑不存在
3. 多行 init 腳本被錯誤逐行執行
4. Oh My Posh 切 theme 後沒有重新初始化 zoxide hook

Oh My Posh 會重建 `prompt`。如果 profile 同時使用 zoxide，請先初始化 Oh My Posh，再執行 `Invoke-ZoxideInit -Force`。

## 參考修改位置

看 [02-PowerShell-Profile.md](./02-PowerShell-Profile.md)
