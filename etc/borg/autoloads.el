;;; autoloads.el --- collect drone autoloads outside the drones  -*- lexical-binding: t; -*-

;;; Commentary:

;; `borg-update-autoloads' writes "<drone>-autoloads.el" into the drone's own
;; working tree.  That leaves a generated, untracked file inside each of the
;; 150 submodules under "lib/", where it shows up in any view that does not
;; honor "submodule.<name>.ignore" (the drone-local `git status',
;; `git status --ignore-submodules=none', magit's module listing).
;;
;; Instead every drone's autoload cookies are scraped into the single file
;; "var/autoloads/autoloads.el" (ignored by git) in one pass.
;; `loaddefs-generate' writes source file names relative to the output file and
;; adds the *output file's directory* to `load-path', so the result works from
;; there.  That directory has to contain nothing but this file: it is prepended
;; to `load-path', so any library living in it would shadow the real one --
;; generating straight into "var/" broke `(require 'savehist)', because the
;; savehist state file is "var/savehist.el".  The file is a machine-local
;; artifact: regenerate it with `make autoloads'.
;;
;; `borg-update-autoloads' is overridden so that borg's own callers -- most
;; importantly `borg--build-noninteractive', which `make build/<drone>',
;; `make <drone>' and `make native/<drone>' all end up in -- write the
;; aggregated file instead of putting the per-drone files back.

;;; Code:

(require 'borg)
(require 'loaddefs-gen)

(defvar my/borg-autoloads-file
  (expand-file-name "var/autoloads/autoloads.el" borg-user-emacs-directory)
  "Single file collecting the autoloads of all drones.
It lives in its own directory because that directory ends up on
`load-path' (see the Commentary); keep it free of anything else.")

(defun my/borg-update-all-autoloads (&optional file)
  "Collect the autoloads of every drone into FILE.
FILE defaults to `my/borg-autoloads-file'.  This mirrors
`borg-update-autoloads' (same directories, same exclusions, same
`add-to-list' load-path preamble) but writes one file outside the drones."
  (let ((file (or file my/borg-autoloads-file))
        dirs excludes)
    (borg-do-drones (drone)
      (let ((path (borg--expand-load-path drone nil)))
        (setq dirs (append dirs path))
        (setq excludes
              (nconc excludes
                     (mapcar #'expand-file-name
                             (borg-get-all drone "no-byte-compile"))
                     (mapcan (lambda (dir)
                               (list (expand-file-name (concat drone "-pkg.el") dir)
                                     (expand-file-name (concat drone "-test.el") dir)
                                     (expand-file-name (concat drone "-tests.el") dir)))
                             path)))))
    (make-directory (file-name-directory file) t)
    (message " Creating %s..." file)
    (borg--silence-loaddefs-generate
     (loaddefs-generate
      dirs file excludes
      (prin1-to-string
       '(add-to-list 'load-path
                     (or (and load-file-name
                              (directory-file-name
                               (file-name-directory load-file-name)))
                         (car load-path))))
      nil t))
    (when-let* ((buf (find-buffer-visiting file)))
      (kill-buffer buf))
    file))

(defun my/borg-update-autoloads (_clone &optional _path)
  "Ignore the drone and refresh the aggregated autoloads file instead."
  (my/borg-update-all-autoloads))

(advice-add 'borg-update-autoloads :override #'my/borg-update-autoloads)

(provide 'borg-autoloads)
;;; autoloads.el ends here
