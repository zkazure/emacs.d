;; -*- lexical-binding: t; -*-

;; Keep these minor-mode lighters visible; collapse the rest in the mode line.
(setopt mode-line-collapse-minor-modes
        '(not
          apheleia-mode
          view-mode))

(add-hook 'ghostel-mode-hook #'mode-line-invisible-mode)

(provide 'init-modeline)
