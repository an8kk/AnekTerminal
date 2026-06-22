$ErrorActionPreference = 'Stop'

function Install-WingetPackage {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Id,

        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    $installed = winget list --id $Id --exact --accept-source-agreements
    if (($installed -join "`n") -match [regex]::Escape($Id)) {
        Write-Host "$Name is already installed."
        return
    }

    Write-Host "Installing $Name..."
    winget install --id $Id --exact --source winget --accept-package-agreements --accept-source-agreements --disable-interactivity
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to install $Name with winget."
    }
}

function Refresh-Path {
    $machinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    $env:Path = "$machinePath;$userPath"
}

Install-WingetPackage -Id 'Microsoft.PowerShell' -Name 'PowerShell'
Install-WingetPackage -Id 'Microsoft.WindowsTerminal' -Name 'Windows Terminal'
Install-WingetPackage -Id 'JanDeDobbeleer.OhMyPosh' -Name 'Oh My Posh'

Refresh-Path

$ohMyPosh = Get-Command oh-my-posh -ErrorAction SilentlyContinue
if (-not $ohMyPosh) {
    throw 'oh-my-posh was installed, but is not available on PATH yet. Restart this shell and run setup.ps1 again.'
}

Write-Host 'Installing MesloLGS Nerd Font via Oh My Posh...'
& $ohMyPosh.Source font install meslo
if ($LASTEXITCODE -ne 0) {
    throw 'Failed to install MesloLGS Nerd Font.'
}

$themeSource = Join-Path $PSScriptRoot 'minimal.omp.json'
$profileSource = Join-Path $PSScriptRoot 'Microsoft.PowerShell_profile.ps1'

Copy-Item -LiteralPath $themeSource -Destination (Join-Path $HOME 'minimal.omp.json') -Force

$documents = [Environment]::GetFolderPath('MyDocuments')
$profileTargets = @(
    (Join-Path $documents 'PowerShell\profile.ps1'),
    (Join-Path $documents 'PowerShell\Microsoft.PowerShell_profile.ps1'),
    (Join-Path $documents 'WindowsPowerShell\profile.ps1'),
    (Join-Path $documents 'WindowsPowerShell\Microsoft.PowerShell_profile.ps1')
)

foreach ($profilePath in $profileTargets) {
    $profileDir = Split-Path -Parent $profilePath
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
    Copy-Item -LiteralPath $profileSource -Destination $profilePath -Force
}

Write-Host ''
Write-Host 'Setup complete.'
Write-Host ''
Write-Host 'Next steps:'
Write-Host '1. Restart Windows Terminal.'
Write-Host '2. Set Windows Terminal font face to MesloLGS NF.'
Write-Host '3. Set acrylic and opacity manually if desired.'
