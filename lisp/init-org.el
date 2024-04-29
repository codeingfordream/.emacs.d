;开启easy template
(require 'org-tempo)

;; 安装org 之前，一定要配置 use-package 不使用内置的org 版本，可以使用本段代码最后面的代码，具体位置可以参考视频
(use-package org
  :pin melpa-tuna
  :ensure t)

(use-package org-contrib
  :pin nongnu
  :ensure t)

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "STARTED(s)" "|" "DONE(d!/!)")
	      (sequence "WAITING(w@/!)" "SOMEDAY(S)" "|" "CANCELLED(c@/!)" "MEETING(m)" "PHONE(p)"))))

(require 'org-checklist)
;; need repeat task and properties
(setq org-log-done t)
(setq org-log-into-drawer t)

(global-set-key (kbd "C-c a") 'org-agenda)
;;(setq org-agenda-files '("~/gtd.org"))
(setq org-agenda-files '("~/.emacs.d/gtd.org"))
(setq org-agenda-span 'day)

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/.emacs.d/gtd.org" "Workspace")
	 "* TODO [#B] %?\n  %i\n %U"
	 :empty-lines 1)))

(global-set-key (kbd "C-c r") 'org-capture)

(setq org-agenda-custom-commands
      '(("c" "重要且紧急的事"
	 ((tags-todo "+PRIORITY=\"A\"")))
	;; ...other commands here
	))

(use-package ox-hugo
  :ensure t   ;Auto-install the package from Melpa
  :pin melpa-tuna  ;`package-archives' should already have ("melpa" . "https://melpa.org/packages/")
  :after ox)

(with-eval-after-load 'org-capture
  (defun org-hugo-new-subtree-post-capture-template ()
    "Returns `org-capture' template string for new Hugo post.
See `org-capture-templates' for more information."
    (let* ((title (read-from-minibuffer "Post Title: ")) ;Prompt to enter the post title
           (fname (org-hugo-slug title)))
      (mapconcat #'identity
                 `(
                   ,(concat "* TODO " title)
                   ":PROPERTIES:"
                   ,(concat ":EXPORT_FILE_NAME: " fname)
                   ":END:"
                   "\n\n")          ;Place the cursor here finally
                 "\n")))

  (add-to-list 'org-capture-templates
               '("h"                ;`org-capture' binding + h
                 "Hugo post"
                 entry
                 ;; It is assumed that below file is present in `org-directory'
                 ;; and that it has a "Blog Ideas" heading. It can even be a
                 ;; symlink pointing to the actual location of all-posts.org!
                 (file+headline "/home/dream/blog/all-blog.org" "Blog Ideas")
                 (function org-hugo-new-subtree-post-capture-template))))

(provide 'init-org)
