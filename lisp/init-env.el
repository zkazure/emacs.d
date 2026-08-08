(setq system-time-locale "en_US.utf8")

(prefer-coding-system       'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-language-environment   'utf-8)

(require 'no-littering)

;; early-init.el
(startup-redirect-eln-cache
 (expand-file-name "var/eln-cache/"
                   user-emacs-directory))

(setq backup-directory-alist
      `(("." .
         ,(no-littering-expand-var-file-name
           "backup/"))))

(setq auto-save-file-name-transforms
      `((".*"
         ,(no-littering-expand-var-file-name "auto-save/")
         t)))

(require 'envrc)
(envrc-global-mode)

(setq inhibit-default-init t)

(provide 'init-env)
