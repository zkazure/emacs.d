;; -*- lexical-binding: t; -*-
;; Load path
;; (push (expand-file-name "site-lisp" user-emacs-directory) load-path)
(require 'package)
(package-initialize)
(push (expand-file-name "lisp" user-emacs-directory) load-path)

;; Packages
;; Without this comment Emacs25 adds (package-initialize) here
(setq package-archives
      '(("gnu"    . "https://mirrors.ustc.edu.cn/elpa/gnu/")
        ("nongnu" . "https://mirrors.ustc.edu.cn/elpa/nongnu/")
        ("melpa"  . "https://mirrors.ustc.edu.cn/elpa/melpa/")))

;; Better defaults
(setq auto-save-default nil)
(setq inhibit-splash-screen t)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets) ; Show path if names are same
(setq delete-by-moving-to-trash t)         ; Deleting files go to OS's trash folder
(setq set-mark-command-repeat-pop t)       ; Repeating C-SPC after popping mark pops it again
(global-set-key (kbd "C-s") #'isearch-forward-regexp)
(global-set-key (kbd "C-r") #'isearch-backward-regexp)


;; Tab and Space
;; Permanently indent with spaces, never with TABs
(setq-default c-basic-offset   4
              tab-width        4
              indent-tabs-mode t)

;; UI
(load-theme 'leuven-dark t)
(set-face-attribute 'default nil :height 120)

(menu-bar-mode -1)

(if (fboundp 'display-line-numbers-mode)
    (progn
      (add-hook 'prog-mode-hook #'display-line-numbers-mode)))

;; Basic modes
(xterm-mouse-mode 1)
(mouse-wheel-mode 1)
(global-subword-mode 1)
(show-paren-mode 1)
(global-auto-revert-mode 1)

(electric-pair-mode 1)
(electric-indent-mode 1)

(global-set-key (kbd "M-p") #'backward-paragraph)
(global-set-key (kbd "M-n") #'forward-paragraph)

(global-set-key (kbd "C-x C-b") 'ibuffer)

(global-set-key (kbd "C-c c") #'compile)
(global-set-key (kbd "<f6>") #'recompile)

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

;;; dired
(require 'dired)
(define-key dired-mode-map (kbd "b") #'dired-up-directory)


;;; view-mode
(require 'view)
(add-hook 'find-file-hook
		  (lambda () (read-only-mode 1)))
(setq view-read-only t)
(global-set-key (kbd "C-c o v") #'view-mode)


;;; terminal
;; curl -L -o ghostel-module.so https://gh-proxy.com/https://github.com/dakra/ghostel/releases/download/v0.59.0/ghostel-module-x86_64-linux.so
(use-package ghostel
  :ensure t
  :config
  (global-set-key (kbd "C-c o t") #'ghostel))

;; support copy from terminal.
(defun my-osc52-copy (text &optional _push)
  "Copy TEXT to the local clipboard via OSC 52."
  (send-string-to-terminal
   (concat
    "\e]52;c;"
    (base64-encode-string
     (encode-coding-string text 'utf-8)
     t)
    "\e\\")))
(setq interprogram-cut-function #'my-osc52-copy)

;; dabbrev
(setq dabbrev-abbrev-char-regexp "[A-Za-z0-9_-]"
      dabbrev-case-fold-search nil)

(use-package ansi-color
  :ensure nil
  :hook
  (compilation-filter-hook . ansi-color-compilation-filter)
  :custom
  (compilation-scroll-output t))

(use-package csv-mode
  :ensure t)
(use-package cuda-mode
  :ensure t
  :mode (("\\.cu\\'"  . cuda-mode)
         ("\\.cuh\\'" . cuda-mode)))

(use-package dumb-jump
  :ensure t
  :config
  (add-to-list 'dumb-jump-language-file-exts
               '(:language "c++" :ext "cu"
                 :agtype nil :rgtype "cuda"))
  (add-to-list 'dumb-jump-language-file-exts
               '(:language "c++" :ext "cuh"
                 :agtype nil :rgtype "cuda"))

  (setq dumb-jump-prefer-searcher 'rg)

  (add-hook 'xref-backend-functions
            #'dumb-jump-xref-activate))

(use-package no-littering
  :ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Init-mini.el ends here
