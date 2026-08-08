(setq dired-dwim-target t)

(require 'dirvish)
(add-to-list 'load-path
             (expand-file-name "lib/dirvish/extensions/" user-emacs-directory))
(require 'dirvish-collapse)
(require 'dirvish-subtree)
(require 'dirvish-yank)
(require 'dirvish-icons)
(require 'dirvish-vc)
(require 'dirvish-quick-access)
(require 'dirvish-ls)


(dirvish-override-dired-mode)
(define-key global-map (kbd "C-x d") 'dirvish)
(define-key dirvish-mode-map (kbd "b")   'dired-up-directory)
;; (define-key dirvish-mode-map (kbd "?")   'dirvish-dispatch) ; [?] a helpful cheatsheet
(define-key dirvish-mode-map (kbd "a")   'dirvish-setup-menu)        ; [a]ttributes settings:`t' toggles mtime, `f' toggles fullframe, etc.
(define-key dirvish-mode-map (kbd "F")   'dirvish-file-info-menu)    ; [f]ile info
(define-key dirvish-mode-map (kbd "o")   'dirvish-quick-access)      ; [o]pen `dirvish-quick-access-entries'
(define-key dirvish-mode-map (kbd "s")   'dirvish-quicksort) ; [s]ort flie list, require ls
;; (define-key dirvish-mode-map (kbd "l")   'dirvish-ls-switches-menu)  ; [l]s command flags
;; (define-key dirvish-mode-map (kbd "r")   'dirvish-history-jump)      ; [r]ecent visited
(define-key dirvish-mode-map (kbd "v")   'dirvish-vc-menu)           ; [v]ersion control commands
(define-key dirvish-mode-map (kbd "*")   'dirvish-mark-menu)
(define-key dirvish-mode-map (kbd "y")   'dirvish-yank-menu)
;; (define-key dirvish-mode-map (kbd "N")   'dirvish-narrow)
;; (define-key dirvish-mode-map (kbd "^")   'dirvish-history-last)
(define-key dirvish-mode-map (kbd "TAB") 'dirvish-subtree-toggle)
;; (define-key dirvish-mode-map (kbd "M-f") 'dirvish-history-go-forward)
;; (define-key dirvish-mode-map (kbd "M-b") 'dirvish-history-go-backward)
;; (define-key dirvish-mode-map (kbd "M-e") 'dirvish-emerge-menu)


(setq dirvish-preview-delay 0.5         ; add delay to avoid flashing while
                                        ; previewing folders
      dired-mouse-drag-files t
      mouse-drag-and-drop-region-cross-program t
      dirvish-use-mode-line t
      dirvish-large-directory-threshold 20000 ; open large directory (over 20000
                                        ; files) asynchronously with `fd'
                                        ; command
      dirvish-default-layout '(0.4 0.1 0.5)
      dired-listing-switches "-Al --group-directories-first"
      dirvish-attributes               ; The order *MATTERS* for some attributes
      '(vc-state subtree-state nerd-icons collapse git-msg file-time file-size)
      )
;; (setq dirvish-mode-line-format
;;       '(:left (sort symlink) :right (omit yank index)))

(setopt dirvish-quick-access-entries ; It's a custom option, `setq' won't work
        '(("h" "~/"                          "Home")
          ("d" "~/Downloads/"                "Downloads")
          ("s" "~/Documents/sysu/"           "Sysu")
          ("c" "~/Documents/cs_learning/"    "CS")
          ;; ("m" "/mnt/"                       "Drives")
          ;; ("s" "/ssh:my-remote-server")      "SSH server"
          ;; ("e" "/sudo:root@localhost:/etc")  "Modify program settings"
          ("t" "~/.local/share/Trash/files/" "TrashCan")))

(provide 'init-dirvish)
