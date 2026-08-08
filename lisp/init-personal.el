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
  (pixel-scroll-precision-mode t)
  )

(global-set-key (kbd "C-c c C") 'compile)
(global-set-key (kbd "<f6>") 'recompile)
(global-set-key (kbd "C-c c g") 'gdb)

(add-hook 'c-ts-mode-hook
          (lambda () (setq-local compile-command
                                 (format "gcc -g %s" (buffer-name)))))
(add-hook 'c++-ts-mode-hook
          (lambda () (setq-local compile-command
                                 (format "g++ -g %s" (buffer-name)))))
(add-hook 'python-ts-mode-hook
          (lambda () (setq-local compile-command
                                 (format "python3 %s" (buffer-name)))))

(setq-default compilation-scroll-output t)
(add-hook 'compilation-filter-hook #'ansi-color-compilation-filter)

;; use to handle camel name
(global-subword-mode 1)

(require 'colorful-mode)

(setq global-colorful-mode t
      colorful-use-prefix t
      colorful-only-strings 'only-prog
      css-fontify-colors nil)

;; (add-to-list 'global-colorful-modes 'helpful-mode)

(require 'link-hint)

(global-set-key (kbd "C-c o l") 'link-hint-open-link)
(global-set-key (kbd "C-c o L") 'link-hint-copy-link)

(let ((my/minor-mode-alist '((flycheck-mode flycheck-mode-line))))
  (setq mode-line-modes
        (mapcar (lambda (elem)
                  (pcase elem
                    (`(:propertize (,_ minor-mode-alist . ,_) . ,_)
                     `(:propertize ("" ,my/minor-mode-alist)
			                       mouse-face mode-line-highlight
			                       local-map ,mode-line-minor-mode-keymap)
                     )
                    (_ elem)))
                mode-line-modes)
        ))
(setq-default mode-line-format
              '("%e" mode-line-front-space
                "["
                (ace-window-display-mode
                 (:propertize
                  (:eval (window-parameter (selected-window) 'ace-window-path))
                  face error))
                "] "
                (:propertize
                 (""
                  mode-line-mule-info
                  mode-line-client
                  mode-line-modified
                  mode-line-remote
                  mode-line-auto-compile
                  mode-line-window-dedicated)
                 display (min-width 6.0))
                mode-line-frame-identification
                mode-line-buffer-identification
                "   "
                mode-line-position
                (project-mode-line project-mode-line-format)

                mode-line-format-right-align
                (:eval (when (bound-and-true-p flymake-mode)
                         (list " "
                               flymake-mode-line-error-counter
                               flymake-mode-line-warning-counter
                               flymake-mode-line-note-counter
                               " ")))
                (:propertize
                 (:eval (when (stringp vc-mode)
                          (replace-regexp-in-string "^ \\w+[:-]" "" vc-mode)))
                 face success)

                "  "
                mode-line-modes
                mode-line-misc-info
                mode-line-end-spaces))

(set-face-attribute 'mode-line-inactive nil :box nil)

(require 'go-mode)
(autoload 'go-mode "go-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))

(setq make-backup-files nil)
(setq create-lockfiles nil)

(require 'rust-mode)
(autoload 'rust-mode "rust-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))
(add-hook 'rust-mode-hook #'lsp)

(require 'breadcrumb)
(breadcrumb-mode 1)

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

(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

;; er/mark-word
;; er/mark-symbol
;; er/mark-method-call
;; er/mark-inside-quotes
;; er/mark-outside-quotes
;; er/mark-inside-pairs
;; er/mark-outside-pairs

(require 'helpful)

;; Note that the built-in `describe-function' includes both functions
;; and macros. `helpful-function' is functions only, so we provide
;; `helpful-callable' as a drop-in replacement.
(global-set-key (kbd "C-h f") #'helpful-callable)

(global-set-key (kbd "C-h v") #'helpful-variable)
(global-set-key (kbd "C-h k") #'helpful-key)
(global-set-key (kbd "C-h x") #'helpful-command)

;; Lookup the current symbol at point. C-c C-d is a common keybinding
;; for this in lisp modes.
(global-set-key (kbd "C-c C-d") #'helpful-at-point)

;; Look up *F*unctions (excludes macros).
;;
;; By default, C-h F is bound to `Info-goto-emacs-command-node'. Helpful
;; already links to the manual, if a function is referenced there.
(global-set-key (kbd "C-h F") #'helpful-function)

(setq counsel-describe-function-function #'helpful-callable)
(setq counsel-describe-variable-function #'helpful-variable)

(require 'gt)
(setq gt-langs '(en zh))
(setq gt-default-translator
      (gt-translator
       :taker   (gt-taker)  ; config the Taker
       :engines (gt-google-engine) ; specify the Engines
       :render  (gt-posframe-pop-render)))

(define-key global-map (kbd "C-c l") 'gt-translate)

(global-set-key (kbd "C-c o b d") 'epkg-describe-package)
(global-set-key (kbd "C-c o b a") 'borg-assimilate)
(global-set-key (kbd "C-c o b b") 'borg-build)
(global-set-key (kbd "C-c o b r") 'borg-remove)
(global-set-key (kbd "C-c o b c") 'borg-clone)

(require 'apheleia)
(add-to-list 'apheleia-mode-alist '(markdown-mode . nil))
(add-to-list 'apheleia-mode-alist '(org-mode . nil))

(setf (alist-get 'c-mode apheleia-mode-alist) '(clang-format))
(setf (alist-get 'c++-mode apheleia-mode-alist) '(clang-format))
(setf (alist-get 'python-mode apheleia-mode-alist) '(black))
(setf (alist-get 'go-mode apheleia-mode-alist) '(gofmt))
;; (setf (alist-get 'js-mode apheleia-mode-alist) '(prettier))
;; (setf (alist-get 'rust-mode apheleia-mode-alist) '(rustfmt))

(require 'avy)
(define-key org-mode-map (kbd "C-,") nil)

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

(require 'org-count-words)
;; (add-hook 'org-mode-hook #'org-count-words-mode)
;; (setq org-count-words-mode-line-format
;;       '(" WC:%s"
;;         " WC:%s(R:%s)"))

(add-to-list 'auto-mode-alist '("\\.ts\\'"  . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'"  . js-ts-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . js-ts-mode))

;; web-mode
(require 'web-mode)

(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))

(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.css?\\'" . web-mode))


;; emmet-mode
(require 'emmet-mode)

(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.
(add-hook 'html-mode-hook  'emmet-mode) ;; enable html
(add-hook 'web-mode-hook 'emmet-mode)
(add-hook 'js-mode-hook 'emmet-mode)
(add-hook 'typescript-ts-mode-hook 'emmet-mode)
(add-hook 'js-ts-mode-hook 'emmet-mode)
(add-hook 'tsx-ts-mode-hook 'emmet-mode)

(add-to-list 'emmet-jsx-major-modes 'js-ts-mode)
(add-to-list 'emmet-jsx-major-modes 'tsx-ts-mode)

(setq emmet-self-closing-tag-style " /"
      emmet-move-cursor-between-quotes nil
      emmet-move-cursor-after-expanding t)


;; rename tag
(require 'highlight-matching-tag)
(require 'instant-rename-tag)

(with-eval-after-load 'web-mode
  (highlight-matching-tag 1)
  (define-key web-mode-map (kbd "C-<return>") 'instant-rename-tag)
  )


;; jsx comment
(require 'cl-lib)

(defun my/tsx--jsx-wrapped-p (s)
  (string-match-p
   (rx bos (* (any " \t"))
       "{/*" (* (any " \t"))
       (*? anything)
       (* (any " \t")) "*/}"
       (* (any " \t")) eos)
   s))

(defun my/tsx--unwrap-jsx (s)
  (replace-regexp-in-string
   (rx bos (* (any " \t"))
       "{/*" (* (any " \t"))
       (group (*? anything))
       (* (any " \t")) "*/}"
       (* (any " \t")) eos)
   "\\1"
   s))

(defun my/tsx--line-body-range ()
  "Return (BEG . END) for current line body excluding indentation.
If blank line, return nil."
  (save-excursion
    (let ((bol (line-beginning-position))
          (eol (line-end-position)))
      (goto-char bol)
      (back-to-indentation)
      (let ((beg (point)))
        (if (>= beg eol) nil (cons beg eol))))))

(defun my/tsx--split-trailing-ws (s)
  "Split S into (CORE . TRAIL) where TRAIL is trailing [ \\t]*."
  (if (string-match (rx bos (group (*? anything)) (group (* (any " \t"))) eos) s)
      (cons (match-string 1 s) (match-string 2 s))
    (cons s "")))

;; (defun my/tsx-toggle-jsx-comment-lines ()
;;   "Toggle JSX comments `{/* ... */}` linewise.

;; Range semantics:
;; - If region active: from line containing region-beginning to line containing
;;   region-end (inclusive), even if region-end is at BOL.
;; - Else: current line only.

;; Per line:
;; - Keep indentation outside wrapper: `    X` <-> `    {/* X */}`.

;; Uses an end marker so buffer growth won't truncate the loop."
;;   (interactive)
;;   (save-excursion
;;     (let* ((use-reg (use-region-p))
;;            (beg (if use-reg (region-beginning) (line-beginning-position)))
;;            (end (if use-reg (region-end)        (line-end-position))))
;;       (when (> beg end) (cl-rotatef beg end))

;;       (let* ((start (save-excursion (goto-char beg) (line-beginning-position)))
;;              ;; End boundary: EOL of the *end endpoint line*, as a marker.
;;              (end-marker (copy-marker
;;                           (save-excursion (goto-char end) (line-end-position))
;;                           t))
;;              (action nil)) ;; 'wrap or 'unwrap

;;         ;; 1) Decide action using first nonblank line body in range
;;         (goto-char start)
;;         (while (and (not action) (<= (point) (marker-position end-marker)))
;;           (let ((rng (my/tsx--line-body-range)))
;;             (when rng
;;               (let ((body (buffer-substring-no-properties (car rng) (cdr rng))))
;;                 (setq action (if (my/tsx--jsx-wrapped-p body) 'unwrap 'wrap)))))
;;           (forward-line 1))

;;         ;; 2) Apply action to each involved line
;;         (when action
;;           (goto-char start)
;;           (while (<= (point) (marker-position end-marker))
;;             (let ((rng (my/tsx--line-body-range)))
;;               (when rng
;;                 (let* ((lb (car rng))
;;                        (le (cdr rng))
;;                        (body (buffer-substring-no-properties lb le)))
;;                   ;; --- 修复开始 ---
;;                   ;; 必须先移动光标到缩进之后 (lb)，否则 insert 会插在行首 (缩进之前)
;;                   (goto-char lb)
;;                   ;; --- 修复结束 ---
;;                   (delete-region lb le)
;;                   (insert
;;                    (if (eq action 'unwrap)
;;                        (if (my/tsx--jsx-wrapped-p body) (my/tsx--unwrap-jsx body) body)
;;                      (if (my/tsx--jsx-wrapped-p body) body (concat "{/* " body " */}")))))))
;;             (forward-line 1)))

;;         (set-marker end-marker nil)))))

;; (with-eval-after-load 'js
;;   (define-key js-mode-map (kbd "C-M-;") #'my/tsx-toggle-jsx-comment-lines))
;; (with-eval-after-load 'typescript-ts-mode
;;   (define-key tsx-ts-mode-map (kbd "C-M-;") #'my/tsx-toggle-jsx-comment-lines))

(fset 'yes-or-no-p 'y-or-n-p)
(global-set-key (kbd "M-Z") #'zap-up-to-char)
(global-set-key (kbd "C-z") #'repeat)   ; suspend is annoying
(global-set-key (kbd "M-p") #'backward-paragraph)
(global-set-key (kbd "M-n") #'forward-paragraph)

(winner-mode 1)
(global-set-key (kbd "C-c w") 'winner-undo)

(setq word-wrap-by-category t)

(defun my/org-export-subtrees-to-gfm ()
  "Export all subtrees that have an EXPORT_FILE_NAME property to Markdown."
  (interactive)
  (require 'ox-pandoc) ; 确保加载了 markdown 导出后端

  (save-excursion
    (org-map-entries
     (lambda ()
       (let ((filename (org-entry-get (point) "EXPORT_FILE_NAME")))
         (when filename
           (org-pandoc-export-to-gfm nil t) ; 't' 参数表示只导出当前 Subtree
           (message "已导出: %s" filename))))
     "+EXPORT_FILE_NAME<>\"\"")))


(defun my/newline-after-punctuation ()
  "在光标前最近的标点符号后换行，但保持光标相对于文本的位置不变。"
  (interactive)
  (let ((punct-regexp "[，。；？！,.;?!]"))
    (save-excursion
      (if (re-search-backward punct-regexp nil t)
          (progn
            (forward-char 1)
            (newline-and-indent))
        (message "前面未找到标点符号")))))
(define-key org-mode-map (kbd "M-Q") #'my/newline-after-punctuation)

;; ansi color
(require 'ansi-color)
(add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)

;; if auto yas-indent will call indent-according-to-mode which use
;; indent-line-function to make indentation
;; and that function in makefile-mode is indent-to-left-margin
(add-hook 'makefile-mode-hook
          (lambda ()
            (setq-local yas-indent-line 'fixed)))

(setq-default history-length 1000)
(add-hook 'after-init-hook 'savehist-mode)

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

;; (with-eval-after-load 'magit
;;   (require 'forge))
(setq auth-source '("~/.authinfo.gpg"))

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
                                rime-predicate-after-alphabet-char-p
                                rime-predicate-punctuation-after-ascii-p
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

(require 'whole-line-or-region)
(whole-line-or-region-global-mode 1)
(with-eval-after-load 'embark
  (cl-pushnew 'embark--mark-target
              (alist-get 'whole-line-or-region-delete-region
                         embark-around-action-hooks)))
(with-eval-after-load 'whole-line-or-region
  (define-key whole-line-or-region-local-mode-map [remap comment-dwim] nil))

(require 'cmake-mode)

(require 'atcoder-tools)

(require 'mermaid-mode)
(require 'ob-mermaid)

(setenv "PUPPETEER_EXECUTABLE_PATH" "/usr/bin/chromium")
(setq mermaid-flags "-b transparent")
(setq mermaid-output-format ".png")

;; (setq asm-comment-char ?#)

(require 'x86-lookup)
(setq x86-lookup-pdf "~/.emacs.d/x86-lookup/sdm.pdf")
(global-set-key (kbd "C-h x") #'x86-lookup)

(require 'marginalia)
(require 'nerd-icons-completion)
(add-hook 'after-init-hook 'marginalia-mode)
(add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup)
(nerd-icons-completion-mode)

(require 'claude-code-ide)
(claude-code-ide-emacs-tools-setup)
(setq claude-code-ide-terminal-backend 'ghostel
      claude-code-ide-use-side-window nil
      claude-code-ide-no-flicker t
      claude-code-ide-window-width 80
      claude-code-ide-focus-claude-after-ediff t
      claude-code-ide-switch-tab-on-ediff nil
      claude-code-ide-show-claude-window-in-ediff t
      claude-code-ide-window-side 'left)

(global-set-key (kbd "C-c o c") 'claude-code-ide-menu)

(require 'gdscript-mode)
(require 'hydra)
(add-hook 'gdscript-mode-hook 'eglot-ensure)
(define-key gdscript-mode-map (kbd "C-c n") nil)
(define-key gdscript-mode-map (kbd "C-c r") nil)
(define-key gdscript-mode-map (kbd "C-c C-n") #'gdscript-debug-hydra)
(define-key gdscript-mode-map (kbd "C-c C-r") #'gdscript-hydra-show)

(require 'dumb-jump)
(setq dumb-jump-prefer-searcher 'rg
      xref-show-definitions-function #'consult-xref)
(add-hook 'xref-backend-functions #'dumb-jump-xref-activate)

(require 'rasi-mode)

(repeat-mode 1)
(define-key undo-repeat-map (kbd "U") 'undo-redo)
;; be able to C-SPC to keep jump back to last position
;; instead of C-u C-SPC every time
(setq set-mark-command-repeat-pop t)

(require 'wgrep)

(require 'lua-mode)

(require 'ghostel)
(require 'ghostel-ime)

(add-hook 'ghostel-mode-hook #'ghostel-ime-mode)
(global-set-key (kbd "C-c o t") #'ghostel)

(require 'matlab-mode)

(require 'popper)
(require 'popper-echo)

(global-set-key (kbd "C-`") #'popper-toggle)
(global-set-key (kbd "M-`") #'popper-cycle)
(global-set-key (kbd "C-M-`") #'popper-toggle-type)

(setq popper-reference-buffers
      '("^\\*ghostel\\*$"
        "\\*Messages\\*"
        ("Output\\*$" . hide)
        "\\*Async Shell Command\\*"
        ;; help-mode
        ;; compilation-mode
        ))

(setq popper-group-function #'popper-group-by-projectile)

(add-to-list 'display-buffer-alist
             '("^\\*ghostel\\*.*$"
               (display-buffer-reuse-window display-buffer-below-selected
                                            display-buffer-at-bottom)
               (window-height . 0.3)
               (reusable-frames . visible)))

(popper-mode +1)
(popper-tab-line-mode -1)
(popper-echo-mode +1)

(require 'kirigami)

(global-set-key (kbd "M-o o") #'kirigami-open-fold)     ; Open fold at point
(global-set-key (kbd "M-o O") #'kirigami-open-fold-rec) ; Open fold recursively
(global-set-key (kbd "M-o r") #'kirigami-open-folds)    ; Open all folds
(global-set-key (kbd "M-o c") #'kirigami-close-fold)    ; Close fold at point
(global-set-key (kbd "M-o m") #'kirigami-close-folds)   ; Close all folds
(global-set-key (kbd "M-o a") #'kirigami-toggle-fold)   ; Toggle fold at point

;; (setq-default search-invisible nil) ; 防止搜索到折叠的区域，从而自动展开

(require 'ox-hugo)

(defun my/org-roam-export-hugo-if-blog ()
  "如果当前 Org 文件包含 'blog' 标签且不包含 'draft' 标签，则在保存时自动导出为 Hugo Markdown。"
  (interactive)
  (when (derived-mode-p 'org-mode)
    (let* ((filetags-str (cadr (assoc "FILETAGS" (org-collect-keywords '("FILETAGS")))))
           (tags (if filetags-str (split-string filetags-str ":" t) nil)))

      (if (and (member "blog" tags)
               (not (member "draft" tags)))
          (progn
            (let ((org-hugo-base-dir (expand-file-name "~/Public/blog/"))
                  (org-hugo-section "post")
                  (org-hugo-auto-set-last-modified t))
              (message "正在将节点导出至 Hugo...")
              (org-hugo-export-wim-to-md)))
        (message "导出跳过：文件标签未包含 'blog'，或包含了 'draft'。")))))

(defun my/blog-publish ()
  "更新指定目录下的 blog"
  (interactive)
  (let* ((blog-dir (expand-file-name "~/Public/blog/"))
         (timestamp (format-time-string "%Y-%m-%d %H:%M:%S"))
         (git-command (format "git add --all ':!themes' && if git diff --cached --quiet; then echo '无变更，跳过'; exit 0; fi && git commit -m 'Auto-update: %s' && git push" timestamp)))

    (start-process-shell-command "blog_pushing" "*blog_pushing*"
                                 (format "cd %s && %s" (shell-quote-argument blog-dir) git-command))
    (message "后台发布进程已启动，请查看 *blog_pushing* buffer。")))

(define-key org-mode-map (kbd "C-c b e") #'my/org-roam-export-hugo-if-blog)
(define-key org-mode-map (kbd "C-c b p") #'my/blog-publish)

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

;; (add-hook 'imenu-list-update-hook
;;           (lambda ()
;;             (when-let ((win (get-buffer-window imenu-list-buffer-name)))
;;               (set-window-parameter win 'window-size-fixed 'width)
;;               (window-resize
;;                win
;;                (- (min (window-width win) 35)
;;                   (window-width win))
;;                t))))

(setq ediff-split-window-function #'split-window-horizontally
      ediff-keep-variants nil
      ediff-window-setup-function #'ediff-setup-windows-plain
      )

(require 'visual-fill-column)

(defun vfc/view-mode (width)
  "use visual-fill-column to enable a view mode"
  (interactive)
  (progn
    (setq-local visual-fill-column-width width
                visual-fill-column-center-text t)
    (visual-fill-column-mode 1)))

(require 'notmuch)

(setq notmuch-always-prompt-for-sender t)

(setq notmuch-saved-searches
      '((:name "inbox" :query "tag:inbox" :key "i" :search-type tree)
        (:name "unread" :query "tag:unread" :key "u" :search-type tree)
        (:name "flagged" :query "tag:flagged" :key "f" :search-type tree)
        (:name "sent" :query "tag:sent" :key "s" :search-type tree)
        ;; (:name "drafts" :query "tag:draft" :key "d" :search-type tree)
        (:name "org-mode-devel" :query "tag:org-mode-devel" :key "o" :search-type tree)
        (:name "list" :query "tag:list" :key "l" :search-type tree)
        (:name "all mail" :query "*" :key "a" :search-type tree)
        ))

(setq mail-user-agent 'notmuch-user-agent
      message-send-mail-function 'message-send-mail-with-sendmail
      sendmail-program "msmtp"
      message-sendmail-extra-arguments '("--read-envelope-from")
      message-sendmail-f-is-evil t)

(global-set-key (kbd "C-c o m") #'notmuch)

(add-hook 'notmuch-show-mode-hook
          (lambda ()
            (visual-line-mode 1)
            (face-remap-add-relative 'default
                                     :height 1.4)
            (setq-local visual-fill-column-center-text t
                        visual-fill-column-width 100)
            (visual-fill-column-mode 1)))

(require 'org-transclusion)

;; (define-key global-map (kbd "<f12>") #'org-transclusion-add)
(define-key global-map (kbd "C-c t m") #'org-transclusion-transient-menu)
(define-key global-map (kbd "C-c t t") #'org-transclusion-mode)

(setq tramp-default-method "scp"
      vc-ignore-dir-regexp (format "\\(%s\\)\\|\\(%s\\)"
                                   vc-ignore-dir-regexp
                                   tramp-file-name-regexp)
      remote-file-name-inhibit-locks t)

(require 'cl-lib)
(require 'unfill)

(defun my/semantic-fill-paragraph ()
  "调用 unfill-paragraph 清理排版，随后在句尾标点处进行语义换行。"
  (interactive)
  (save-excursion
    ;; 确保先清空多余换行符
    (unfill-paragraph)

    (forward-paragraph)
    (let ((end (set-marker (make-marker) (point)))
          (beg (progn (backward-paragraph) (point)))
          ;; 关闭英文双空格限制
          (sentence-end-double-space nil))
      (goto-char beg)
      (while (< (point) end)
        (let ((prev-point (point)))
          (forward-sentence 1)
          (skip-chars-backward " \t")
          (if (<= (point) prev-point)
              (goto-char end)
            (when (< (point) end)
              (delete-horizontal-space)
              (insert "\n")))))
      (set-marker end nil))))

(defvar my/fill-paragraph-state nil
  "The way the paragraph was filled the last time.")

(defun my/fill-paragraph-rotate ()
  "按顺序切换段落排版方式：语义换行 -> unfill -> 传统 fill。"
  (interactive)
  ;; 检查是否连续按键。如果不是（比如按了方向键再回来），则重置状态。
  (unless (eq last-command this-command)
    (setq my/fill-paragraph-state nil))

  (let (deactivate-mark)
    (cl-case my/fill-paragraph-state
      ;; 状态 A：刚进行过语义换行 -> 切换到合并单行
      (semantic
       (call-interactively 'unfill-paragraph)
       (setq my/fill-paragraph-state 'unfill))

      ;; 状态 B：刚被合并为单行 -> 切换到传统的基于列宽排版
      (unfill
       (call-interactively 'fill-paragraph)
       (setq my/fill-paragraph-state 'fill))

      ;; 状态 C（默认状态）：其他情况 -> 优先执行语义换行
      (t
       (call-interactively 'my/semantic-fill-paragraph)
       (setq my/fill-paragraph-state 'semantic)))))

(global-set-key (kbd "M-q") #'my/fill-paragraph-rotate)

(require 'multiple-cursors)

(global-set-key (kbd "C-c m l") #'mc/edit-lines)
(global-set-key (kbd "C-c m e") #'mc/edit-ends-of-lines)
(global-set-key (kbd "C-c m a") #'mc/edit-beginnings-of-lines)
(global-set-key (kbd "C-c m n") #'mc/mark-next-like-this)
(global-set-key (kbd "C-c m p") #'mc/mark-previous-like-this)
(global-set-key (kbd "C-c m h") #'mc/mark-all-like-this-dwim)

;; (mc/mark-all-like-this)
;; (mc/mark-all-words-like-this)
;; (mc/mark-all-symbols-like-this)
;; (mc/mark-all-in-region)
;; (mc/mark-all-like-this-in-defun)
;; (mc/mark-all-words-like-this-in-defun)
;; (mc/mark-all-symbols-like-this-in-defun)
;; (mc/mark-all-dwim)

;; (mc/mark-next-like-this)
;; (mc/mark-next-like-this-word)
;; (mc/mark-next-word-like-this)
;; (mc/mark-next-like-this-symbol)
;; (mc/mark-next-symbol-like-this)

;; (mc/mark-previous-like-this)
;; (mc/mark-previous-like-this-word)
;; (mc/mark-previous-word-like-this)
;; (mc/mark-previous-like-this-symbol)
;; (mc/mark-previous-symbol-like-this)

;; (mc/mark-more-like-this-extended)
;; (mc/add-cursor-on-click)
;; (mc/mark-pop)

;; (mc/unmark-next-like-this)
;; (mc/unmark-previous-like-this)
;; (mc/skip-to-next-like-this)
;; (mc/skip-to-previous-like-this)

;; (set-rectangular-region-anchor)
;; (mc/mark-sgml-tag-pair)
;; (mc/insert-numbers)
;; (mc/insert-letters)
;; (mc/reverse-regions)
;; (mc/vertical-align)
;; (mc/vertical-align-with-space)

;; if you use multiple-cursors, this is for you:
(with-eval-after-load 'visual-regexp
  (define-key global-map (kbd "C-c M") 'vr/mc-mark))

(require 'elfeed)
(require 'elfeed-org)

(elfeed-org)
(setq rmh-elfeed-org-files (list "~/.emacs.d/elfeed.org"))

;; (global-set-key (kbd "C-c o e") 'elfeed)

(add-hook 'elfeed-show-mode-hook 'olivetti-mode)
(add-hook 'elfeed-search-mode-hook 'olivetti-mode)

(with-eval-after-load 'god-mode
  (add-to-list 'god-exempt-major-modes 'elfeed-search-mode)
  (add-to-list 'god-exempt-major-modes 'elfeed-show-mode)
  )

(require 'change-inner)
(global-set-key (kbd "C-c c i") #'change-inner)
(global-set-key (kbd "C-c c o") #'change-outer)

(with-eval-after-load 'god-mode
  (define-key god-local-mode-map (kbd "c") nil)
  (define-key god-local-mode-map (kbd "c i")
              (lambda () (interactive)
                (call-interactively #'change-inner)
                (god-local-mode -1)
                ))
  (define-key god-local-mode-map (kbd "c o")
              (lambda () (interactive)
                (call-interactively #'change-outer)
                (god-local-mode -1)
                )))

(require 'ebib)
(global-set-key (kbd "C-c o e") 'ebib)
;; citekey formula: auth.lower + year + shorttitle(2,2).lower
(setq ebib-bibtex-dialect 'biblatex
      ebib-preload-bib-files '("~/Documents/roam/references.bib")
      ebib-notes-directory "~/Documents/roam/reference/"
      ebib-file-search-dirs '("~/Documents/zotero/"))

(setq god-mode-enable-function-key-translation nil)
(require 'god-mode)
(god-mode)

;; (setq god-mode-alist
;;       '((nil . "C-")
;;         ("g" . "M-")
;;         ("G" . "C-M-")))

(dolist (mode '(notmuch-hello-mode
                notmuch-search-mode
                notmuch-show-mode
                notmuch-tree-mode
                notmuch-message-mode
                ghostel-mode
                ebib-log-mode
                ebib-index-mode
                ebib-entry-mode
                ;; dired-mode
                ;; magit-mode
                ))
  (add-to-list 'god-exempt-major-modes mode))

(define-key org-mode-map (kbd "C-'") nil)
(global-set-key (kbd "C-'") #'god-local-mode)
(global-set-key (kbd "C-'") #'god-local-mode)
(define-key god-local-mode-map (kbd "i") #'god-local-mode)
(define-key god-local-mode-map (kbd "g") #'keyboard-quit)


;; surround
(with-eval-after-load 'god-mode
  (defun my/god-mode-wrap-or-translate ()
    "当存在活跃选区时，调用原生 self-insert-command 触发包围；否则走 god-mode 默认转换。"
    (interactive)
    (if (use-region-p)
        ;; 核心技巧：通过 let 临时禁用 god-local-mode，
        ;; 使 god-mode-map 里的 <remap> 暂时失效，从而安全调用原生的 self-insert-command
        (let ((god-local-mode nil))
          (call-interactively #'self-insert-command))
      ;; 无选区时，将按键交还给 god-mode 去解析（例如把 ( 解析为 C-( ）
      (call-interactively #'god-mode-self-insert)))

  ;; 将需要触发包围的符号绑定到自定义命令上
  (dolist (key '("\"" "<" ">" "(" ")" "[" "]" "{" "}"))
    (define-key god-local-mode-map (kbd key) #'my/god-mode-wrap-or-translate)))


;; indicator
(custom-set-faces
 '(god-mode-lighter ((t (:inherit error)))))
(defun my-god-mode-update-cursor-type ()
  (setq cursor-type (if (or god-local-mode buffer-read-only) 'box 'bar)))
(add-hook 'post-command-hook #'my-god-mode-update-cursor-type)


;; work with emasc-rime
(defvar-local my/god-prev-input-method nil)

(defun my/god-enter-command-state ()
  "进入命令态（god-mode）时：提交/取消候选并关闭输入法。"
  (setq my/god-prev-input-method current-input-method)
  ;; 若 rime 正在预编辑，尽量先结束它（有就调用，没有就跳过）
  (when (fboundp 'rime-commit) (ignore-errors (rime-commit)))
  (when (fboundp 'rime-abort)  (ignore-errors (rime-abort)))
  (deactivate-input-method))

(defun my/god-leave-command-state ()
  "退出命令态时：如果之前开着 rime，则恢复。"
  (when (and my/god-prev-input-method
             (stringp my/god-prev-input-method))
    (activate-input-method my/god-prev-input-method)))

(with-eval-after-load 'god-mode
  (add-hook 'god-mode-enabled-hook  #'my/god-enter-command-state)
  (add-hook 'god-mode-disabled-hook #'my/god-leave-command-state))

(require 'citar)

;; basic
(setq citar-bibliography '("~/Documents/roam/references.bib"))
(global-set-key (kbd "C-c n o") #'citar-open)

;; citar-capf
(add-hook 'LaTeX-mode-hook #'citar-capf-setup)
(add-hook 'org-mode-hook #'citar-capf-setup)

;; embark
(citar-embark-mode 1)

;; org-cite
(setq org-cite-global-bibliography '("~/Documents/roam/references.bib")
      org-cite-insert-processor 'citar
      org-cite-follow-processor 'citar
      org-cite-activate-processor 'citar
      citar-bibliography org-cite-global-bibliography)

;; templates
(setq citar-templates
      '((main . "${author editor:30%sn}     ${date year issued:4}     ${title:48}")
        (suffix . "          ${=key= id:15}    ${=type=:12}    ${tags keywords:*}")
        (preview . "${author editor:%etal} (${year issued date}) ${title}, ${journal journaltitle publisher container-title collection-title}.\n")
        (note . "Notes on ${author editor:%etal}, ${title}")))

;; indicators
(defvar citar-indicator-notes-icons
  (citar-indicator-create
   :symbol (nerd-icons-mdicon
            "nf-md-notebook"
            :face 'nerd-icons-blue
            :v-adjust -0.3)
   :function #'citar-has-notes
   :padding "  "
   :tag "has:notes"))

(defvar citar-indicator-links-icons
  (citar-indicator-create
   :symbol (nerd-icons-octicon
            "nf-oct-link"
            :face 'nerd-icons-orange
            :v-adjust -0.1)
   :function #'citar-has-links
   :padding "  "
   :tag "has:links"))

(defvar citar-indicator-files-icons
  (citar-indicator-create
   :symbol (nerd-icons-faicon
            "nf-fa-file"
            :face 'nerd-icons-green
            :v-adjust -0.1)
   :function #'citar-has-files
   :padding "  "
   :tag "has:files"))

(setq citar-indicators
      (list citar-indicator-files-icons
            citar-indicator-notes-icons
            citar-indicator-links-icons))

(require 'citar-org-roam)

(citar-org-roam-mode 1)

;; use filename renamed by Zotero as title.
(setq citar-org-roam-note-title-template "${file}")
(defun kazure/citar-clean-title (&rest _args)
  "Clean title generated by citar."
  (when (derived-mode-p 'org-mode)
    (save-excursion
      (goto-char (point-min))
      (when (re-search-forward "^#\\+TITLE: \\(.+\\)$" nil t)
        (let ((title (match-string 1)))
          (when (string-match-p "\\.\\(pdf\\|epub\\)$" title)
            (replace-match
             (concat "#+TITLE: "
                     (file-name-base
                      (file-name-nondirectory title))))))))))
(advice-add 'citar-create-note
            :after
            #'kazure/citar-clean-title)


(add-to-list 'org-roam-capture-templates
             '("r" "reference" plain "%?"
               :target
               (file+head
                "reference/${citar-citekey}.org"

                "#+TITLE: ${note-title}\n#+CREATED: %U\n#+LAST_MODIFIED: %U\n#+FILETAGS:\n\n* Abstract\n* Introduction\n* Method\n* Limitation\n\n"
                )
               :unnarrowed t))

(setq citar-org-roam-capture-template-key "r")

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

;; deeper color
;; (setq highlight-parentheses-background-colors
;;       (list
;;        (face-attribute 'diff-hl-reference-insert :background)
;;        (face-attribute 'diff-hl-reference-delete :background)))

(add-hook 'prog-mode-hook #'highlight-parentheses-mode)

(global-set-key (kbd "C-x f") nil)      ; avoid changing column with accidently

(setq gdb-many-windows t)
(setq gdb-show-main t)
(setq gdb-non-stop-setting nil)

(setq window-combination-resize t)

(require 'pangu-spacing)
(global-set-key (kbd "C-c o p") #'pangu-spacing-mode)

(setq-default show-trailing-whitespace nil)

(defun zkazure/show-trailing-whitespace ()
  (setq-local show-trailing-whitespace t))
(add-hook 'prog-mode-hook #'zkazure/show-trailing-whitespace)

(defun sanityinc/newline-at-end-of-line ()
  "Move to end of line, enter a newline, and reindent."
  (interactive)
  (move-end-of-line 1)
  (newline-and-indent))
(global-set-key (kbd "S-<return>") #'sanityinc/newline-at-end-of-line)


;; Don't disable narrowing commands
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-defun 'disabled nil)
;; Don't disable case-change functions
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(provide 'init-personal)
