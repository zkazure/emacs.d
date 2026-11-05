;; -*- lexical-binding: t; -*-

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

(provide 'early-init-gui)

;; Local Variables:
;; no-byte-compile: t
;; indent-tabs-mode: nil
;; End:

