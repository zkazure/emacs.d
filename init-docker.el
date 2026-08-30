;; Load path
;; (push (expand-file-name "site-lisp" user-emacs-directory) load-path)
(push (expand-file-name "lisp" user-emacs-directory) load-path)

;; Packages
;; Without this comment Emacs25 adds (package-initialize) here
(setq package-archives
      '(("gnu"    . "https://mirrors.ustc.edu.cn/elpa/gnu/")
        ("nongnu" . "https://mirrors.ustc.edu.cn/elpa/nongnu/")
        ("melpa"  . "https://mirrors.ustc.edu.cn/elpa/melpa/")))

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

(global-set-key (kbd "C-x C-b") 'ibuffer)

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


;;; terminal
(use-package eat
  :ensure t
  :init
  (setq explicit-shell-file-name "/bin/bash"))

(xterm-mouse-mode 1)
(mouse-wheel-mode 1)

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Init-mini.el ends here
