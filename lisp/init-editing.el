;; -*- lexical-binding: t; -*-
;; 放置和编辑文字有关的命令

(require 'unfill)

(global-set-key (kbd "C-z") #'repeat)   ; stop C-z from suspending frame.
(global-set-key (kbd "M-Z") #'zap-up-to-char)
(global-set-key (kbd "C-x f") nil)      ; avoid changing column with accidently

;; Don't disable narrowing commands
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-defun 'disabled nil)
;; Don't disable case-change functions
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)


(require 'avy)
(defun my-call-with-input-method-off (command)
  "Temporarily disable current input method, then call COMMAND interactively."
  (let ((im current-input-method))
    (unwind-protect
        (progn
          (when im (deactivate-input-method))
          (call-interactively command))
      (when im (set-input-method im)))))

(defun my-avy-goto-char-2 ()
  (interactive)
  (my-call-with-input-method-off #'avy-goto-char-2))

(global-set-key (kbd "C-,") 'my-avy-goto-char-2)
(with-eval-after-load 'org-mode
  (define-key org-mode-map (kbd "C-,") nil))



(require 'sudo-edit)
(require 'wgrep)


(require 'symbol-overlay)
(global-set-key (kbd "M-i") 'symbol-overlay-put)
(global-set-key (kbd "C-c o s") 'symbol-overlay-mode)
(global-set-key (kbd "C-c o S") 'symbol-overlay-remove-all)
(define-key symbol-overlay-mode-map (kbd "M-i") 'symbol-overlay-put)
(define-key symbol-overlay-mode-map (kbd "M-I") 'symbol-overlay-remove-all)
(define-key symbol-overlay-mode-map (kbd "M-n") 'symbol-overlay-jump-next)
(define-key symbol-overlay-mode-map (kbd "M-p") 'symbol-overlay-jump-next)
;; (define-key symbol-overlay-map (kbd "M-n") 'symbol-overlay-switch-forward)
;; (define-key symbol-overlay-map (kbd "M-p") 'symbol-overlay-switch-backward)
(defun my/wgrep-safe-replace-all ()
  "在全 buffer 范围内替换当前 symbol-overlay 符号，跳过 wgrep 只读区域，
且在输入框中预填待替换的原始文本供修改。"
  (interactive)
  (let* (;; 1. 获取用于精确搜索的正则表达式（如 \<symbol\>）
         (symbol-regexp (symbol-overlay-get-symbol))
         ;; 2. 获取光标下纯粹的符号明文，不带正则边界
         (raw-symbol (thing-at-point 'symbol t))
         ;; 3. 提示输入新名称，并将 raw-symbol 作为初始内容填入输入框
         (replacement (read-string "Rename to: " raw-symbol)))
    (save-excursion
      (goto-char (point-min))
      (perform-replace symbol-regexp replacement nil t nil)
      )))
(with-eval-after-load 'wgrep
  (define-key symbol-overlay-map (kbd "R") #'my/wgrep-safe-replace-all))



(require 'multiple-cursors)
(global-set-key (kbd "C-c m l") #'mc/edit-lines)
(global-set-key (kbd "C-c m e") #'mc/edit-ends-of-lines)
(global-set-key (kbd "C-c m a") #'mc/edit-beginnings-of-lines)
(global-set-key (kbd "C-c m n") #'mc/mark-next-like-this)
(global-set-key (kbd "C-c m p") #'mc/mark-previous-like-this)
(global-set-key (kbd "C-c m h") #'mc/mark-all-like-this-dwim)


(require 'move-text)
(move-text-default-bindings)

(defun indent-region-advice (&rest ignored)
  (let ((deactivate deactivate-mark))
    (if (region-active-p)
        (indent-region (region-beginning) (region-end))
      (indent-region (line-beginning-position) (line-end-position)))
    (setq deactivate-mark deactivate)))

(advice-add 'move-text-up :after 'indent-region-advice)
(advice-add 'move-text-down :after 'indent-region-advice)


(require 'whole-line-or-region)
(whole-line-or-region-global-mode 1)
(diminish 'whole-line-or-region-local-mode)
(with-eval-after-load 'embark
  (cl-pushnew 'embark--mark-target
              (alist-get 'whole-line-or-region-delete-region
                         embark-around-action-hooks)))
(with-eval-after-load 'whole-line-or-region
  (define-key whole-line-or-region-local-mode-map [remap comment-dwim] nil))


(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)


(require 'visual-regexp)
(define-key global-map (kbd "C-c r") 'vr/replace)
(define-key global-map (kbd "C-c q") 'vr/query-replace)
;; to use visual-regexp-steroids's isearch instead of the built-in regexp isearch, also include the following lines:
(define-key esc-map (kbd "C-r") 'vr/isearch-backward) ;; C-M-r
(define-key esc-map (kbd "C-s") 'vr/isearch-forward) ;; C-M-s
;; if you use multiple-cursors, this is for you:
(with-eval-after-load 'visual-regexp
  (define-key global-map (kbd "C-c M") 'vr/mc-mark))


(require 'colorful-mode)
(setq global-colorful-mode t
      colorful-use-prefix t
      colorful-only-strings 'only-prog
      css-fontify-colors nil)
;; (add-to-list 'global-colorful-modes 'helpful-mode)


(require 'vundo)


(require 'highlight-parentheses)
;; highlight-parentheses 只会渲染设置的数量
;; 1. 显式使用 "unspecified"，告诉 Emacs 的 Overlay：
;; “我的前景色是透明的，请直接透出底层的 rainbow-delimiters 颜色”
(setq highlight-parentheses-colors '(unspecified unspecifieD))

;; 2. 指定背景色列表，仅提供两个颜色，插件因此只会高亮最近的两层
(setq highlight-parentheses-background-colors
      (list
       (face-attribute 'diff-refine-removed :background)
       (face-attribute 'diff-refine-added :background)))
(add-hook 'prog-mode-hook #'highlight-parentheses-mode)
(diminish 'highlight-parentheses-mode)



(require 'super-save)
(setq auto-save-default nil)
(setq super-save-auto-save-when-idle t
      super-save-idle-duration 5
      super-save-silent t
      super-save-remote-files nil
      super-save-delete-trailing-whitespace 'except-current-line)
(add-to-list 'super-save-triggers 'ace-window)
(add-to-list 'super-save-hook-triggers 'find-file-hook)
(super-save-mode +1)
(diminish 'super-save-mode)



(provide 'init-editing)
