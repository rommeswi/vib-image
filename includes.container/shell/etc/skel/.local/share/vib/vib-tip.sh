#!/usr/bin/env bash

R=$'\033[0m'
BORDER=$'\033[38;2;86;95;137m'
TITLE_C=$'\033[1;38;2;122;162;247m'
TEXT_C=$'\033[38;2;192;202;245m'
CODE_C=$'\033[38;2;125;207;255m'

# Replace `...` spans with CODE_C color, returning to TEXT_C after each
highlight() {
  local text="$1" result="" chunk
  while [[ "$text" == *'`'* ]]; do
    chunk="${text%%\`*}"
    result+="${TEXT_C}${chunk}${CODE_C}"
    text="${text#*\`}"
    chunk="${text%%\`*}"
    result+="${chunk}${TEXT_C}"
    text="${text#*\`}"
  done
  printf '%s' "${result}${text}"
}

tips=(
  # Shell / zsh
  "󰆍|Press `Ctrl+R` to search through everything you have typed before - start typing to filter"
  "󰆍|Press `Ctrl+T` to pick a file from the current directory tree and insert its path"
  "󰆍|Press `Alt+C` to navigate into any subdirectory interactively"
  "󰆍|Press `Esc` at the prompt to edit your command like a text file; press `i` to type again"
  "󰆍|`!!` re-runs your last command (handy with `sudo !!`); `!$` reuses its last argument"
  "󰆍|`z dirname` takes you to a folder you have visited before - no full path needed"
  # Files
  "󰉋|`ll` shows file sizes, permissions and dates; `la` also shows hidden files"
  "󰉋|`ll --tree` shows the contents of the current folder as a tree"
  "󰉋|`cat file` shows it with syntax colours and line numbers"
  "󰉋|`ranger` lets you browse folders and open files with arrow keys - press `q` to quit"
  # Search
  "󱎸|`rg pattern` searches inside files across your whole project instantly"
  "󱎸|`fd name` finds files by name - just type part of the name, no wildcards needed"
  # Editors
  "|`e file` opens the file in your full editor environment"
  "|`nvim file` opens a file in a keyboard-driven editor - type `:q` and Enter to quit"
  # Packages
  "󰏗|`apx install pkg` installs any package without touching the base system"
  "󰏗|`abroot upgrade` updates the core system safely - your files are never at risk"
  "󰏗|`flatpak install remote app` installs a desktop application"
  # Python
  "󰌠|`uv run script.py` runs a Python script and handles its dependencies automatically"
  "󰌠|`uvx tool` runs a Python command-line tool without any setup"
  # Network
  "󰛳|Your machine is on a private ZeroTier network - other devices can join with the same network ID"
  "󰛳|`GSConnect` in the system tray lets your phone share notifications, files and clipboard with your desktop"
  # Basic shell operations
  "󰆍|`cmd | cmd2` passes the output of one command as input to the next; chain as many as you like"
  "󰆍|`man cmd` opens the manual for any command - press `q` to quit, arrow keys to scroll"
  "󰆍|`export VAR=value` sets an environment variable for the current session and all programs you launch"
  "󰆍|`cmd > file` saves the output to a file (overwrites it); `>>` adds to the end without overwriting"
  "󰆍|`cmd 2> file` saves error messages to a file; `&>` saves both normal output and errors together"
  "󰆍|`cmd &` runs a command in the background so you can keep using the terminal"
  "󰆍|`jobs` lists background tasks; `fg` brings the most recent one back; `bg` resumes a paused one"
  "󰆍|`\$(cmd)` inserts the output of a command into another - e.g. echo \"Today is \$(date)\""
  "󰆍|`\$VAR` inserts the value of a variable anywhere in a command - e.g. `echo \$HOME` shows your home folder"
  "󰆍|`which cmd` shows where on the system a command lives"
  "󰆍|`cmd1 && cmd2` runs cmd2 only if cmd1 succeeded; `||` runs it only if cmd1 failed"
  "󰆍|`grep pattern file` filters and prints only lines that match a pattern; `-i` ignores capitalisation"
  "󰆍|`head -n 10 file` shows the first 10 lines of a file; `tail -n 10` shows the last 10"
  "󰆍|`wc -l file` counts lines; `-w` counts words; `-c` counts bytes"
  "󰆍|`sort file` sorts lines alphabetically; `-n` sorts by number; `-r` reverses the order"
  "󰆍|`sort file | uniq` removes duplicate lines - sort first so duplicates are adjacent"
  "󰆍|`cut -d, -f1 file` extracts a column from comma-separated text; change the delimiter with `-d`"
  "󰆍|`chmod +x file` makes a file executable so you can run it as a command"
  "󰆍|`ps aux` lists every running process with its ID, owner and resource usage"
  "󰆍|`kill PID` stops a process by its ID; `kill -9 PID` forces it to stop immediately"
  "󰆍|`df -h` shows how much space is left on each filesystem in a readable format"
  "󰆍|`du -sh folder` shows how much disk space a folder and its contents take up"
  "󰆍|`curl -O url` downloads a file from the internet into the current folder"
  "󰆍|`tar -xzf archive.tar.gz` unpacks a compressed archive; `tar -czf archive.tar.gz folder` creates one"
  "󰆍|`ssh user@host` opens a secure shell session on another machine"
  "󰆍|`alias short='long command'` creates a shortcut; add it to `.zshrc` to keep it across sessions"
  "󰆍|`history` lists your recent commands with numbers; `!42` re-runs command number 42"
  "󰆍|`env` lists all environment variables currently set in your session"
  "󰆍|`xargs` feeds the output of one command as arguments to another - e.g. `fd .log | xargs wc -l`"
  # Terminal
  "󰆍|`kitty` supports tabs and splits - `Ctrl+Shift+T` opens a new tab, `Ctrl+Shift+Enter` splits the window"
  # Browsers
  "󰈹|`Firefox` blocks cross-site trackers by default - check the shield icon in the address bar for details"
  "󰈹|`Brave` blocks ads and trackers automatically - no extensions needed for a clean browsing experience"
  "󰈹|`Chromium` is the open-source browser Chrome is built on, without Google data collection"
  "󰈹|`GNOME Web` turns any website into a standalone app - open the site and choose Install as Web Application"
  # Office and notes
  "󰏆|`LibreOffice` opens and edits Word, Excel and PowerPoint files - use it as a full office suite"
  "󰆴|`Logseq` organises your notes as a knowledge graph - use [[double brackets]] to link ideas across pages"
  "󰓓|`Rnote` is a handwriting and sketching app - great for annotating PDFs with a stylus or drawing tablet"
  # Utilities
  "󰙵|`Bottles` runs Windows applications on Linux - create a bottle, pick a runner, and install your app"
  "󱖫|`Boxes` creates and runs virtual machines - download an ISO and have it running in a few clicks"
  "󱔗|`Deja Dup` backs up your files automatically - set a schedule and destination once, then forget about it"
  "󰒃|`Flatseal` controls what each Flatpak app can access - revoke file, network or device permissions per app"
  "󰒃|`Metadata Cleaner` strips hidden data from files before sharing - location, camera model, author name and more"
  "󰊢|`Extension Manager` lets you browse and install GNOME Shell extensions without opening a browser"
  # GNOME extensions
  "󰆍|`GPaste` keeps a history of everything you copy - click the clipboard icon in the top bar to retrieve it"
  "󰆍|`gTile` tiles windows into a grid - trigger it with its shortcut and click cells to snap a window into position"
  "󰆍|A drop-down terminal slides in from the top of the screen - configure its key in the `ddterm` extension settings"
  # Media
  "󰙴|`Videos` plays most media formats without installing extra codecs"
  "󰎆|`Music` organises your audio files by artist and album - point it at your music folder in its preferences"
  "󰑫|`Shortwave` is an internet radio app - search by station name, genre or location"
  "󰎆|`Sound Recorder` captures audio from your microphone and saves it as a file you can share"
  "󰙷|`Snapshot` lets you take photos and videos directly from your webcam"
  # Other utilities
  "󰋊|`Disk Usage Analyzer` shows what is taking up space on your drive - open a folder for a visual breakdown"
  "󰈙|`File Roller` creates and opens zip and tar.gz archives - right-click any file or folder to compress it"
  "󰖔|`Connections` accesses other computers remotely over RDP or VNC"
  "󰑳|`Document Scanner` digitises physical pages and works with most USB and network scanners"
  # Python stack
  "󰌠|`numpy`, `scipy`, `pandas` and `matplotlib` are pre-installed - start analysing data straight away"
  "󰌠|Use `dask` instead of `pandas` when your dataset is too large to fit in memory - the API is nearly identical"
  # LaTeX
  "󰈙|TeX Live is installed - compile a document with `pdflatex file.tex` or `lualatex` for modern font support"
  # Editors - advanced
  "|`nvim +Tutor` opens an interactive tutorial that teaches you the basics of Vim in about 30 minutes"
  "|Press `Space` in nvim or Spacemacs to open a searchable menu of all available commands"
  "|In nvim and Spacemacs, press `H` to jump to the start of a line and `L` to jump to the end - easier than `^` and `\$`"
  # Browsers
  "󰈹|`Zen Browser` is a Firefox-based browser built for wide screens - it supports all Firefox extensions"
  # Claude Code
  "󱚣|`claude` is an AI coding assistant available in the terminal - run `claude` to start a session in any project"
  "󱚣|The `claude` command works best with editor extensions activated - check your editor's extension marketplace"
  # System customisation
  "󰏗|This system is built from a fork of `hendrikirdneh/labstick` - fork it on GitHub to build your own image, then point `abroot` at your new Docker image in the config editor"
  # GNOME extensions
  "󰊢|Some GNOME extensions may be installed but switched off - open `Extension Manager` to see what is available"
  # GNOME desktop shortcuts
  "󰨇|Press `Super` to open the overview and search for apps, files and settings"
  "󰨇|In the overview, press `Alt+number` to jump directly to a specific open window"
  "󰨇|Right-click an app in the overview and choose Pin to pin it to the dock; then press `Super+number` to launch it instantly"
  "󰨇|Press `Super` twice quickly to open the full app grid"
  "󰨇|Press `Super+Up` to maximise the active window; `Super+Down` to minimise it"
  "󰨇|Press `Super+Left` or `Super+Right` to snap the active window to half the screen"
  "󰨇|Press `Super+Space` to switch between keyboard layouts"
  "󰨇|Press `F12` to drop a terminal down from the top of the screen - press it again to hide it"
  # gTile
  "󰨇|Press `Super+Enter` to open the `gTile` grid overlay, then click across cells to snap the active window"
  "󰨇|Inside the `gTile` overlay, press `Ctrl+1` through `Ctrl+5` to snap the window to a column preset"
  # kitty shortcuts
  "󰆍|`Ctrl+Shift+C` copies selected text in `kitty`; `Ctrl+Shift+V` pastes"
  "󰆍|`Ctrl+Shift+T` opens a new tab in `kitty`; `Ctrl+Tab` switches to the next one"
  "󰆍|`Ctrl+Shift+Enter` opens a new split pane in `kitty`"
  "󰆍|`Ctrl+Shift+Up` / `Down` scrolls one line at a time in `kitty`; `Ctrl+Shift+PageUp` / `PageDown` scrolls a full page"
  "󰆍|Press `Ctrl+Shift+H` in `kitty` to browse the full scrollback history in your editor"
  "󰆍|Press `Ctrl+Shift+F` in `kitty` to search through the terminal output"
  "󰆍|Click any URL in `kitty` with `Ctrl+click` to open it in your browser"
  # SSH
  "󰖔|`ssh-keygen -t ed25519` generates a modern SSH key pair - add the public key to services like GitHub or remote servers"
  "󰖔|Your SSH public key is at `~/.ssh/id_ed25519.pub` - this is safe to share; never share the private key"
  # git
  "󰊢|`git status` shows what has changed; `git diff` shows the exact lines; `git log --oneline` shows the history"
  "󰊢|`git add -p` lets you stage changes chunk by chunk - useful for keeping commits focused"
  "󰊢|`git stash` saves your uncommitted work so you can switch context; `git stash pop` brings it back"
  "󰊢|`git commit -m 'message'` records a snapshot; push it with `git push` to share it"
  # Browser extensions and security
  "󰈹|Add `uBlock Origin` to your browser to block ads and malicious scripts across all websites"
  "󰈹|`LeechBlock NG` lets you set time limits on distracting websites - configure it once and stay focused"
  "󰈹|`Bitwarden` is a free, open-source password manager available as a browser extension and desktop app"
  "󰒃|Never store passwords or API tokens in plain text files - use `Bitwarden` for passwords and the `GNOME Keyring` for secrets your applications need"
)

