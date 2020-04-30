;; -*- coding: utf-8; lexical-binding: t; -*-

;; 设置源

;; 猪场
;; (setq configuration-layer-elpa-archives
;; '(("melpa-cn" . "http://mirrors.163.com/elpa/melpa/")
;;  ("org-cn"   . "http://mirrors.163.com/elpa/org/")
;;  ("gnu-cn"   . "http://mirrors.163.com/elpa/gnu/")))

;; 鹅厂
;;(setq configuration-layer-elpa-archives
;;    '(("melpa-cn" . "http://mirrors.cloud.tencent.com/elpa/melpa/")
;;      ("org-cn"   . "http://mirrors.cloud.tencent.com/elpa/org/")
;;      ("gnu-cn"   . "http://mirrors.cloud.tencent.com/elpa/gnu/")))
;;
;; 清华
;;(setq configuration-layer-elpa-archives
;;    '(("melpa-cn" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
;;      ("org-cn"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/org/")
;;      ("gnu-cn"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")))
;;
;; Emacs China
;;(setq configuration-layer-elpa-archives
;;    '(("melpa-cn" . "http://elpa.emacs-china.org/melpa/")
;;      ("org-cn"   . "http://elpa.emacs-china.org/org/")
;;      ("gnu-cn"   . "http://elpa.emacs-china.org/gnu/")))
;;
;; 默认全屏
(setq initial-frame-alist (quote ((fullscreen . maximized))))
;; 高亮当前行
(global-hl-line-mode 1)
;; 关闭备份文件
(setq make-backup-files nil)
;; 启用自动括号匹配
(add-hook 'emacs-lisp-mode-hook 'show-paren-mode)

;; 主题配置
(load-theme 'solarized-dark t)

;; 设置字体
(set-fontset-font "fontset-default" 'unicode'("等距更纱黑体 T SC"))
(dolist (param '(
                 (font . "等距更纱黑体 T SC")
                 ))
  (add-to-list 'default-frame-alist param)
  (add-to-list 'initial-frame-alist param)
  )
;; ;; 设置字体
;; ;; Setting English Font
;; (set-face-attribute
;;  'default nil :font "DejaVu Sans Mono 11")
;; ;; Setting Chinese Font
;; (dolist (charset '(kana han symbol cjk-misc bopomofo))
;;   (set-fontset-font (frame-parameter nil 'font)
;;             charset
;;             (font-spec :family "Microsoft Yahei" :size 14)))


;; 新快捷键设置
(my-space-leader-def
  ;; 命令
  "SPC" 'execute-extended-command
  "j=" 'zenghuajian/astyle
  "/" 'counsel-rg
  ;; exit
  "qq" 'kill-emacs
  ;; buffer
  "TAB" 'evil-switch-to-windows-last-buffer
  "bb" 'counsel-switch-buffer
  "bd" 'evil-delete-buffer
  "bm" 'zenghuajian/toggle-maximize-buffer
  ;; file setting
  "fr" 'my-counsel-recentf
  "ff" 'counsel-find-file
  "fs" 'save-buffer
  "fS" 'save-some-buffers
  "fed" 'open-init-file
  ;; windows setting
  "wd" 'delete-window-on
  "wD" 'delete-other-windows
  "w/" 'split-window-right
  "w-" 'split-window-down
  "wl" 'evil-window-right
  "wh" 'evil-window-left
  "wj" 'evil-window-down
  "wk" 'evil-window-up)

;; 打开配置文件
(defun open-init-file ()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

;; Use en_US locale to format time.
;; if not set, the OS locale is used.
(setq system-time-locale "C")

;; 配置esc 为3个esc
(global-set-key (kbd "<escape>")      'keyboard-escape-quit)

;; 当前buffer 最大化
(defun zenghuajian/toggle-maximize-buffer ()
  "Maximize buffer"
  (interactive)
  (save-excursion
    (if (and (= 1 (length (window-list)))
             (assoc ?_ register-alist))
        (jump-to-register ?_)
      (progn
        (window-configuration-to-register ?_)
        (delete-other-windows)))))

;; 使用astyl 格式化
(defun zenghuajian/astyle (start end)
  (setq astyle-command "astyle -A1Lfpjk3NS")
  (setq astyle-nowlinenum (line-number-at-pos))
  "Run astyle on region or buffer"
  (interactive (if mark-active
                   (list (region-beginning) (region-end))
                 (list (point-min) (point-max))
                 ))
  (save-restriction
    (shell-command-on-region start end
                             astyle-command
                             (current-buffer) t
                             (get-buffer-create "*Astyle Errors*") t))
  (goto-char 1)
  (forward-line astyle-nowlinenum))
;; 使用use-package
(require-package 'use-package)
(require-package 'ccls)

;; 设置ccls 和 lsp
(use-package lsp-mode
  :commands lsp
  :init
  (setq lsp-auto-guess-root t)
  (setq lsp-prefer-flymake t)
  (setq lsp-restart 'auto-restart)
  (setq lsp-log-io nil)
  (setq lsp-enable-folding nil)
  (setq lsp-enable-snippet nil)
  (setq lsp-enable-symbol-highlighting nil)
  (setq lsp-enable-links nil)
  :config
  (require 'lsp-clients)
  )
(use-package lsp-ui :commands lsp-ui-mode)
(use-package company-lsp :commands company-lsp)
;; if you are ivy user
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

(use-package ccls
  :hook ((c-mode cc-mode c++-mode objc-mode cuda-mode) .
         (lambda () (require 'ccls) (lsp))))

;; 补全显示
(setq company-minimum-prefix-length 1
      company-idle-delay 0.0) ;; default is 0.2

;; ;; 括号高亮
;; (require-package 'highlight-parentheses)
;; (define-globalized-minor-mode global-highlight-parentheses-mode
;;   highlight-parentheses-mode
;;   (lambda ()
;;     (highlight-parentheses-mode t)))
;; (global-highlight-parentheses-mode t)

;; ;; 陈斌推荐lsp mode
;; (with-eval-after-load 'lsp-mode
;;   ;; enable log only for debug
;;   (setq lsp-log-io nil)
;;   ;; use `evil-matchit' instead
;;   (setq lsp-enable-folding nil)
;;   ;; no real time syntax check
;;   (setq lsp-diagnostic-package :none)
;;   ;; handle yasnippet by myself
;;   (setq lsp-enable-snippet nil)
;;   ;; use `company-ctags' only.
;;   ;; Please note `company-lsp' is automatically enabled if it's installed
;;   (setq lsp-enable-completion-at-point nil)
;;   ;; turn off for better performance
;;   (setq lsp-enable-symbol-highlighting nil)
;;   ;; use find-fine-in-project instead
;;   (setq lsp-enable-links nil)
;;   ;; auto restart lsp
;;   (setq lsp-restart 'auto-restart)
;;   ;; don't watch 3rd party javascript libraries
;;   (push "[/\\\\][^/\\\\]*\\.\\(json\\|html\\|jade\\)$" lsp-file-watch-ignored)
;;   ;; don't ping LSP lanaguage server too frequently
;;   (defvar lsp-on-touch-time 0)
;;   (defadvice lsp-on-change (around lsp-on-change-hack activate)
;;     ;; do run `lsp-on-change' too frequently
;;     (when (> (- (float-time (current-time))
;;                 lsp-on-touch-time) 30) ;; 30 seconds
;;       (setq lsp-on-touch-time (float-time (current-time)))
;;       ad-do-it)))