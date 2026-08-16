;; -*- lexical-binding: t; -*-

(require 'pyim)
(setq pyim-cloudim nil)
(setq pyim-candidates-search-buffer-p nil)
(setq pyim-enable-shortcode nil)

(setq pyim-default-scheme 'ziranma-shuangpin
      pyim-page-tooltip 'minibuffer
      pyim-page-style 'one-line)
(setq-default pyim-punctuation-translate-p '(auto))

(with-eval-after-load 'avy
  (defun my-avy--regex-candidates (fun regex &optional beg end pred group)
    (let ((regex (pyim-cregexp-build regex)))
      (funcall fun regex beg end pred group)))
  (advice-add 'avy--regex-candidates :around #'my-avy--regex-candidates))

(with-eval-after-load 'orderless
  (defun my-orderless-regexp (orig-func component)
    (let ((result (funcall orig-func component)))
      (pyim-cregexp-build result)))
  (advice-add 'orderless-regexp :around #'my-orderless-regexp))

(require 'rime)

(setq rime-translate-keybindings
      '("C-n" "C-p" "C-g" "shift"))
;; (setq rime-user-data-dir "~/.emacs.d/rime/")
(setq rime-user-data-dir (expand-file-name "~/.config/rime/rime-moran/"))

(setq default-input-method "rime"
      rime-show-candidate 'posframe
      rime-posframe-style 'vertical
      rime-show-preedit 'inline
      ;; rime-posframe-fixed-position nil
      rime-disable-predicates '(
                                ;; rime-predicate-prog-in-code-p
                                ;; rime-predicate-after-alphabet-char-p
                                ;; rime-predicate-punctuation-after-ascii-p
                                rime-predicate-punctuation-line-begin-p
                                ;; rime-predicate-space-after-cc-p ; 感觉有些困扰
                                rime-predicate-current-uppercase-letter-p
                                rime-predicate-tex-math-or-command-p
                                ))

(setq rime-posframe-properties
      (list
       :internal-border-width 2
       ;; :background-color "#1e1e2e"
       ;; :foreground-color "#cdd6f4"
       ))


(with-eval-after-load 'rime
  (face-spec-reset-face 'rime-default-face)
  (face-spec-reset-face 'rime-candidate-num-face)
  (face-spec-reset-face 'rime-code-face)
  (face-spec-reset-face 'rime-comment-face)
  (face-spec-reset-face 'rime-cursor-face))


(provide 'init-ime)
