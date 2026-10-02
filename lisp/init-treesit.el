;; -*- lexical-binding: t; -*-

(require 'treesit)

(setq treesit-enabled-modes t
      treesit-font-lock-level 4)


(with-eval-after-load 'treesit
  (dolist (mode '(c++-mode clojure-mode))
    (setq major-mode-remap-alist
          (assq-delete-all mode major-mode-remap-alist))))


(provide 'init-treesit)
