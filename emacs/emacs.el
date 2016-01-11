;; My emacs configuration
;; Thanks : <http://tuhdo.github.io/c-ide.html> , where I took a lot of this

;; Adding other repositories here
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/")) ;; Melpa
	;;(add-to-list 'package-archives '("name" . "url")) ;; Name
)

;; COMPlete ANYthing mode enabling @ emacs startup
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(setq company-backends (delete 'company-semantic company-backends))

;; run ggtags-create-tags
;; ggtags
(require 'ggtags)
(add-hook 'c-mode-common-hook
 (lambda ()
   (when (derived-mode-p
	  'c-mode
	  'c++-mode
	  'java-mode
	  'asm-mode
	  'python-mode)
   (ggtags-mode 1))))

(define-key ggtags-mode-map (kbd "C-c g s") 'ggtags-find-other-symbol)
(define-key ggtags-mode-map (kbd "C-c g h") 'ggtags-view-tag-history)
(define-key ggtags-mode-map (kbd "C-c g r") 'ggtags-find-reference)
(define-key ggtags-mode-map (kbd "C-c g f") 'ggtags-find-file)
(define-key ggtags-mode-map (kbd "C-c g c") 'ggtags-create-tags)
(define-key ggtags-mode-map (kbd "C-c g u") 'ggtags-update-tags)
(define-key ggtags-mode-map (kbd "M-,") 'pop-tag-mark)
(setq-local imenu-create-index-function #'ggtags-build-imenu-index)
(add-hook 'c-mode-common-hook 'hs-minor-mode)

;; GDB Multi-window
(setq
 gdb-many-windows t
 gdb-show-main t
 )

;; Enabling semantic mode
(semantic-mode 1)
(defun my:semantic_to_ac()
  (add-to-list 'ac-sources 'ac-source-semantic)
  )

;; auto-complete
(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)

;; yasnippet
(require 'yasnippet)
(yas-global-mode 1)

(defun my:acc-c-header-init ()
  (require 'auto-complete-c-headers)
  (add-to-list 'ac-sources 'ac-source-c-headers)
  (add-to-list 'achead:include-directories '" /usr/lib/gcc/x86_64-unknown-linux-gnu/5.3.0/../../../../include/c++/5.3.0
 /usr/lib/gcc/x86_64-unknown-linux-gnu/5.3.0/../../../../include/c++/5.3.0/x86_64-unknown-linux-gnu
 /usr/lib/gcc/x86_64-unknown-linux-gnu/5.3.0/../../../../include/c++/5.3.0/backward
 /usr/lib/gcc/x86_64-unknown-linux-gnu/5.3.0/include
 /usr/local/include
 /usr/lib/gcc/x86_64-unknown-linux-gnu/5.3.0/include-fixed
 /usr/include"
     )
  )
(add-hook 'c-mode-common-hook 'my:semantic_to_ac)
(add-hook 'c-mode 'company-mode)
(add-hook 'c++-mode 'company-mode)
(add-hook 'c-mode 'my:acc-c-header-init)
(add-hook 'c++-mode 'my:acc-c-header-init)
(add-hook 'c-mode-hook '(lambda () 
													(setq ac-sources (append (ac-source-semantic) ac-sources))
													(local-set-key (kbd "RET") 'newline-and-indent)
													(linum-mode 1)
													(semantic-mode t)))
(add-hook 'c++-mode-hook '(lambda ()
			    (setq ac-sources (append (ac-source-semantic) ac-sources))
			    (local-set-key (kbd "RET") 'newline-and-indent)
			    (linum-mode 1)
			    (semantic-mode t)))

(global-set-key (kbd "C-M-c") 'company-complete)
(add-to-list 'company-backends 'company-c-headers)

(semantic-add-system-include "/usr/include")
(setq c-default-style "user")
(global-set-key (kbd "<f5>") (lambda ()
                               (interactive)
                               (setq-local compilation-read-command nil)
                               (call-interactively 'compile)))

;; Python hooks
(add-to-list 'company-backends 'company-jedi)
(add-hook 'python-mode 'elpy-mode)
(add-hook 'python-mode 'jedi-mode)

;; lateral numbers
(global-linum-mode 1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(current-language-environment "UTF-8")
 '(custom-enabled-themes (quote (wombat)))
 '(ede-project-directories
   (quote
    ("/home/stefanozzz123/Devel/C/JASM" "/home/stefanozzz123")))
 '(line-number-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Source Code Pro" :foundry "adobe" :slant normal :weight normal :height 90 :width normal)))))
(global-set-key (kbd "C-M-u") 'memory-usage)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

;; My keybindings
(global-set-key (kbd "C-M-m") 'minimap-mode)
(global-set-key (kbd "C-M-d") 'diff-hl-mode)
(global-set-key (kbd "C-M-p") 'package-list-packages)
(global-set-key (kbd "C-M-s") 'sr-speedbar-open)
(global-set-key (kbd "C-M-c") 'sr-speedbar-close)

;;modeline, to complete
(setq-default
 mode-line-format
 (list
  "%b:%I "
  "| "
  mode-line-mule-info
  mode-line-modified
  " |  "
  "(%02l;%02c):"
  mode-line-position
  " | "
  mode-line-modes
  " | "
  (format-time-string "%H:%M")
  " | "
  (getenv "USER")
  ))

;; colors of modeline
(set-face-background 'mode-line "black") ;; Active 
(set-face-background 'modeline-inactive "grey") ;; Inactive
(set-face-foreground 'mode-line "green") ;; Active 
(set-face-foreground 'modeline-inactive "blue") ;; Inactive

(require 'ede)
(global-ede-mode)
;;(projectile-global-mode)
(setq projectile-enable-caching t)
(global-semantic-idle-summary-mode 1)
(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)
(global-semantic-decoration-mode 1)
(global-semantic-show-unmatched-syntax-mode 1)
(add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)
(which-function-mode 1)
