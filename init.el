;;; init.el --- user-init-file -*- lexical-binding: t; no-byte-compile: t -*-
;;; Early birds

(let ((gui-file (expand-file-name "init-gui.el" user-emacs-directory))
      (tui-file (expand-file-name "init-tui.el" user-emacs-directory)))
  (if (display-graphic-p)
      (load gui-file)
    (load tui-file)))

(provide 'init)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:
;;; init.el ends here
