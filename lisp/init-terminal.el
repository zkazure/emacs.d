;; -*- lexical-binding: t; -*-

(xterm-mouse-mode 1)

(require-package 'ghostel '(:url "https://github.com/dakra/ghostel.git" :lisp-dir "lisp"))
(require 'ghostel)
(require 'ghostel-ime)

(add-hook 'ghostel-mode-hook #'ghostel-ime-mode)
(global-set-key (kbd "C-c o t") #'ghostel)

(provide 'init-terminal)
