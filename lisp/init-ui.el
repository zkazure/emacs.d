(setq multibyte-syntax-as-symbol t)
;; (setq-default line-spacing .1)

;; 减少闪烁
(modify-frame-parameters nil '((inhibit-double-buffering . nil)))

(customize-set-variable 'fill-column 80)
(add-hook 'text-mode-hook (lambda () (progn
                                       (visual-line-mode 1)
                                       (visual-wrap-prefix-mode 1))))

;; (setq global-display-fill-column-indicator-mode
;;       '((not help-mode
;;              eat-mode)
;;         t))
;; (add-hook 'after-init-hook #'global-display-fill-column-indicator-mode)

(when (fboundp 'display-line-numbers-mode)
  (setq-default display-line-numbers-width 3)
  (add-hook 'prog-mode-hook 'display-line-numbers-mode)
  (add-hook 'yaml-mode-hook 'display-line-numbers-mode)
  (add-hook 'yaml-ts-mode-hook 'display-line-numbers-mode)
  ;; (setq display-line-numbers-type 'relative)
  )

(when (boundp 'display-fill-column-indicator)
  (setq-default indicate-buffer-boundaries 'left)
  (setq-default display-fill-column-indicator-character ?┊)
  (add-hook 'prog-mode-hook 'display-fill-column-indicator-mode))

(global-so-long-mode 1)

(setq next-screen-context-lines 2)

(setq enable-recursive-minibuffers +1)
(setq cursor-in-non-selected-windows nil)

(setq hl-line-sticky-flag nil
      hl-line-overlay-priority -50
      ;; hl-line-range-function (lambda () (cons (line-end-position)
      ;;                                    (line-beginning-position 2)))
      )

(global-hl-line-mode 1)

(load-theme 'modus-operandi)

(setq initial-frame-alist
      (append (list (cons 'font "Maple Mono NF CN-12"))
              initial-frame-alist))
(setq default-frame-alist
      (append (list (cons 'font "Maple Mono NF CN-12"))
              default-frame-alist))

(when (display-graphic-p)
  (set-frame-font "Maple Mono NF CN-12" t t))

(set-face-attribute 'variable-pitch nil
                    :family "Noto Serif"
                    :height 120
                    :weight 'regular)

(global-set-key (kbd "C-x C-b") 'ibuffer-other-window)
(setq ibuffer-show-empty-filter-groups t)
(setq ibuffer-saved-filter-groups
      `(("default"
         ;; ("mail" (or
         ;;          (mode . message-mode)
         ;;          (mode . notmuch-hello-mode)
         ;;          (mode . notmuch-search-mode)
         ;;          (mode . notmuch-message-mode)
         ;;          (mode . notmuch-show-mode)
         ;;          (mode . notmuch-tree-mode)
         ;;          (mode . bbdb-mode)
         ;;          (mode . mail-mode)
         ;;          (mode . mu4e-main-mode)
         ;;          (mode . gnus-group-mode)
         ;;          (mode . gnus-summary-mode)
         ;;          (mode . gnus-article-mode)
         ;;          (name . "^\\..bdb$")))
         ("org" (or
                 (mode . org-agenda-mode)
                 (mode . diary-mode)
                 (name . "^\\*Calendar\\*$")
                 (name . "^diary$")
                 (filename . "Pending/org/")))
         ("dired" (mode . dired-mode))
         ("emacs" (or
                   (name . "^\\*package.*results\\*$")
                   (name . "^\\*Shell.*Output\\*$")
                   (name . "^\\*Compile-Log\\*$")
                   (name . "^\\*Completions\\*$")
                   (name . "^\\*Backtrace\\*$")
                   (name . "^\\*dashboard\\*$")
                   (name . "^\\*Messages\\*$")
                   (name . "^\\*scratch\\*$")
                   (name . "^\\*Appointment Alert\\*$")
                   (name . "^\\*info\\*$")
                   (name . "^\\*Help\\*$")))
         )))
(defun ct/ibuffer-enable-saved-filter-groups ()
  (ibuffer-switch-to-saved-filter-groups "default"))

(add-hook 'ibuffer-mode-hook #'ct/ibuffer-enable-saved-filter-groups)
(setq ibuffer-formats
      '((mark modified read-only locked " "
  	          (name 20 20 :left :elide)
  	          " "
  	          (mode 16 16 :left :elide)
  	          " "
  	          filename-and-process)
  	    (mark " "
  	          (name 16 -1)
  	          " " filename)))

(provide 'init-ui)
