;; -*- lexical-binding: t; -*-

(require 'cape)
(add-to-list 'completion-at-point-functions #'cape-file)
(with-eval-after-load 'org
  (add-hook 'org-mode-hook
            (lambda ()
              (add-to-list 'completion-at-point-functions #'cape-dabbrev t))))

(provide 'init-cape)
