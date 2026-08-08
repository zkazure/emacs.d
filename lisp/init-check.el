(require 'jinx)
(add-hook 'emacs-startup-hook #'global-jinx-mode)
(add-to-list 'jinx-exclude-regexps '(t "\\cc")) ; 拼写检查忽略中文

(keymap-global-set "M-$" #'jinx-correct)
(keymap-global-set "C-M-$" #'jinx-languages)

(setq jinx-languages "en_GB en_US")

(setq flymake-no-changes-timeout 1
      flymake-fringe-indicator-position 'right-fringe
      flymake-margin-indicator-position 'right-margin
      flymake-show-diagnostics-at-end-of-line nil)

(provide 'init-check)
