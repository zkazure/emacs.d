(require 'org-roam)

(add-to-list 'load-path
             (expand-file-name "lib/org-roam/extensions/" user-emacs-directory))
;; (require 'org-roam-dailies)
(require 'org-roam-export)
(require 'org-roam-graph)
(require 'org-roam-overlay)
(require 'org-roam-protocol)

(setq org-roam-directory (file-truename "~/Documents/roam/"))
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
  (let ((custom-agenda-files '("~/Documents/roam/")))
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

(provide 'init-org-roam)
