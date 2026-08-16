;; -*- lexical-binding: t; -*-

(setq window-combination-resize t)

(winner-mode 1)
(global-set-key (kbd "C-c w") 'winner-undo)


(require 'ace-window)

(global-set-key (kbd "C-x o") 'ace-window)

(setq aw-keys '(?1 ?2 ?3 ?4 ?5 ?6 ?7 ?8 ?9 ?0))
(setq aw-background t
      aw-scope 'frame
      aw-dispatch-always nil
      aw-minibuffer-flag nil
      aw-display-mode-overlay nil)

(with-eval-after-load 'ace-window
  (setq aw-dispatch-alist
        '((?d aw-delete-window "Delete Window")
          (?D delete-other-windows "Delete Other Windows") ; select one and delete others
	      (?s aw-swap-window "Swap Windows")
	      (?m aw-move-window "Move Window")
	      (?c aw-copy-window "Copy Window")
	      (?f aw-flip-window)
          (?j aw-switch-buffer-in-window "Select Buffer") ; change and jump
	      (?J aw-switch-buffer-other-window "Switch Buffer Other Window") ; change but not jump
	      (?c aw-split-window-fair "Split Fair Window")
	      (?v aw-split-window-vert "Split Vert Window")
	      (?h aw-split-window-horz "Split Horz Window")
	      (?? aw-show-dispatch-help))))

;; (ace-window-display-mode 1)


(provide 'init-window)
