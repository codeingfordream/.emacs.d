(use-package evil
  :ensure t
  :init
  ;;默认的按键绑定用处不大
  (setq evil-want-keybinding nil)
  ;;C-u上下滚动
  (setq evil-want-C-u-scroll t)
  (evil-mode)

  ;;在插入模式的时候希望使用emacs的快键键,但又不希望进入emacs state
  ;;将evil-insert-state-map 置为空
  (setcdr evil-insert-state-map nil)
  ;;将esc绑定到evil-insert-state-map
  (define-key evil-insert-state-map [escape] 'evil-normal-state)

  ;;新增空行
  (define-key evil-normal-state-map (kbd "[ SPC") (lambda () (interactive) (evil-insert-newline-above) (forward-line)))
  (define-key evil-normal-state-map (kbd "] SPC") (lambda () (interactive) (evil-insert-newline-below) (forward-line -1)))

  ;;qiehuan buffer
  (define-key evil-normal-state-map (kbd "[ b") 'previous-buffer)
  (define-key evil-normal-state-map (kbd "] b") 'next-buffer)
  (define-key evil-motion-state-map (kbd "[ b") 'previous-buffer)
  (define-key evil-motion-state-map (kbd "] b") 'next-buffer)

  ;;普通模式下dired的按键绑定
  (evil-define-key 'normal dired-mode-map
  ;;打开当期文件
  (kbd "<RET>") 'dired-find-alternate-file
  ;;进入上一级目录
  (kbd "C-k") 'dired-up-directory
  "`" 'dired-open-term
  "q" 'quit-window
  ;;在另一个窗口打开当前文件
  "o" 'dired-find-file-other-window
  ")" 'dired-omit-mode)


  ;; https://emacs.stackexchange.com/questions/46371/how-can-i-get-ret-to-follow-org-mode-links-when-using-evil-mode
  (with-eval-after-load 'evil-maps
    ;;org-mode下有一个链接,按回车键可以访问这个链接
    (define-key evil-motion-state-map (kbd "RET") nil))
  )

;;install undo-tree
(use-package undo-tree
  :diminish
  :init
  (global-undo-tree-mode 1)
  (setq undo-tree-auto-save-history nil)
  (evil-set-undo-system 'undo-tree))

;;使用*对当前词语进行搜索的时候,可以在modeline上显示总共有多少个结果,以及当前在哪个结果上
(use-package evil-anzu
  :ensure t
  :after evil
  :diminish
  :demand t
  :init
  (global-anzu-mode t))

;;社区贡献的按键绑定,有较强的合理性
(use-package evil-collection
  :ensure t
  :demand t
  :config
  ;;移除一些个性化的按键绑定
  (setq evil-collection-mode-list (remove 'lispy evil-collection-mode-list))
  (evil-collection-init)

  (cl-loop for (mode . state) in
	   '((org-agenda-mode . normal)
	     (Custom-mode . emacs)
	     (eshell-mode . emacs)
	     (makey-key-mode . motion))
	   do (evil-set-initial-state mode state)))


;;注释插件
(use-package evil-nerd-commenter
  :init
  (define-key evil-normal-state-map (kbd ",/") 'evilnc-comment-or-uncomment-lines)
  (define-key evil-visual-state-map (kbd ",/") 'evilnc-comment-or-uncomment-lines)
  )


;;用f去查找字符,会高亮所有结果,然耨用;移动到下一个
(use-package evil-snipe
  :ensure t
  :diminish
  :init
  (evil-snipe-mode +1)
  (evil-snipe-override-mode +1)
  )





(use-package general
  :init
  (with-eval-after-load 'evil
    (general-add-hook 'after-init-hook
		      (lambda (&rest _)
			(when-let ((messages-buffer (get-buffer "*Messages*")))
			  (with-current-buffer messages-buffer
			    (evil-normalize-keymaps))))
		      nil
		      nil
		      t))


  (general-create-definer global-definer
    :keymaps 'override
    :states '(insert emacs normal hybrid motion visual operator)
    :prefix "SPC"
    :non-normal-prefix "C-SPC")

  (defmacro +general-global-menu! (name infix-key &rest body)
    "Create a definer named +general-global-NAME wrapping global-definer.
Create prefix map: +general-global-NAME. Prefix bindings in BODY with INFIX-KEY."
    (declare (indent 2))
    `(progn
       (general-create-definer ,(intern (concat "+general-global-" name))
	 :wrapping global-definer
	 :prefix-map ',(intern (concat "+general-global-" name "-map"))
	 :infix ,infix-key
	 :wk-full-keys nil
	 "" '(:ignore t :which-key ,name))
       (,(intern (concat "+general-global-" name))
	,@body)))

  (general-create-definer global-leader
    :keymaps 'override
    :states '(emacs normal hybrid motion visual operator)
    :prefix ","
    "" '(:ignore t :which-key (lambda (arg) `(,(cadr (split-string (car arg) " ")) . ,(replace-regexp-in-string "-mode$" "" (symbol-name major-mode)))))))


(use-package general
  :init
  (global-definer
    ;;SPC !打开shell命令
    "!" 'shell-command
    ;;SPC SPC 相当于M-x
    "SPC" 'execute-extended-command
    "'" 'vertico-repeat
    ;;扩展区域SPC v,再按v不断扩充区域,按-减少选中区域
    "v" 'er/expand-region
    "+" 'text-scale-increase
    "-" 'text-scale-decrease
    ;;因为C-u向上翻滚(vim按键),为了使用emac中的C-u所以绑定到了SPC u
    "u" 'universal-argument
    "hc" 'zilongshanren/clearn-highlight
    "hH" 'zilongshanren/highlight-dwim
    ;;emacs中的C-h f绑定到了SPC hdf
    "hdf" 'describe-function
    ;;emacs中的C-h v绑定到了SPC hdv
    "hdv" 'describe-variable
    ;;emacs中的C-h k绑定到了SPC hdk
    "hdk" 'describe-key

    ;; 这里是其他的快捷键
    "0" 'select-window-0
    "1" 'select-window-1
    "2" 'select-window-2
    "3" 'select-window-3
    "4" 'select-window-4
    "5" 'select-window-5
    ))

(+general-global-menu! "window" "w"
    ;;下面快捷键和教程不一样,我采用的是\,因为是特殊字符,需要反编译一下\字符
    "\\" 'split-window-right
    "-" 'split-window-below
    "m" 'delete-other-windows
    "u" 'winner-undo
    "z" 'winner-redo
    "w" 'esw/select-window
    "s" 'esw/swap-two-windows
    "d" 'esw/delete-window
    "=" 'balance-windows-area
    "r" 'esw/move-window
    "x" 'resize-window
    "H" 'buf-move-left
    "L" 'buf-move-right
    "J" 'buf-move-down
    "K" 'buf-move-up)

;;将和buffer相关归为一组(前缀SPC b)
(+general-global-menu! "buffer" "b"
    "d" 'kill-current-buffer
    ;;SPC b b调用consult-buffer帮忙找到结果
    "b" '(consult-buffer :which-key "consult buffer")
    "B" 'switch-to-buffer
    "p" 'previous-buffer
    "R" 'rename-buffer
    "M" '((lambda () (interactive) (switch-to-buffer "*Messages*"))
	  :which-key "messages-buffer")
    "n" 'next-buffer
    "i" 'ibuffer
    "f" 'my-open-current-directory
    "k" 'kill-buffer
    "y" 'copy-buffer-name
    "K" 'kill-other-buffers)

(use-package iedit
  :ensure t
  :init
  (setq iedit-toggle-key-default nil)
  :config
  (define-key iedit-mode-keymap (kbd "M-h") 'iedit-restrict-function)
  (define-key iedit-mode-keymap (kbd "M-i") 'iedit-restrict-current-line))

;;viw选中光标下的单词,摁下R(选择多个单词),通过vim命令
;;(gg进入第一个单词,G进入最后一个,0进入选中单词的第一个字母,$进入选中字母的最后一个,i进入编辑模式,进行多光标编辑),
;;想要退出,esc进入normal模式,按两下C-g,退出该模式
(use-package evil-multiedit
  :ensure t
  :commands (evil-multiedit-default-keybinds)
  :init
  (evil-multiedit-default-keybinds))



(provide 'init-evil)
