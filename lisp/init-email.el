;; -*- lexical-binding: t; -*-

(require 'notmuch)

(setq notmuch-always-prompt-for-sender t)

(setq notmuch-saved-searches
      '((:name "inbox" :query "tag:inbox" :key "i" :search-type tree)
        (:name "unread" :query "tag:unread" :key "u" :search-type tree)
        (:name "flagged" :query "tag:flagged" :key "f" :search-type tree)
        (:name "sent" :query "tag:sent" :key "s" :search-type tree)
        ;; (:name "drafts" :query "tag:draft" :key "d" :search-type tree)
        (:name "org-mode-devel" :query "tag:org-mode-devel" :key "o" :search-type tree)
        (:name "list" :query "tag:list" :key "l" :search-type tree)
        (:name "all mail" :query "*" :key "a" :search-type tree)
        ))

(setq mail-user-agent 'notmuch-user-agent
      message-send-mail-function 'message-send-mail-with-sendmail
      sendmail-program "msmtp"
      message-sendmail-extra-arguments '("--read-envelope-from")
      message-sendmail-f-is-evil t)

(global-set-key (kbd "C-c o m") #'notmuch)

(add-hook 'notmuch-show-mode-hook
          (lambda ()
            (visual-line-mode 1)
            (face-remap-add-relative 'default
                                     :height 1.4)
            (setq-local visual-fill-column-center-text t
                        visual-fill-column-width 100)
            (visual-fill-column-mode 1)))

(provide 'init-email)
