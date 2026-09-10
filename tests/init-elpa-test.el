;;; init-elpa-test.el --- Package installation contract -*- lexical-binding: t -*-

(require 'ert)
(require 'cl-lib)
(require 'init-elpa)
(require 'package-vc)

(ert-deftest require-package-keeps-installed-packages ()
  "An existing archive or built-in package must not be replaced or upgraded."
  (cl-letf (((symbol-function 'package-installed-p) (lambda (&rest _) t))
            ((symbol-function 'package-vc-install) (lambda (&rest _) (ert-fail "VC install")))
            ((symbol-function 'package-install) (lambda (&rest _) (ert-fail "Archive install")))
            ((symbol-function 'package-refresh-contents) (lambda () (ert-fail "Refresh"))))
    (should (require-package 'example "https://example.invalid/example.git"))
    (should (require-package 'example))))

(ert-deftest require-package-installs-vc-once-without-loading ()
  (let (installed calls)
    (cl-letf (((symbol-function 'package-installed-p) (lambda (&rest _) installed))
              ((symbol-function 'package-vc-install)
               (lambda (spec &rest _)
                 (push spec calls)
                 (setq installed t)))
              ((symbol-function 'package-install) (lambda (&rest _) (ert-fail "Fallback")))
              ((symbol-function 'package-refresh-contents) (lambda () (ert-fail "Refresh"))))
      (should (require-package 'test-unloaded-package "https://example.invalid/repo.git"))
      (should (require-package 'test-unloaded-package "https://example.invalid/repo.git"))
      (should (equal calls '((test-unloaded-package :url "https://example.invalid/repo.git"))))
      (should-not (featurep 'test-unloaded-package)))))

(ert-deftest require-package-preserves-vc-build-spec ()
  (let (installed received)
    (cl-letf (((symbol-function 'package-installed-p) (lambda (&rest _) installed))
              ((symbol-function 'package-vc-install)
               (lambda (spec &rest _) (setq received spec installed t))))
      (require-package 'example '(:url "https://example.invalid/repo.git" :lisp-dir "lisp"))
      (should (equal received '(example :url "https://example.invalid/repo.git" :lisp-dir "lisp"))))))

(ert-deftest require-package-vc-failure-is-actionable-and-does-not-fallback ()
  (cl-letf (((symbol-function 'package-installed-p) (lambda (&rest _) nil))
            ((symbol-function 'package-vc-install) (lambda (&rest _) (error "Network unavailable")))
            ((symbol-function 'package-install) (lambda (&rest _) (ert-fail "Fallback"))))
    (let ((err (should-error (require-package 'example "https://example.invalid/repo.git"))))
      (should (string-match-p "example.*https://example.invalid/repo.git.*Network unavailable"
                              (error-message-string err))))))

(ert-deftest require-package-requires-source-for-missing-package ()
  (cl-letf (((symbol-function 'package-installed-p) (lambda (&rest _) nil)))
    (should-error (require-package 'example))))

(ert-deftest require-package-rejects-incomplete-installation ()
  (cl-letf (((symbol-function 'package-installed-p) (lambda (&rest _) nil))
            ((symbol-function 'package-vc-install) (lambda (&rest _) nil)))
    (should-error (require-package 'example "https://example.invalid/repo.git"))))

(ert-deftest require-package-archive-refreshes-only-when-needed ()
  (dolist (known '(nil t))
    (let ((package-archive-contents (when known '((example . ignored))))
          installed (refreshes 0))
      (cl-letf (((symbol-function 'package-installed-p) (lambda (&rest _) installed))
                ((symbol-function 'package-refresh-contents) (lambda () (cl-incf refreshes)))
                ((symbol-function 'package-install)
                 (lambda (package &rest _) (should (eq package 'example)) (setq installed t))))
        (should (require-package 'example :archive))
        (should (= refreshes (if known 0 1)))))))

;;; init-elpa-test.el ends here
