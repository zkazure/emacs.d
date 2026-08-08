(require 'visual-regexp)
;; (require 'visual-regexp-steroids)
;; (setq vr/engine 'emacs)
;; (setq vr/command-python "python3 /home/kazure/.emacs.d/lib/visual-regexp-steroids/regexp.py")

(define-key global-map (kbd "C-c r") 'vr/replace)
(define-key global-map (kbd "C-c q") 'vr/query-replace)
;; to use visual-regexp-steroids's isearch instead of the built-in regexp isearch, also include the following lines:
(define-key esc-map (kbd "C-r") 'vr/isearch-backward) ;; C-M-r
(define-key esc-map (kbd "C-s") 'vr/isearch-forward) ;; C-M-s

(provide 'init-visual-regexp)
