# Theme Switching

The image ships a time-based light/dark theme switcher that synchronises GNOME Shell, the kitty terminal, Neovim, and Emacs/Spacemacs.  The palette used for both variants is **Tokyo Night** — the dark (`night`) style at night and a bespoke light (`day`) style during the day, derived from the same `folke/tokyonight.nvim` colour set.

---

## Overview

| Time | Mode | GNOME scheme | Accent | Wallpaper |
|------|------|-------------|--------|-----------|
| 08:00 → 19:59 | **day** | `prefer-light` | blue | `tokyo-day.jpg` (clement-souchet) |
| 20:00 → 07:59 | **night** | `prefer-dark` | slate | `tokyonight.jpg` |

All four apps — GNOME Shell, kitty, Neovim, Emacs — switch atomically each time the mode changes.

---

## The `theme-switch` Script

**Location:** `/usr/local/bin/theme-switch`

```
theme-switch [day|night|auto]
```

| Argument | Behaviour |
|----------|-----------|
| `day` | Unconditionally switch to light/day mode |
| `night` | Unconditionally switch to dark/night mode |
| `auto` | Read the current hour; switch to `day` if 08 ≤ hour < 20, otherwise `night` |

The script is idempotent — running it repeatedly in the same mode is safe.

### What it changes

1. **GNOME** — calls `gsettings set org.gnome.desktop.interface color-scheme` and `accent-color`.  GNOME automatically picks `picture-uri` (day wallpaper) or `picture-uri-dark` (night wallpaper) to match.
2. **kitty** — copies `~/.config/kitty/tokyonight-day.conf` or `~/.config/kitty/tokyonight.conf` over `~/.config/kitty/current-theme.conf`, then sends `SIGUSR1` to every running kitty process to reload the config.
3. **ddterm** — writes `foreground-color`, `background-color` and the 16-colour `palette` under `/com/github/amezin/ddterm/`.  ddterm repaints open terminals as the keys change.
4. **oh-my-posh** — copies `~/.config/oh-my-posh/config-day.json` or `config-night.json` over `config.json`.  oh-my-posh re-reads its config on every prompt, so running shells repaint at the next prompt.
5. **Claude Code** — sets `theme` to `light` or `dark` in `~/.claude/settings.json`.  Claude Code draws its own input box, dim hints and diff highlighting, and defaults to `dark`, which is unreadable on a light terminal.  The key is rewritten only when it actually differs.
6. **Mode marker** — writes `day` or `night` to `$XDG_STATE_HOME/theme-mode` (`~/.local/state/theme-mode`).  Anything that renders its own colours can read one file instead of querying GNOME on every redraw; the Claude Code status line does exactly that.
7. **Neovim** — iterates all nvim server sockets under `$XDG_RUNTIME_DIR` and `/tmp`, sending `:set background=light` or `:set background=dark` to each.
8. **Emacs** — calls `emacsclient --eval "(change-theme-to-light)"` or `"(change-theme-to-dark)"`.

Apps that are not running are silently skipped.

---

## Automatic Scheduling

Three systemd **user** units handle automatic switching.  They are pre-enabled for every user via skel symlinks, so no `systemctl --user enable` step is required after first login.

### `theme-day.timer` / `theme-day.service`

Fires daily at **08:00**.  Runs `theme-switch day`.

### `theme-night.timer` / `theme-night.service`

Fires daily at **20:00**.  Runs `theme-switch night`.

### `theme-startup.service`

Runs once each time a graphical session starts (`WantedBy=graphical-session.target`).  Calls `theme-switch auto`, which picks the correct mode based on the current clock time.  This ensures the right theme is active even after a reboot or login that happens outside a scheduled switch window.

### Inspecting timer status

```bash
systemctl --user list-timers theme-day.timer theme-night.timer
systemctl --user status theme-startup.service
```

### Manual override

```bash
theme-switch day
theme-switch night
```

---

## GNOME Integration

Two dconf keys in `/etc/dconf/db/local.d/00-lab-defaults` control the wallpaper per colour scheme:

