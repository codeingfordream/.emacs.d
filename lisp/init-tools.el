;;modeline上显示我的所有按键和执行命令
;;(use-package keycast)
;;(add-to-list 'global-mode-string '("" keycast-mode-line))
;;(keycast-mode t)

(defun my/search-project-for-symbol-at-point ()
  (interactive)
  (if (use-region-p)
      (progn
	;;因为电脑系统原因装不了ripgrep从而选用consult-grep,故做了更改
	;;(consult-ripgrep (project-root (project-current))
	(consult-grep (project-root (project-current))
			 (buffer-substring (region-beginning) (region-end))))))

;;do what i mean(dwim)
(defun zilongshanren/highlight-dwim ()
  (interactive)
  (if (use-region-p)
      (progn
        (highlight-frame-toggle)
        (deactivate-mark))
    (symbol-overlay-put)))

(use-package expand-region
  :config
  (defadvice er/prepare-for-more-expansions-internal
      (around helm-ag/prepare-for-more-expansions-internal activate)
    ad-do-it
    (let ((new-msg (concat (car ad-return-value)
			   ", H to highlight in buffers"
			   ", / to search in project, "
			   "e iedit mode in functions"
			   "f to search in files, "
			   "b to search in opened buffers"))
	  (new-bindings (cdr ad-return-value)))
      (cl-pushnew
       '("H" (lambda ()
	       (interactive)
	       (call-interactively
		'zilongshanren/highlight-dwim)))
       new-bindings)
      (cl-pushnew
       '("/" (lambda ()
	       (interactive)
	       (call-interactively
		'my/search-project-for-symbol-at-point)))
       new-bindings)
      (cl-pushnew
       ;;SPC v选中单词,按e键选中多个单词,就是多光标编辑
       '("e" (lambda ()
	       (interactive)
	       (call-interactively
		'evil-multiedit-match-all)))
       new-bindings)
      (cl-pushnew
       '("f" (lambda ()
	       (interactive)
	       (call-interactively
		'find-file)))
       new-bindings)
      (cl-pushnew
       ;;SPC v绑定单词(作为一个入口,也可以理解为对选中位置到文件结尾进行搜索),按b键调用consult-line进行搜索,虽然也不知道有什么用
       '("b" (lambda ()
	       (interactive)
	       (call-interactively
		'consult-line)))
       new-bindings)
      (setq ad-return-value (cons new-msg new-bindings)))))


;;交互式的替换SPC v选中想要替换的单词,然后快捷键C-r,再进行替换
(defun zilongshanren/evil-quick-replace (beg end)
  (interactive "r")
  (when (evil-visual-state-p)
    (evil-exit-visual-state)
    (let ((selection (regexp-quote (buffer-substring-no-properties beg end))))
      (setq command-string (format "%%s /%s//g" selection))
      (minibuffer-with-setup-hook
	  (lambda () (backward-char 2))
	(evil-ex command-string)))))


;;这条命令所在的文件放在较前面会报错(evil-visual-state-map 无效).
(define-key evil-visual-state-map (kbd "C-r") 'zilongshanren/evil-quick-replace)

(defun zilongshanren/clearn-highlight ()
  (interactive)
  (clear-highlight-frame)
  (symbol-overlay-remove-all))

(use-package symbol-overlay
  :config
  (define-key symbol-overlay-map (kbd "h") 'nil)
  )

(use-package highlight-global
  :ensure nil
  :commands (highlight-frame-toggle)
  :quelpa (highlight-global :fetcher github :repo "glen-dai/highlight-global")
  :config
  (progn
    (setq-default highlight-faces
		  '(('hi-red-b . 0)
		    ('hi-aquamarine . 0)
		    ('hi-pink . 0)
		    ('hi-blue-b . 0)))))

;;安装终端vterm
(use-package vterm
  :ensure t)

(use-package vterm-toggle
  :ensure t)


(provide 'init-tools)


