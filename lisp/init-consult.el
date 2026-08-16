;; -*- lexical-binding: t; -*-

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

(provide 'init-consult)
