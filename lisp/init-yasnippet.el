;; -*- lexical-binding: t; -*-

(require-package 'yasnippet "https://github.com/joaotavora/yasnippet")
(require 'yasnippet)

(yas-global-mode 1)
(diminish 'yas-minor-mode)

;; yasnippet
(with-eval-after-load 'consult
  (require-package 'consult-yasnippet "https://github.com/mohkale/consult-yasnippet")
  (require 'consult-yasnippet)
  (global-set-key (kbd "M-g y") #'consult-yasnippet))

(provide 'init-yasnippet)
