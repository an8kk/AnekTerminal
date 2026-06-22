# Minimal Windows Terminal setup

Small reusable setup for Windows Terminal, PowerShell, Oh My Posh, and MesloLGS Nerd Font.

Prompt layout: status on the first line, input on the second line.

```text
C:\Users\Anek\kao on  master is 󰏗 v0.1.0 via  v3.13.12
› your command here
```

Legend:

- `C:\Users\Anek\kao`: full current directory.
- `on  master`: current git branch; shown only inside git repos.
- `is 󰏗 v0.1.0`: project/package version from `pyproject.toml`, `package.json`, or other supported project files.
- `via  v3.13.12`: active Python version via `uv`.
- `›`: input prompt symbol on its own line.

## Install

```powershell
git clone https://github.com/an8kk/AnekTerminal.git dotfiles
cd dotfiles/terminal
powershell -ExecutionPolicy Bypass -File setup.ps1
```

After setup, restart Windows Terminal. The script applies the profile, prompt theme, Anek color scheme, MesloLGS Nerd Font, cursor shape, and background image.

## Windows Terminal appearance

- Color scheme: Anek dark
- Font: MesloLGS Nerd Font
- Background image: `terminalbg.png`, copied locally as `terminalbg-<hash>.png`
- Background image opacity: 22%
- Acrylic: off
- Terminal opacity: 100%
- Cursor shape: bar

Adjust background image opacity manually if you want the image stronger or softer.
