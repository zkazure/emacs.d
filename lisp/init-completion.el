(require 'orderless)

(setq orderless-component-separator #'orderless-escapable-split-on-space
      completion-styles '(orderless flex)
      completion-category-defaults nil
      ;; completion-pcm-leading-wildcard t ; emacs 31
      )

(setq completion-category-overrides
      '((file    (styles orderless partial-completion basic))
        (buffer  (styles orderless))
        (eglot   (styles . (orderless basic)))
        ))

(require 'vertico)
(add-to-list 'load-path
             (expand-file-name "lib/vertico/extensions/" user-emacs-directory))
(require 'vertico-buffer)
(require 'vertico-directory)
(require 'vertico-flat)
(require 'vertico-grid)
(require 'vertico-indexed)
;; (require 'vertico-mouse)
(require 'vertico-multiform)
;; (require 'vertico-quick)
;; (require 'vertico-repeat)
;; (require 'vertico-reverse)
(require 'vertico-sort)
;; (require 'vertico-suspend)
;; (require 'vertico-posframe)

(vertico-mode)

(keymap-set vertico-map "RET" #'vertico-directory-enter)
(keymap-set vertico-map "DEL" #'vertico-directory-delete-char)
(keymap-set vertico-map "M-DEL" #'vertico-directory-delete-word)
(add-hook 'rfn-eshadow-update-overlay-hook #'vertico-directory-tidy)

(setq vertico-sort-function 'vertico-sort-history-length-alpha)

(vertico-multiform-mode)

(vertico-indexed-mode)

(require 'consult)

(with-eval-after-load 'consult
  (define-key global-map
              [remap isearch-forward] #'consult-line)
  (define-key global-map
              [remap Info-search] #'consult-info)
  (define-key global-map
              [remap recentf-open-files] #'consult-recent-file))

(global-set-key (kbd "C-c M-x") 'consult-mode-command)
(global-set-key (kbd "C-c h") 'consult-history)
(global-set-key (kbd "C-c K") 'consult-kmacro)
(global-set-key (kbd "C-c M") 'consult-man)
(global-set-key (kbd "C-c i") 'consult-info)
(global-set-key (kbd "C-x M-:") 'consult-complex-command)     ;; orig. repeat-complex-command
(global-set-key (kbd "C-x b") 'consult-buffer)                ;; orig. switch-to-buffer
(global-set-key (kbd "C-x 4 b") 'consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
(global-set-key (kbd "C-x 5 b") 'consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
(global-set-key (kbd "C-x t b") 'consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
(global-set-key (kbd "C-x r b") 'consult-bookmark)            ;; orig. bookmark-jump
(global-set-key (kbd "C-x p b") 'consult-project-buffer)      ;; orig. project-switch-to-buffer
(global-set-key (kbd "M-#") 'consult-register-load)
(global-set-key (kbd "M-'") 'consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
(global-set-key (kbd "C-M-#") 'consult-register)
(global-set-key (kbd "M-y") 'consult-yank-pop)                ;; orig. yank-pop
(global-set-key (kbd "M-g e") 'consult-compile-error)
(global-set-key (kbd "M-g r") 'consult-grep-match)
(global-set-key (kbd "M-g f") 'consult-flymake)               ;; Alternative: consult-flycheck
(global-set-key (kbd "M-g g") 'consult-goto-line)             ;; orig. goto-line
(global-set-key (kbd "M-g M-g") 'consult-goto-line)           ;; orig. goto-line
(global-set-key (kbd "M-g o") 'consult-outline)               ;; Alternative: consult-org-heading
(global-set-key (kbd "M-g m") 'consult-mark)
(global-set-key (kbd "M-g k") 'consult-global-mark)
(global-set-key (kbd "M-g i") 'consult-imenu)
(global-set-key (kbd "M-g I") 'consult-imenu-multi)
(global-set-key (kbd "M-s d") 'consult-find)                  ;; Alternative: consult-fd
(global-set-key (kbd "M-s c") 'consult-locate)
(global-set-key (kbd "M-s g") 'consult-grep)
(global-set-key (kbd "M-s G") 'consult-git-grep)
(global-set-key (kbd "M-s r") 'consult-ripgrep)
(global-set-key (kbd "M-s l") 'consult-line)
(global-set-key (kbd "M-s L") 'consult-line-multi)
(global-set-key (kbd "M-s k") 'consult-keep-lines)
(global-set-key (kbd "M-s u") 'consult-focus-lines)
(global-set-key (kbd "M-s e") 'consult-isearch-history)


(define-key isearch-mode-map (kbd "M-e") 'consult-isearch-history)         ;; orig. isearch-edit-string
(define-key isearch-mode-map (kbd "M-s e") 'consult-isearch-history)       ;; orig. isearch-edit-string
(define-key isearch-mode-map (kbd "M-s l") 'consult-line)                  ;; needed by consult-line to detect isearch
(define-key isearch-mode-map (kbd "M-s L") 'consult-line-multi)            ;; needed by consult-line to detect isearch

(define-key minibuffer-mode-map (kbd "M-s") 'consult-history)                 ;; orig. next-matching-history-element
(define-key minibuffer-mode-map (kbd "M-r") 'consult-history)                ;; orig. previous-matching-history-element

(add-hook 'completion-list-mode-hook #'consult-preview-at-point-mode)

(advice-add #'register-preview :override #'consult-register-window)
(setq register-preview-delay 0.5)

(setq xref-show-xrefs-function #'consult-xref
      xref-show-definitions-function #'consult-xref)

(consult-customize
 consult-theme :preview-key '(:debounce 0.2 any)
 consult-ripgrep consult-git-grep consult-grep consult-man
 consult-bookmark consult-recent-file consult-xref
 consult-source-bookmark consult-source-file-register
 consult-source-recent-file consult-source-project-recent-file
 ;; :preview-key "M-."
 :preview-key '(:debounce 0.4 any))

(setq consult-narrow-key "<") ;; "C-+"

;; yasnippet
(with-eval-after-load 'consult
  (require 'consult-yasnippet)
  (global-set-key (kbd "M-g y") #'consult-yasnippet))

(require 'embark)
(require 'embark-consult)

(global-set-key (kbd "C-.") #'embark-act)
(global-set-key (kbd "C-;") #'embark-dwim)

(add-hook 'embark-collect-mode-hook #'consult-preview-at-point-mode)

;; which-key for embark
(with-no-warnings
  (with-eval-after-load 'which-key
    (defun embark-which-key-indicator ()
      "An embark indicator that displays keymaps using which-key.
The which-key help message will show the type and value of the
current target followed by an ellipsis if there are further
targets."
      (lambda (&optional keymap targets prefix)
        (if (null keymap)
            (which-key--hide-popup-ignore-command)
          (which-key--show-keymap
           (if (eq (plist-get (car targets) :type) 'embark-become)
               "Become"
             (format "Act on %s '%s'%s"
                     (plist-get (car targets) :type)
                     (embark--truncate-target (plist-get (car targets) :target))
                     (if (cdr targets) "…" "")))
           (if prefix
               (pcase (lookup-key keymap prefix 'accept-default)
                 ((and (pred keymapp) km) km)
                 (_ (key-binding prefix 'accept-default)))
             keymap)
           nil nil t (lambda (binding)
                       (not (string-suffix-p "-argument" (cdr binding))))))))

    (setq embark-indicators
          '(embark-which-key-indicator
            embark-highlight-indicator
            embark-isearch-highlight-indicator))

    (defun embark-hide-which-key-indicator (fn &rest args)
      "Hide the which-key indicator immediately when using the completing-read prompter."
      (which-key--hide-popup-ignore-command)
      (let ((embark-indicators
             (remq #'embark-which-key-indicator embark-indicators)))
        (apply fn args)))

    (advice-add #'embark-completing-read-prompter
                :around #'embark-hide-which-key-indicator)))

(require 'corfu)
(add-to-list 'load-path
             (expand-file-name "lib/corfu/extensions/" user-emacs-directory))
;; (require 'corfu-echo)
(require 'corfu-history)
(require 'corfu-info)
(require 'corfu-popupinfo)

(setq tab-always-indent 'complete)
(setq completion-cycle-threshold 4)
(setq text-mode-ispell-word-completion nil)

(setq corfu-auto t
      corfu-auto-prefix 2
      corfu-count 10
      corfu-cycle t
      corfu-preview-current nil
      corfu-on-exact-match nil
      corfu-auto-delay 0.1
      corfu-popupinfo-delay '(0.8 . 0.4)
      corfu-quit-at-boundary t
      global-corfu-modes '((not erc-mode
                                circe-mode
                                help-mode
                                gud-mode)
                           t))

(setq-default corfu-quit-no-match 'separator)
(add-hook 'after-init-hook #'global-corfu-mode)

(with-eval-after-load 'corfu
  (corfu-popupinfo-mode)
  (corfu-history-mode))

;; nerd-icon for corfu
(require 'nerd-icons-corfu)
(with-eval-after-load 'corfu
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

;; (keymap-unset corfu-map "RET")

(require 'corfu-indexed)

(dotimes (i 10)
  (define-key corfu-map
              (kbd (format "M-%s" i))
              (kbd (format "C-%s RET" i))))

(with-eval-after-load 'corfu
  (corfu-indexed-mode)
  (define-key corfu-map [remap next-line] nil)
  (define-key corfu-map [remap previous-line] nil)
  (define-key corfu-map [remap beginning-of-line] nil)
  (define-key corfu-map [remap end-of-line] nil)
  )

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

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(c++-mode . ("clangd" "--header-insertion=never")))
  ;; (add-to-list 'eglot-server-programs
  ;;              '(c++-ts-mode . ("clangd" "--header-insertion=never")))
  (add-to-list 'eglot-server-programs
               '(c-mode . ("clangd" "--header-insertion=never")))
  ;; (add-to-list 'eglot-server-programs
  ;;              '(c-ts-mode . ("clangd" "--header-insertion=never")))
  (add-to-list 'eglot-server-programs
               '(python-mode . ("basedpyright-langserver")) t)
  (add-to-list 'eglot-server-programs
               '(python-ts-mode . ("basedpyright-langserver")) t)
  (add-to-list 'eglot-server-programs
               '(java-mode . ("/home/kazure/.emacs.d/.cache/lsp/eclipse.jdt.ls/bin/jdtls")))
  (add-to-list 'eglot-server-programs
               '(java-ts-mode . ("/home/kazure/.emacs.d/.cache/lsp/eclipse.jdt.ls/bin/jdtls")))
  (add-to-list 'eglot-server-programs
               '(scheme-mode . ("racket" "-l" "racket-langserver")))
  (add-to-list 'eglot-server-programs
               '(asm-mode . ("asm-lsp")))
  (add-to-list 'eglot-server-programs
               '(emacs-lisp-mode . ("ellsp")))
  )

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

;; ;; use .eglot-root as project root
;; (defun rc/find-root-for-eglot-for-clj
;;     (di)r
;;   (when (bound-and-true-p eglot-lsp-context)
;;     (let ((root (locate-dominating-file dir ".eglot-root")))
;; 	  (when root (cons 'transient root)))))
;; (add-hook 'project-find-functions #'rc/find-root-for-eglot-for-clj)

(provide 'init-eglot)

(require 'cape)
(add-to-list 'completion-at-point-functions #'cape-file)
(with-eval-after-load 'org
  (add-hook 'org-mode-hook
            (lambda ()
              (add-to-list 'completion-at-point-functions #'cape-dabbrev t))))

(provide 'init-completion)
