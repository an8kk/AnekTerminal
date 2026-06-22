if (-not $global:AnekOhMyPoshInitialized) {
    $global:AnekOhMyPoshInitialized = $true
    oh-my-posh init pwsh --config "$HOME\minimal.omp.json" | Invoke-Expression
}
