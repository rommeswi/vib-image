# Labstick — Getting Started on macOS with OrbStack

This guide sets up the full lab environment (editors, Python stack, LaTeX, JupyterLab, etc.) inside a container on your Mac.

---

## 1. Find out which Mac you have

Click the Apple menu → **About This Mac**.

- **Apple M1 / M2 / M3 / M4** → you have Apple Silicon, use the `arm64` image
- **Intel Core i…** → you have an Intel Mac, use the `amd64` image

---

## 2. Create your container

Run **one** of the following depending on your Mac (see step 1).

**Apple Silicon (M1/M2/M3/M4):**
```bash
docker run -it \
  --name labstick \
  -v ~/Documents/lab-work:/home/lab/work \
  -v ~/.ssh:/home/lab/.ssh:ro \
  -p 8888:8888 \
  ghcr.io/rommeswi/labstick-orbstack-arm64:main
```

**Intel Mac:**
```bash
docker run -it \
  --name labstick \
  -v ~/Documents/lab-work:/home/lab/work \
  -v ~/.ssh:/home/lab/.ssh:ro \
  -p 8888:8888 \
  ghcr.io/rommeswi/labstick-orbstack-amd64:main
```

This will:
- Download the image (large, ~5 GB — only done once)
- Create a persistent container called `labstick`
- Mount `~/Documents/lab-work` on your Mac as `/home/lab/work` inside the container — **save all your work there** so it survives if the container is ever recreated
- Forward port `8888` for JupyterLab

You will land in a **zsh** shell inside the container.

> **Tip:** The `~/Documents/lab-work` folder is created automatically if it does not exist yet.

---

## 3. Day-to-day use

After the first run, you do not need the long command above again.

**Open a terminal in the container** — easiest via OrbStack:
1. Open **OrbStack** from your Applications folder
2. Click **Containers** in the sidebar
3. Click `labstick` → click **Terminal** (this opens kitty)

Or from the macOS Terminal:
```bash
docker start labstick
docker exec -it labstick kitty
```

**Stop the container** when you are done for the day:
```bash
docker stop labstick
```

---

## 4. Working with files

Your work folder is shared between your Mac and the container:

| Inside the container | On your Mac |
|---|---|
| `/home/lab/work` | `~/Documents/lab-work` |

You can edit files with Finder, VS Code on the Mac side, or with Neovim/Emacs inside the container — they all see the same files.

---

## 5. JupyterLab

Inside the container run:

```bash
jupyter lab --ip=0.0.0.0 --no-browser
```

Then open your Mac browser and go to **http://localhost:8888**. Copy the token from the terminal output when prompted.

---

## 6. GUI applications (Emacs, Zathura, Xournal++, Zotero, JabRef)

OrbStack automatically forwards the display — GUI apps launched inside the container appear as normal macOS windows.

Simply run them by name from the container terminal:

```bash
emacs          # opens the Emacs GUI window
zathura file.pdf
xournalpp
zotero
jabref         # amd64 only; not yet available for Apple Silicon
```

> **Note:** Zotero and JabRef are not available on Apple Silicon (ARM64) because their developers do not yet publish Linux ARM64 builds. You can run the macOS versions of these apps directly on your Mac instead — they will read and write the same files in your shared `lab-work` folder.

---

## 7. LaTeX

Compile a document from inside the container:

```bash
cd ~/work/my-paper
latexmk -pdf main.tex
```

Open the resulting PDF with Zathura:

```bash
zathura main.pdf
```

VimTeX (in Neovim) and the Spacemacs LaTeX layer are already configured to call `latexmk` and open Zathura automatically with `<leader>cc` / `SPC m b b`.

---

## 8. Updating the image

When a new version of the image is released:

```bash
# Download the latest image
docker pull ghcr.io/rommeswi/labstick-orbstack-arm64:main   # or amd64

# Remove the old container (your files in ~/Documents/lab-work are safe)
docker rm -f labstick

# Re-create it with the same command from step 3
```