```ini
[org/gnome/desktop/background]
picture-uri='file:///usr/share/backgrounds/tokyo-day.jpg'
picture-uri-dark='file:///usr/share/backgrounds/tokyonight.jpg'
```

GNOME Shell reads `picture-uri` when `color-scheme` is `prefer-light` and `picture-uri-dark` when it is `prefer-dark`.  The theme-switch script only needs to change `color-scheme`; the wallpaper follows automatically.

These are dconf *defaults*.  A user who has ever picked a wallpaper in Settings has both keys set in their own database, which shadows the defaults and pins one image across both modes.  `gsettings reset org.gnome.desktop.background picture-uri picture-uri-dark` puts such a user back on the image defaults.

### Shell themes

Since GNOME 47 the stock shell stylesheet ships light and dark variants and picks one from `color-scheme`, so the top bar and menus follow the switch on their own.  The image overrides two things on top of that, through a pair of user shell themes in `/usr/share/themes/`:

| | LabDay | LabNight |
|---|---|---|
| Base | `gnome-shell-light.css` | `gnome-shell-dark.css` |
| `#panel` | transparent | transparent |
| Popover shell, modal dialogs | `#f3eee2` (stock `#fafafb`) | `#24283b` (stock `#36363a`) |
| Cards: quick toggles, calendar, notifications | `#fbf8f1` (stock `#ffffff`) | `#2f3449` (stock `#47474c`) |

The transparent panel lets the wallpaper through instead of laying a bar over it.  The menu surfaces move off GNOME's neutral white and grey — warm sand by day to sit with the sunrise wallpaper, Tokyo Night by night to match kitty and ddterm — keeping stock's relationship of lighter cards on a darker popover shell.

`theme-switch` sets `org.gnome.shell.extensions.user-theme name` to the right one, and enables the User Themes extension first, since a user whose own `enabled-extensions` list predates the image default will not have it on.  A single fixed shell theme would hold the panel and menus at one colour in both modes, which is why there is a pair rather than one.

### Wallpapers

| File | Photo | Mode |
|------|-------|------|
| `/usr/share/backgrounds/tokyo-day.jpg` | clement-souchet — Tokyo Tower at sunrise (Unsplash `FVK-lpEc-Bc`) | day |
| `/usr/share/backgrounds/tokyonight.jpg` | night cityscape (Unsplash `H4uGE2skayY`) | night |

Both files are committed under `includes.container/usr/share/backgrounds/` and copied verbatim into the image.

---

## Kitty Terminal

### Colour files

| File | Purpose |
|------|---------|
| `~/.config/kitty/tokyonight.conf` | Tokyo Night dark palette (shipped with the image) |
| `~/.config/kitty/tokyonight-day.conf` | Tokyo Night Day palette (see palette below) |
| `~/.config/kitty/current-theme.conf` | Active palette — overwritten by `theme-switch`, included by `kitty.conf` |

`kitty.conf` contains:

```
include current-theme.conf
```

`current-theme.conf` is initialised to the dark theme at image build time.  `theme-switch` replaces its contents and reloads kitty with `pkill -USR1 kitty`.

`skel-sync` copies `/etc/skel` into a home directory with `rsync --ignore-existing`, so a `~/.config/kitty/kitty.conf` that predates the switcher is never updated and keeps whatever `include` line it had.  If kitty ignores the switch, check that its last line reads `include current-theme.conf` and not `include tokyonight.conf`.

### Tokyo Night Day palette

Derived directly from `folke/tokyonight.nvim` `day` style.

| Role | Hex |
|------|-----|
| Background | `#e1e2e7` |
| Foreground | `#3760bf` |
| Red | `#f52a65` |
| Green | `#587539` |
| Yellow | `#8c6c3e` |
| Blue | `#2e7de9` |
| Magenta | `#9854f1` |
| Cyan | `#007197` |
| Selection bg | `#b2c2f0` |
| Cursor | `#3760bf` |

---

## ddterm and the Prompt

