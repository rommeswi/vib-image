;; -*- mode: emacs-lisp; lexical-binding: t -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Layer configuration:
This function should only modify configuration layer settings."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs

   ;; Lazy installation of layers (i.e. layers are installed only when a file
   ;; with a supported type is opened). Possible values are `all', `unused'
   ;; and `nil'. `unused' will lazy install only unused layers (i.e. layers
   ;; not listed in variable `dotspacemacs-configuration-layers'), `all' will
   ;; lazy install any layer that support lazy installation even the layers
   ;; listed in `dotspacemacs-configuration-layers'. `nil' disable the lazy
   ;; installation feature and you have to explicitly list a layer in the
   ;; variable `dotspacemacs-configuration-layers' to install it.
   ;; (default 'unused)
   dotspacemacs-enable-lazy-installation 'unused

   ;; If non-nil then Spacemacs will ask for confirmation before installing
   ;; a layer lazily. (default t)
   dotspacemacs-ask-for-lazy-installation t

   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '(
                                           ;;"~/configs/layers/"
                                           )

   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers
   '(yaml
     ;; ----------------------------------------------------------------
     ;;                 S P A C E M A C S  Layers
     ;; ----------------------------------------------------------------

     auto-completion

     bibtex

     ;; what is this layer?
     bm

     ;; better editing of .csv files
     csv

     emacs-lisp

     ;; the next layer requires a working R installation
     ;; then run R in terminal
     ;; execute the following commands:
     ;; install.packages("lintr")
     ;; install.packages("languageserver")
     (ess :variables
          ess-r-backend 'lsp
          ess-assign-key "\M--")


     ;; the next layer changes the behavior of the s, f, and t searches
     (evil-snipe :variables
                 evil-snipe-enable-alternate-f-and-t-behaviors t
                 evil-snipe-auto-disable-substitute nil)
     ;; ideally, evil-snipe should have a transient mode menu
     ;; there is still something wrong with the behavior of the i key
     ;; I think this is related to snipe

     git
     ;; Make sure to add '(recentf-exclude (quote (".log" ".gz"...)))
     ;; to (custom-set-variables) via customize-variable

     html

     ivy

     javascript

     (json :variables
           json-fmt-tool 'prettier
           json-backend 'lsp)

     (latex :variables
            latex-backend 'company-auctex)

     ;; lean

     ;; the following layer is recommended for use with R
     lsp

     ;; includes wolfram-mode for mathematica
     major-modes

     ;; mu4e requires setting '(mu4e-user-mail-address-list
     ;; (quote ("rommeswi@ntu.edu.tw" "bla"))) via customize-variable
     ;; mu4e

     major-modes

     multiple-cursors

     openai

     pdf

     prettier

     (python :variables python-backend 'anaconda
             python-fill-column 70)

     (ranger :variables
             ranger-override-dired 'ranger
             ranger-show-preview t
             ranger-show-hidden t
             ranger-cleanup-eagerly t
             ranger-cleanup-on-disable t
             ranger-ignored-extensions '("mkv" "flv" "iso" "mp4"))

     ;; The next layer requires installation of ispell via apt-get
     spell-checking

     themes-megapack

     treemacs

     tree-sitter

     ;; ----------------------------------------------------------------
     ;;        End  of  S P A C E M A C S  Layers
     ;; ----------------------------------------------------------------
     )


   ;; List of additional packages that will be installed without being wrapped
   ;; in a layer (generally the packages are installed only and should still be
   ;; loaded using load/require/use-package in the user-config section below in
   ;; this file). If you need some configuration for these packages, then
   ;; consider creating a layer. You can also put the configuration in
   ;; `dotspacemacs/user-config'. To use a local version of a package, use the
   ;; `:location' property: '(your-package :location "~/path/to/your-package/")
   ;; Also include the dependencies as they will not be resolved automatically.
   dotspacemacs-additional-packages '(
                                      auto-dim-other-buffers
                                      ;;xenops
                                      )

   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()

   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages '()

   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and deletes any unused
   ;; packages as well as their unused dependencies. `used-but-keep-unused'
   ;; installs only the used packages but won't delete unused ones. `all'
   ;; installs *all* packages supported by Spacemacs and never uninstalls them.
   ;; (default is `used-only')
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization:
This function is called at the very beginning of Spacemacs startup,
before layer configuration.
It should only modify the values of Spacemacs settings."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; If non-nil then enable support for the portable dumper. You'll need to
   ;; compile Emacs 27 from source following the instructions in file
   ;; EXPERIMENTAL.org at to root of the git repository.
   ;;
   ;; WARNING: pdumper does not work with Native Compilation, so it's disabled
   ;; regardless of the following setting when native compilation is in effect.
   ;;
   ;; (default nil)
   dotspacemacs-enable-emacs-pdumper nil

   ;; Name of executable file pointing to emacs 27+. This executable must be
   ;; in your PATH.
   ;; (default "emacs")
   dotspacemacs-emacs-pdumper-executable-file "emacs"

   ;; Name of the Spacemacs dump file. This is the file will be created by the
   ;; portable dumper in the cache directory under dumps sub-directory.
   ;; To load it when starting Emacs add the parameter `--dump-file'
   ;; when invoking Emacs 27.1 executable on the command line, for instance:
   ;;   ./emacs --dump-file=$HOME/.emacs.d/.cache/dumps/spacemacs-27.1.pdmp
   ;; (default (format "spacemacs-%s.pdmp" emacs-version))
   dotspacemacs-emacs-dumper-dump-file (format "spacemacs-%s.pdmp" emacs-version)

   ;; If non-nil ELPA repositories are contacted via HTTPS whenever it's
   ;; possible. Set it to nil if you have no way to use HTTPS in your
   ;; environment, otherwise it is strongly recommended to let it set to t.
   ;; This variable has no effect if Emacs is launched with the parameter
   ;; `--insecure' which forces the value of this variable to nil.
   ;; (default t)
   dotspacemacs-elpa-https t

   ;; Maximum allowed time in seconds to contact an ELPA repository.
   ;; (default 5)
   dotspacemacs-elpa-timeout 5

   ;; Set `gc-cons-threshold' and `gc-cons-percentage' when startup finishes.
   ;; This is an advanced option and should not be changed unless you suspect
   ;; performance issues due to garbage collection operations.
   ;; (default '(100000000 0.1))
   dotspacemacs-gc-cons '(100000000 0.1)

   ;; Set `read-process-output-max' when startup finishes.
   ;; This defines how much data is read from a foreign process.
   ;; Setting this >= 1 MB should increase performance for lsp servers
   ;; in emacs 27.
   ;; (default (* 1024 1024))
   dotspacemacs-read-process-output-max (* 1024 1024)

   ;; If non-nil then Spacelpa repository is the primary source to install
   ;; a locked version of packages. If nil then Spacemacs will install the
   ;; latest version of packages from MELPA. Spacelpa is currently in
   ;; experimental state please use only for testing purposes.
   ;; (default nil)
   dotspacemacs-use-spacelpa nil

   ;; If non-nil then verify the signature for downloaded Spacelpa archives.
   ;; (default t)
   dotspacemacs-verify-spacelpa-archives t

   ;; If non-nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. Note that checking for
   ;; new versions works via git commands, thus it calls GitHub services
   ;; whenever you start Emacs. (default nil)
   dotspacemacs-check-for-update nil

   ;; If non-nil, a form that evaluates to a package directory. For example, to
   ;; use different package directories for different Emacs versions, set this
   ;; to `emacs-version'. (default 'emacs-version)
   dotspacemacs-elpa-subdirectory 'emacs-version

   ;; One of `vim', `emacs' or `hybrid'.
   ;; `hybrid' is like `vim' except that `insert state' is replaced by the
   ;; `hybrid state' with `emacs' key bindings. The value can also be a list
   ;; with `:variables' keyword (similar to layers). Check the editing styles
   ;; section of the documentation for details on available variables.
   ;; (default 'vim)
   dotspacemacs-editing-style 'vim

   ;; If non-nil show the version string in the Spacemacs buffer. It will
   ;; appear as (spacemacs version)@(emacs version)
   ;; (default t)
   dotspacemacs-startup-buffer-show-version nil

   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner 'official

   ;; Scale factor controls the scaling (size) of the startup banner. Default
   ;; value is `auto' for scaling the logo automatically to fit all buffer
   ;; contents, to a maximum of the full image height and a minimum of 3 line
   ;; heights. If set to a number (int or float) it is used as a constant
   ;; scaling factor for the default logo size.
   dotspacemacs-startup-banner-scale 'auto

   ;; List of items to show in startup buffer or an association list of
   ;; the form `(list-type . list-size)`. If nil then it is disabled.
   ;; Possible values for list-type are:
   ;; `recents' `recents-by-project' `bookmarks' `projects' `agenda' `todos'.
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   ;; The exceptional case is `recents-by-project', where list-type must be a
   ;; pair of numbers, e.g. `(recents-by-project . (7 .  5))', where the first
   ;; number is the project limit and the second the limit on the recent files
   ;; within a project.
   dotspacemacs-startup-lists '((recents . 6)
                                (projects . 5))

   ;; True if the home buffer should respond to resize events. (default t)
   dotspacemacs-startup-buffer-responsive t

   ;; Show numbers before the startup list lines. (default t)
   dotspacemacs-show-startup-list-numbers t

   ;; The minimum delay in seconds between number key presses. (default 0.4)
   dotspacemacs-startup-buffer-multi-digit-delay 0.4

   ;; If non-nil, show file icons for entries and headings on Spacemacs home buffer.
   ;; This has no effect in terminal or if "all-the-icons" package or the font
   ;; is not installed. (default nil)
   dotspacemacs-startup-buffer-show-icons t

   ;; Default major mode for a new empty buffer. Possible values are mode
   ;; names such as `text-mode'; and `nil' to use Fundamental mode.
   ;; (default `text-mode')
   dotspacemacs-new-empty-buffer-major-mode 'tex-mode

   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode

   ;; If non-nil, *scratch* buffer will be persistent. Things you write down in
   ;; *scratch* buffer will be saved and restored automatically.
   dotspacemacs-scratch-buffer-persistent t

   ;; If non-nil, `kill-buffer' on *scratch* buffer
   ;; will bury it instead of killing.
   dotspacemacs-scratch-buffer-unkillable nil

   ;; Initial message in the scratch buffer, such as "Welcome to Spacemacs!"
   ;; (default nil)
   dotspacemacs-initial-scratch-message nil

   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press `SPC T n' to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(solarized-light-high-contrast
                         rebecca)

   ;; Set the theme for the Spaceline. Supported themes are `spacemacs',
   ;; `all-the-icons', `custom', `doom', `vim-powerline' and `vanilla'. The
   ;; first three are spaceline themes. `doom' is the doom-emacs mode-line.
   ;; `vanilla' is default Emacs mode-line. `custom' is a user defined themes,
   ;; refer to the DOCUMENTATION.org for more info on how to create your own
   ;; spaceline theme. Value can be a symbol or list with additional properties.
   ;; (default '(spacemacs :separator wave :separator-scale 1.5))
   ;; Supported separators are alternate, arrow, arrow-fade, bar, box, brace,
   ;; butt, chamfer, contour, curve, rounded, roundstub, wave, zigzag,
   ;; slant, utf-8 but these only work with powerline?
   dotspacemacs-mode-line-theme '(all-the-icons
                                  :separator-scale 1.5
                                  )

   ;; If non-nil the cursor color matches the state color in GUI Emacs.
   ;; (default t)
   dotspacemacs-colorize-cursor-according-to-state t

   ;; The leader key
   dotspacemacs-leader-key "SPC"

   ;; The key used for Emacs commands `M-x' (after pressing on the leader key).
   ;; (default "SPC")
   dotspacemacs-emacs-command-key "SPC"

   ;; The key used for Vim Ex commands (default ":")
   dotspacemacs-ex-command-key ":"

   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"

   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","

   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m" for terminal mode, "<M-return>" for GUI mode).
   ;; Thus M-RET should work as leader key in both GUI and terminal modes.
   ;; C-M-m also should work in terminal mode, but not in GUI mode.
   dotspacemacs-major-mode-emacs-leader-key (if window-system "<M-return>" "C-M-m")

   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs `C-i', `TAB' and `C-m', `RET'.
   ;; Setting it to a non-nil value, allows for separate commands under `C-i'
   ;; and TAB or `C-m' and `RET'.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil

   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"

   ;; If non-nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil

   ;; If non-nil then the last auto saved layouts are resumed automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil

   ;; If non-nil, auto-generate layout name when creating new layouts. Only has
   ;; effect when using the "jump to layout by number" commands. (default nil)
   dotspacemacs-auto-generate-layout-names nil

   ;; Size (in MB) above which spacemacs will prompt to open the large file
   ;; literally to avoid performance issues. Opening a file literally means that
   ;; no major mode or minor modes are active. (default is 1)
   dotspacemacs-large-file-size 1

   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache

   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5

   ;; If non-nil, the paste transient-state is enabled. While enabled, after you
   ;; paste something, pressing `C-j' and `C-k' several times cycles through the
   ;; elements in the `kill-ring'. (default nil)
   dotspacemacs-enable-paste-transient-state t

   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4

   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom

   ;; Control where `switch-to-buffer' displays the buffer. If nil,
   ;; `switch-to-buffer' displays the buffer in the current window even if
   ;; another same-purpose window is available. If non-nil, `switch-to-buffer'
   ;; displays the buffer in a same-purpose window even if the buffer can be
   ;; displayed in the current window. (default nil)
   dotspacemacs-switch-to-buffer-prefers-purpose nil

   ;; If non-nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t

   ;; If non-nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup t

   ;; If non nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil

   ;; If non-nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil

   ;; If non-nil the frame is undecorated when Emacs starts up. Combine this
   ;; variable with `dotspacemacs-maximized-at-startup' in OSX to obtain
   ;; borderless fullscreen. (default nil)
   dotspacemacs-undecorated-at-startup nil

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90

   ;; If non-nil show the titles of transient states. (default t)
   dotspacemacs-show-transient-state-title t

   ;; If non-nil show the color guide hint for transient state keys. (default t)
   dotspacemacs-show-transient-state-color-guide t

   ;; If non-nil unicode symbols are displayed in the mode line.
   ;; If you use Emacs as a daemon and wants unicode characters only in GUI set
   ;; the value to quoted `display-graphic-p'. (default t)
   dotspacemacs-mode-line-unicode-symbols t

   ;; If non-nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters point
   ;; when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t

   ;; Show the scroll bar while scrolling. The auto hide time can be configured
   ;; by setting this variable to a number. (default t)
   dotspacemacs-scroll-bar-while-scrolling nil

   ;; Control line numbers activation.
   ;; If set to `t', `relative' or `visual' then line numbers are enabled in all
   ;; `prog-mode' and `text-mode' derivatives. If set to `relative', line
   ;; numbers are relative. If set to `visual', line numbers are also relative,
   ;; but only visual lines are counted. For example, folded lines will not be
   ;; counted and wrapped lines are counted as multiple lines.
   ;; This variable can also be set to a property list for finer control:
   ;; '(:relative nil
   ;;   :visual nil
   ;;   :disabled-for-modes dired-mode
   ;;                       doc-view-mode
   ;;                       markdown-mode
   ;;                       org-mode
   ;;                       pdf-view-mode
   ;;                       text-mode
   ;;   :size-limit-kb 1000)
   ;; When used in a plist, `visual' takes precedence over `relative'.
   ;; (default nil)
   dotspacemacs-line-numbers '(:relative t
                                         :disabled-for-modes dired-mode
                                                             doc-view-mode
                                                             markdown-mode
                                                             LaTeX-mode
                                                             latex-mode
                                                             pdf-view-mode
                                         :size-limit-kb 1000)
   ;; Code folding method. Possible values are `evil' and `origami'.
   ;; (default 'evil)
   dotspacemacs-folding-method 'evil

   ;; If non-nil and `dotspacemacs-activate-smartparens-mode' is also non-nil,
   ;; `smartparens-strict-mode' will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil

   ;; If non-nil smartparens-mode will be enabled in programming modes.
   ;; (default t)
   dotspacemacs-activate-smartparens-mode t

   ;; If non-nil pressing the closing parenthesis `)' key in insert mode passes
   ;; over any automatically added closing parenthesis, bracket, quote, etc...
   ;; This can be temporary disabled by pressing `C-q' before `)'. (default nil)
   dotspacemacs-smart-closing-parenthesis nil

   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all

   ;; If non-nil, start an Emacs server if one is not already running.
   ;; (default nil)
   dotspacemacs-enable-server nil

   ;; Set the emacs server socket location.
   ;; If nil, uses whatever the Emacs default is, otherwise a directory path
   ;; like \"~/.emacs.d/server\". It has no effect if
   ;; `dotspacemacs-enable-server' is nil.
   ;; (default nil)
   dotspacemacs-server-socket-dir nil

   ;; If non-nil, advise quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil

   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `rg', `ag', `pt', `ack' and `grep'.
   ;; (default '("rg" "ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("rg" "ag" "pt" "ack" "grep")

   ;; Format specification for setting the frame title.
   ;; %a - the `abbreviated-file-name', or `buffer-name'
   ;; %t - `projectile-project-name'
   ;; %I - `invocation-name'
   ;; %S - `system-name'
   ;; %U - contents of $USER
   ;; %b - buffer name
   ;; %f - visited file name
   ;; %F - frame name
   ;; %s - process status
   ;; %p - percent of buffer above top of window, or Top, Bot or All
   ;; %P - percent of buffer above bottom of window, perhaps plus Top, or Bot or All
   ;; %m - mode name
   ;; %n - Narrow if appropriate
   ;; %z - mnemonics of buffer, terminal, and keyboard coding systems
   ;; %Z - like %z, but including the end-of-line format
   ;; If nil then Spacemacs uses default `frame-title-format' to avoid
   ;; performance issues, instead of calculating the frame title by
   ;; `spacemacs/title-prepare' all the time.
   ;; (default "%I@%S")
   dotspacemacs-frame-title-format "%I@%S"

   ;; Format specification for setting the icon title format
   ;; (default nil - same as frame-title-format)
   dotspacemacs-icon-title-format nil

   ;; Show trailing whitespace (default t)
   dotspacemacs-show-trailing-whitespace t

   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed' to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup 'trailing

   ;; If non-nil activate `clean-aindent-mode' which tries to correct
   ;; virtual indentation of simple modes. This can interfere with mode specific
   ;; indent handling like has been reported for `go-mode'.
   ;; If it does deactivate it here.
   ;; (default t)
   dotspacemacs-use-clean-aindent-mode t

   ;; Accept SPC as y for prompts if non-nil. (default nil)
   dotspacemacs-use-SPC-as-y t

   ;; If non-nil shift your number row to match the entered keyboard layout
   ;; (only in insert state). Currently supported keyboard layouts are:
   ;; `qwerty-us', `qwertz-de' and `querty-ca-fr'.
   ;; New layouts can be added in `spacemacs-editing' layer.
   ;; (default nil)
   dotspacemacs-swap-number-row nil

   ;; Either nil or a number of seconds. If non-nil zone out after the specified
   ;; number of seconds. (default nil)
   dotspacemacs-zone-out-when-idle nil

   ;; Run `spacemacs/prettify-org-buffer' when
   ;; visiting README.org files of Spacemacs.
   ;; (default nil)
   dotspacemacs-pretty-docs nil

   ;; If nil the home buffer shows the full path of agenda items
   ;; and todos. If non-nil only the file name is shown.
   dotspacemacs-home-shorten-agenda-source nil

   ;; If non-nil then byte-compile some of Spacemacs files.
   dotspacemacs-byte-compile nil)

  ;; Default font or prioritized list of fonts. The `:size' can be specified as
  ;; a non-negative integer (pixel size), or a floating-point (point size).
  ;; Point size is recommended, because it's device independent. (default 10.0)
  (if (> (frame-outer-width) 3000)
      (setq-default dotspacemacs-default-font '("SpaceMono Nerd Font"
                                                :size 18.0
                                                :weight normal
                                                :width normal
                                                ))
      (setq-default dotspacemacs-default-font '("SpaceMono Nerd Font"
                                              :size 12.0
                                              :weight normal
                                              :width normal
                                              ))
    )
  )

