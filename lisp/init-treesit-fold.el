(require 'treesit-fold)

(add-hook 'prog-mode-hook (lambda ()
                            (when (and (fboundp 'treesit-parser-list)
                                       (treesit-parser-list))
                              (treesit-fold-mode 1)
                              ;; (treesit-fold-indicators-mode 1)
                              (treesit-fold-line-comment-mode 1))))

(setq treesit-fold-line-count-show t)  ; Show line count in folded regions
;; (setq treesit-fold-line-count-format " <%d lines> ")
;; (add-hook 'org-mode-hook (lambda () (setq treesit-fold-indicators-fringe 'right-fringe)))

(setq treesit-fold-summary-show t)
(setq treesit-fold-summary-max-length 60)
(setq treesit-fold-summary-exceeded-string "...")
(setq treesit-fold-summary-format " <S> %s ")

;; (setq treesit-fold-indicators-face-function
;;       (lambda (pos &rest _)
;;         ;; Return the face of it's function.
;;         (line-reminder--get-face (line-number-at-pos pos t))))
;; (setq line-reminder-add-line-function
;;       (lambda (&rest _)
;;         (null (treesit-fold--overlays-in treesit-fold-indicators-window (selected-window)
;;                                     (line-beginning-position) (line-end-position)))))

(provide 'init-treesit-fold)
