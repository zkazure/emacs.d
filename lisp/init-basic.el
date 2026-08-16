;;; -*- lexical-binding: t -*-

(require 'no-littering)
(require 'diminish)

(with-eval-after-load 'outline
  (diminish 'outline-minor-mode))
(with-eval-after-load 'reveal
  (diminish 'reveal-mode))
(with-eval-after-load 'eldoc
  (diminish 'eldoc-mode))

(setq auth-source '("~/.authinfo.gpg"))

(setq make-backup-files nil)
(setq create-lockfiles nil)

;; if auto yas-indent will call indent-according-to-mode which use
;; indent-line-function to make indentation
;; and that function in makefile-mode is indent-to-left-margin
(fset 'yes-or-no-p 'y-or-n-p)
(global-set-key (kbd "M-p") #'backward-paragraph)
(global-set-key (kbd "M-n") #'forward-paragraph)

(setq-default show-trailing-whitespace nil)
(defun zkazure/show-trailing-whitespace ()
  (setq-local show-trailing-whitespace t))
(add-hook 'prog-mode-hook #'zkazure/show-trailing-whitespace)


;; Adjust garbage collection threshold for early startup (see use of gcmh below)
(setq gc-cons-threshold (* 128 1024 1024))

(require 'gcmh)
(setq gcmh-high-cons-threshold (* 128 1024 1024))
(gcmh-mode)
(diminish 'gcmh-mode)

;; Process performance tuning
(setq read-process-output-max (* 4 1024 1024))
(setq process-adaptive-read-buffering nil)

;; skip delay
(setq redisplay-skip-fontification-on-input t)

;; 禁止双向显示文字
(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right)
(setq bidi-inhibit-bpa t
      long-line-threshold 1000
      large-hscroll-threshold 1000
      syntax-wholeline-max 1000)

(setq jit-lock-defer-time 0)

(when (fboundp 'global-so-long-mode)
  (global-so-long-mode 1))


(setq system-time-locale "en_US.utf8")

(prefer-coding-system       'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-language-environment   'utf-8)

(require 'envrc)
(envrc-global-mode)
(diminish 'envrc-mode)



;; save pasteboard before killing
(setq save-interprogram-paste-before-kill t)
(setq kill-do-not-save-duplicates t)

(setq reb-re-syntax 'string)

(when (fboundp 'global-subword-mode)
  (global-subword-mode 1))

(save-place-mode 1)
(advice-add 'save-place-find-file-hook :after
            (lambda (&rest _)
              (when buffer-file-name (ignore-errors (recenter)))))

(setq help-window-select t)

(setq inhibit-default-init t)

(add-hook 'after-init-hook 'global-auto-revert-mode)
(setq global-auto-revert-non-file-buffers t
      auto-revert-verbose nil)


(require 'which-key)
(which-key-mode)
(diminish 'which-key-mode)
(require 'which-key-posframe)
(which-key-posframe-mode)


(when (fboundp 'repeat-mode)
    (progn
      (add-hook 'after-init-hook 'repeat-mode)
      (define-key undo-repeat-map (kbd "U") 'undo-redo)))
(define-key undo-repeat-map (kbd "U") 'undo-redo)
;; be able to C-SPC to keep jump back to last position
;; instead of C-u C-SPC every time
(setq set-mark-command-repeat-pop t)


(require 'projectile)
(projectile-mode +1)
(diminish 'projectile-mode)
;; Recommended keymap prefix on Windows/Linux
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)



(require 'dumb-jump)
(setq dumb-jump-prefer-searcher 'rg
      xref-show-definitions-function #'consult-xref)
(add-hook 'xref-backend-functions #'dumb-jump-xref-activate)



(require 'helpful)
;; Note that the built-in `describe-function' includes both functions
;; and macros. `helpful-function' is functions only, so we provide
;; `helpful-callable' as a drop-in replacement.
(global-set-key (kbd "C-h f") #'helpful-callable)
(global-set-key (kbd "C-h v") #'helpful-variable)
(global-set-key (kbd "C-h k") #'helpful-key)
(global-set-key (kbd "C-h x") #'helpful-command)
;; Lookup the current symbol at point. C-c C-d is a common keybinding
;; for this in lisp modes.
(global-set-key (kbd "C-c C-d") #'helpful-at-point)
;; Look up *F*unctions (excludes macros).
;; By default, C-h F is bound to `Info-goto-emacs-command-node'. Helpful
;; already links to the manual, if a function is referenced there.
(global-set-key (kbd "C-h F") #'helpful-function)
(setq counsel-describe-function-function #'helpful-callable)
(setq counsel-describe-variable-function #'helpful-variable)


(provide 'init-basic)
