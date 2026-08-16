;; -*- lexical-binding: t; -*-



;;; Org
(require 'org)
(require 'ox-pandoc)
(require 'ox-gfm)

(setq org-directory (expand-file-name "~/Documents/roam/"))
(defvar org-main-directory
  (list (expand-file-name "main/" org-directory))
  "Directory for org files in main.")

(setq org-imenu-depth 4
      org-ellipsis nil
      ;; org-ellipsis " ┑"
      org-startup-folded 'show2levels
      org-startup-indented t
      org-indent-mode-turns-on-hiding-stars nil
      org-hide-leading-stars nil
      org-log-into-drawer t
      org-log-repeat nil            ; repeat 了多少次不重要，加了很丑
      org-fold-catch-invisible-edits 'smart
      org-link-descriptive t
      org-export-with-priority t
      org-tags-column 0
      org-footnote-auto-adjust t ; support auto renumber and sort footnote in
                                        ; org file
      org-use-fast-todo-selection nil
      org-edit-src-content-indentation 0
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

(require 'org-count-words)
;; (add-hook 'org-mode-hook #'org-count-words-mode)
;; (setq org-count-words-mode-line-format
;;       '(" WC:%s"
;;         " WC:%s(R:%s)"))


(require 'org-appear)
(setq org-hide-emphasis-markers nil
      org-appear-autolinks t
      org-appear-autosubmarkers t
      org-appear-autoentities t
      org-appear-autokeywords t
      org-appear-delay 0.5)
(add-hook 'org-mode-hook 'org-appear-mode)


;;; Archive
(setq org-archive-location
      (expand-file-name
       (concat org-directory "archive/%s_archive::datetree/")))



;;; Agenda
(global-set-key (kbd "C-c a") 'org-agenda)
(setq org-agenda-files org-main-directory)

(setq org-agenda-include-diary nil)
(setq org-agenda-hide-tags-regexp
      "\\<\\(draft\\|todo\\)\\>")
(setq org-agenda-start-with-log-mode t)

(setq org-agenda-skip-scheduled-if-done nil
      org-agenda-skip-deadline-if-done nil
      org-agenda-skip-timestamp-if-done nil)

(setq org-agenda-span 'week
      org-agenda-window-setup 'reorganize-frame
      ;; org-agenda-compact-blocks nil
      )

(customize-set-variable 'org-agenda-time-grid
                        '((today require-timed remove-match)
                          (0700 1200 2400)
                          ":  " "┈┈┈┈┈┈┈┈┈┈┈┈┈"))
(customize-set-variable 'org-agenda-current-time-string "ᐊ┈┈┈┈┈┈┈┈ now")


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



;;; Capture
(define-key global-map (kbd "C-c n c") 'org-capture)

(setq org-capture-templates nil)

(setq org-capture-templates
      `(
        ("i" "Inbox"
         entry (file ,(expand-file-name "Inbox.org" org-main-directory))
         "* TODO %?")
        ("p" "Project"
         entry (file ,(expand-file-name "Projects.org" org-main-directory))
         "* TODO %?")
        ("a" "Agenda"
         entry (file ,(expand-file-name "Agenda.org" org-main-directory))
         "* TODO %?")
        ("j" "Journal"
         entry (file+olp+datetree ,(expand-file-name "Journal.org" org-main-directory))
         "* %?"
         :tree-type week
         :empty-lines 1
         :jump-to-captured t)
        ))



;;; Babel
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



;;; Roam
(setq org-roam-directory org-directory)
(defvar org-roam-main-directory org-main-directory
  "Directory for roam files in main.")

(require 'org-roam)
(add-to-list 'load-path
             (expand-file-name "lib/org-roam/extensions/" user-emacs-directory))
;; (require 'org-roam-dailies)
(require 'org-roam-export)
(require 'org-roam-graph)
(require 'org-roam-overlay)
(require 'org-roam-protocol)

(setq org-roam-db-gc-threshold most-positive-fixnum)
(setq org-roam-complete-everywhere t)

(define-key global-map (kbd "C-c n l") 'org-roam-buffer-toggle)
(define-key global-map (kbd "C-c n f") 'org-roam-node-find)
(define-key global-map (kbd "C-c n g") 'org-roam-graph)
(define-key global-map (kbd "C-c n i") 'org-roam-node-insert)
(define-key global-map (kbd "C-c n t") 'org-roam-tag-add)
;; (define-key global-map (kbd "C-c n c") 'org-roam-capture)
;; (define-key global-map (kbd "C-c n d") 'org-roam-dailies-map)
;; (define-key global-map (kbd "C-c n j") 'org-roam-dailies-capture-today)
(define-key org-mode-map (kbd "C-c n n") 'org-id-get-create)
(define-key global-map (kbd "C-c n r") 'org-roam-node-random)
(define-key global-map (kbd "C-c n a") 'org-roam-alias-add)

(org-roam-db-autosync-mode 1)

(cl-defmethod org-roam-node-type ((node org-roam-node))
  "Return the TYPE of NODE."
  (condition-case nil
      (file-name-nondirectory
       (directory-file-name
        (file-name-directory
         (file-relative-name (org-roam-node-file node) org-roam-directory))))
    (error "")))

(setq org-roam-node-display-template
      (concat "${type:15} ${title:*} " (propertize "${tags:20}" 'face 'org-tag)))

(defun jethro/tag-new-node-as-draft ()
  (org-roam-tag-add '("draft")))
(add-hook 'org-roam-capture-new-node-hook #'jethro/tag-new-node-as-draft)

(setq org-roam-capture-templates
      '(
        ;; ("g" "Game" plain "%?"
        ;;  :if-new (file+head "game/%<%Y%m%d%H%M%S>-${title}.org"
        ;;                     "#+title: ${title}\n#+filetags:\n")`
	    ;;  :immediate-finish t
	    ;;  :unnarrowed t)
        ("m" "Main" plain  "%?"
         :if-new
         (file+head "main/${title}.org"
                    "#+TITLE: ${title}\n#+CREATED: %U\n#+FILETAGS: \n* Main\n")
         :immediate-finish t
         :unnarrowed t)
        ("c" "Coding" plain "%?"
         :if-new
         (file+head "coding/${title}.org"
                    "#+TITLE: ${title}\n#+CREATED: %U\n#+FILETAGS: \n* Main\n")
         :immediate-finish t
         :unnarrowed t)
        ("i" "Idea" plain "%?"
         :if-new
         (file+head "idea/${title}.org"
                    "#+TITLE: ${title}\n#+CREATED: %U\n#+FILETAGS: \n* Main\n")
         :immediate-finish t
         :unnarrowed t)
        ("R" "Reading" plain "%?"
         :if-new
         (file+head "reading/${title}.org"
                    "#+TITLE: ${title}\n#+CREATED: %U\n#+FILETAGS: \n* Main\n")
         :immediate-finish t
         :unnarrowed t)
        ("w" "Web" plain "%?"
         :if-new
         (file+head "web/${title}.org"
                    "#+TITLE: ${title}\n#+CREATED: %U\n#+FILETAGS: \n* Main\n")
         :immediate-finish t
         :unnarrowed t)
        ("s" "Stem" plain "%?"
         :if-new
         (file+head "stem/${title}.org"
                    "#+TITLE: ${title}\n#+CREATED: %U\n#+FILETAGS: \n* Main\n")
         :immediate-finish t
         :unnarrowed t)
        ("M" "Misc" plain "%?"
         :if-new
         (file+head "misc/${title}.org"
                    "#+TITLE: ${title}\n#+CREATED: %U\n* Main\n")
         :immediate-finish t
         :unnarrowed t)
        ))

;; (setq org-roam-dailies-capture-templates
;;       '(("d" "default" entry "* %<%I:%M %p>: %?"
;;          :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n#+filetags: :diary:draft:\n\n* Main\n"))))

(defun vulpea-todo-p ()
  "Return non-nil if current buffer has any todo entry.
  TODO entries marked as done are ignored, meaning the this
  function returns nil if current buffer contains only completed
  tasks."
  (seq-find                                 ; (3)
   (lambda (type)
     (eq type 'todo))
   (org-element-map                         ; (2)
       (org-element-parse-buffer 'headline) ; (1)
       'headline
     (lambda (h)
       (org-element-property :todo-type h)))))

(defun vulpea-todo-update-tag ()
  "Update TODO tag in the current buffer."
  (when (and (not (active-minibuffer-window))
             (vulpea-buffer-p))
    (save-excursion
      (goto-char (point-min))
      (let* ((tags (vulpea-buffer-tags-get))
             (original-tags tags))
        (if (vulpea-todo-p)
            (setq tags (cons "todo" tags))
          (setq tags (remove "todo" tags)))

        ;; cleanup duplicates
        (setq tags (seq-uniq tags))

        ;; update tags if changed
        (when (or (seq-difference tags original-tags)
                  (seq-difference original-tags tags))
          (apply #'vulpea-buffer-tags-set tags))))))

(defun vulpea-buffer-p ()
  "Return non-nil if the currently visited buffer is a note."
  (and buffer-file-name
       (string-prefix-p
        (expand-file-name (file-name-as-directory org-roam-directory))
        (file-name-directory buffer-file-name))))

(defun vulpea-todo-files ()
  "Return a list of note files containing 'todo' tag." ;
  (seq-uniq
   (seq-map
    #'car
    (org-roam-db-query
     [:select [nodes:file]
              :from tags
              :left-join nodes
              :on (= tags:node-id nodes:id)
              :where (like tag (quote "%\"todo\"%"))]))))


(defun vulpea-agenda-files-update (&rest _)
  "Update `org-agenda-files' by merging with current files.
  This function accepts any number of arguments, as required by advice."
  (let ((custom-agenda-files org-agenda-files))
    (setq org-agenda-files
          (seq-uniq
           (append custom-agenda-files
                   (vulpea-todo-files))))))

(add-hook 'find-file-hook #'vulpea-todo-update-tag)
(add-hook 'before-save-hook #'vulpea-todo-update-tag)

(advice-add 'org-agenda :before #'vulpea-agenda-files-update)
(advice-add 'org-todo-list :before #'vulpea-agenda-files-update)

;; functions borrowed from `vulpea' library
;; https://github.com/d12frosted/vulpea/blob/6a735c34f1f64e1f70da77989e9ce8da7864e5ff/vulpea-buffer.el

(defun vulpea-buffer-tags-get ()
  "Return filetags value in current buffer."
  (vulpea-buffer-prop-get-list "filetags" "[ :]"))

(defun vulpea-buffer-tags-set (&rest tags)
  "Set TAGS in current buffer.
  If filetags value is already set, replace it."
  (if tags
      (vulpea-buffer-prop-set
       "filetags" (concat ":" (string-join tags ":") ":"))
    (vulpea-buffer-prop-remove "filetags")))

(defun vulpea-buffer-tags-add (tag)
  "Add a TAG to filetags in current buffer."
  (let* ((tags (vulpea-buffer-tags-get))
         (tags (append tags (list tag))))
    (apply #'vulpea-buffer-tags-set tags)))

(defun vulpea-buffer-tags-remove (tag)
  "Remove a TAG from filetags in current buffer."
  (let* ((tags (vulpea-buffer-tags-get))l
         (tags (delete tag tags)))
    (apply #'vulpea-buffer-tags-set tags)))

(defun vulpea-buffer-prop-set (name value)
  "Set a file property called NAME to VALUE in buffer file.
  If the property is already set, replace its value."
  (setq name (downcase name))
  (org-with-point-at 1
    (let ((case-fold-search t))
      (if (re-search-forward (concat "^#\\+" name ":\\(.*\\)")
                             (point-max) t)
          (replace-match (concat "#+" name ": " value) 'fixedcase)
        (while (and (not (eobp))
                    (looking-at "^[#:]"))
          (if (save-excursion (end-of-line) (eobp))
              (progn
                (end-of-line)
                (insert "\n"))
            (forward-line)
            (beginning-of-line)))
        (insert "#+" name ": " value "\n")))))

(defun vulpea-buffer-prop-set-list (name values &optional separators)
  "Set a file property called NAME to VALUES in current buffer.
  VALUES are quoted and combined into single string using
  `combine-and-quote-strings'.
  If SEPARATORS is non-nil, it should be a regular expression
  matching text that separates, but is not part of, the substrings.
  If nil it defaults to `split-string-default-separators', normally
  \"[ \f\t\n\r\v]+\", and OMIT-NULLS is forced to t.
  If the property is already set, replace its value."
  (vulpea-buffer-prop-set
   name (combine-and-quote-strings values separators)))

(defun vulpea-buffer-prop-get (name)
  "Get a buffer property called NAME as a string."
  (org-with-point-at 1
    (when (re-search-forward (concat "^#\\+" name ": \\(.*\\)")
                             (point-max) t)
      (buffer-substring-no-properties
       (match-beginning 1)
       (match-end 1)))))

(defun vulpea-buffer-prop-get-list (name &optional separators)
  "Get a buffer property NAME as a list using SEPARATORS.
  If SEPARATORS is non-nil, it should be a regular expression
  matching text that separates, but is not part of, the substrings.
  If nil it defaults to `split-string-default-separators', normally
  \"[ \f\t\n\r\v]+\", and OMIT-NULLS is forced to t."
  (let ((value (vulpea-buffer-prop-get name)))
    (when (and value (not (string-empty-p value)))
      (split-string-and-unquote value separators))))

(defun vulpea-buffer-prop-remove (name)
  "Remove a buffer property called NAME."
  (org-with-point-at 1
    (when (re-search-forward (concat "\\(^#\\+" name ":.*\n?\\)")
                             (point-max) t)
      (replace-match ""))))


;;; Org-roam-ui
(require 'org-roam-ui)
(require 'websocket)

(setq org-roam-ui-open-on-start nil
      org-roam-ui-sync-theme nil
      org-roam-ui-update-on-save t
      org-roam-ui-follow t)

(provide 'init-org-roam-ui)



;;; Ebib
(require 'ebib)
(global-set-key (kbd "C-c o e") 'ebib)
;; citekey formula: auth.lower + year + shorttitle(2,2).lower
(setq ebib-bibtex-dialect 'biblatex
      ebib-preload-bib-files (list
                              (expand-file-name "references.bib" org-directory))
      ebib-notes-directory (list
                            (expand-file-name "reference/" org-directory))
      ebib-file-search-dirs '("~/Documents/zotero/"))



;;; Citar
(require 'citar)
;; basic
(setq citar-bibliography
      (list (expand-file-name "references.bib" org-directory)))

(global-set-key (kbd "C-c n o") #'citar-open)

;; citar-capf
(add-hook 'LaTeX-mode-hook #'citar-capf-setup)
(add-hook 'org-mode-hook #'citar-capf-setup)

;; embark
(citar-embark-mode 1)

;; org-cite
(setq org-cite-global-bibliography citar-bibliography
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

                "#+TITLE: ${note-title}\n#+CREATED: %U\n#+LAST_MODIFIED: %U\n#+FILETAGS:\n\n* Abstract\n* Motivation\n* Problem\n* Method\n* Evaluation\n* Limitation\n* Epilogue\n\n"
                )
               :unnarrowed t))

(setq citar-org-roam-capture-template-key "r")



;;; Latex
(setq org-highlight-latex-and-related '(native latex entities)
      org-pretty-entities t
      org-pretty-entities-include-sub-superscripts nil)

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

(require 'org-fragtog)
(add-hook 'org-mode-hook 'org-fragtog-mode)
(setq org-fragtog-preview-delay 0.2)



;;; ox-hugo
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



;;; Transclusion
(require 'org-transclusion)

;; (define-key global-map (kbd "<f12>") #'org-transclusion-add)
(define-key global-map (kbd "C-c t m") #'org-transclusion-transient-menu)
(define-key global-map (kbd "C-c t t") #'org-transclusion-mode)

(setq tramp-default-method "scp"
      vc-ignore-dir-regexp (format "\\(%s\\)\\|\\(%s\\)"
                                   vc-ignore-dir-regexp
                                   tramp-file-name-regexp)
      remote-file-name-inhibit-locks t)



;;; Export
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



(provide 'init-org)
