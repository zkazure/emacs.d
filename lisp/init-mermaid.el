;; -*- lexical-binding: t; -*-

(require 'mermaid-mode)
(require 'ob-mermaid)

(setenv "PUPPETEER_EXECUTABLE_PATH" "/usr/bin/chromium")
(setq mermaid-flags "-b transparent")
(setq mermaid-output-format ".png")

(provide 'init-mermaid)
