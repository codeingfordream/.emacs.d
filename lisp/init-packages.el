(require 'package)
(setq package-archives '(("gnu-tuna"    .  "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
			 ("nongnu" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
			 ("melpa-tuna"  .  "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
(package-initialize)

;;防止反复调用 package-refresh-contents 会影响加载速度
(when (not package-archive-contents)
  (package-refresh-contents))

;;; 这个配置一定要配置在 use-package 的初始化之前，否则无法正常安装
(assq-delete-all 'org package--builtins)
(assq-delete-all 'org package--builtin-versions)


;; Setup `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))


(require 'use-package-ensure)
(setq use-package-always-ensure t)


(use-package restart-emacs
  :ensure t)

;;(use-package evil
;;  :ensure t
;;
;;  :init
;;  ;; Enable Evil
;;  (require 'evil)
;;  (evil-mode 1)
;;  )


(use-package quelpa)

(unless (package-installed-p 'quelpa-use-package)
  (quelpa
   '(quelpa-use-package
     :fetcher git
     :url "https://github.com/quelpa/quelpa-use-package.git")))

(use-package quelpa-use-package
  :init
  (setq quelpa-use-package-inhibit-loading-quelpa t)
  :demand t)

(provide 'init-packages)
