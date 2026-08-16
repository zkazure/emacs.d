;;; init.el --- user-init-file -*- lexical-binding: t; no-byte-compile: t -*-
;;; Early birds

(progn ;     startup
  (defvar before-user-init-time (current-time)
    "Value of `current-time' when Emacs begins loading `user-init-file'.")
  (message "Loading Emacs...done (%.3fs)"
           (float-time (time-subtract before-user-init-time
                                      before-init-time)))
  (setq user-init-file (or load-file-name buffer-file-name))
  (setq user-emacs-directory (file-name-directory user-init-file))
  (message "Loading %s..." user-init-file)
  (when (< emacs-major-version 27)
    (setq package-enable-at-startup nil)
    ;; (package-initialize)
    (load-file (expand-file-name "early-init.el" user-emacs-directory)))
  (setq inhibit-startup-buffer-menu t)
  (setq inhibit-startup-screen t)
  (setq inhibit-startup-echo-area-message "locutus")
  (setq initial-buffer-choice t)
  (setq initial-scratch-message "")
  (when (fboundp 'set-scroll-bar-mode)
    (set-scroll-bar-mode nil))
  (when (fboundp 'tool-bar-mode)
    (tool-bar-mode 0))
  (menu-bar-mode -1))


(eval-and-compile
  (add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory)))

(require 'init-borg)

(require 'init-basic)
(require 'init-ui)

(require 'init-window)
(require 'init-buffer)
(require 'init-dired)

(require 'init-consult)
(require 'init-eglot)
(require 'init-vertico)
(require 'init-corfu)
(require 'init-flymake)
(require 'init-orderless)
(require 'init-cape)
(require 'init-embark)

(require 'init-org)
(require 'init-markdown)
(require 'init-yasnippet)
(require 'init-latex)

(require 'init-editing)
(require 'init-ime)
(require 'init-terminal)
(require 'init-email)
(require 'init-compile)
(require 'init-gdb)
(require 'init-ai)

(require 'init-indent)
(require 'init-treesit)
(require 'init-lisp)
(require 'init-go)
(require 'init-rust)
(require 'init-javascript)
(require 'init-lua)
(require 'init-makefile)
(require 'init-cmake)
(require 'init-matlab)
(require 'init-gdscript)
(require 'init-csv)
(require 'init-yaml)
(require 'init-mermaid)

(require 'init-misc)

(provide 'init)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:
;;; init.el ends here
