# Minimal Windows Terminal setup

Small reusable setup for Windows Terminal, PowerShell, Oh My Posh, and MesloLGS Nerd Font.

Prompt layout: status on the first line, input on the second line.

```text
kao on  master is 󰏗 v0.1.0 via  v3.13.12
› your command here
```

Legend:

- `kao`: current folder name only.
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

After setup, restart Windows Terminal and set the font face to `MesloLGS NF`.

## Recommended Windows Terminal appearance

- Theme: dark
- Acrylic: on
- Opacity: 92-95%
- Cursor shape: bar

Acrylic and opacity are intentionally left as manual Windows Terminal settings.
