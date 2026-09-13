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
(setq package-enable-at-startup t)
(setq package-quickstart nil)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                         ("melpa" . "https://melpa.org/packages/")))

;; Borg (secondary mode): Borg activates the drones in "borg/" and then
;; lets package.el activate everything else in "elpa/".  Borg itself is
;; installed by package.el, so its directory is looked up in "elpa/";
;; when Borg is not installed yet, nothing changes and Emacs activates
;; the packages itself as before.  See "Makefile" and "borg/README.org".
(let ((borg-dir (car (last (sort (directory-files (expand-file-name "elpa" user-emacs-directory)
                                                t "\\`borg-[0-9]" t)
                                        #'string-lessp)))))
  (when borg-dir
    (add-to-list 'load-path borg-dir))
  (when (require 'borg-elpa nil t)
    (setq package-enable-at-startup nil)
    (borg-elpa-initialize)))

(setenv "LSP_USE_PLISTS" "true")
(setq lsp-use-plists t)

(provide 'early-init)

;; Local Variables:
;; no-byte-compile: t
;; indent-tabs-mode: nil
;; End:
;;; early-init.el ends here
