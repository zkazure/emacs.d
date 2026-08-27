;; Load path
;; (push (expand-file-name "site-lisp" user-emacs-directory) load-path)
(push (expand-file-name "lisp" user-emacs-directory) load-path)

;; Packages
;; Without this comment Emacs25 adds (package-initialize) here
(setq package-archives
      '(("gnu"   . "http://elpa.gnu.org/packages/")
        ("melpa" . "http://melpa.org/packages/")))

;; Better defaults
(setq inhibit-splash-screen t)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets) ; Show path if names are same
(setq delete-by-moving-to-trash t)         ; Deleting files go to OS's trash folder
(setq set-mark-command-repeat-pop t)       ; Repeating C-SPC after popping mark pops it again

;; Tab and Space
;; Permanently indent with spaces, never with TABs
(setq-default c-basic-offset   4
              tab-width        4
              indent-tabs-mode nil)

;; UI
(load-theme 'wombat t)
(set-face-attribute 'default nil :height 120)


(menu-bar-mode -1)

(if (fboundp 'display-line-numbers-mode)
    (progn
      (add-hook 'prog-mode-hook #'display-line-numbers-mode)))

;; Basic modes
(show-paren-mode 1)
(global-auto-revert-mode 1)

(electric-pair-mode 1)
(electric-indent-mode 1)

(global-set-key (kbd "M-p") #'backward-paragraph)
(global-set-key (kbd "M-n") #'forward-paragraph)

;; Completion
(when (fboundp 'global-completion-preview-mode)
  (global-completion-preview-mode 1))

(setq save-interprogram-paste-before-kill t
      apropos-do-all t
      mouse-yank-at-point t
      require-final-newline t
      load-prefer-newer t
      read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      completion-ignore-case t
      ediff-window-setup-function 'ediff-setup-windows-plain
      custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load-file custom-file))

(setq dabbrev-abbrev-char-regexp "[A-Za-z0-9_-]"
      dabbrev-case-fold-search nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Init-mini.el ends here
