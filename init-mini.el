;; Load path
;; (push (expand-file-name "site-lisp" user-emacs-directory) load-path)
(push (expand-file-name "lisp" user-emacs-directory) load-path)

;; Packages
;; Without this comment Emacs25 adds (package-initialize) here
(setq package-archives
      '(("gnu"   . "http://elpa.gnu.org/packages/")
        ("melpa" . "http://melpa.org/packages/")))

;; Explicitly set the preferred coding systems to avoid annoying prompt
;; from emacs (especially on Microsoft Windows)
(prefer-coding-system 'utf-8)


;; Better defaults
;; (setq initial-scratch-message nil)
(setq inhibit-splash-screen t)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets) ; Show path if names are same
(setq adaptive-fill-regexp "[ t]+|[ t]*([0-9]+.|*+)[ t]*")
(setq adaptive-fill-first-line-regexp "^* *$")
(setq delete-by-moving-to-trash t)         ; Deleting files go to OS's trash folder
(setq auto-save-default nil)               ; Disable auto save
(setq set-mark-command-repeat-pop t)       ; Repeating C-SPC after popping mark pops it again

(setq-default major-mode 'text-mode)

(setq sentence-end-double-space nil)

;; Tab and Space
;; Permanently indent with spaces, never with TABs
(setq-default c-basic-offset   4
              tab-width        4
              indent-tabs-mode nil)

;; UI
(load-theme 'wombat t)
(set-face-attribute 'default nil :height 120)


(unless (eq window-system 'ns)
  (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))
(when (fboundp 'horizontal-scroll-bar-mode)
  (horizontal-scroll-bar-mode -1))

(setq hl-line-sticky-flag nil)
(setq hl-line-range-function
      (lambda () (cons (line-end-position)
                       (line-beginning-position 2))))
(global-hl-line-mode 1)
(if (fboundp 'display-line-numbers-mode)
    (progn
      (add-hook 'prog-mode-hook #'display-line-numbers-mode)))

;; Basic modes
(show-paren-mode 1)
(delete-selection-mode 1)
(global-auto-revert-mode 1)
;; (recentf-mode 1)
;; (when (fboundp 'savehist-mode)
;;   (savehist-mode 1))
;; (if (fboundp 'save-place-mode)
;;     (save-place-mode 1)
;;   (require 'saveplace)
;; (setq-default save-place t))

(setq electric-pair-inhibit-predicate 'electric-pair-default-inhibit)
(electric-pair-mode 1)
(electric-indent-mode 1)

(global-set-key (kbd "M-p") #'backward-paragraph)
(global-set-key (kbd "M-n") #'forward-paragraph)

(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "M-z") 'zap-up-to-char)

(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)

;; repeat command easily
(if (fboundp 'repeat-mode)
    (progn
      (repeat-mode 1)
      (define-key undo-repeat-map (kbd "U") 'undo-redo)))


;; Completion
(when (fboundp 'global-completion-preview-mode)
  (global-completion-preview-mode 1))

;; (if (fboundp 'fido-mode)
;;     (progn
;;       (fido-mode 1)
;;       (when (fboundp 'fido-vertical-mode)
;;         (fido-vertical-mode 1))

;;       (defun fido-recentf-open ()
;;         "Use `completing-read' to find a recent file."
;;         (interactive)
;;         (if (find-file (completing-read "Find recent file: " recentf-list))
;;             (message "Opening file...")
;;           (message "Aborting")))
;;       (global-set-key (kbd "C-x C-r") 'fido-recentf-open))
;;   (progn
;;     (ido-mode 1)
;;     (ido-everywhere 1)

;;     (setq ido-use-virtual-buffers t
;;           ido-use-filename-at-point 'guess
;;           ido-create-new-buffer 'always
;;           ido-enable-flex-matching t)

;;     ;; (defun ido-recentf-open ()
;;     ;;   "Use `ido-completing-read' to find a recent file."
;;     ;;   (interactive)
;;     ;;   (if (find-file (ido-completing-read "Find recent file: " recentf-list))
;;     ;;       (message "Opening file...")
;;     ;;     (message "Aborting")))
;;     ;; (global-set-key (kbd "C-x C-r") 'ido-recentf-open))
;;   ))

(setq save-interprogram-paste-before-kill t
      apropos-do-all t
      mouse-yank-at-point t
      require-final-newline t
      visible-bell t
      load-prefer-newer t
      frame-inhibit-implied-resize t
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
