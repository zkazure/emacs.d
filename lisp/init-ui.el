;; -*- lexical-binding: t; -*-
;; 放置一些简单的界面调节

;; Suppress GUI features
(setq use-file-dialog nil)
(setq use-dialog-box nil)

(setq inhibit-splash-screen t)

(setq frame-inhibit-implied-resize t)

(setq-default
 window-resize-pixelwise t
 frame-resize-pixelwise t)

(setq scroll-preserve-screen-position t
      scroll-margin 1
      scroll-conservatively 101
      auto-window-vscroll nil
      fast-but-imprecise-scrolling t
      )

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1) ((control) . nil))
      mouse-wheel-progressive-speed nil
      mouse-wheel-follow-mouse 't)

(when (fboundp 'pixel-scroll-precision-mode)
  (pixel-scroll-precision-mode 1))

;; avoid rendering cursor in other windows
(setq-default cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)

(add-hook 'after-init-hook 'show-paren-mode)

(when (fboundp 'electric-pair-mode)
  (add-hook 'after-init-hook 'electric-pair-mode))
(add-hook 'after-init-hook 'electric-indent-mode)

(when (fboundp 'display-line-numbers-mode)
  (setq-default display-line-numbers-width 3)
  (add-hook 'prog-mode-hook 'display-line-numbers-mode)
  (add-hook 'yaml-mode-hook 'display-line-numbers-mode)
  (add-hook 'yaml-ts-mode-hook 'display-line-numbers-mode)
  )

(when (boundp 'display-fill-column-indicator)
  (setq-default indicate-buffer-boundaries 'left)
  (setq-default display-fill-column-indicator-character ?┊)
  (add-hook 'prog-mode-hook 'display-fill-column-indicator-mode))

(global-hl-line-mode 1)
(setq hl-line-sticky-flag nil
      hl-line-overlay-priority -50)


(add-hook 'text-mode-hook
          (lambda () (progn (visual-line-mode 1)
                       (visual-wrap-prefix-mode 1))))
(setq word-wrap-by-category t)


(require 'breadcrumb)
(breadcrumb-mode 1)


(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)


(require 'jinx)
(add-hook 'emacs-startup-hook #'global-jinx-mode)
(diminish 'jinx-mode)
(add-to-list 'jinx-exclude-regexps '(t "\\cc")) ; 拼写检查忽略中文

(keymap-global-set "M-$" #'jinx-correct)
(keymap-global-set "C-M-$" #'jinx-languages)

(setq jinx-languages "en_GB en_US")



(require 'visual-fill-column)
(defun vfc/view-mode (width)
  "use visual-fill-column to enable a view mode"
  (interactive)
  (progn
    (setq-local visual-fill-column-width width
                visual-fill-column-center-text t)
    (visual-fill-column-mode 1)))




(require 'kirigami)
(global-set-key (kbd "M-o o") #'kirigami-open-fold)     ; Open fold at point
(global-set-key (kbd "M-o O") #'kirigami-open-fold-rec) ; Open fold recursively
(global-set-key (kbd "M-o r") #'kirigami-open-folds)    ; Open all folds
(global-set-key (kbd "M-o c") #'kirigami-close-fold)    ; Close fold at point
(global-set-key (kbd "M-o m") #'kirigami-close-folds)   ; Close all folds
(global-set-key (kbd "M-o a") #'kirigami-toggle-fold)   ; Toggle fold at point



(setq multibyte-syntax-as-symbol t)

(setq next-screen-context-lines 2)

(setq enable-recursive-minibuffers +1)
(setq cursor-in-non-selected-windows nil)




(load-theme 'modus-operandi)

(setq initial-frame-alist
      (append (list (cons 'font "Maple Mono NF CN-12"))
              initial-frame-alist))
(setq default-frame-alist
      (append (list (cons 'font "Maple Mono NF CN-12"))
              default-frame-alist))

(when (display-graphic-p)
  (set-frame-font "Maple Mono NF CN-12" t t))

(set-face-attribute 'variable-pitch nil
                    :family "Noto Serif"
                    :height 120
                    :weight 'regular)

(set-face-attribute 'mode-line-inactive nil :box nil)

(provide 'init-ui)
