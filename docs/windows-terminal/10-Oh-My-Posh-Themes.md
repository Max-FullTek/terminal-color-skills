# Oh My Posh Theme 試用包

## 目前切換方式

PowerShell profile 會優先讀取使用者環境變數：

`OMP_THEME_NAME`

如果有設定，就直接用該 theme 名稱初始化 `Oh My Posh`。
如果沒有設定，預設會用：

`clean-detailed`

另外，臨時預覽會使用目前 session 專用的：

`OMP_THEME_SESSION_NAME`

這樣可以避免 `omp-theme preview <name>` 影響永久設定。

## VS Code Integrated Terminal 注意事項

VS Code 的 integrated terminal 會繼承 VS Code 主程式啟動時的環境變數。
如果只依賴 `$env:OMP_THEME_NAME`，就可能發生「Windows Terminal 正常，但 VS Code 新 terminal 又變回舊 theme」的情況。

目前 profile 已改成：

1. 永久 theme 一律讀取 User 層級的 `OMP_THEME_NAME`
2. 當前 session 預覽才讀取 `OMP_THEME_SESSION_NAME`
3. 不再讓 VS Code process 裡殘留的舊 `$env:OMP_THEME_NAME` 覆蓋 User 設定

如果 VS Code terminal 已經開著，改完後可以執行：

```powershell
. $PROFILE
```

或重新開一個 integrated terminal。

## 目前可切換的主題清單

目前 `omp-theme` 已經擴成完整清單模式。
現在 `omp-theme list` / `omp-theme next` / `omp-theme prev` / `omp-theme tour`
會在目前這版 `oh-my-posh 29.12.0` 可用的整批內建主題中輪播。

我這邊已驗證，目前已載入並可正常使用的主題共有：

`122` 個

如果你想看完整名單，直接執行：

```powershell
omp-theme list
```

這批主題來源是依照 Oh My Posh 官方 theme 名稱整理後，再逐一驗證可用性留下來的。

## 我最推薦先看的主題

### 1. `clean-detailed`

感覺：

- 乾淨
- 可讀性高
- 資訊量適中

### 2. `slim`

感覺：

- 最精簡
- 很輕
- 視覺壓力低

### 3. `paradox`

感覺：

- Powerline 風格明顯
- 區塊感強
- 比較有 Nerd Font 味道

### 4. `tokyonight_storm`

感覺：

- 顏色現代
- 對比舒服
- 視覺個性較強

### 5. `powerlevel10k_modern`

感覺：

- 整體平衡
- 比較像成熟開發者主力 prompt

### 6. `catppuccin_mocha`

感覺：

- 顏色柔和
- 氣氛比較明確

## 快速切換

現在最推薦的方式，是直接用已經寫進 PowerShell profile 的主指令：

```powershell
omp-theme list
omp-theme current
omp-theme tour
omp-theme preview clean-detailed
omp-theme set clean-detailed
omp-theme clean-detailed
omp-theme next
omp-theme prev
```

這些指令可以在任何資料夾直接用，不需要切到專案目錄。

## 指令用途

- `omp-theme list`
  列出候選 theme 名稱，並標示目前使用中的 theme
- `omp-theme current`
  顯示目前正在使用的 theme 名稱
- `omp-theme tour`
  進入互動式輪播模式，逐一預覽 theme，最後再決定是否存下來
- `omp-theme preview <name>`
  只在目前 session 套用指定 theme，不寫入永久設定
- `omp-theme set <name>`
  直接切到指定 theme 並存成永久設定
- `omp-theme <name>`
  直接切到指定 theme，效果等同 `omp-theme set <name>`
- `omp-theme next`
  切到下一個 theme
- `omp-theme prev`
  切回上一個 theme

## 建議你現在怎麼試

### 方式 1：互動式輪播，最推薦

```powershell
omp-theme tour
```

進入後可用：

- `Enter` 或 `n`：下一個
- `p`：上一個
- `s`：保存目前 theme
- `q`：退出且不保存

### 方式 2：先看名稱列表再手選

```powershell
omp-theme list
omp-theme paradox
```

### 方式 3：只在當前 session 試看

```powershell
omp-theme preview slim
omp-theme preview paradox
omp-theme preview tokyonight_storm
omp-theme preview powerlevel10k_modern
```

### 方式 4：逐一輪播並永久切換

```powershell
omp-theme next
omp-theme next
omp-theme prev
```

## 備用切換方式

專案裡也有保留切換腳本：

[switch-omp-theme.ps1](../../skills/oh-my-posh-setup/scripts/switch-omp-theme.ps1)

注意：

- 這支腳本是保留在 Oh My Posh skill 裡的備用工具，所以你必須從專案目錄或完整路徑執行
- 如果你人在 `~`，請優先用 `omp-theme`

## 相關文件

- [04-Oh-My-Posh.md](./04-Oh-My-Posh.md)
- [02-PowerShell-Profile.md](./02-PowerShell-Profile.md)
- [README.md](./README.md)
