;; -*- lexical-binding: t; -*-

(require-package 'cuda-mode "https://github.com/chachi/cuda-mode")
(require 'cuda-mode)
(add-to-list 'auto-mode-alist
             '("\\.cu[h]?\\'" . cuda-mode))

(provide 'init-cpp)
