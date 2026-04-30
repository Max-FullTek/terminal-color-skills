param(
    [Parameter(Position = 0)]
    [ValidateSet("clean-detailed", "slim", "paradox", "tokyonight_storm")]
    [string]$Theme = "clean-detailed"
)

[Environment]::SetEnvironmentVariable("OMP_THEME_NAME", $Theme, "User")
$env:OMP_THEME_NAME = $Theme

Write-Host "Oh My Posh theme set to: $Theme"
Write-Host "Open a new Windows Terminal tab, or run:"
Write-Host ". `$PROFILE"
