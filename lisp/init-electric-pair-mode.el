(when (fboundp 'electric-pair-mode)
  (add-hook 'after-init-hook 'electric-pair-mode))
(add-hook 'after-init-hook 'electric-indent-mode)

(setq electric-pair-inhibit-predicate 'electric-pair-default-inhibit)

(provide 'init-electric-pair-mode)
