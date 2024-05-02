;;这一行代码，将函数 open-init-file 绑定到 <f2> 键上
(global-set-key (kbd "<f2>") 'open-init-file)

(global-set-key (kbd "C-h C-f") 'find-function)
(global-set-key (kbd "C-h C-v") 'find-variable)
(global-set-key (kbd "C-h C-k") 'find-function-on-key)

;;显示关键字列表
(global-set-key (kbd "C-s") 'consult-line)
;;差早函数列表
(global-set-key (kbd "M-s i") 'consult-imenu)

;;没什么用,没弄明白,导出的buffer不可写,embark-export-write没有
(define-key minibuffer-local-map (kbd "C-c C-m") 'embark-export-write)

;;C-;iterm2无法传入,所以换个快捷键
(global-set-key (kbd "C-c C-a") 'embark-act)

(global-set-key (kbd "C-c p f") 'project-find-file)
(global-set-key (kbd "C-c p s") 'consult-grep)

(provide 'init-keybindings)