ddterm and oh-my-posh both used to carry a single hardcoded dark palette, so they stayed dark through the day.

**ddterm** stores colours in dconf under `/com/github/amezin/ddterm/`.  `includes.container/etc/dconf/db/local.d/00-ddterm` supplies the initial (night) palette and the font; `theme-switch` writes user-level keys for the current mode, which shadow those defaults from the first switch onward.  The day palette is the same Tokyo Night Day set kitty uses, converted to ddterm's `rgb(r,g,b)` form.

**oh-my-posh** keeps the same layout in both variants and differs only in colour.  The day file replaces the pale pastels, which are unreadable on `#e1e2e7`:

| Segment | Night | Day |
|---------|-------|-----|
| session (`user on host`) | `#ffbebc` | `#f52a65` |
| inline words (`on`, `at`, `MEM:`) | `#ffffff` | `#6172b0` |
| time | `#bc93ff` | `#9854f1` |
| git | `#ee79d1` | `#b15c00` |
| path | `#ffafd2` | `#2e7de9` |
| execution time, sysinfo, status | `#94ffa2` / `#a9ffb4` | `#587539` |
| python | `#fffd82` | `#8c6c3e` |
| status on error | `#ef5350` | `#f52a65` |

## Terminal Fonts

kitty, ddterm and GNOME's `monospace-font-name` are all set to `MesloLGL Nerd Font 11` so a terminal looks the same whichever one opens it, and so Claude Code — which has no font of its own and inherits the terminal's — does too.

## Neovim

### Startup detection

`lua/config/options.lua` queries the GNOME colour scheme before any plugin is loaded:

```lua
local handle = io.popen("gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null")
if handle then
  local scheme = handle:read("*a")
  handle:close()
  if scheme:match("prefer%-light") then
    vim.o.background = "light"
  end
end
```

This sets `vim.o.background` before `lazy.nvim` initialises plugins, so the tokyonight plugin receives the correct value at load time.

### Runtime switching

`lua/plugins/tokyonight.lua` registers an `OptionSet` autocmd:

```lua
vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "background",
  callback = function()
    local style = vim.o.background == "light" and "day" or "night"
    require("tokyonight").setup({
      style = style,
      transparent = true,
      styles = { sidebars = "transparent", floats = "transparent" },
    })
    vim.cmd("colorscheme tokyonight")
  end,
})
```

When `theme-switch` sends `:set background=light` (or `dark`) to a running nvim instance via `nvim --server <sock> --remote-send`, this callback fires and reloads the colorscheme immediately without restarting nvim.

### Style mapping

| `vim.o.background` | tokyonight style |
|--------------------|-----------------|
| `light` | `day` |
| `dark` | `night` |

---

## Emacs / Spacemacs

### Themes

| Mode | Theme |
|------|-------|
| Night | `tokyo-night` (MELPA package `tokyo-night-theme`) |
| Day | `tokyo-night-day` (local file `~/.emacs.d/private/themes/tokyo-night-day-theme.el`) |

`dotspacemacs-themes` is set to `'(tokyo-night tokyo-night-day)`.  `tokyo-night-theme` is listed in `dotspacemacs-additional-packages` to ensure it is installed from MELPA.

### Theme switching functions

Two functions in `dotspacemacs/user-config` are called by the theme-switch script via `emacsclient`:

```elisp
(defun change-theme-to-light ()
  (load-theme 'tokyo-night-day t)
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (when (eq major-mode 'pdf-view-mode)
        (pdf-view-midnight-minor-mode -1)))))

(defun change-theme-to-dark ()
  (spacemacs/load-theme 'tokyo-night)
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (when (eq major-mode 'pdf-view-mode)
        (pdf-view-midnight-minor-mode 1)))))
```

Both functions also update any open PDF buffers: `pdf-view-midnight-minor-mode` is enabled in dark mode (Tokyo Night colours) and disabled in light mode.

### Custom `tokyo-night-day` theme

**File:** `~/.emacs.d/private/themes/tokyo-night-day-theme.el`

The theme is loaded from `custom-theme-load-path`, which is extended in `dotspacemacs/user-init`:

