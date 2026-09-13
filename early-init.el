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

;; Borg would write each drone's autoloads into that drone; etc/borg/autoloads.el
;; overrides that and collects them all in var/autoloads/autoloads.el instead,
;; which we then load here.  That file lives in its own directory because it is
;; prepended to `load-path' (that is how its relative source names resolve);
;; do not put anything else in var/autoloads/.  Both loads are best-effort
;; (NOERROR/NOMESSAGE/NOSUFFIX): after a fresh clone the generated file does not
;; exist yet, so startup just reports the first autoloaded function that
;; init.el calls, until `make autoloads' has been run once.
(load (expand-file-name "etc/borg/autoloads.el" user-emacs-directory) t t t)
(load (expand-file-name "var/autoloads/autoloads.el" user-emacs-directory) t t t)

(setq package-enable-at-startup nil)

(setenv "LSP_USE_PLISTS" "true")
(setq lsp-use-plists t)

(provide 'early-init)

;; Local Variables:
;; no-byte-compile: t
;; indent-tabs-mode: nil
;; End:
;;; early-init.el ends here
