;; -*- lexical-binding: t; -*-

(require 'google-c-style)
(add-hook 'c-mode-common-hook #'google-set-c-style)



(require 'cuda-mode)
(add-to-list 'auto-mode-alist
             '("\\.cu[h]?\\'" . cuda-mode))

(provide 'init-cpp)
