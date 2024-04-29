(require 'eglot)

(use-package treesit-auto
  :demand t
  :init
  (progn
    (setq treesit-font-lock-level 4)
    )
  :config
  (setq treesit-auto-install 'prompt)
  (global-treesit-auto-mode)
  )




















(provide 'init-programming)
