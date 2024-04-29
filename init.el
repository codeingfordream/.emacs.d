;;在文件最开头添加的这个 文件作用域的变量设置，设置变量的绑定方式
;; -*- lexical-binding: t -*-

(add-to-list 'load-path "~/.emacs.d/lisp/")

(require 'init-basic)
(require 'init-funcs)
(require 'init-packages)
(require 'init-completion)
(require 'init-keybindings)
(require 'init-org)
(require 'init-evil)
(require 'init-programming)
(require 'init-tools)
(require 'init-ui)
(require 'init-window)


(setq custom-file (expand-file-name "~/.emacs.d/custom.el"))
(load custom-file 'no-error 'no-message)

