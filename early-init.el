;;; early-init.el --- earliest birds               -*- lexical-binding: t -*-

(setq load-prefer-newer t)

;; Cache directory contents to speed up library lookup.
(when (and (boundp 'load-path-filter-function)
           (fboundp 'load-path-filter-cache-directory-files))
  (setq load-path-filter-function #'load-path-filter-cache-directory-files))

(when (and (fboundp 'startup-redirect-eln-cache)
           (fboundp 'native-comp-available-p)
           (native-comp-available-p))
  (startup-redirect-eln-cache
   (convert-standard-filename
    (expand-file-name  "var/eln-cache/" user-emacs-directory))))

;; Do not compile packages in the background while editing: Borg pins their
;; versions, and native compilation is an explicit build step when wanted.
(setq native-comp-jit-compilation nil)

(setq gc-cons-percentage 0.6)

;; Borg is the primary package manager.  Every third-party package, including
;; Borg itself, is a pinned drone under "lib/"; package.el is not initialized.
(add-to-list 'load-path (expand-file-name "lib/borg" user-emacs-directory))
(require 'borg)
(borg-initialize)
(setq package-enable-at-startup nil)

(setenv "LSP_USE_PLISTS" "true")
(setq lsp-use-plists t)

(provide 'early-init)

;; Local Variables:
;; no-byte-compile: t
;; indent-tabs-mode: nil
;; End:
;;; early-init.el ends here