(defun dotspacemacs/user-env ()
  "Environment variables setup.
This function defines the environment variables for your Emacs session. By
default it calls `spacemacs/load-spacemacs-env' which loads the environment
variables declared in `~/.spacemacs.env' or `~/.spacemacs.d/.spacemacs.env'.
See the header of this file for more information."
  (spacemacs/load-spacemacs-env)
)

(defun dotspacemacs/user-init ()
  "Initialization for user code:
This function is called immediately after `dotspacemacs/init', before layer
configuration.
It is mostly for variables that should be set before packages are loaded.
If you are unsure, try setting them in `dotspacemacs/user-config' first."

  (defun latex/post-init-auctex ()
    (spacemacs|use-package-add-hook tex
      :post-config
      ;; This adds additional fontification
      (dolist (el '(
              ("\\mathscr{A}" . 119964)
              ("\\mathscr{B}" . 8492)
              ("\\mathscr{C}" . 119966)
              ("\\mathscr{D}" . 119967)
              ("\\mathscr{E}" . 8496)
              ("\\mathscr{F}" . 8497)
              ("\\mathscr{G}" . 119970)
              ("\\mathscr{H}" . 8459)
              ("\\mathscr{I}" . 8464)
              ("\\mathscr{J}" . 119973)
              ("\\mathscr{K}" . 119974)
              ("\\mathscr{L}" . 8466)
              ("\\mathscr{M}" . 8499)
              ("\\mathscr{N}" . 119977)
              ("\\mathscr{O}" . 119978)
              ("\\mathscr{P}" . 119979)
              ("\\mathscr{Q}" . 119980)
              ("\\mathscr{R}" . 8475)
              ("\\mathscr{S}" . 119982)
              ("\\mathscr{T}" . 119983)
              ("\\mathscr{U}" . 119984)
              ("\\mathscr{V}" . 119985)
              ("\\mathscr{W}" . 119986)
              ("\\mathscr{X}" . 119987)
              ("\\mathscr{Y}" . 119988)
              ("\\mathscr{Z}" . 119989)
	            ("\\em" . 10001)
	            ("\\it" . 10001)
	            ("\\itshape" . 10001)
	            ("\\sl" . 10001)
	            ("\\slshape" . 10001)
	            ("\\em" . 10001)
	            ("\\emph" . 10001)
	            ("\\textsl" . 10001)
	            ("\\textit" . 10001)
	            ("\\mathit" . 10001)
              ("\\bf" . 10002)
              ("\\bfseries" . 10002)
              ("\\sc" . 10002)
              ("\\scshape" . 10002)
              ("\\sscshape" . 10002)
              ("\\ulcshape" . 10002)
              ("\\upshape" . 10002)
              ("\\swshape" . 10002)
              ("\\textbf" . 10002)
              ("\\textsc" . 10002)
              ("\\textssc" . 10002)
              ("\\textulc" . 10002)
              ("\\textup" . 10002)
              ("\\textsw" . 10002)
              ("\\boldsymbol" . 10002)
              ("\\pmb" . 10002)
              ("\\mathbf" . 10002)
              ("\\overline" . 10000)
              ("\\underline" . 9998)
              ("\\ul" . 9998)
              ("\\uuline" . 9998)
              ("\\uwave" . 9998)
              ("\\dotuline" . 9998)
              ("\\dashuline" . 9998)
	            ("\\not\\in" . ?\u2209)))
    (add-to-list 'tex--prettify-symbols-alist el)
     )))
)


