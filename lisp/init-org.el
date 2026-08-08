(require 'org)
(require 'ox-pandoc)
(require 'ox-gfm)

(setq org-imenu-depth 4
      org-ellipsis nil
      ;; org-ellipsis " ┑"
      org-startup-folded 'show2levels
      ;; org-startup-indented nil
      ;; org-indent-mode-turns-on-hiding-stars nil
      org-hide-leading-stars nil
      org-log-into-drawer t
      org-log-repeat nil            ; repeat 了多少次不重要，加了很丑
      ;; org-indent-mode-turns-on-hiding-stars nil
      org-fold-catch-invisible-edits 'smart
      org-link-descriptive t
      org-export-with-priority t
      org-tags-column 0
      org-footnote-auto-adjust t ; support auto renumber and sort footnote in
                                        ; org file
      )

(custom-set-faces
 '(org-document-title ((t (:height 1.1 :weight bold))))
 '(org-level-1 ((t (:height 1.05 :weight bold))))
 '(org-level-2 ((t (:height 1.05 :weight bold))))
 '(org-level-3 ((t (:height 1.05 :weight bold))))
 '(org-level-4 ((t (:height 1.05 :weight bold))))
 '(org-level-5 ((t (:height 1.05 :weight bold))))
 '(org-level-6 ((t (:height 1.05 :weight bold))))
 '(org-level-7 ((t (:height 1.05 :weight bold))))
 '(org-level-8 ((t (:height 1.05 :weight bold))))
 '(org-level-9 ((t (:height 1.05 :weight bold)))))

(add-hook 'org-mode-hook (lambda () (setq-local diff-hl-side 'right)))

(setq org-use-fast-todo-selection nil)

(setq org-archive-location "~/Documents/roam/archive/%s_archive::datetree/")

(setq org-agenda-include-diary nil)
(setq org-agenda-hide-tags-regexp
      "\\<\\(draft\\|todo\\)\\>")

(global-set-key (kbd "C-c a") 'org-agenda)
(setq org-agenda-span 'week
      org-agenda-window-setup 'reorganize-frame
      ;; org-agenda-compact-blocks nil
      )

;; ui
(customize-set-variable 'org-agenda-time-grid
                        '((today require-timed remove-match)
                          (0700 1200 2400)
                          ":  " "┈┈┈┈┈┈┈┈┈┈┈┈┈"))
(customize-set-variable 'org-agenda-current-time-string "ᐊ┈┈┈┈┈┈┈┈ now")

(setq org-agenda-files '((expand-file-name "~/Documents/roam/main/")))

(setq org-agenda-skip-scheduled-if-done nil
      org-agenda-skip-deadline-if-done nil
      org-agenda-skip-timestamp-if-done nil)

;; ??? what is this
(setq org-agenda-start-with-log-mode t)

(require 'org-super-agenda)
(org-super-agenda-mode 1)
(add-to-list
 'org-agenda-custom-commands
 '("d" "Daily Action"
   (
    (agenda ""
            ((org-agenda-overriding-header
              (concat "TODAY (W" (format-time-string "%V") ")"))
             (org-agenda-span 'day)
             (org-agenda-show-log t)
             (org-agenda-log-mode-items '(clock))
             ))
    (agenda ""
            ((org-agenda-overriding-header
              (concat "FOLLOWING DAYS (W" (format-time-string "%V") ")"))
             (org-agenda-span 6)
             (org-agenda-start-day "+1d")
             (org-agenda-start-on-weekday nil)))
    (alltodo ""
             ((org-agenda-overriding-header "ALL TODO ITEMS")
              (org-super-agenda-groups
               '(
                 (:name "Today"
                        :file-path "/Today.org")
                 (:name "Projects"
                        :file-path "/Projects.org")
                 (:name "Agenda"
                        :file-path "/Agenda.org")
                 (:name "Planning"
                        :file-path "/Planning.org")
                 (:name "Inbox"
                        :file-path "/Inbox.org")
                 (:auto-category t)
                 ))
              (org-agenda-sorting-strategy
               '(todo-state-up category-keep))
              (org-agenda-prefix-format '((todo . "%e %i %b %l %t %s")))
              (org-agenda-show-inherited-tags nil)
              ))
    )))

(define-key global-map (kbd "C-c n c") 'org-capture)

(setq org-capture-templates nil)

(defvar roam-main-dir (expand-file-name "main" (file-truename "~/Documents/roam/"))
  "Directory for roam files in main.")

(setq org-capture-templates
      `(
        ("i" "Inbox"
         entry (file ,(expand-file-name "Inbox.org" roam-main-dir))
         "* TODO %?")
        ("p" "Project"
         entry (file ,(expand-file-name "Projects.org" roam-main-dir))
         "* TODO %?")
        ("a" "Agenda"
         entry (file ,(expand-file-name "Agenda.org" roam-main-dir))
         "* TODO %?")
        ("j" "Journal"
         entry (file+olp+datetree ,(expand-file-name "Journal.org" roam-main-dir))
         "* %?"
         :tree-type week
         :empty-lines 1
         :jump-to-captured t)
        ))

(setq org-edit-src-content-indentation 0)

(with-eval-after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   (seq-filter
    (lambda (pair)
      (locate-library (concat "ob-" (symbol-name (car pair)))))
    '((emacs-lisp . t)
      (python . t)
      (shell . t)
      (C . t)
      (javascript . t)
      (go . t)
      (java . t)
      (scheme . t)
      (sqlite . t)
      (mermaid . t)
      ))))

(with-eval-after-load 'org
  (add-to-list 'org-src-lang-modes '("javascript" . js-ts) )
  (add-to-list 'org-src-lang-modes '("cpp" . c++-ts) )
  (add-to-list 'org-src-lang-modes '("C" . c-ts) )
  (add-to-list 'org-src-lang-modes '("sh" . bash-ts) )
  (add-to-list 'org-src-lang-modes '("python" . python-ts) )
  (add-to-list 'org-src-lang-modes '("css" . css-ts))
  (add-to-list 'org-src-lang-modes '("yaml" . yaml-ts))
  (add-to-list 'org-src-lang-modes '("java" . java-ts))
  (add-to-list 'org-src-lang-modes '("json" . json-ts)))

;; (with-eval-after-load 'org
;;   (add-to-list 'org-babel-default-header-args:python
;;                '(:results . "output")))

(setq org-confirm-babel-evaluate nil)

;; for python
(setq org-babel-python-command "python3")

(add-hook 'org-babel-after-execute-hook 'org-display-inline-images)

(setq org-structure-template-alist
      '(("a" . "src asm")
        ("c" . "src cpp")
        ("C" . "src C")
        ("e" . "src elisp")
        ("f" . "src fundamental")
        ("g" . "src go :imports '(\"fmt\")")
        ("h" . "src html")
        ("j" . "src json")
        ("J" . "src java")
        ("l" . "src lua")
        ("p" . "src python")
        ("P" . "src python :results file graphics :exports results :file ./img/plot.png")
        ("Q" . "src sqlite :colnames yes")
        ("r" . "src rust")
        ("s" . "src")
        ("S" . "src sh")
        ("t" . "src typescript")
        ("z" . "src zig")
        ))

(require 'org-appear)

(setq org-hide-emphasis-markers nil)
(setq org-appear-autolinks t)
(setq org-appear-autosubmarkers t)
(setq org-appear-autoentities t)
(setq org-appear-autokeywords t)
(setq org-appear-delay 0.5)

(add-hook 'org-mode-hook 'org-appear-mode)

(setq org-highlight-latex-and-related '(native latex entities)) ;; LaTeX 语法高亮设置
(setq org-pretty-entities t) ;; LaTeX 代码的 prettify
(setq org-pretty-entities-include-sub-superscripts nil) ;; 不隐藏 LaTeX 的上下标更容易编辑

(add-hook 'org-mode-hook 'org-cdlatex-mode)

;; org-cdlatex-mode 中使用 cdlatex 的自动匹配括号, 并把 $...$ 换成 \( ... \)
(defun my/insert-inline-parentheses ()
  (interactive)
  (insert "\\( ") ;; 把 "\\(" 和 "\\)" 替换成 "$" 就能实现输入成对 "$" 的功能.
  (save-excursion (insert " \\)" )))

(defun my/insert-inline-parentheses2 ()
  (interactive)
  (insert "\\(") ;; 把 "\\(" 和 "\\)" 替换成 "$" 就能实现输入成对 "$" 的功能.
  (save-excursion (insert "\\)" )))

(defun my/insert-square-bra-OCDL ()
  (interactive)
  (insert "\\[ ")
  (save-excursion (insert " \\]" )))

(defun my/insert-inline-braces ()
  (interactive)
  (insert "\\{ ")
  (save-excursion (insert " \\}" )))

(defun my/insert-number-regex ()
  (interactive)
  (insert "[0-9]"))

(define-key org-cdlatex-mode-map (kbd "C-M-9") 'my/insert-inline-parentheses)
(define-key global-map (kbd "C-M-9") 'my/insert-inline-parentheses2)
(define-key global-map (kbd "C-M-0") 'my/insert-number-regex)
(define-key org-cdlatex-mode-map (kbd "C-M-[") 'my/insert-square-bra-OCDL)
(define-key org-cdlatex-mode-map (kbd "C-M-{") 'my/insert-inline-braces)

;; preview with C-c C-x C-l

(setq my/latex-preview-scale 1.8) ;; 一般来说这里的 scale 约等于 set-face-attribute 中的 :height /100
(setq org-format-latex-options
      `(:foreground default :background default :scale ,my/latex-preview-scale :html-foreground "Black" :html-background "Transparent" :html-scale ,my/latex-preview-scale :matchers ("begin" "$1" "$" "$$" "\\(" "\\["))) ;; 增大公式预览的图片大小

(define-advice org-html-paragraph
    (:around (orig-fun paragraph contents info) org-html-paragraph-advice)
  "Join consecutive Chinese lines into a single long line without
unwanted space when exporting org-mode to html."
  (let* ((fix-regexp "[[:multibyte:]]")
         (fixed-contents
          (replace-regexp-in-string
           (concat
            "\\(" fix-regexp "\\) *\n *\\(" fix-regexp "\\)") "\\1\\2" contents)))
    (funcall orig-fun paragraph fixed-contents info)))


(define-advice org-gfm-paragraph
    (:around (orig-fun paragraph contents info) org-gfm-paragraph-advice)
  "Join consecutive Chinese lines into a single long line without
unwanted space when exporting org-mode to html."
  (let* ((fix-regexp "[[:multibyte:]]")
         (fixed-contents
          (replace-regexp-in-string
           (concat
            "\\(" fix-regexp "\\) *\n *\\(" fix-regexp "\\)") "\\1\\2" contents)))
    (funcall orig-fun paragraph fixed-contents info)))


(define-advice org-pandoc-paragraph
    (:around (orig-fun paragraph contents info) org-pandoc-paragraph-advice)
  "Join consecutive Chinese lines into a single long line without
unwanted space when exporting org-mode to html."
  (let* ((fix-regexp "[[:multibyte:]]")
         (fixed-contents
          (replace-regexp-in-string
           (concat
            "\\(" fix-regexp "\\) *\n *\\(" fix-regexp "\\)") "\\1\\2" contents)))
    (funcall orig-fun paragraph fixed-contents info)))

(provide 'init-org)
