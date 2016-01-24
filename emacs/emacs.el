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
(add-to-list 'company-backend 'company-c-headers)
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

;; ecb
(require 'ecb)
(setq ecb-layout-name "leftright2")
(setq ecb-compile-window-height 8)
(setq ecb-create-layout-frame-width 10)
;; Taken from: https://truongtx.me/2013/03/10/ecb-emacs-code-browser/
;;; activate and deactivate ecb
(global-set-key (kbd "C-x C-,") 'ecb-activate)
(global-set-key (kbd "C-x C-'") 'ecb-deactivate)
;;; show/hide ecb window
(global-set-key (kbd "C-;") 'ecb-show-ecb-windows)
(global-set-key (kbd "C-'") 'ecb-hide-ecb-windows)
;;; quick navigation between ecb windows
(global-set-key (kbd "C-)") 'ecb-goto-window-edit1)
(global-set-key (kbd "C-!") 'ecb-goto-window-directories)
(global-set-key (kbd "C-@") 'ecb-goto-window-sources)
(global-set-key (kbd "C-#") 'ecb-goto-window-methods)
(global-set-key (kbd "C-$") 'ecb-goto-window-compilation)

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

;; Header completion
(require 'semantic/bovine/gcc)
(semantic-add-system-include "/usr/lib/gcc/x86_64-unknown-linux-gnu/5.3.0/include" 'c-mode)
(semantic-add-system-include "/usr/lib/gcc/x86_64-unknown-linux-gnu/5.3.0/include-fixed" 'c-mode)
(semantic-add-system-include "/usr/local/include" 'c-mode)
(semantic-add-system-include "/usr/include" 'c-mode)
(semantic-add-system-include "/usr/lib/gcc/x86_64-unknown-linux-gnu/5.3.0/../../../../include/c++/5.3.0" 'c++-mode)
(semantic-add-system-include "/usr/lib/gcc/x86_64-unknown-linux-gnu/5.3.0/../../../../include/c++/5.3.0/x86_64-unknown-linux-gnu" 'c++-mode)

;; More auto-completion
(defun my-c-mode-cedet-hook()
  (add-to-list 'ac-sources 'ac-source-gtags)
  (add-to-list 'ac-sources 'ac-source-semantic)
  )

(add-hook 'c-mode-common-hook 'my-c-mode-cedet-hook)
(add-hook 'c-mode 'company-mode)
(add-hook 'c++-mode 'company-mode)
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
 '(custom-enabled-themes (quote (monokai)))
 '(custom-safe-themes
   (quote
    ("38ba6a938d67a452aeb1dada9d7cdeca4d9f18114e9fc8ed2b972573138d4664" default)))
 '(ecb-options-version "2.40")
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
(global-set-key (kbd "C-M-o") 'highlight-changes-mode)
(global-set-key (kbd "C-M-i") 'iedit-mode)
(global-set-key (kbd "<f6>") 'company-c-headers)
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

(global-semantic-idle-summary-mode 1)
(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)
(global-semantic-decoration-mode 1)
(global-semantic-show-unmatched-syntax-mode 1)
(global-semantic-highlight-func-mode 1)
(global-semantic-idle-local-symbol-highlight-mode 1)
(add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)
(which-function-mode 1)
(global-diff-hl-mode 1)
(electric-pair-mode 1)
