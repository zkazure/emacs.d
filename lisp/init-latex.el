(require 'auctex)

(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master t)

(add-hook 'latex-mode-hook 'prettify-symbols-mode)

;; use C-c C-p C-p to preview
(add-hook 'latex-mode-hook
          (defun preview-larger-previews ()
            (setq preview-scale-function
                  (lambda () (* 1.25
                                (funcall (preview-scale-from-face)))))))

(setq prettify-symbols-unprettify-at-point t)

(setq TeX-fold-section t)
(setq TeX-fold-comment t)

(add-hook 'latex-mode-hook 'TeX-fold-mode)

(require 'cdlatex)

(add-hook 'latex-mode-hook 'turn-on-cdlatex)

(with-eval-after-load 'cdlatex
  (add-to-list 'cdlatex-math-modify-alist '(?B "\\mathbb" nil t nil nil)))

(defun my/yas-try-expanding-auto-snippets ()
  (when (and (boundp 'yas-minor-mode)
	         yas-minor-mode)
    (let ((yas-buffer-local-condition ''(require-snippet-condition . auto)))
      (yas-expand))))

;; Try after every insertion
(add-hook 'post-self-insert-hook #'my/yas-try-expanding-auto-snippets)

(eval-after-load 'latex
  '(progn
     (define-key LaTeX-mode-map (kbd "C-S-e") 'latex-math-from-calc)))
(eval-after-load 'org
  '(progn
     (define-key org-mode-map (kbd "C-S-e") 'latex-math-from-calc)))

(defun latex-math-from-calc ()
  "Evaluate `calc' on the contents of line at point."
  (interactive)
  (cond ((region-active-p)
         (let* ((beg (region-beginning))
                (end (region-end))
                (string (buffer-substring-no-properties beg end)))
           (kill-region beg end)
           (insert (calc-eval `(,string calc-language latex
                                        calc-prefer-frac t
                                        calc-angle-mode rad)))))
        (t (let ((l (thing-at-point 'line)))
             (end-of-line 1) (kill-line 0)
             (insert (calc-eval `(,l
                                  calc-language latex
                                  calc-prefer-frac t
                                  calc-angle-mode rad)))))))

(require 'org-table)
(require 'cdlatex)

;; 绑定 orgtbl-mode-map 中的 <tab> 和 TAB 键
(eval-after-load 'org-table
  '(progn
     (define-key orgtbl-mode-map (kbd "<tab>") #'lazytab-org-table-next-field-maybe)
     (define-key orgtbl-mode-map (kbd "TAB") #'lazytab-org-table-next-field-maybe)))

;; 添加 cdlatex-tab-hook
(add-hook 'cdlatex-tab-hook 'lazytab-cdlatex-or-orgtbl-next-field 90)

;; 定义 cdlatex 命令
(add-to-list 'cdlatex-command-alist '("smat" "Insert smallmatrix env"
                                      "\\left( \\begin{smallmatrix} ? \\end{smallmatrix} \\right)"
                                      #'lazytab-position-cursor-and-edit
                                      nil nil t))
(add-to-list 'cdlatex-command-alist '("bmat" "Insert bmatrix env"
                                      "\\begin{bmatrix} ? \\end{bmatrix}"
                                      #'lazytab-position-cursor-and-edit
                                      nil nil t))
(add-to-list 'cdlatex-command-alist '("pmat" "Insert pmatrix env"
                                      "\\begin{pmatrix} ? \\end{pmatrix}"
                                      #'lazytab-position-cursor-and-edit
                                      nil nil t))
(add-to-list 'cdlatex-command-alist '("tbl" "Insert table"
                                      "\\begin{table}\n\\centering ? \\caption{}\n\\end{table}\n"
                                      #'lazytab-position-cursor-and-edit
                                      nil t nil))

;; 定义函数
(defun lazytab-position-cursor-and-edit ()
  "Positions the cursor after inserting a cdlatex template and calls orgtbl-edit."
  (cdlatex-position-cursor)
  (lazytab-orgtbl-edit))

(defun lazytab-orgtbl-edit ()
  "Enters org-table mode for editing, and prepares for replacement upon exit."
  (advice-add 'orgtbl-ctrl-c-ctrl-c :after #'lazytab-orgtbl-replace)
  (orgtbl-mode 1)
  (open-line 1)
  (insert "\n|"))

(defun lazytab-orgtbl-replace (&rest _)
  "Replaces the org-table with its LaTeX/amsmath equivalent."
  (interactive "P")
  (unless (org-at-table-p) (user-error "Not at a table"))
  (let* ((table (org-table-to-lisp))
         params
         (replacement-table
          (if (texmathp)
              (lazytab-orgtbl-to-amsmath table params)
            (orgtbl-to-latex table params))))
    (kill-region (org-table-begin) (org-table-end))
    (open-line 1)
    (push-mark)
    (insert replacement-table)
    (align-regexp (region-beginning) (region-end) "\\([:space:]*\\)& ")
    (orgtbl-mode -1)
    (advice-remove 'orgtbl-ctrl-c-ctrl-c #'lazytab-orgtbl-replace)))

(defun lazytab-orgtbl-to-amsmath (table params)
  "Converts an org-table to amsmath format."
  (orgtbl-to-generic
   table
   (org-combine-plists
    '(:splice t
              :lstart ""
              :lend " \\\\"
              :sep " & "
              :hline nil
              :llend "")
    params)))

(defun lazytab-cdlatex-or-orgtbl-next-field ()
  "Moves to the next field in org-table if applicable, otherwise lets cdlatex handle it."
  (when (and (bound-and-true-p orgtbl-mode)
             (org-table-p)
             (looking-at "[[:space:]]*\\(?:|\\|$\\)")
             (let ((s (thing-at-point 'sexp)))
               (not (and s (assoc s cdlatex-command-alist-comb)))))
    (call-interactively #'org-table-next-field)
    t))

(defun lazytab-org-table-next-field-maybe ()
  "If cdlatex-mode is active, calls cdlatex-tab, otherwise org-table-next-field."
  (interactive)
  (if (bound-and-true-p cdlatex-mode)
      (cdlatex-tab)
    (org-table-next-field)))

(add-hook 'latex-mode-hook 'turn-on-reftex)

(setq TeX-source-correlate-mode t)
(setq TeX-source-correlate-start-server t)
(setq TeX-view-program-list '(("Okular" "okular --unique %o#src:%n%b")
                              ))
(setq TeX-view-program-selection
      (quote
       ((output-pdf "Zathura")
        (output-dvi "Okular")
        (output-html "xdg-open"))))

(provide 'init-latex)
