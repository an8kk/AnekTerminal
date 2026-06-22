# Minimal Windows Terminal setup

Small reusable setup for Windows Terminal, PowerShell, Oh My Posh, and MesloLGS Nerd Font.

Prompt layout: status on the first line, input on the second line.

```text
 C:\path\to\repo  󰘬 branch 󰏗 package-version  node-version      pwsh 7.5.5
❯ your command here
```

Legend:

- ` C:\path\to\repo`: full current path.
- `󰘬 branch`: current git branch; shown only inside git repos.
- `󰏗 package-version`: npm/package version; shown when package metadata exists.
- ` node-version`: active Node.js version; shown everywhere Node is available.
- `pwsh 7.5.5`: PowerShell name and version, right-aligned.
- `❯`: input prompt symbol on its own line.

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
