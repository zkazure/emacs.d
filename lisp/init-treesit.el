(require 'treesit)

(setq treesit-language-source-alist
      '((bash "https://github.com/tree-sitter/tree-sitter-bash")
        (c "https://github.com/tree-sitter/tree-sitter-c")
        (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
        (cmake "https://github.com/uyha/tree-sitter-cmake")
        (csharp "https://github.com/tree-sitter/tree-sitter-c-sharp.git")
        (dockerfile "https://github.com/camdencheek/tree-sitter-dockerfile")
        (elisp "https://github.com/Wilfred/tree-sitter-elisp")
        (elixir "https://github.com/elixir-lang/tree-sitter-elixir")
        (haskell "https://github.com/tree-sitter/tree-sitter-haskell")
        (css "https://github.com/tree-sitter/tree-sitter-css")
        (go "https://github.com/tree-sitter/tree-sitter-go")
        (html "https://github.com/tree-sitter/tree-sitter-html")
        (java "https://github.com/tree-sitter/tree-sitter-java.git")
        (javascript "https://github.com/tree-sitter/tree-sitter-javascript")
        (json "https://github.com/tree-sitter/tree-sitter-json")
        (php . ("https://github.com/tree-sitter/tree-sitter-php"))
        (lua . ("https://github.com/Azganoth/tree-sitter-lua"))
        (make "https://github.com/alemuller/tree-sitter-make")
        (markdown "https://github.com/ikatyang/tree-sitter-markdown")
        (org . ("https://github.com/milisims/tree-sitter-org"))
        (python "https://github.com/tree-sitter/tree-sitter-python")
        (ruby . ("https://github.com/tree-sitter/tree-sitter-ruby"))
        (toml "https://github.com/tree-sitter/tree-sitter-toml")
        (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
        (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
        (rust . ("https://github.com/tree-sitter/tree-sitter-rust"))
        (sql . ("https://github.com/m-novikov/tree-sitter-sql"))
        (vue . ("https://github.com/merico-dev/tree-sitter-vue"))
        (kotlin . ("https://github.com/fwcd/tree-sitter-kotlin"))
        (yaml "https://github.com/ikatyang/tree-sitter-yaml")
        (zig . ("https://github.com/GrayJack/tree-sitter-zig"))
        (clojure . ("https://github.com/sogaiu/tree-sitter-clojure"))
        ))


(setq major-mode-remap-alist
      '((c-mode . c-ts-mode)
        (c++-mode . c++-ts-mode)
        (clojure-mode . clojure-ts-mode)
        (conf-toml-mode . toml-ts-mode)
        (css-mode . css-ts-mode)
        (go-mode . go-ts-mode)
        (js-mode . js-ts-mode)
        (java-mode . java-ts-mode)
        (json-mode . json-ts-mode)
        (js-json-mode . json-ts-mode)
        (python-mode . python-ts-mode)
        (rust-mode . rust-ts-mode)
        (sh-mode . bash-ts-mode)
        (bash-mode . bash-ts-mode)
        (typescript-mode . typescript-ts-mode)
        (tsx-mode . tsx-ts-mode)
        (toml-mode . toml-ts-mode)
        (yaml-mode . yaml-ts-mode)
        ;; (markdown-mode . markdown-ts-mode)
        ))

;; (add-hook 'markdown-ts-mode-hook (lambda () (treesit-parser-create 'markdown)))
;; (add-hook 'zig-mode-hook (lambda () (treesit-parser-create 'zig)))
;; (add-hook 'mojo-mode-hook (lambda () (treesit-parser-create 'mojo)))
(add-hook 'emacs-lisp-mode-hook (lambda () (treesit-parser-create 'elisp)))
(add-hook 'ielm-mode-hook (lambda () (treesit-parser-create 'elisp)))
;; (add-hook 'go-mode-hook (lambda () (treesit-parser-create 'go)))
;; (add-hook 'java-mode-hook (lambda () (treesit-parser-create 'java)))
;; (add-hook 'java-ts-mode-hook (lambda () (treesit-parser-create 'java)))
;; (add-hook 'clojure-mode-hook (lambda () (treesit-parser-create 'clojure)))
;; (add-hook 'clojure-ts-mode-hook (lambda () (treesit-parser-create 'clojure)))
;; (add-hook 'cider-repl-mode-hook (lambda () (treesit-parser-create 'clojure)))
;; (add-hook 'php-mode-hook (lambda () (treesit-parser-create 'php)))
;; (add-hook 'php-ts-mode-hook (lambda () (treesit-parser-create 'php)))
;; (add-hook 'haskell-mode-hook (lambda () (treesit-parser-create 'haskell)))
;; (add-hook 'kotlin-mode-hook (lambda () (treesit-parser-create 'kotlin)))
;; (add-hook 'ruby-mode-hook (lambda () (treesit-parser-create 'ruby)))
;; (add-hook 'org-mode-hook (lambda () (treesit-parser-create 'org)))

(add-hook 'web-mode-hook #'(lambda ()
                             (let ((file-name (buffer-file-name)))
                               (when file-name
                                 (treesit-parser-create
                                  (pcase (file-name-extension file-name)
                                    ("vue" 'vue)
                                    ("html" 'html)
                                    ("php" 'php))))
                               )))

(setq treesit-font-lock-level 4)

;; for cmake-ts-mode
(add-to-list 'auto-mode-alist '("CMakeLists\\.txt\\'" . cmake-ts-mode))
(add-to-list 'auto-mode-alist '("\\.cmake\\'" . cmake-ts-mode))



(require 'treesit-fold)
(add-hook 'prog-mode-hook (lambda ()
                            (when (and (fboundp 'treesit-parser-list)
                                       (treesit-parser-list))
                              (treesit-fold-mode 1)
                              ;; (treesit-fold-indicators-mode 1)
                              (treesit-fold-line-comment-mode 1))))
(setq treesit-fold-line-count-show t)  ; Show line count in folded regions
;; (setq treesit-fold-line-count-format " <%d lines> ")
;; (add-hook 'org-mode-hook (lambda () (setq treesit-fold-indicators-fringe 'right-fringe)))

(setq treesit-fold-summary-show t
      treesit-fold-summary-max-length 60
      treesit-fold-summary-exceeded-string "..."
      treesit-fold-summary-format " <S> %s ")

;; (setq treesit-fold-indicators-face-function
;;       (lambda (pos &rest _)
;;         ;; Return the face of it's function.
;;         (line-reminder--get-face (line-number-at-pos pos t))))
;; (setq line-reminder-add-line-function
;;       (lambda (&rest _)
;;         (null (treesit-fold--overlays-in treesit-fold-indicators-window (selected-window)
;;                                     (line-beginning-position) (line-end-position)))))


(provide 'init-treesit)
