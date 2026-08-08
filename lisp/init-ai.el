(require 'gptel)
(require 'gptel-magit)
;; (gptel-make-ollama "Ollama"             ;Any name of your choosing
;;   :host "localhost:11434"               ;Where it's running
;;   :stream t                             ;Stream responses
;;   :models '(mistral:latest))          ;List of models

(global-set-key (kbd "C-c o g") #'gptel)
;; ;; OPTIONAL configuration
;; (setq
;;  gptel-model 'mistral:latest
;;  gptel-backend (gptel-make-ollama "Ollama"
;;                  :host "localhost:11434"
;;                  :stream t
;;                  :models '(mistral:latest)))


;; (gptel-make-deepseek "DeepSeek"       ;Any name you want
;; :stream t                           ;for streaming responses
;; :key "your-api-key")               ;can be a function that returns the key
;; OPTIONAL configuration
(setq gptel-model   'deepseek-v4-flash
      gptel-backend (gptel-make-deepseek "DeepSeek"
                      :stream t
                      :key (lambda ()
                             (let* ((results (auth-source-search :host "api.deepseek.com" :user "apikey"))
                                    (first-match (car results))
                                    (secret-value (plist-get first-match :secret))
                                    (actual-key (if (functionp secret-value)
                                                    (funcall secret-value)
                                                  secret-value)))
                               actual-key))))
;; FOR OpenAI chatgpt
;; (setq gptel-model 'gpt-5.4-mini
;;       gptel-backend (gptel-make-openai-oauth "OpenAI-sub"))


;; (gptel-make-gh-copilot "Copilot")
;; OPTIONAL configuration
;; (setq gptel-model 'gpt-5.2
;;       gptel-backend (gptel-make-gh-copilot "Copilot"))


(setq-default gptel-default-mode 'markdown-mode)

(global-set-key (kbd "C-c g g") 'gptel)
(global-set-key (kbd "C-c g s") 'gptel-send)
(global-set-key (kbd "C-c g r") 'gptel-rewrite)
(global-set-key (kbd "C-c g m") 'gptel-menu)
(global-set-key (kbd "C-c g a") 'gptel-add-file)
(global-set-key (kbd "C-c g A") 'gptel-add)
(global-set-key (kbd "C-c g t") 'gptel-org-set-topic)

;; set property under each heading
;; :PROPERTIES:
;; :gptel-model: gpt-4o
;; :gptel-system: You are a helpful assistant.
;; :END:

(setq gptel-directives
      '(
        (default
         . "​核心思维：运用第一性原理，拒绝经验主义和路径盲从。不要假设我完全清楚目标，若动机模糊请停下讨论；若路径非最优，请直接建议更短、更低成本的办法。\n\n输出结构： 所有的回答必须强制分为两个部分：\n- 直接执行：按照我当前的要求和逻辑，直接给出任务结果。\n- 深度交互：基于底层逻辑对我的原始需求进行“审慎挑战”。包括但不限于：质疑我的动机是否偏离目标（XY问题）、分析当前路径的弊端、并给出更优雅的替代方案。")
        (rewrite
         . "Please rewrite the following words or paragraphs\n1. preserve original length.\n2. maintain original style\n3. correct grammatical errors")
        (super-rewrite
         . "Please rewrite the following words or paragraphs and preserve original length as much as possible. Your rewrite should:\n\n1. **Enhance academic precision** by refining terminology and eliminating ambiguous phrasing\n2. **Strengthen analytical depth** through more sophisticated argumentation, evidence presentation and logical progression between ideas\n3. **Improve technical clarity** by explaining complex concepts more accessibly without sacrificing accuracy\n4. **Adapt stylistic approach** based on content type:\n   - Formal academic tone for research-oriented material\n   - Professional technical style for industry applications\n   - Measured journalistic approach for broader academic dissemination\n5. Finally, point out what you modified")
        (programming
         . "You are a large language model and a careful programmer. Provide code and only code as output without any additional text, prompt or note.")
        (writing
         . "You are a large language model and a writing assistant. Respond concisely.")
        (chat
         . "You are a large language model and a conversation partner. Respond concisely.\n1. When I send a message, immediately check and point out any grammar mistakes or awkward wording.\n2. After feedback, answer my questions or provide your response in advanced, fluent English (above TOEFL 110 or IELTS 8.0 level).\n3. At the end of your response, explain any difficult grammar structures and advanced words you used, using clear English suitable for CET-4 550 level.\n")))

;; (add-hook 'gptel-post-stream-hook 'gptel-auto-scroll)
(add-hook 'gptel-post-response-functions 'gptel-end-of-response)

(provide 'init-ai)
