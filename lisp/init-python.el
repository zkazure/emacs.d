;; -*- lexical-binding: t; -*-

;; C-c C-p to open a Python REPL
(define-key python-ts-mode-map (kbd "M-<return>") #'python-shell-send-statement)

(defun my/python-shell-send-statement-and-next-line (&optional arg)
  "发送当前行的 Python 语句之后向下移动一行"
  (interactive "P")
  (python-shell-send-statement)
  (next-line))
(define-key python-ts-mode-map (kbd "S-<return>") #'my/python-shell-send-statement-and-next-line)

(defun my/python-shell-send-paragraph-or-above (&optional arg)
  "发送当前上下有空行分隔的代码块（段落）到 Python REPL。
如果光标当前在空行上，则自动向上寻找第一个代码块并发送。"
  (interactive "P")
  (save-excursion
    ;; 1. 如果当前行是空行，向上跳过所有空白字符，定位到上方最近的代码块末尾
    (when (looking-at-p "^[ \t]*$")
      (skip-chars-backward " \t\n\r"))
    ;; 2. 获取该段落（上下空行之间）的起止位置
    (let ((end (progn (forward-paragraph) (point)))
          (beg (progn (backward-paragraph) (point))))
      ;; 3. 检查是否包含有效代码，并发送给 Python
      (if (string-blank-p (buffer-substring-no-properties beg end))
          (message "未找到可执行的 Python 代码块！")
        (python-shell-send-region beg end arg)
        ;; 在 minibuffer 提示已发送的行号范围，方便确认
        (message "已发送代码块: 第 %d 行 -> 第 %d 行"
                 (line-number-at-pos beg)
                 (line-number-at-pos (1- end)))))))
(define-key python-ts-mode-map (kbd "C-<return>") #'my/python-shell-send-paragraph-or-above)


(provide 'init-python)
