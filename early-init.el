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

(setq gc-cons-percentage 0.6)
(setq package-enable-at-startup t)
(setq package-quickstart nil)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                         ("melpa" . "https://melpa.org/packages/")))

(setenv "LSP_USE_PLISTS" "true")
(setq lsp-use-plists t)

(provide 'early-init)

;; Local Variables:
;; no-byte-compile: t
;; indent-tabs-mode: nil
;; End:
;;; early-init.el ends here
