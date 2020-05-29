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

;; 设置用户名与邮箱
(setq user-full-name "HuaJianZeng")
(setq user-mail-address "zhj12ab@163.com")

;; 设置字体
(when *win64*
(set-fontset-font "fontset-default" 'unicode'("等距更纱黑体 T SC"))
(set-fontset-font "fontset-default" 'gb18030'("等距更纱黑体 T SC". "unicode-bmp"))
(dolist (param '((font . "等距更纱黑体 T SC")))
  (add-to-list 'default-frame-alist param)
  (add-to-list 'initial-frame-alist param))
  )

(when *linux*
(set-fontset-font "fontset-default" 'unicode'("Sarasa Mono T SC"))
(set-fontset-font "fontset-default" 'gb18030'("Sarasa Mono T SC". "unicode-bmp"))
(dolist (param '((font . "Sarasa Mono T SC")))
  (add-to-list 'default-frame-alist param)
  (add-to-list 'initial-frame-alist param))
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
  ;; lsp-rename
  "lr" 'lsp-rename
  ;; goto define
  "lfd" 'lsp-find-definition
  "lfr" 'lsp-find-references
  ;; file setting
  "fr" 'my-counsel-recentf
  "ff" 'counsel-find-file
  "fs" 'save-buffer
  "fS" 'save-some-buffers
  "fed" 'open-init-file
  ;; switch to cpp h
  "sw" 'ff-find-other-file

  ;; windows setting
  "ws" 'ace-swap-window
  "wd" 'delete-windows-on
  "wm" 'delete-other-windows
  "w/" 'split-window-right
  "w-" 'split-window-below
  "wl" 'evil-window-right
  "wh" 'evil-window-left
  "wj" 'evil-window-down
  "wk" 'evil-window-up)

;; (define-key company-active-map (kbd "C-n") (lambda () (interactive) (company-complete-common-or-cycle 1)))
;; (define-key company-active-map (kbd "C-p") (lambda () (interactive) (company-complete-common-or-cycle -1)))

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
  ;; (save-buffer)
  ;; "Run astyle on region or buffer"
  (interactive (if mark-active
                   (list (region-beginning) (region-end))
                 (list (point-min) (point-max))
                 ))
  (save-restriction
    (shell-command-on-region start end
                             astyle-command
                             (current-buffer) t
;;                             (get-buffer-create "*Astyle Errors*") t
                             ))
  (goto-char 1)
  (forward-line astyle-nowlinenum))

;; 使用use-package
(require-package 'use-package)
(require-package 'ccls)
(require-package 'lsp-ui)

;; 设置ccls 和 lsp
(use-package lsp-mode
  :commands lsp
  :init
  ;; @see https://github.com/emacs-lsp/lsp-mode#performance
  (setq read-process-output-max (* 1024 1024)) ;; 1MB
  (setq lsp-auto-guess-root t
  lsp-prefer-flymake nil
  lsp-restart 'auto-restart
  lsp-signature-auto-activate nil
  lsp-log-io nil
  lsp-enable-file-watchers nil
  lsp-enable-folding nil
  lsp-enable-snippet nil
  lsp-enable-on-type-formatting nil
  lsp-enable-symbol-highlighting nil
  lsp-enable-links nil)
  :config
  (with-no-warnings
    (defun my-lsp--init-if-visible (func &rest args)
      "Not enabling lsp in `git-timemachine-mode'."
      (unless (bound-and-true-p git-timemachine-mode)
        (apply func args)))
    (advice-add #'lsp--init-if-visible :around #'my-lsp--init-if-visible))
  (require 'lsp-clients)
  )

;; (use-package lsp-ui :commands lsp-ui-mode)
(use-package lsp-ui
  :custom-face
  (lsp-ui-sideline-code-action ((t (:inherit warning))))
  :hook (lsp-mode . lsp-ui-mode)
  :init (setq lsp-ui-doc-enable nil
              lsp-ui-doc-use-webkit nil
              lsp-ui-doc-delay 0.2
              lsp-ui-doc-include-signature t
              lsp-ui-doc-position 'at-point
              lsp-ui-doc-border (face-foreground 'default)
              lsp-eldoc-enable-hover t ; Disable eldoc displays in minibuffer

              lsp-ui-sideline-enable t
              lsp-ui-sideline-show-hover t
              lsp-ui-sideline-show-diagnostics t
              lsp-ui-sideline-show-code-actions t
              lsp-ui-sideline-ignore-duplicate t

              lsp-ui-imenu-enable t
              lsp-ui-imenu-colors `(,(face-foreground 'font-lock-keyword-face)
                                    ,(face-foreground 'font-lock-string-face)
                                    ,(face-foreground 'font-lock-constant-face)
                                    ,(face-foreground 'font-lock-variable-name-face)))
  :config
  (add-to-list 'lsp-ui-doc-frame-parameters '(right-fringe . 8))

  ;; `C-g'to close doc
  (advice-add #'keyboard-quit :before #'lsp-ui-doc-hide)

  ;; Reset `lsp-ui-doc-background' after loading theme
  (add-hook 'after-load-theme-hook
            (lambda ()
              (setq lsp-ui-doc-border (face-foreground 'default))
              (set-face-background 'lsp-ui-doc-background
                                   (face-background 'tooltip)))))

;; company-lsp
(use-package company-lsp :commands company-lsp)
;; if you are ivy user
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

(use-package ccls
  :init
  ;;(evil-set-initial-state 'ccls--tree-mode 'emacs)
  ;;evil-record-macro keybinding clobbers q in cquery-tree-mode-map for some reason?
  ;;(evil-make-overriding-map 'ccls-tree-mode-map)
  (set (make-local-variable 'lsp-disabled-clients) '(clangd cquery))
  ;; 高亮
  (setq ccls-sem-highlight-method 'font-lock)
  :hook ((c-mode cc-mode c++-mode objc-mode cuda-mode) .
         (lambda () (require 'ccls) (lsp))))

(ccls-use-default-rainbow-sem-highlight)

;; flymake disable??
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
  ;; (setq pyim-page-tooltip 'popup)
  (setq pyim-page-tooltip 'posframe)

  ;; 选词框显示5个候选词
  (setq pyim-page-length 5)

  :bind
  (("C-;" . pyim-convert-string-at-point) ;与 pyim-probe-dynamic-english 配合
   ;;("C-;" . pyim-delete-word-from-personal-buffer)
   ))

(set-terminal-coding-system 'utf-8)
(modify-coding-system-alist 'process "*" 'utf-8)
(prefer-coding-system 'utf-8)
(setq default-process-coding-system '(utf-8 . utf-8))

(setq sdcv-dictionary-data-dir (expand-file-name (concat my-emacs-d ".stardict")))

;; export ort to docx
(defun org-export-docx ()
  (interactive)
  (let ((docx-file (concat (file-name-sans-extension (buffer-file-name)) ".docx"))
           (template-file "~/.emacs.d/template/template.docx"))
    (shell-command (format "pandoc %s -o %s --reference-doc=%s" (buffer-file-name) docx-file template-file))
    (message "Convert finish: %s" docx-file)))

;; 配置路径
(when *win64*
(setenv "PATH" "C:\\extern_exec;C:\\extern_exec\\Aspell\\bin;C:\\extern_exec\\glo663wb\\bin;C:\\cygwin64\\bin;C:\\msys64\\mingw64\\bin;C:\\msys64\\usr\\bin;C:\\Windows\\System32;C:\\WINDOWS\\System32\\WindowsPowerShell\\v1.0")
;; 配置sdcv
(setq sdcv-program "C:\\cygwin64\\bin\\sdcv.exe")
 )

;; evil-numbers
(require 'evil-numbers)
(define-key evil-normal-state-map (kbd "C-c a") 'evil-numbers/inc-at-pt)
(define-key evil-visual-state-map (kbd "C-c a") 'evil-numbers/inc-at-pt)

(define-key evil-normal-state-map (kbd "C-c d") 'evil-numbers/dec-at-pt)
(define-key evil-visual-state-map (kbd "C-c d") 'evil-numbers/dec-at-pt)
;; end of .custom.el