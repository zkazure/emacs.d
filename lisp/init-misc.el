;; -*- lexical-binding: t; -*-

(defun my-open-current-dir-in-thunar()
  (interactive)
  (let ((dir (expand-file-name default-directory)))
    (start-process "thunar" nil "thunar" dir)
    (message "open %s in Thunar" dir)))
(define-key global-map (kbd "C-c o F") 'my-open-current-dir-in-thunar)

(defun my/open-current-dir-in-default-terminal ()
  "Open the current directory in the system default terminal."
  (interactive)
  ;; 直接调用 x-terminal-emulator，它会自动继承 Emacs 当前的 default-directory
  (start-process "default-terminal-process" nil "x-terminal-emulator")
  (message "Opened default terminal in: %s" default-directory))
(global-set-key (kbd "C-c o T") 'my/open-current-dir-in-default-terminal)


(global-set-key (kbd "C-c o b d") 'epkg-describe-package)
(global-set-key (kbd "C-c o b a") 'borg-assimilate)
(global-set-key (kbd "C-c o b b") 'borg-build)
(global-set-key (kbd "C-c o b r") 'borg-remove)
(global-set-key (kbd "C-c o b c") 'borg-clone)



(require 'leetcode)
(setq leetcode-prefer-language "cpp"
      leetcode-save-solutions t
      leetcode-directory "~/Documents/cs_learning/OI/leetcode")
;; (setq leetcode-prefer-tag-display nil)
;; (global-set-key (kbd "C-c o c") 'leetcode)
(add-hook 'leetcode--problems-mode-hook
          (lambda () (display-line-numbers-mode -1)))
(add-hook 'leetcode--problem-detail-mode-hook
          (lambda () (display-line-numbers-mode -1)))



(require 'link-hint)
(global-set-key (kbd "C-c o l") 'link-hint-open-link)
(global-set-key (kbd "C-c o L") 'link-hint-copy-link)



(require 'gt)
(setq gt-langs '(en zh))
(setq gt-default-translator
      (gt-translator
       :taker   (gt-taker)  ; config the Taker
       :engines (gt-google-engine) ; specify the Engines
       :render  (gt-posframe-pop-render)))
(define-key global-map (kbd "C-c l") 'gt-translate)



(require 'olivetti)
(setq olivetti-style 'fancy
      olivetti-margin-width 5)
(add-hook 'olivetti-mode-hook
          (lambda ()
            (if olivetti-mode
                (progn
                  (when diff-hl-mode
                    (setq-local olivetti--diff-hl-was-on t)
                    (diff-hl-mode -1))
                  (when (boundp 'display-fill-column-indicator-mode)
                    (setq-local olivetti--fill-indicator-was-on t)
                    (display-fill-column-indicator-mode -1)))
              (progn
                (when (bound-and-true-p olivetti--diff-hl-was-on)
                  (diff-hl-mode 1)
                  (kill-local-variable 'olivetti--diff-hl-was-on))
                (when (bound-and-true-p olivetti--fill-indicator-was-on)
                  (display-fill-column-indicator-mode 1)
                  (kill-local-variable 'olivetti--fill-indicator-was-on))))))
(global-set-key (kbd "C-c o w") #'olivetti-mode)


(require 'atcoder-tools)


(require 'x86-lookup)
(setq x86-lookup-pdf "~/.emacs.d/x86-lookup/sdm.pdf")
(global-set-key (kbd "C-h x") #'x86-lookup)



;; speedbar in the same frame
(require 'sr-speedbar)
(setq sr-speedbar-width 30
      sr-speedbar-max-width 90
      sr-speedbar-right-side nil
      sr-speedbar-skip-other-window-p t
      speedbar-show-unknown-files t)
(global-set-key (kbd "C-c o d") #'sr-speedbar-toggle)
;; add nerd icon support
(require 'nerd-icons-speedbar)
(add-hook 'speedbar-mode-hook 'nerd-icons-speedbar-mode)



(require 'imenu-list)
(setq imenu-list-focus-after-activation nil
      imenu-list-auto-resize t
      imenu-list-size 0.16
      imenu-list-position 'left)
(global-set-key (kbd "C-c o i") #'imenu-list-smart-toggle)
(setq ediff-split-window-function #'split-window-horizontally
      ediff-keep-variants nil
      ediff-window-setup-function #'ediff-setup-windows-plain
      )



(require 'apheleia)
(add-to-list 'apheleia-mode-alist '(markdown-mode . nil))
(add-to-list 'apheleia-mode-alist '(org-mode . nil))
(setf (alist-get 'c-mode apheleia-mode-alist) '(clang-format))
(setf (alist-get 'c++-mode apheleia-mode-alist) '(clang-format))
(setf (alist-get 'python-mode apheleia-mode-alist) '(black))
(setf (alist-get 'go-mode apheleia-mode-alist) '(gofmt))
;; (setf (alist-get 'js-mode apheleia-mode-alist) '(prettier))
;; (setf (alist-get 'rust-mode apheleia-mode-alist) '(rustfmt))



(provide 'init-misc)
