;; -*- lexical-binding: t; -*-

(require-package 'go-mode "https://github.com/dominikh/go-mode.el")
(require 'go-mode)
(autoload 'go-mode "go-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))

(provide 'init-go)
