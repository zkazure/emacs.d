;; -*- lexical-binding: t; -*-

(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator " • ")
(setq uniquify-after-kill-buffer-p t)
(setq uniquify-ignore-buffers-re "^\\*")


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

(provide 'init-buffer)
