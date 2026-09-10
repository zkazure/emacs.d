;;; init-elpa.el --- Ensure packages are installed -*- lexical-binding: t -*-

;;; Commentary:
;; Like Purcell's require-package, this ensures installation, not loading.
;; package.el activates installed packages before init.el via early-init.el.

;;; Code:

(require 'package)

(defun require-package (package &optional source)
  "Ensure PACKAGE is installed, returning non-nil on success.
An installed package (including a built-in) is left alone.
For a missing package, SOURCE is a repository URL or a package-vc
specification plist containing :url.  Use :archive explicitly to
install from the configured package archives instead.
This function neither loads PACKAGE's library nor upgrades existing
installations.  Installation errors retain the package and source context."
  (or (package-installed-p package)
      (condition-case err
          (progn
            (cond
             ((eq source :archive)
              (unless (assq package package-archive-contents)
                (package-refresh-contents))
              (package-install package))
             ((or (stringp source)
                  (and (listp source) (plist-get source :url)))
              (require 'package-vc)
              (package-vc-install
               (cons package (if (stringp source)
                                 (list :url source)
                               source))))
             (t (error "Missing repository URL or explicit :archive source")))
            (unless (package-installed-p package)
              (error "Installation finished but the package is unavailable"))
            t)
        (error
         (error "Could not install %s from %S: %s"
                package source (error-message-string err))))))

(provide 'init-elpa)
;;; init-elpa.el ends here
