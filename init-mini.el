;;; init-mini.el --- Standalone built-in Emacs configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; A small, self-contained entry point.  It deliberately uses only Emacs
;; built-ins and does not load the modular main configuration.

;;; Code:

;; Load path
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; Package metadata.  This file neither initializes packages nor installs them.
(setq package-archives
      '(("gnu"   . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))

;; Better defaults
(setq inhibit-splash-screen t
      uniquify-buffer-name-style 'post-forward-angle-brackets
      delete-by-moving-to-trash t
      set-mark-command-repeat-pop t
      save-interprogram-paste-before-kill t
      apropos-do-all t
      mouse-yank-at-point t
      require-final-newline t
      load-prefer-newer t
      read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      completion-ignore-case t
      ediff-window-setup-function 'ediff-setup-windows-plain
      dabbrev-abbrev-char-regexp "[A-Za-z0-9_-]"
      dabbrev-case-fold-search nil)

;; Tab and space
(setq-default c-basic-offset 4
              tab-width 4
              indent-tabs-mode nil)

;; UI
(load-theme 'wombat t)
(set-face-attribute 'default nil :height 120)
(menu-bar-mode -1)

(when (fboundp 'display-line-numbers-mode)
  (add-hook 'prog-mode-hook #'display-line-numbers-mode))

;; Basic modes
(show-paren-mode 1)
(global-auto-revert-mode 1)
(electric-pair-mode 1)
(electric-indent-mode 1)

(global-set-key (kbd "M-p") #'backward-paragraph)
(global-set-key (kbd "M-n") #'forward-paragraph)

;; Built-in minibuffer completion
(setq completion-styles '(basic partial-completion substring)
      completion-category-defaults nil
      completion-category-overrides '((file (styles partial-completion))))
(when (fboundp 'fido-vertical-mode)
  (fido-vertical-mode 1))
(when (fboundp 'global-completion-preview-mode)
  (global-completion-preview-mode 1))

;; Persist useful navigation history without loading external packages.
(savehist-mode 1)
(save-place-mode 1)

;; Load user customizations normally so errors remain visible.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file nil 'nomessage))

(provide 'init-mini)

;;; init-mini.el ends here
