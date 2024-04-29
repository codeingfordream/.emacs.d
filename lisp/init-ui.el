(global-display-line-numbers-mode 1)

(setq inhibit-startup-screen 1)

(toggle-frame-maximized)

(tool-bar-mode -1)
(menu-bar-mode -1)

;;(scroll-bar-mode -1)
(scroll-all-mode -1)

(setq-default cursor-type '(bar . 5))

;;高亮当前行
(global-hl-line-mode 1)

;;安装主题
;;(use-package monokai-theme)
;;(load-theme 'monokai 1)

;;(use-package doom-themes)
;;(load-theme 'doom-one 1)

(use-package gruvbox-theme)
(load-theme 'gruvbox-dark-medium 1)

(use-package simple
  :ensure nil
  :hook (after-init . size-indication-mode)
  :init
  (progn
    (setq column-number-mode t)
    ))

;; 这里的执行顺序非常重要，doom-modeline-mode 的激活时机一定要在设置global-mode-string 之后‘
;;(use-package doom-modeline
;;  :ensure t
;;
;;  :init
;;  (doom-modeline-mode t))
;;(use-package airline-themes :ensure t)

(require 'powerline)
(powerline-default-theme)

(require 'airline-themes)
(load-theme 'airline-base16_gruvbox_dark_hard  t)

(provide 'init-ui)

