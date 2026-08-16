;; -*- lexical-binding: t; -*-

(global-set-key (kbd "C-c c C") 'compile)
(global-set-key (kbd "<f6>") 'recompile)


;; ansi color
(require 'ansi-color)
(add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)

(setq-default compilation-scroll-output t)
(add-hook 'compilation-filter-hook #'ansi-color-compilation-filter)


(provide 'init-compile)
