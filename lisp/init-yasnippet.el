(require 'yasnippet)
(yas-global-mode 1)

;; yasnippet
(with-eval-after-load 'consult
  (require 'consult-yasnippet)
  (global-set-key (kbd "M-g y") #'consult-yasnippet))

(provide 'init-yasnippet)
