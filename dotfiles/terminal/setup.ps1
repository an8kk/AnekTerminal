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

function Set-ObjectProperty {
    param(
        [Parameter(Mandatory = $true)]
        [psobject]$Object,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        $Value
    )

    $Object | Add-Member -MemberType NoteProperty -Name $Name -Value $Value -Force
}

function Update-WindowsTerminalSettings {
    param(
        [Parameter(Mandatory = $true)]
        [string]$BackgroundPath
    )

    $settingsPath = Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json'
    if (-not (Test-Path -LiteralPath $settingsPath)) {
        Write-Host 'Windows Terminal settings.json was not found. Open Windows Terminal once, then rerun setup.ps1 to apply appearance settings.'
        return
    }

    $settings = Get-Content -Raw -LiteralPath $settingsPath | ConvertFrom-Json
    if (-not $settings.profiles) {
        Set-ObjectProperty -Object $settings -Name 'profiles' -Value ([pscustomobject]@{})
    }

    if (-not $settings.profiles.defaults) {
        Set-ObjectProperty -Object $settings.profiles -Name 'defaults' -Value ([pscustomobject]@{})
    }

    $defaults = $settings.profiles.defaults
    Set-ObjectProperty -Object $defaults -Name 'backgroundImage' -Value $BackgroundPath
    Set-ObjectProperty -Object $defaults -Name 'backgroundImageAlignment' -Value 'center'
    Set-ObjectProperty -Object $defaults -Name 'backgroundImageOpacity' -Value 0.22
    Set-ObjectProperty -Object $defaults -Name 'backgroundImageStretchMode' -Value 'uniformToFill'
    Set-ObjectProperty -Object $defaults -Name 'cursorShape' -Value 'bar'
    Set-ObjectProperty -Object $defaults -Name 'opacity' -Value 94
    Set-ObjectProperty -Object $defaults -Name 'useAcrylic' -Value $true

    if (-not $defaults.font) {
        Set-ObjectProperty -Object $defaults -Name 'font' -Value ([pscustomobject]@{})
    }
    Set-ObjectProperty -Object $defaults.font -Name 'face' -Value 'MesloLGS Nerd Font'

    $settings | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $settingsPath -Encoding UTF8
    Write-Host 'Windows Terminal defaults updated.'
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
$backgroundSource = Join-Path $PSScriptRoot 'terminalbg.png'
$backgroundTarget = Join-Path $HOME 'terminalbg.png'

Copy-Item -LiteralPath $themeSource -Destination (Join-Path $HOME 'minimal.omp.json') -Force
Copy-Item -LiteralPath $backgroundSource -Destination $backgroundTarget -Force

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

Update-WindowsTerminalSettings -BackgroundPath $backgroundTarget

Write-Host ''
Write-Host 'Setup complete.'
Write-Host ''
Write-Host 'Next steps:'
Write-Host '1. Restart Windows Terminal.'
Write-Host '2. The prompt, MesloLGS Nerd Font, acrylic, opacity, and terminal background are applied.'
Write-Host '3. Adjust Windows Terminal appearance manually only if you want a different opacity.'
