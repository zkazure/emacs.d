;; -*- lexical-binding: t; -*-

;;; Global defaults

(setq-default indent-tabs-mode nil
              tab-width 4)


;;; Helpers

(defun my/set-indent (width)
  "Use spaces and set TAB display width to WIDTH."
  (setq-local indent-tabs-mode nil)
  (setq-local tab-width width))

(defun my/add-hooks (hooks function)
  "Add FUNCTION to every hook in HOOKS."
  (dolist (hook hooks)
    (add-hook hook function)))


;;; C / C++ / Java

(defun my/c-indent ()
  (my/set-indent 4)
  ;; c-mode / c++-mode / java-mode
  (setq-local c-basic-offset 4)
  ;; c-ts-mode / c++-ts-mode
  (setq-local c-ts-mode-indent-offset 4))

(my/add-hooks
 '(c-mode-hook
   c++-mode-hook
   c-ts-mode-hook
   c++-ts-mode-hook
   java-mode-hook)
 #'my/c-indent)


;;; Go

(defun my/go-indent ()
  (my/set-indent 4)
  (setq-local go-ts-mode-indent-offset 4))

(my/add-hooks
 '(go-mode-hook
   go-ts-mode-hook)
 #'my/go-indent)


;;; JavaScript / TypeScript

(defun my/js-indent ()
  (my/set-indent 2)
  (setq-local js-indent-level 2)
  (setq-local typescript-indent-level 2))

(my/add-hooks
 '(js-mode-hook
   js-ts-mode-hook
   typescript-mode-hook)
 #'my/js-indent)


;;; CSS

(defun my/css-indent ()
  (my/set-indent 2)
  (setq-local css-indent-offset 2))

(my/add-hooks
 '(css-mode-hook
   css-ts-mode-hook)
 #'my/css-indent)


;;; YAML

(defun my/yaml-indent ()
  (my/set-indent 2)
  (setq-local yaml-indent-offset 2))

(my/add-hooks
 '(yaml-mode-hook
   yaml-ts-mode-hook)
 #'my/yaml-indent)


;;; Shell

(defun my/sh-indent ()
  (my/set-indent 4)
  (setq-local sh-basic-offset 4))

(add-hook 'sh-mode-hook #'my/sh-indent)


(provide 'init-indent)
