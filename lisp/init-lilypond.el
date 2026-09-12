;;; init-lilypond.el --- LilyPond 2.26 support -*- lexical-binding: t; -*-

(defconst my-lilypond-root
  (expand-file-name "~/.local/opt/lilypond-2.26.0/")
  "User installation directory for LilyPond 2.26.")

(defconst my-lilypond-bin
  (expand-file-name "bin/" my-lilypond-root))

(defconst my-lilypond-command
  (expand-file-name "lilypond" my-lilypond-bin))

(defconst my-lilypond-site-lisp
  (expand-file-name "share/emacs/site-lisp/" my-lilypond-root))

(if (file-executable-p my-lilypond-command)
    (progn
      ;; These affect Emacs and the programs it starts, not the login shell.
      (add-to-list 'exec-path my-lilypond-bin)
      (unless (member my-lilypond-bin (parse-colon-path (getenv "PATH")))
        (setenv "PATH" (concat my-lilypond-bin path-separator (getenv "PATH"))))
      (add-to-list 'load-path my-lilypond-site-lisp)
      ;; The official initializer only installs autoloads for .ly and .ily.
      (load (expand-file-name "lilypond-init.el" my-lilypond-site-lisp) nil t)
      (with-eval-after-load 'lilypond-mode
        (setq lilypond-lilypond-command my-lilypond-command)))
  (message "LilyPond 2.26 is unavailable at %s" my-lilypond-command))

(with-eval-after-load 'ob-lilypond
  (customize-set-variable
   'org-babel-lilypond-commands
   (list my-lilypond-command "xdg-open" "xdg-open"))
  (setq org-babel-lilypond-arrange-mode nil)
  (setf (alist-get "lilypond" org-src-lang-modes nil nil #'equal)
        'lilypond))

(provide 'init-lilypond)
;;; init-lilypond.el ends here
