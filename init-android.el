;;; init.el --- Android-friendly Emacs configuration -*- lexical-binding: t; -*-

;;; 启动阶段提高 GC 阈值
(setq gc-cons-threshold (* 64 1024 1024)
      gc-cons-percentage 0.2)
(add-hook
 'emacs-startup-hook
 (lambda ()
   (setq gc-cons-threshold (* 16 1024 1024)
         gc-cons-percentage 0.1)))

(setq inhibit-startup-screen t
      inhibit-startup-message t
      initial-scratch-message nil
      ring-bell-function #'ignore
      use-dialog-box nil)

(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

(column-number-mode 1)

;; 平滑滚动
(when (fboundp 'pixel-scroll-precision-mode)
  (pixel-scroll-precision-mode 1))

(setq scroll-conservatively 101
      scroll-margin 2)


;;; Android 触屏优化

;; 长按拖动时按“单词”选择，比精确选字符更适合手指。
(when (boundp 'touch-screen-word-select)
  (setq touch-screen-word-select t))

;; 允许再次拖动来扩展已有选区。
(when (boundp 'touch-screen-extend-selection)
  (setq touch-screen-extend-selection t))

;; 拖动选择时在 echo area 显示位置。
(when (boundp 'touch-screen-preview-select)
  (setq touch-screen-preview-select t))

;; 避免误触造成横向滚动。
(when (boundp 'touch-screen-enable-hscroll)
  (setq touch-screen-enable-hscroll nil))


;;; UTF-8 / 中文

(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8-unix)

(setq default-buffer-file-coding-system 'utf-8-unix)

(load-theme 'modus-operandi-tinted)

;;; 编辑体验

(electric-pair-mode 1)
(show-paren-mode 1)

(setq-default
 indent-tabs-mode nil
 tab-width 4
 fill-column 80)

(global-visual-line-mode)
(global-hl-line-mode)


(cond
 ((fboundp 'fido-vertical-mode)
  (fido-vertical-mode 1))
 ((fboundp 'icomplete-vertical-mode)
  (icomplete-vertical-mode 1)))
(when (fboundp 'minibuffer-depth-indicate-mode)
  (minibuffer-depth-indicate-mode 1))


;;; 历史记录 / 最近文件 / 光标位置

(savehist-mode 1)
(save-place-mode 1)

(require 'recentf)

(setq recentf-max-saved-items 100
      recentf-max-menu-items 20)

(recentf-mode 1)

;; 文件被其他 Android App 修改后自动刷新。
(global-auto-revert-mode 1)

(setq global-auto-revert-non-file-buffers t)


(let ((backup-dir
       (expand-file-name "backup/" user-emacs-directory))
      (autosave-dir
       (expand-file-name "auto-save/" user-emacs-directory)))

  (make-directory backup-dir t)
  (make-directory autosave-dir t)

  (setq backup-directory-alist
        `(("." . ,backup-dir)))

  (setq auto-save-file-name-transforms
        `((".*" ,autosave-dir t))))

(setq make-backup-files nil
      auto-save-default nil
      version-control t
      delete-old-versions t
      kept-new-versions 5
      kept-old-versions 2)




;;; ------------------------------------------------------------
;;; 16. Package.el
;;; ------------------------------------------------------------

(require 'package)

(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")))

;; 不在启动时自动联网刷新软件包列表。
;; 第一次需要安装包时手动：
;;
;; M-x package-refresh-contents
;; M-x package-list-packages


;;; ------------------------------------------------------------
;;; 17. 可选字体设置
;;; ------------------------------------------------------------

(set-face-attribute 'default nil :height 150)
(setq image-scaling-factor 3.0
      tool-bar-button-margin 10)
(add-hook 'emacs-startup-hook
          (lambda ()
            (when (fboundp 'tool-bar--flush-cache)
              (tool-bar--flush-cache))
            (clear-image-cache t)
            (force-mode-line-update t)))

;;; Dired
(setq dired-kill-when-opening-new-dired-buffer t
      delete-by-moving-to-trash t
      dired-hide-details-preserved-columns '(6 7 8))
(add-hook 'dired-mode-hook #'dired-hide-details-mode)



;;; Org Mode
(with-eval-after-load 'org
  ;; 手机屏幕下比大量星号好看。
  (setq org-startup-indented t
        org-hide-leading-stars nil
        org-indent-mode-turns-on-hiding-stars nil
        ))

(setq default-directory "/sdcard/Documents/roam/")
(add-hook 'emacs-startup-hook
          (lambda ()
            (dired default-directory)))

;;; init.el ends here
