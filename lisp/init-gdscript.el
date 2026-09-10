;; -*- lexical-binding: t; -*-


(require-package 'gdscript-mode "https://github.com/godotengine/emacs-gdscript-mode")
(require 'gdscript-mode)
(require-package 'hydra "https://github.com/abo-abo/hydra")
(require 'hydra)

(add-hook 'gdscript-mode-hook 'eglot-ensure)
(define-key gdscript-mode-map (kbd "C-c n") nil)
(define-key gdscript-mode-map (kbd "C-c r") nil)
(define-key gdscript-mode-map (kbd "C-c C-n") #'gdscript-debug-hydra)
(define-key gdscript-mode-map (kbd "C-c C-r") #'gdscript-hydra-show)

(provide 'init-gdscript)
