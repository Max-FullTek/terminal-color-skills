# eza 設定

## 目前狀態

目前已改成不使用 `eza`。

原因：

- 你已經有 `Terminal-Icons`
- 一般列目錄時，`eza` 和 PowerShell 原生 `Get-ChildItem` 的差異不夠有感
- 更符合需求的是互動式 terminal 檔案管理器 `broot`

`eza` 不會常駐吃資源，只在執行時才跑；移除主要是為了降低工具重疊與 profile 複雜度。

## 目前設定

profile 內的 `eza` 快捷函式已移除。

如果未來想重新啟用，再重新安裝 `eza-community.eza`，並在 profile 補回需要的函式即可。

## 替代方案

請看：

[11-broot.md](./11-broot.md)
