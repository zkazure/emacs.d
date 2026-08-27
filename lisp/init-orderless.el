;; -*- lexical-binding: t; -*-

(require 'cape)
(add-to-list 'completion-at-point-functions #'cape-file)


(require 'orderless)
(setq orderless-component-separator #'orderless-escapable-split-on-space
      completion-styles '(orderless basic)
      completion-category-defaults nil
      completion-category-overrides nil
      ;; completion-pcm-leading-wildcard t ; emacs 31
      )

;; (setq completion-category-overrides
;;       '((file    (styles orderless partial-completion basic))
;;         (buffer  (styles orderless))
;;         (eglot   (styles . (orderless basic)))
;;         ))

(provide 'init-orderless)
