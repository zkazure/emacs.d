;; -*- lexical-binding: t; -*-

(global-set-key (kbd "C-c c g") 'gdb)

(setq gdb-many-windows t)
(setq gdb-show-main t)
(setq gdb-non-stop-setting nil)

(provide 'init-gdb)
