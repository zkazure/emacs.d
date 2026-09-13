;; -*- lexical-binding: t; -*-

;; Eglot is provided by this Emacs release.
(require 'eglot)
(require 'eglot-booster)

;; `prog-mode-hook' also fires in major modes no LSP server is configured for,
;; e.g. emacs-lisp-mode.  There `eglot--lookup-mode' falls back to a nil
;; contact, and `eglot--connect' then dies inside `jsonrpc-process-connection'
;; with "Wrong type argument: processp, nil", which `eglot-ensure' turns into
;; a warning once per buffer.  Only start Eglot where a server is configured.
(defun my/eglot-ensure-when-supported ()
  "Call `eglot-ensure' if MAJOR-MODE has a server program in `eglot-server-programs'."
  (when (cdr (eglot--lookup-mode major-mode))
    (eglot-ensure)))

(with-eval-after-load 'eglot
  (remove-hook 'prog-mode-hook 'eglot-ensure)
  (add-hook 'prog-mode-hook #'my/eglot-ensure-when-supported)
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

(setq eldoc-echo-area-use-multiline-p nil
      eldoc-echo-area-display-truncation-message nil)

(provide 'init-eglot)
