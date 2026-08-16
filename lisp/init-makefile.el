;; -*- lexical-binding: t; -*-

(add-hook 'makefile-mode-hook
          (lambda ()
            (setq-local yas-indent-line 'fixed)))

(provide 'init-makefile)
