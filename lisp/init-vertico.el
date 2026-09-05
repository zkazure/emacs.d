;; -*- lexical-binding: t; -*-

(require 'vertico)
(add-to-list 'load-path
             (expand-file-name "lib/vertico/extensions/" user-emacs-directory))
(require 'vertico-buffer)
(require 'vertico-directory)
(require 'vertico-flat)
(require 'vertico-grid)
(require 'vertico-indexed)
;; (require 'vertico-mouse)
(require 'vertico-multiform)
;; (require 'vertico-quick)
;; (require 'vertico-repeat)
;; (require 'vertico-reverse)
(require 'vertico-sort)
;; (require 'vertico-suspend)
;; (require 'vertico-posframe)

(vertico-mode)

(keymap-set vertico-map "RET" #'vertico-directory-enter)
(keymap-set vertico-map "DEL" #'vertico-directory-delete-char)
(keymap-set vertico-map "M-DEL" #'vertico-directory-delete-word)
(add-hook 'rfn-eshadow-update-overlay-hook #'vertico-directory-tidy)

(setq vertico-sort-function 'vertico-sort-history-length-alpha)

(vertico-indexed-mode)


(require 'vertico-posframe)
(defun my-vertico-posframe-truncate-line (line)
  "Truncate Vertico candidate LINE without affecting minibuffer input."
  (let* ((width (- vertico-posframe-width 2))
         ;; Vertico 的每个候选末尾自带 \n，
         ;; 单独保存它，避免破坏候选的行结构和 face。
         (newline (if (string-suffix-p "\n" line)
                      (substring line -1)
                    ""))
         (body (if (string-suffix-p "\n" line)
                   (substring line 0 -1)
                 line)))
    (concat
     (truncate-string-to-width body width 0 nil "…")
     newline)))

(defun my-vertico-posframe-truncate-candidates (lines)
  "Truncate candidate lines when using wrapping vertico-posframe."
  (if (and vertico-posframe-mode
           (not vertico-posframe-truncate-lines)
           (numberp vertico-posframe-width))
      (mapcar #'my-vertico-posframe-truncate-line lines)
    lines))

(advice-add 'vertico--arrange-candidates
            :filter-return
            #'my-vertico-posframe-truncate-candidates)

(setq vertico-posframe-poshandler #'posframe-poshandler-frame-top-center
      vertico-posframe-truncate-lines nil
      )

(setq vertico-multiform-categories
      '((t posframe)))
(vertico-multiform-mode)



;; icons
(require 'marginalia)
(require 'nerd-icons-completion)
(add-hook 'after-init-hook 'marginalia-mode)
(add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup)
(nerd-icons-completion-mode)


(provide 'init-vertico)