pick=$(( RANDOM % ${#tips[@]} ))
icon="${tips[$pick]%%|*}"
text="${tips[$pick]#*|}"

if [[ -n "${COLUMNS:-}" ]]; then
  W=$COLUMNS
else
  W=$(tput cols 2>/dev/null) || W=80
fi

INNER=$(( W - 6 ))
[[ $INNER -lt 20 ]] && INNER=20

mapfile -t wrapped < <(printf '%s\n' "$text" | fold -s -w "$INNER")

rep() { local i; for (( i=0; i<$2; i++ )); do printf '%s' "$1"; done; }

TITLE=" ${icon}  Tip of the Day "
RIGHT=$(( W - 2 - 1 - ${#TITLE} ))

printf "${BORDER}╭─${TITLE_C}%s${R}${BORDER}" "$TITLE"
rep '─' "$RIGHT"
printf "╮${R}\n"
printf "${BORDER}│${R}%$(( W - 2 ))s${BORDER}│${R}\n" ''
for line in "${wrapped[@]}"; do
  pad=$(( INNER - ${#line} ))
  printf "${BORDER}│${R}  ${TEXT_C}%s%*s${R}  ${BORDER}│${R}\n" "$(highlight "$line")" "$pad" ''
done
printf "${BORDER}│${R}%$(( W - 2 ))s${BORDER}│${R}\n" ''
printf "${BORDER}╰"
rep '─' $(( W - 2 ))
printf "╯${R}\n\n"
