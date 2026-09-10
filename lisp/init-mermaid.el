;; -*- lexical-binding: t; -*-

(require-package 'mermaid-mode "https://github.com/abrochard/mermaid-mode")
(require 'mermaid-mode)
(require-package 'ob-mermaid "https://github.com/arnm/ob-mermaid")
(require 'ob-mermaid)

(setenv "PUPPETEER_EXECUTABLE_PATH" "/usr/bin/chromium")
(setq mermaid-flags "-b transparent")
(setq mermaid-output-format ".png")

(provide 'init-mermaid)