(defun dotspacemacs/user-load ()
  "Library to load while dumping.
This function is called only while dumping Spacemacs configuration. You can
`require' or `load' the libraries of your choice that will be included in the
dump."
)


(defun dotspacemacs/user-config ()
  "Configuration function for user code.
This function is called at the very end of Spacemacs
initialization after layers configuration. This is the place
where most of your configurations should be done. Unless it is
explicitly specified that a variable should be set before a
package is loaded, you should place your code here."

  ;; ~~~~~~~~~~~~~~~~~~~~~~
  ;;        Buffers
  ;; ~~~~~~~~~~~~~~~~~~~~~~

  ;; Immediately close the scratch buffer
  ;; This requires that the dotspacemacs-scratch-mode is nil
  (kill-buffer "*scratch*")

  ;; Removes *messages* buffer.
  ;;(setq-default message-log-max nil)
  ;;(kill-buffer "*Messages*")

  ;; Previous buffer command that skips certain buffers
  (setq switch-to-prev-buffer-skip-regexp
    (rx bos (or
                (seq (zero-or-more anything) "*")
                (seq (zero-or-more anything) ".log")
                (seq (zero-or-more anything) ".synctex.gz")
                (seq "magit-diff" (zero-or-more anything))
                (seq "magit-process" (zero-or-more anything))
                (seq "magit-revision" (zero-or-more anything))
                (seq "magit-stash" (zero-or-more anything)))
        eos)
    )

  ;; ~~~~~~~~~~~~~~~~~~~~~~
  ;;        Navigation
  ;; ~~~~~~~~~~~~~~~~~~~~~~

  ;; Navigating to the beginning/end of the line with $/^ is annoying
  ;; This rebinds H and L to go the the beginning/end of a line

  (define-key evil-motion-state-map (kbd "H") 'evil-first-non-blank)
  (define-key evil-motion-state-map (kbd "L") 'evil-end-of-line)

  ;; ~~~~~~~~~~~~~~~~~~~~~~
  ;;        Theme
  ;; ~~~~~~~~~~~~~~~~~~~~~~

  ;; Choose theme depending on dark or light mode in GTK
  ;; use external command to call the following functions
  ;; emacsclient --eval "(change-theme-to-light)"
  ( defun change-theme-to-light ()
    (load-theme 'solarized-light-high-contrast t)
    )

  ( defun change-theme-to-dark ()
    (load-theme 'rebecca t)
    )
  ;; Still need to go through all pdf buffers to switch to dark mode.

  ;; Spaceline configuration
  (setq spaceline-all-the-icons-separator-type 'none)
  (spaceline-toggle-all-the-icons-vc-status-off)
  (spaceline-toggle-all-the-icons-git-status-off)
  (spaceline-toggle-all-the-icons-buffer-size-off)
  (spaceline-toggle-all-the-icons-weather-on)
  (spaceline-toggle-all-the-icons-battery-status-on)
  (spaceline-toggle-all-the-icons-buffer-position-off)
  (spaceline-toggle-all-the-icons-modified-off)
  (spaceline-toggle-all-the-icons-eyebrowse-workspace-off)

  ;; ~~~~~~~~~~~~~~~~~~~~~~
  ;;        Indent
  ;; ~~~~~~~~~~~~~~~~~~~~~~
  (indent-guide-global-mode)

  (set-face-foreground 'indent-guide-face "dimgray")
  (add-hook 'prog-mode-hook (lambda () (progn
                                         (setq indent-guide-recursive t)
                                         (setq indent-guide-char ""))))

  ;; ~~~~~~~~~~~~~~~~~~~~~~
  ;;        Fonts
  ;; ~~~~~~~~~~~~~~~~~~~~~~

  ;; this config requires to run M-x all-the-icons-install-fonts
  ;; this config requires to download nerd fonts

  ;; remove underline and overline from mode-line:
  (set-face-attribute 'mode-line nil
                      :overline nil
                      :underline nil)
  (set-face-attribute 'mode-line-inactive nil
                      :overline nil
                      :underline nil)

  ;; define font that over-lines the text
  (defface overline
    '((((supports :overline t))
       :overline t)
      (((supports :slant italic))
       :slant italic)
      (((supports :weight bold))
       :weight bold)
      (t :overline t))
    "Basic overlined face."
    :group 'basic-faces)
  ;; remove additional spacing between text and overline
  (setq overline-margin 0)
  ;; increase line spacing to make overlines more natural
  (setq line-spacing 0)
  (setq x-underline-at-descent-line nil)

  ;; ~~~~~~~~~~~~~~~~~~~~~~
  ;;        Scrolling
  ;; ~~~~~~~~~~~~~~~~~~~~~~

  ;; Scroll precision mode
  (pixel-scroll-precision-mode)

  ;; Touch and mouse scroll
  (global-set-key [down-mouse-1] 'mouse-drag-drag)
  (setq mouse-drag-electric-col-scrolling nil)
  ;; unfortunately, it still does a lot of horizontal scrolling

  ;; Make sure there is always context visible while scrolling
  (setq scroll-margin 7)

  ;; Scroll to bottom of e.g. ESS/python buffers on new input
  (setq comint-scroll-to-bottom-on-input t)
  ;; (setq comint-scroll-to-bottom-on-output t)

  ;; Make up and down arrows scroll one line at a time without moving the cursor
  (define-key evil-normal-state-map (kbd "<up>") (lambda () (interactive) (scroll-down 1)))
  (define-key evil-normal-state-map (kbd "<down>") (lambda () (interactive) (scroll-up 1)))

  ;; ~~~~~~~~~~~~~~~~~~~~~~
  ;;        Others
  ;; ~~~~~~~~~~~~~~~~~~~~~~

  ;; golden ratio mode
  ;; resizes the active window relative to other windows
  (golden-ratio-mode 1)
  (setq golden-ratio-max-width 99)

  ;; Make sure windows are never split horizontally
  (setq split-height-threshold nil)

  ;;Command for setting correct size when the display size changes
  (setq frame-resize-pixelwise t)

  ;;clock
  (display-time-mode 1)

  ;;which key prefix for evil-mc
  (which-key-add-keymap-based-replacements evil-motion-state-map
    "gr"  '("evil-mc" . nil))

  ;; exit evil-insert-mode via C-x:
  (define-key evil-insert-state-map (kbd "C-x") 'evil-normal-state)

  ;; LSP increase maximum directories
  (setq lsp-file-watch-threshold 5000)

  ;; LSP enable folding
  (add-hook 'lsp-after-open-hook #'lsp-origami-try-enable)

  ;; ~~~~~~~~~~~~~~~~~~~~~~
  ;;    Function Keys
  ;; ~~~~~~~~~~~~~~~~~~~~~~
  ;; unbind pesky 2 column mode:
  (global-unset-key (kbd "<f2> 2"))
  (global-unset-key (kbd "<f2> s"))
  (global-unset-key (kbd "<f2> b"))
  (global-unset-key (kbd "<f2> <f2>"))

  ;; Function keys should be set so that they match the symbols on them

  ;;(global-unset-key (kbd "<f3>"))
  ;;(global-unset-key (kbd "<f4>"))
  ;; bind f3 to outline?
  ;; bind f4 to file manager?
  ;; bind f11 to ?
  (global-set-key (kbd "<f12>") 'toggle-frame-fullscreen)
  ;; set F2 to change theme
  ;; set F7 and F9 to switch windows
  ;; set F8 to continue without completion
  ;; set F4, F5, F12

  ;; ~~~~~~~~~~~~~~~~~~~~~~
  ;;        BibTeX
  ;; ~~~~~~~~~~~~~~~~~~~~~~

  ;; ivy-bibtex configuration
  (setq
   bibtex-maintain-sorted-entries t
   bibtex-completion-bibliography '("~/projects/bibliography/biblatex.bib")
   bibtex-completion-library-path "~/projects/bibliography/PDFs"
   bibtex-completion-notes-path "~/projects/bibliography/notes.org"
   bibtex-completion-pdf-open-function #'find-file-other-window)

  ;; ~~~~~~~~~~~~~~~~~~~~~~
  ;;        LaTeX
  ;; ~~~~~~~~~~~~~~~~~~~~~~
  ;; To Do: mathscr characters on `

  ;; Completion server
  (setq lsp-tex-server 'digestif)

  ;; This turns the backslash into a word character for easier navigation using "w"
  (add-hook 'LaTeX-mode-hook #'(lambda () (modify-syntax-entry (string-to-char TeX-esc)
                                                               "w"
                                                               LaTeX-mode-syntax-table)))
  ;; This turns the hat into a word character
  (add-hook 'LaTeX-mode-hook #'(lambda () (modify-syntax-entry ?^
                                                               "w"
                                                               LaTeX-mode-syntax-table)))
  ;; This turns the dash into a word character
  (add-hook 'LaTeX-mode-hook #'(lambda () (modify-syntax-entry ?-
                                                               "w"
                                                               LaTeX-mode-syntax-table)))
  ;; This turns the underscore into a word character
  (add-hook 'LaTeX-mode-hook #'(lambda () (modify-syntax-entry ?_
                                                               "w"
                                                               LaTeX-mode-syntax-table)))

  ;; Get rid of strange braces added:
  (setq TeX-insert-braces nil)

  ;; prettify symbols
  (add-hook 'LaTeX-mode-hook #'prettify-symbols-mode)
  (add-hook 'plain-tex-mode #'prettify-symbols-mode)

  ;; This fixes that the bold fontification does not work
  (add-hook 'LaTeX-mode-hook
            (lambda ()
              (set-face-attribute 'font-latex-bold-face nil :weight 'bold)
              ))

  ;; use outline
  (add-hook 'LaTeX-mode-hook #'outline-minor-mode)
  (add-hook 'LaTeX-mode-hook #'outline-hide-body)
  ;; support folding for \item (disabled) and bibliography
  (setq TeX-outline-extra
        '(
          ;;("[ \t]*\\\\\\(bib\\)?item\\b" 7)
          ("\\\\bibliography\\b" 2)
          ("\\\\printbibliography\\b" 2)
          ))

  ;; Key to view reference under cursor
  ;; Pressing SPC r m or , m opens the ivy-bibtex manager
  (let ((prefix (if (eq latex-backend 'lsp) "R" "r")))
    (spacemacs/declare-prefix-for-mode 'latex-mode (concat "m" prefix) "reftex")
    (spacemacs/set-leader-keys-for-major-mode 'latex-mode
      (concat prefix "m")    'ivy-bibtex))

  ;; symbolify \not
  ;; symbolify \int
  ;; symbolify \mathrm

  ;; do not ask for saving
  (setq TeX-save-query nil)

  ;; ~~~~~~~~~~~~~~~~~~~~~~
  ;; OpenAI
  ;; ~~~~~~~~~~~~~~~~~~~~~~
  (setq openai-user "user")
  (setq openai-key (getenv "OPENAI_API_KEY"))
  (setq openai--show-log t)

  ;; ~~~~~~~~~~~~~~~~~~~~~~
  ;; Python
  ;; ~~~~~~~~~~~~~~~~~~~~~~
  ;; enable camel case
  (add-hook 'python-mode-hook (lambda () (subword-mode t)))
  ;; enable shell restart shortcut
  (spacemacs/set-leader-keys-for-major-mode 'python-mode
    "sn" 'python-shell-restart)

  ;; ~~~~~~~~~~~~~~~~~~~~~~
  ;; R / ESS
  ;; ~~~~~~~~~~~~~~~~~~~~~~
  (setq-default ess-indent-with-fancy-comments nil)
  (setq-default ess-ask-for-ess-directory nil)

  ;; ~~~~~~~~~~~~~~~~~~~~~~
  ;; Files and Associations
  ;; ~~~~~~~~~~~~~~~~~~~~~~

  ;; dired file browser
  ;; make dired show less details
  (add-hook 'dired-mode-hook 'dired-hide-details-mode)
  ;; make dired not open new buffers for new directories
  (setq dired-kill-when-opening-new-dired-buffer t)

  ;; ~~~~~~~~~~~
  ;; PDF view mode
  ;; ~~~~~~~~~~~

  ;;pdf-tools needs proper scaling
  (setq-default pdf-view-use-scaling t)
  (setq-default pdf-view-display-size 'fit-page)

  (setq-default pdf-view-mode-hook (lambda ()
                                     (if (eq spacemacs--cur-theme "rebecca")
                                         (pdf-view-midnight-minor-mode t)
                                       (pdf-view-midnight-minor-mode nil))))

  ;; ~~~~~~~~~~~
  ;; Magit
  ;; ~~~~~~~~~~~
  (with-eval-after-load 'magit
    (magit-add-section-hook
     'magit-status-sections-hook
     'magit-insert-tracked-files
     nil
     'append)
    )
  (setq-default magit-show-long-lines-warning nil)

  ;; ~~~~~~~~~~~
  ;; Auto-completion
  ;; ~~~~~~~~~~~
  (setq auto-completion-return-key-behavior nil)
  (setq auto-completion-tab-key-behavior 'complete)

  ;; ~~~~~~~~~~~
  ;; Evil Snipe
  ;; ~~~~~~~~~~~
  ;; Resolve conflict with magit
  (add-hook 'magit-mode-hook 'turn-off-evil-snipe-override-mode)

  ;; evil-snipe-auto-scroll should maybe be customized to true
  ;; Remove keybinding to s/S
  ;; and set up keybinding to f/F
  (with-eval-after-load 'evil-snipe
    (evil-define-key '(normal motion) evil-snipe-local-mode-map
      "s" nil
      "S" nil
      "f" #'evil-snipe-s
      "F" #'evil-snipe-S)
    (evil-define-key '(normal motion) evil-snipe-override-local-mode-map
       "s" nil
       "S" nil
       "f" #'evil-snipe-s
       "F" #'evil-snipe-S))
  ;; Add repeat search keybinding
  (with-eval-after-load 'evil-snipe
    (setq evil-snipe-parent-transient-map
      (let ((map (make-sparse-keymap)))
        (define-key map "f" #'evil-snipe-repeat)
        (define-key map "F" #'evil-snipe-repeat-reverse)
        map)))
  )

;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-engine-alist '((platex "Japanese Tex/LaTeX" "ptex" "platex" "")))
 '(compilation-scroll-output t)
 '(custom-safe-themes
   '("18cf5d20a45ea1dff2e2ffd6fbcd15082f9aa9705011a3929e77129a971d1cb3" "00445e6f15d31e9afaa23ed0d765850e9cd5e929be5e8e63b114a3346236c44c" default))
 '(evil-surround-pairs-alist
   '((40 "( " . " )")
     (91 "[ " . " ]")
     (123 "{ " . " }")
     (41 "(" . ")")
     (93 "[" . "]")
     (125 "{" . "}")
     (35 "#{" . "}")
     (98 "(" . ")")
     (66 "{" . "}")
     (62 "<" . ">")
     (116 . evil-surround-read-tag)
     (60 . evil-surround-read-tag)
     (6 . evil-surround-prefix-function)
     (102 . evil-surround-function)
     (38 "&" . "&")))
 '(fill-column 70)
 '(focus-follows-mouse t)
 '(inferior-R-args "--vanilla")
 '(package-selected-packages
   '(yaml-mode auto-dim-other-buffers doom-modeline shrink-path nerd-icons add-node-modules-path counsel-gtags dap-mode lsp-docker lsp-treemacs bui lsp-mode ggtags helm-gtags wfnames import-js grizzl js-doc js2-refactor multiple-cursors livid-mode nodejs-repl npm-mode skewer-mode js2-mode tern ws-butler writeroom-mode visual-fill-column winum volatile-highlights vim-powerline vi-tilde-fringe uuidgen undo-tree queue treemacs-projectile treemacs-persp treemacs-icons-dired treemacs-evil treemacs cfrs pfuture posframe toc-org symon symbol-overlay string-inflection spacemacs-whitespace-cleanup spacemacs-purpose-popwin spaceline-all-the-icons memoize spaceline powerline space-doc restart-emacs request rainbow-delimiters quickrun popwin persp-mode password-generator paradox spinner overseer org-superstar open-junk-file nameless multi-line shut-up macrostep lorem-ipsum link-hint inspector info+ indent-guide hungry-delete hl-todo highlight-parentheses highlight-numbers parent-mode highlight-indentation hide-comnt help-fns+ helm-xref helm-themes helm-swoop helm-purpose window-purpose imenu-list helm-projectile helm-org helm-mode-manager helm-make helm-flx helm-descbinds helm-ag google-translate golden-ratio flycheck-package package-lint flycheck pkg-info epl flycheck-elsa flx-ido flx fancy-battery eyebrowse expand-region evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-textobj-line evil-terminal-cursor-changer evil-surround evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-lisp-state evil-lion evil-indent-plus evil-iedit-state evil-goggles evil-exchange evil-escape evil-ediff evil-easymotion evil-collection annalist evil-cleverparens smartparens evil-args evil-anzu anzu eval-sexp-fu emr iedit clang-format projectile paredit list-utils elisp-slime-nav elisp-def f editorconfig dumb-jump s drag-stuff dired-quick-sort devdocs define-word column-enforce-mode clean-aindent-mode centered-cursor-mode auto-highlight-symbol ht dash auto-compile packed compat all-the-icons aggressive-indent ace-window ace-link ace-jump-helm-line helm avy popup helm-core which-key use-package pcre2el hydra lv hybrid-mode holy-mode font-lock+ evil-evilified-state evil goto-chg dotenv-mode diminish bind-map bind-key async))
 '(python-shell-interpreter "python3")
 '(recentf-exclude
   '("~/.emacs.d/.cache/.custom-settings" "COMMIT_EDITMSG\\'" "~/.emacs.d/elpa/29.0/develop/" "~/.emacs.d/.cache/" "*.synctex.gz" "*.log"))
 '(spaceline-all-the-icons-eyebrowse-display-name nil)
 '(split-height-threshold nil)
 '(warning-suppress-types '((use-package) ((evil-collection)) ((evil-collection)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background nil))))
 '(highlight-parentheses-highlight ((nil (:weight ultra-bold))) t)
 '(mode-line ((((class color) (min-colors 89)) (:inverse-video unspecified :overline nil :underline nil :box (1 . 1))))))
)
