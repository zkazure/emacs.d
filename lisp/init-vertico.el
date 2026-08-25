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

(vertico-multiform-mode)

(vertico-indexed-mode)


(require 'vertico-posframe)
(vertico-posframe-mode 1)
(setq vertico-posframe-poshandler #'posframe-poshandler-frame-top-center)

;; icons
(require 'marginalia)
(require 'nerd-icons-completion)
(add-hook 'after-init-hook 'marginalia-mode)
(add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup)
(nerd-icons-completion-mode)


(provide 'init-vertico)