```elisp
(add-to-list 'custom-theme-load-path (expand-file-name "~/.emacs.d/private/themes"))
```

It defines faces for core UI, syntax highlighting, org-mode, dired, magit, ivy, company, which-key, and the spaceline mode-line, all using the Tokyo Night Day palette.

Key colour decisions:

| Role | Hex | Rationale |
|------|-----|-----------|
| Background | `#e1e2e7` | Clean off-white matching the sky in the wallpaper |
| Foreground | `#3760bf` | Deep blue — readable on light bg, echoes the city steel tones |
| Keywords | `#9854f1` (magenta) | High contrast against light bg |
| Strings | `#587539` (green) | Earthy green, readable and calm |
| Types | `#007197` (cyan) | Teal-blue, distinct from keywords |
| Comments | `#848cb5` (muted blue-grey) | Recedes naturally |
| Constants | `#b15c00` (orange) | Warm accent, mirrors the sunrise tones in the wallpaper |

### PDF midnight mode colours

```elisp
(setq pdf-view-midnight-colors '("#a9b1d6" . "#1a1b26"))
```

These match the Tokyo Night dark background (`#1a1b26`) and foreground (`#a9b1d6`), making PDF reading comfortable in night mode.

---

## Adding More Wallpapers

The repository keeps a few reference photos from Unsplash at the project root, with the photo ID and author in the filename:

```
tobias-wilden-bNeYImiDDbw-unsplash.jpg
graham-powell-wood-GqWwKK_Ps_A-unsplash.jpg
sam-lau-hJnXMWAZsBs-unsplash.jpg
leo-segundo-d7Q7up8OGZQ-unsplash.jpg
```

To use one as the day wallpaper, copy it to `includes.container/usr/share/backgrounds/tokyo-day.jpg`, or add it under a new name there and point `picture-uri` in `includes.container/etc/dconf/db/local.d/00-lab-defaults` at the new file.

Wallpapers are committed rather than downloaded during the build. The build-time `wget` of the Unsplash URLs produced 0-byte files and did not fail the build, so the dconf defaults pointed at wallpapers that were not there.

## File Reference

| Path | Role |
|------|------|
| `/usr/local/bin/theme-switch` | Main orchestration script |
| `~/.config/systemd/user/theme-day.timer` | Fires at 08:00 |
| `~/.config/systemd/user/theme-night.timer` | Fires at 20:00 |
| `~/.config/systemd/user/theme-startup.service` | Fires on graphical session start |
| `~/.config/kitty/tokyonight-day.conf` | Kitty day palette |
| `~/.config/kitty/tokyonight.conf` | Kitty night palette |
| `~/.config/kitty/current-theme.conf` | Active kitty palette (managed by `theme-switch`) |
| `~/.config/oh-my-posh/config-day.json` | Prompt colours for day |
| `~/.config/oh-my-posh/config-night.json` | Prompt colours for night |
| `~/.config/oh-my-posh/config.json` | Active prompt config (managed by `theme-switch`) |
| `~/.local/state/theme-mode` | Current mode, for tools that colour themselves |
| `includes.container/etc/dconf/db/local.d/00-ddterm` | ddterm defaults (initial palette and font) |
| `~/.config/nvim/lua/config/options.lua` | Detects GNOME scheme at nvim startup |
| `~/.config/nvim/lua/plugins/tokyonight.lua` | Responds to `background` option changes |
| `~/.emacs.d/private/themes/tokyo-night-day-theme.el` | Custom Emacs day theme |
| `/usr/share/backgrounds/tokyo-day.jpg` | Day wallpaper (system-wide) |
| `/usr/share/backgrounds/tokyonight.jpg` | Night wallpaper (system-wide) |
| `includes.container/etc/dconf/db/local.d/00-lab-defaults` | GNOME dconf defaults |
| `includes.container/usr/share/backgrounds/` | Both wallpapers, copied into the image |
| `modules/theme-switcher/config.yml` | Build-time setup for theme-switcher |
