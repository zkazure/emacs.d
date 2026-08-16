;; -*- lexical-binding: t; -*-

(require 'eglot)
(require 'eglot-booster)
(with-eval-after-load 'eglot
  (add-hook 'prog-mode-hook 'eglot-ensure)
  (setq eglot-booster-io-only t)
  (eglot-booster-mode 1)
  )

(with-eval-after-load 'eglot
  (setq eglot-autoshutdown t
        eglot-send-changes-idle-time 0.5)
  (setf (plist-get eglot-events-buffer-config :size) 0)
  )

;; (with-eval-after-load 'eglot
;;   (add-to-list 'eglot-server-programs
;;                '(c++-mode . ("clangd" "--header-insertion=never")))
;;   ;; (add-to-list 'eglot-server-programs
;;   ;;              '(c++-ts-mode . ("clangd" "--header-insertion=never")))
;;   (add-to-list 'eglot-server-programs
;;                '(c-mode . ("clangd" "--header-insertion=never")))
;;   ;; (add-to-list 'eglot-server-programs
;;   ;;              '(c-ts-mode . ("clangd" "--header-insertion=never")))
;;   (add-to-list 'eglot-server-programs
;;                '(python-mode . ("basedpyright-langserver")) t)
;;   (add-to-list 'eglot-server-programs
;;                '(python-ts-mode . ("basedpyright-langserver")) t)
;;   (add-to-list 'eglot-server-programs
;;                '(java-mode . ("/home/kazure/.emacs.d/.cache/lsp/eclipse.jdt.ls/bin/jdtls")))
;;   (add-to-list 'eglot-server-programs
;;                '(java-ts-mode . ("/home/kazure/.emacs.d/.cache/lsp/eclipse.jdt.ls/bin/jdtls")))
;;   (add-to-list 'eglot-server-programs
;;                '(scheme-mode . ("racket" "-l" "racket-langserver")))
;;   (add-to-list 'eglot-server-programs
;;                '(asm-mode . ("asm-lsp")))
;;   (add-to-list 'eglot-server-programs
;;                '(emacs-lisp-mode . ("ellsp")))
;;   )

(setq eglot-ignored-server-capabilities
      '(:documentOnTypeFormattingProvider
        :documentFormattingProvider
        :documentRangeFormattingProvider
        :renameProvider
        :documentHighlightProvider
        :foldingRangeProvider
        :inlayHintProvider
        :hoverProvider
        ))

(provide 'init-eglot)
