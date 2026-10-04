;; -*- lexical-binding: t; -*-

(require 'sql-indent)
(add-hook 'sql-mode-hook 'sqlind-minor-mode)

(provide 'init-sql)
