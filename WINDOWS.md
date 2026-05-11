# Windows Setup

Approximation of the `labstick` vib image on Windows: PowerShell host with all
development work inside WSL2 running Fedora 42.

## 1. WSL2 + Fedora

Elevated PowerShell:

```powershell
wsl --update
wsl --install -d FedoraLinux-42
wsl --set-default FedoraLinux-42
```

First launch: create user, set password. Then:

```bash
sudo dnf upgrade --refresh -y
sudo dnf install -y dnf-plugins-core
```

## 2. Windows-side tools

```powershell
winget install --id Microsoft.WindowsTerminal
winget install --id Git.Git
winget install --id JanDeDobbeleer.OhMyPosh
```

## 3. Nerd Fonts (Windows side)

Fonts are rendered by Windows Terminal, so install them on Windows, not in WSL.

```powershell
oh-my-posh font install JetBrainsMono
oh-my-posh font install Meslo
```

Then open Windows Terminal → Settings → your Fedora profile → Appearance →
Font face → **JetBrainsMono Nerd Font** (or MesloLGM Nerd Font). Save and set
the Fedora profile as the default profile.

## 4. Fedora — base packages

```bash
sudo dnf install -y \
  zsh kitty-terminfo git vim meld wl-clipboard openssh-clients \
  curl wget tar unzip jq yq \
  ripgrep fd-find fzf bat eza zoxide \
  neovim emacs ranger \
  gcc gcc-c++ make clang pkgconf-pkg-config \
  poppler-devel poppler-glib-devel zlib-devel libpng-devel \
  nodejs npm podman \
  gh
```

## 5. glab

```bash
curl -sSL https://gitlab.com/gitlab-org/cli/-/raw/main/scripts/install.sh | sudo bash
```

## 6. Shell — zsh + Prezto + oh-my-posh

```bash
curl -s https://ohmyposh.dev/install.sh | sudo bash -s -- -d /usr/local/bin
git clone --recursive https://github.com/sorin-ionescu/prezto.git \
  "${ZDOTDIR:-$HOME}/.zprezto"

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

chsh -s $(which zsh)
```

Append to `~/.zshrc`:

```sh
eval "$(oh-my-posh init zsh)"
eval "$(zoxide init zsh)"
alias ls='eza'
```

## 7. Python — uv

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Use `uv` and `uvx` for all Python work.

## 8. Claude Code

```bash
sudo npm install -g @anthropic-ai/claude-code
```

## 9. LazyVim

Neovim was installed via dnf in §4.

```bash
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git
nvim
```

First launch pulls plugins. Run `:checkhealth` to verify the Nerd Font is
detected.

## 10. Spacemacs

```bash
git clone --depth=1 https://github.com/syl20bnr/spacemacs ~/.emacs.d
emacs
```

First launch writes `~/.spacemacs` and installs packages.

## 11. Podman

Installed in §4. Test:

```bash
podman run --rm hello-world
```

## Tips

- `wsl --shutdown` from PowerShell restarts the VM.
- Keep `~/.gitconfig`, SSH keys, and code in `~/` inside WSL — not under `/mnt/c/`.
