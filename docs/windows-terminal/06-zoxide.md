# zoxide 設定

## 作用

`zoxide` 是快速跳資料夾工具，常用法：

```powershell
z repo
zi
```

## 目前設定

目前 profile 內會：

1. 找到 `zoxide`
2. 執行 `zoxide init powershell`
3. 把初始化輸出接成單一字串後 `Invoke-Expression`

目前安全寫法：

```powershell
$zoxideCommand = Get-Command zoxide -ErrorAction SilentlyContinue
if ($zoxideCommand) {
    $zoxideInit = (& $zoxideCommand.Source init powershell) -join "`n"
}
if (-not [string]::IsNullOrWhiteSpace($zoxideInit)) {
    Invoke-Expression $zoxideInit
}
```

## 為什麼要這樣寫

`zoxide init powershell` 會輸出整段 PowerShell 腳本。
如果直接管線給 `Invoke-Expression`，會有機率被拆成多行個別執行，進而出現：

- 空字串錯誤
- 大括號區塊不完整錯誤

實際遇過的 Windows Terminal 啟動錯誤：

```text
Invoke-Expression: Cannot bind argument to parameter 'Command' because it is an empty string.
Invoke-Expression: Missing closing '}' in statement block or type definition.
```

這不是 zoxide 壞掉，而是 profile 把初始化腳本拆碎執行。

## 與 Oh My Posh 的順序

Oh My Posh 和 zoxide 都會碰到 `prompt`。建議先初始化 Oh My Posh，再初始化 zoxide：

```powershell
Invoke-OmpInit
Invoke-ZoxideInit -Force
```

如果 `omp-theme` helper 會在目前 session 重新載入 Oh My Posh，也要在 theme 切換後再跑一次 zoxide init，否則 `z` 還能跳目錄，但目錄紀錄 hook 可能不再更新。

## 你可以怎麼改

### 改命令前綴

例如你不想用 `z`，可以改成：

```powershell
$zoxideInit = (& $zoxideCommand.Source init powershell --cmd j) -join "`n"
```

### 不想自動建立 `z` / `zi`

```powershell
$zoxideInit = (& $zoxideCommand.Source init powershell --no-cmd) -join "`n"
```

### 暫時停用

把整個 zoxide 區塊先註解掉

## 常用指令

```powershell
z project
zi
zoxide query project
```

## 參考修改位置

看 [02-PowerShell-Profile.md](./02-PowerShell-Profile.md)
