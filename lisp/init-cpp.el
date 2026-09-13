;; -*- lexical-binding: t; -*-

(require 'cuda-mode)
(add-to-list 'auto-mode-alist
             '("\\.cu[h]?\\'" . cuda-mode))

(provide 'init-cpp)
