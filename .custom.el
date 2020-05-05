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

;; 默认全屏
(setq initial-frame-alist (quote ((fullscreen . maximized))))
;; 高亮当前行
(global-hl-line-mode 1)
;; 关闭备份文件
(setq make-backup-files nil)
;; 启用自动括号匹配
(add-hook 'emacs-lisp-mode-hook 'show-paren-mode)

;; 主题配置
;; (load-theme 'solarized-dark t)
(load-theme 'doom-molokai t)


;; 新快捷键设置
(my-space-leader-def
  ;; 命令
  "SPC" 'execute-extended-command
  "j=" 'zenghuajian/astyle
  ;; "/" 'counsel-rg
  "/" 'color-rg-search-input-in-project
  ;; exit
  "qq" 'kill-emacs
  ;; buffer
  "TAB" 'evil-switch-to-windows-last-buffer
  "bb" 'counsel-switch-buffer
  "bd" 'evil-delete-buffer
  "bm" 'toggle-full-window
  ;; file setting
  "fr" 'my-counsel-recentf
  "ff" 'counsel-find-file
  "fs" 'save-buffer
  "fS" 'save-some-buffers
  "fed" 'open-init-file
  ;; switch to cpp h
  ;; "sw" 'switch-source-file
  ;; comment
  "cl" 'evilnc-comment-or-uncomment-lines
  ;; windows setting
  "w TAB" 'ace-window
  "ws" 'ace-swap-window
  "wd" 'delete-windows-on
  "wm" 'delete-other-windows
  "w/" 'split-window-right
  "w-" 'split-window-below
  "wl" 'evil-window-right
  "wh" 'evil-window-left
  "wj" 'evil-window-down
  "wk" 'evil-window-up)

;;定义在cpp文件和.h文件中切换的函数
;;;###autoload
;; (defun switch-source-file ()
;;   (interactive)
;;   (setq file-name (buffer-file-name))
;;   (if (string-match "//.cpp" file-name)
;;       (find-file (replace-regexp-in-string "//.cpp" "/.h" file-name)))
;;   (if (string-match "//.c" file-name)
;;       (find-file (replace-regexp-in-string "//.c" "/.h" file-name)))
;;   (if (string-match "//.h" file-name)
;;       (find-file (replace-regexp-in-string "//.h" "/.cpp" file-name))))

;; 打开配置文件
(defun open-init-file ()
  (interactive)
  (find-file "~/.emacs.d/.custom.el"))

;; Use en_US locale to format time.
;; if not set, the OS locale is used.
(setq system-time-locale "C")

;; 配置esc 为3个esc
(global-set-key (kbd "<escape>")      'keyboard-escape-quit)

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

;;(evil-set-initial-state 'ccls--tree-mode 'emacs)
;;evil-record-macro keybinding clobbers q in cquery-tree-mode-map for some reason?
;;(evil-make-overriding-map 'ccls-tree-mode-map)
(set (make-local-variable 'lsp-disabled-clients) '(clangd cquery))
;; 高亮
(setq ccls-sem-highlight-method 'font-lock)
(ccls-use-default-rainbow-sem-highlight)

;; flymake disable??
(setq lsp-prefer-flymake nil)
(setq-default flycheck-disabled-checkers '(c/c++-clang c/c++-cppcheck c/c++-gcc))

;; 补全显示
(setq company-minimum-prefix-length 1
      company-idle-delay 0.0) ;; default is 0.2

;;use color-rg into side_lisp
(require 'color-rg)

;; no display ispell function
(defun message-off-advice (oldfun &rest args)
  "Quiet down messages in adviced OLDFUN."
  (let ((message-off (make-symbol "message-off")))
    (unwind-protect
    (progn
      (advice-add #'message :around #'ignore (list 'name message-off))
      (apply oldfun args))
    (advice-remove #'message message-off))))

(advice-add #'ispell-init-process :around #'message-off-advice)

;; 内置拼音pyim配置
(use-package pyim
  :ensure nil
  :demand t
  :config
  ;; 激活 basedict 拼音词库，五笔用户请继续阅读 README
  (use-package pyim-basedict
    :ensure nil
    :config (pyim-basedict-enable))

  (setq default-input-method "pyim")

  ;; 我使用全拼
  (setq pyim-default-scheme 'quanpin)

  ;; 设置 pyim 探针设置，这是 pyim 高级功能设置，可以实现 *无痛* 中英文切换 :-)
  ;; 我自己使用的中英文动态切换规则是：
  ;; 1. 光标只有在注释里面时，才可以输入中文。
  ;; 2. 光标前是汉字字符时，才能输入中文。
  ;; 3. 使用 M-j 快捷键，强制将光标前的拼音字符串转换为中文。
  (setq-default pyim-english-input-switch-functions
                '(pyim-probe-dynamic-english
                  pyim-probe-isearch-mode
                  pyim-probe-program-mode
                  pyim-probe-org-structure-template))

  (setq-default pyim-punctuation-half-width-functions
                '(pyim-probe-punctuation-line-beginning
                  pyim-probe-punctuation-after-punctuation))

  ;; 开启拼音搜索功能
  (pyim-isearch-mode 1)

  ;; 使用 popup-el 来绘制选词框, 如果用 emacs26, 建议设置
  ;; 为 'posframe, 速度很快并且菜单不会变形，不过需要用户
  ;; 手动安装 posframe 包。
  (setq pyim-page-tooltip 'popup)

  ;; 选词框显示5个候选词
  (setq pyim-page-length 5)

  :bind
  (("M-j" . pyim-convert-string-at-point) ;与 pyim-probe-dynamic-english 配合
   ("C-;" . pyim-delete-word-from-personal-buffer)))

;; 配置sdcv
(setq sdcv-dictionary-data-dir "~/.emacs.d/.startdic")

