(require 'leetcode)

(setq leetcode-prefer-language "cpp")

;; (setq leetcode-prefer-sql "mysql")

(setq leetcode-save-solutions t)
(setq leetcode-directory "~/Documents/cs_learning/leetcode")

;; (setq leetcode-prefer-tag-display nil)

;; (global-set-key (kbd "C-c o c") 'leetcode)

(add-hook 'leetcode--problems-mode-hook
          (lambda () (display-line-numbers-mode -1)))
(add-hook 'leetcode--problem-detail-mode-hook
          (lambda () (display-line-numbers-mode -1)))

(provide 'init-leetcode)
