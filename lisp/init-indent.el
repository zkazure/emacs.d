(setq-default indent-tabs-mode nil
              tab-width 4)

(defun adjust-languages-indent (n)
  (setq-local c-basic-offset n)
  (setq-local c-ts-mode-indent-offset n)
  (setq-local go-ts-mode-indent-offset n)

  (setq-local coffee-tab-width n)
  (setq-local javascript-indent-level n)
  (setq-local js-indent-level n)

  (setq-local web-mode-attr-indent-offset n)
  (setq-local web-mode-attr-value-indent-offset n)
  (setq-local web-mode-code-indent-offset n)
  (setq-local web-mode-css-indent-offset n)
  (setq-local web-mode-markup-indent-offset n)
  (setq-local web-mode-sql-indent-offset n)

  (setq-local css-indent-offset n)
  (setq-local typescript-indent-level n)
  )

(dolist (hook (list
               'c++-ts-mode-hook
               'c-ts-mode-hook
               'java-mode-hook
               'haskell-mode-hook
               'asm-mode-hook
               'sh-mode-hook
               'haskell-cabal-mode-hook
               'ruby-mode-hook
               'qml-mode-hook
               ;; 'scss-mode-hook
               'go-mode-hook
               'go-ts-mode-hook
               'coffee-mode-hook
               'rust-mode-hook
               ))
  (add-hook hook #'(lambda ()
                     (setq indent-tabs-mode nil)
                     (adjust-languages-indent 4)
                     )))

(dolist (hook (list
               'web-mode-hook
               'js-mode-hook
               'js-ts-mode-hook
               'typescript-mode-hook
               'css-ts-mode-hook
               ))
  (add-hook hook #'(lambda ()
                     (setq indent-tabs-mode nil)
                     (adjust-languages-indent 2)
                     )))

(dolist (hook (list
               'yaml-mode-hook
               'yaml-ts-mode-hook
               ))
  (add-hook 'hook #'(lambda ()
                      (setq indent-tabs-mode nil)
                      (setq-local yaml-indent 2)
                      (setq-local tab-width 2))))


(provide 'init-indent)
