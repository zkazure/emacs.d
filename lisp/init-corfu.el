;; -*- lexical-binding: t; -*-

(require 'corfu)
(add-to-list 'load-path
             (expand-file-name "lib/corfu/extensions/" user-emacs-directory))
;; (require 'corfu-echo)
;; (require 'corfu-history)
(require 'corfu-info)
(require 'corfu-indexed)
(require 'corfu-popupinfo)

(setq tab-always-indent 'complete)
(setq completion-cycle-threshold 4)

(setq corfu-auto t
      corfu-auto-prefix 2
      corfu-count 10
      corfu-cycle t
      corfu-preview-current nil
      corfu-on-exact-match nil
      corfu-auto-delay 0.1
      corfu-popupinfo-delay '(0.8 . 0.4)
      corfu-quit-at-boundary t
      global-corfu-modes '((not erc-mode
                                circe-mode
                                help-mode
                                gud-mode)
                           t))

(setq-default corfu-quit-no-match 'separator)
(add-hook 'after-init-hook #'global-corfu-mode)

(with-eval-after-load 'corfu
  (corfu-popupinfo-mode)
  (corfu-indexed-mode))

(dotimes (i 10)
  (define-key corfu-map
              (kbd (format "M-%s" i))
              (kbd (format "C-%s RET" i))))


;; nerd-icon for corfu
(require 'nerd-icons-corfu)
(with-eval-after-load 'corfu
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))


(provide 'init-corfu)
