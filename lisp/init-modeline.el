;; -*- lexical-binding: t; -*-

(let ((my/minor-mode-alist '((flycheck-mode flycheck-mode-line))))
  (setq mode-line-modes
        (mapcar (lambda (elem)
                  (pcase elem
                    (`(:propertize (,_ minor-mode-alist . ,_) . ,_)
                     `(:propertize ("" ,my/minor-mode-alist)
			                       mouse-face mode-line-highlight
			                       local-map ,mode-line-minor-mode-keymap)
                     )
                    (_ elem)))
                mode-line-modes)
        ))
(setq-default mode-line-format
              '("%e" mode-line-front-space
                "["
                (ace-window-display-mode
                 (:propertize
                  (:eval (window-parameter (selected-window) 'ace-window-path))
                  face error))
                "] "
                (:propertize
                 (""
                  mode-line-mule-info
                  mode-line-client
                  mode-line-modified
                  mode-line-remote
                  mode-line-auto-compile
                  mode-line-window-dedicated)
                 display (min-width 6.0))
                mode-line-frame-identification
                mode-line-buffer-identification
                "   "
                mode-line-position
                (project-mode-line project-mode-line-format)

                mode-line-format-right-align
                (:eval (when (bound-and-true-p flymake-mode)
                         (list " "
                               flymake-mode-line-error-counter
                               flymake-mode-line-warning-counter
                               flymake-mode-line-note-counter
                               " ")))
                (:propertize
                 (:eval (when (stringp vc-mode)
                          (replace-regexp-in-string "^ \\w+[:-]" "" vc-mode)))
                 face success)

                "  "
                mode-line-modes
                mode-line-misc-info
                mode-line-end-spaces))

(set-face-attribute 'mode-line-inactive nil :box nil)

(provide 'init-modeline)
