;; -*- lexical-binding: t; -*-

(require-package 'vertico "https://github.com/minad/vertico")
(require 'vertico)
;; VC checkouts keep the extensions in their source subdirectory.
(let ((extensions (expand-file-name "extensions/"
                                    (file-name-directory (locate-library "vertico")))))
  (when (file-directory-p extensions)
    (add-to-list 'load-path extensions)))
(require 'vertico-buffer)
(require 'vertico-directory)
(require 'vertico-flat)
(require 'vertico-grid)
(require 'vertico-indexed)
;; (require 'vertico-mouse)
;; (require 'vertico-multiform)
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

(require-package 'vertico-buffer-frame "https://github.com/kn66/vertico-buffer-frame.git")
(require 'vertico-buffer-frame)
(setq vertico-buffer-frame-auto-width t
      vertico-buffer-frame-consult-preview nil)
(vertico-buffer-frame-mode 1)


;; icons
(require-package 'marginalia "https://github.com/minad/marginalia")
(require 'marginalia)
(require-package 'nerd-icons-completion "https://github.com/rainstormstudio/nerd-icons-completion")
(require 'nerd-icons-completion)
(add-hook 'after-init-hook 'marginalia-mode)
(add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup)
(nerd-icons-completion-mode)


(provide 'init-vertico)
