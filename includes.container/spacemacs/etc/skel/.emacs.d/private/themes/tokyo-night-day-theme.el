;;; tokyo-night-day-theme.el --- Light theme based on Tokyo Night Day -*- lexical-binding: t -*-

;; Palette sourced from folke/tokyonight.nvim "day" style.
;; Color names match the clement-souchet Tokyo Tower sunrise photo:
;; warm peach-orange sky, cool steel-blue city, crisp whites.

(deftheme tokyo-night-day "Light theme based on the Tokyo Night Day color palette")

(let* ((bg        "#e1e2e7")  ; main background — light grey-white
       (bg-alt    "#d4d5db")  ; sidebars, popups
       (bg-dark   "#c4cad9")  ; borders, inactive elements
       (bg-hl     "#b2c2f0")  ; selection / visual
       (fg        "#3760bf")  ; main foreground — deep blue
       (fg-dim    "#6172b0")  ; secondary text, sidebar fg
       (comment   "#848cb5")  ; comments — muted blue-grey
       (red       "#f52a65")  ; errors, deletions
       (green     "#587539")  ; strings, additions
       (yellow    "#8c6c3e")  ; warnings, operators
       (blue      "#2e7de9")  ; functions, links
       (magenta   "#9854f1")  ; keywords
       (cyan      "#007197")  ; types, special
       (orange    "#b15c00")  ; constants, numbers
       (teal      "#388092")  ; constructors
       (purple    "#7847bd")  ; builtins
       (border    "#9196a2"))

  (custom-theme-set-faces
   'tokyo-night-day

   ;; --- Core ---
   `(default                           ((t (:background ,bg :foreground ,fg))))
   `(cursor                            ((t (:background ,fg))))
   `(fringe                            ((t (:background ,bg-alt :foreground ,comment))))
   `(vertical-border                   ((t (:foreground ,bg-dark))))
   `(window-divider                    ((t (:foreground ,bg-dark))))
   `(window-divider-first-pixel        ((t (:foreground ,bg-dark))))
   `(window-divider-last-pixel         ((t (:foreground ,bg-dark))))
   `(border                            ((t (:foreground ,border))))

   ;; --- Selection / Highlighting ---
   `(region                            ((t (:background ,bg-hl))))
   `(highlight                         ((t (:background ,bg-dark))))
   `(secondary-selection               ((t (:background ,bg-dark))))
   `(show-paren-match                  ((t (:background ,bg-hl :weight bold))))
   `(show-paren-mismatch               ((t (:background ,red :foreground ,bg :weight bold))))
   `(trailing-whitespace               ((t (:background ,red))))
   `(whitespace-trailing               ((t (:background ,red))))

   ;; --- Search ---
   `(isearch                           ((t (:background ,blue :foreground ,bg :weight bold))))
   `(isearch-fail                      ((t (:background ,red :foreground ,bg))))
   `(lazy-highlight                    ((t (:background ,bg-hl :foreground ,fg))))
   `(match                             ((t (:background ,bg-hl :foreground ,fg :weight bold))))

   ;; --- Line numbers ---
   `(line-number                       ((t (:foreground ,comment :background ,bg-alt))))
   `(line-number-current-line          ((t (:foreground ,blue :background ,bg-dark :weight bold))))
   `(linum                             ((t (:foreground ,comment :background ,bg-alt))))

   ;; --- Mode line ---
   `(mode-line                         ((t (:background ,bg-alt :foreground ,fg
                                           :box (:line-width 1 :color ,bg-dark)
                                           :overline nil :underline nil))))
   `(mode-line-inactive                ((t (:background ,bg-dark :foreground ,comment
                                           :box (:line-width 1 :color ,bg-dark)
                                           :overline nil :underline nil))))
   `(mode-line-buffer-id               ((t (:foreground ,blue :weight bold))))
   `(mode-line-emphasis                ((t (:foreground ,fg :weight bold))))
   `(mode-line-highlight               ((t (:foreground ,magenta :weight bold))))

   ;; --- Minibuffer ---
   `(minibuffer-prompt                 ((t (:foreground ,blue :weight bold))))

   ;; --- Header ---
   `(header-line                       ((t (:background ,bg-alt :foreground ,fg-dim))))

   ;; --- Font lock (syntax highlighting) ---
   `(font-lock-builtin-face            ((t (:foreground ,purple))))
   `(font-lock-comment-face            ((t (:foreground ,comment :slant italic))))
   `(font-lock-comment-delimiter-face  ((t (:foreground ,comment :slant italic))))
   `(font-lock-constant-face           ((t (:foreground ,orange))))
   `(font-lock-doc-face                ((t (:foreground ,comment))))
   `(font-lock-function-name-face      ((t (:foreground ,blue))))
   `(font-lock-keyword-face            ((t (:foreground ,magenta :weight bold))))
   `(font-lock-negation-char-face      ((t (:foreground ,red))))
   `(font-lock-preprocessor-face       ((t (:foreground ,orange))))
   `(font-lock-regexp-grouping-backslash ((t (:foreground ,cyan))))
   `(font-lock-regexp-grouping-construct ((t (:foreground ,cyan))))
   `(font-lock-string-face             ((t (:foreground ,green))))
   `(font-lock-type-face               ((t (:foreground ,cyan :slant italic))))
   `(font-lock-variable-name-face      ((t (:foreground ,fg))))
   `(font-lock-warning-face            ((t (:foreground ,red :weight bold))))

   ;; --- Status ---
   `(error                             ((t (:foreground ,red :weight bold))))
   `(warning                           ((t (:foreground ,yellow))))
   `(success                           ((t (:foreground ,green :weight bold))))

   ;; --- Links ---
   `(link                              ((t (:foreground ,blue :underline t))))
   `(link-visited                      ((t (:foreground ,purple :underline t))))
   `(button                            ((t (:foreground ,blue :underline t))))

   ;; --- Org mode ---
   `(org-document-title                ((t (:foreground ,blue :weight bold :height 1.3))))
   `(org-document-info                 ((t (:foreground ,fg-dim))))
   `(org-level-1                       ((t (:foreground ,magenta :weight bold :height 1.2))))
   `(org-level-2                       ((t (:foreground ,blue :weight bold :height 1.1))))
   `(org-level-3                       ((t (:foreground ,cyan :weight bold))))
   `(org-level-4                       ((t (:foreground ,teal))))
   `(org-level-5                       ((t (:foreground ,purple))))
   `(org-level-6                       ((t (:foreground ,green))))
   `(org-block                         ((t (:background ,bg-alt :foreground ,fg :extend t))))
   `(org-block-begin-line              ((t (:background ,bg-dark :foreground ,comment :extend t))))
   `(org-block-end-line                ((t (:background ,bg-dark :foreground ,comment :extend t))))
   `(org-code                          ((t (:foreground ,cyan :background ,bg-alt))))
   `(org-verbatim                      ((t (:foreground ,orange :background ,bg-alt))))
   `(org-checkbox                      ((t (:foreground ,blue :weight bold))))
   `(org-date                          ((t (:foreground ,teal :underline t))))
   `(org-tag                           ((t (:foreground ,comment :weight bold))))
   `(org-todo                          ((t (:foreground ,red :weight bold))))
   `(org-done                          ((t (:foreground ,green :weight bold))))
   `(org-special-keyword               ((t (:foreground ,comment))))

   ;; --- Dired ---
   `(dired-directory                   ((t (:foreground ,blue :weight bold))))
   `(dired-symlink                     ((t (:foreground ,cyan))))
   `(dired-marked                      ((t (:foreground ,orange :weight bold))))

   ;; --- Ivy / Counsel ---
   `(ivy-current-match                 ((t (:background ,bg-hl :foreground ,fg :weight bold))))
   `(ivy-minibuffer-match-face-1       ((t (:foreground ,comment))))
   `(ivy-minibuffer-match-face-2       ((t (:foreground ,blue :weight bold))))
   `(ivy-minibuffer-match-face-3       ((t (:foreground ,magenta :weight bold))))
   `(ivy-minibuffer-match-face-4       ((t (:foreground ,cyan :weight bold))))
   `(ivy-virtual                       ((t (:foreground ,fg-dim))))
   `(ivy-confirm-face                  ((t (:foreground ,green))))
   `(ivy-match-required-face           ((t (:foreground ,red))))

   ;; --- Company ---
   `(company-tooltip                   ((t (:background ,bg-alt :foreground ,fg))))
   `(company-tooltip-selection         ((t (:background ,bg-hl :foreground ,fg :weight bold))))
   `(company-tooltip-common            ((t (:foreground ,blue :weight bold))))
   `(company-scrollbar-bg              ((t (:background ,bg-dark))))
   `(company-scrollbar-fg              ((t (:background ,border))))
   `(company-preview-common            ((t (:foreground ,comment))))

   ;; --- Magit ---
   `(magit-header-line                 ((t (:foreground ,fg :weight bold))))
   `(magit-section-heading             ((t (:foreground ,blue :weight bold))))
   `(magit-section-highlight           ((t (:background ,bg-alt))))
   `(magit-diff-added                  ((t (:background "#d4e8c8" :foreground ,green))))
   `(magit-diff-added-highlight        ((t (:background "#c6e0b4" :foreground ,green :weight bold))))
   `(magit-diff-removed                ((t (:background "#f3d0d5" :foreground ,red))))
   `(magit-diff-removed-highlight      ((t (:background "#edbfc6" :foreground ,red :weight bold))))
   `(magit-diff-context                ((t (:foreground ,fg-dim))))
   `(magit-diff-context-highlight      ((t (:background ,bg-alt :foreground ,fg-dim))))
   `(magit-branch-local                ((t (:foreground ,teal :weight bold))))
   `(magit-branch-remote               ((t (:foreground ,green :weight bold))))
   `(magit-tag                         ((t (:foreground ,yellow))))
   `(magit-hash                        ((t (:foreground ,comment))))

   ;; --- which-key ---
   `(which-key-key-face                ((t (:foreground ,blue :weight bold))))
   `(which-key-group-description-face  ((t (:foreground ,magenta))))
   `(which-key-command-description-face ((t (:foreground ,fg))))
   `(which-key-separator-face          ((t (:foreground ,comment))))

   ;; --- Spaceline ---
   `(spacemacs-normal-face             ((t (:background ,blue :foreground ,bg :weight bold))))
   `(spacemacs-insert-face             ((t (:background ,green :foreground ,bg :weight bold))))
   `(spacemacs-visual-face             ((t (:background ,magenta :foreground ,bg :weight bold))))
   `(spacemacs-replace-face            ((t (:background ,red :foreground ,bg :weight bold))))

   ;; --- misc ---
   `(shadow                            ((t (:foreground ,comment))))
   `(escape-glyph                      ((t (:foreground ,cyan))))
   `(homoglyph                         ((t (:foreground ,cyan))))
   `(nobreak-space                     ((t (:foreground ,red :underline t))))
   `(tooltip                           ((t (:background ,bg-alt :foreground ,fg)))))

  (custom-theme-set-variables
   'tokyo-night-day
   '(pdf-view-midnight-colors '("#3760bf" . "#e1e2e7"))))

(provide-theme 'tokyo-night-day)

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; tokyo-night-day-theme.el ends here
