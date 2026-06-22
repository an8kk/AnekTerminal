# Minimal Windows Terminal setup

Small reusable setup for Windows Terminal, PowerShell, Oh My Posh, and MesloLGS Nerd Font.

Prompt layout: full path, git branch, package version, Node.js version, and a right-aligned PowerShell version.

## Install

```powershell
git clone https://github.com/an8kk/AnekTerminal.git dotfiles
cd dotfiles/terminal
powershell -ExecutionPolicy Bypass -File setup.ps1
```

After setup, restart Windows Terminal and set the font face to `MesloLGS NF`.

## Recommended Windows Terminal appearance

- Theme: dark
- Acrylic: on
- Opacity: 92-95%
- Cursor shape: bar

Acrylic and opacity are intentionally left as manual Windows Terminal settings.
