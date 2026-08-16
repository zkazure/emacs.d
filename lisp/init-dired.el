;; -*- lexical-binding: t; -*-

(require 'dired)

(define-key dired-mode-map (kbd "b") #'dired-up-directory)

(defun dired-mark-files-by-extension (extension)
  "Mark all files with EXTENSION in the current Dired buffer."
  (interactive "sExtension: ")
  (setq extension (string-remove-prefix "." extension))
  (dired-mark-files-regexp
   (concat "\\." (regexp-quote extension) "\\'")))
(define-key dired-mode-map (kbd "* e") #'dired-mark-files-by-extension)

(setq-default dired-dwim-target t)

(setq dired-kill-when-opening-new-dired-buffer t
      delete-by-moving-to-trash t)

;; (require 'diredfl)
;; (diredfl-global-mode)

;; (require 'diff-hl-dired)
;; (add-hook 'dired-mode-hook 'diff-hl-dired-mode)

;; (require 'nerd-icons-dired)
;; (add-hook 'dired-mode-hook 'nerd-icons-dired-mode)

(provide 'init-dired)
