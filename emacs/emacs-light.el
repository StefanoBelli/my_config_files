(prefer-coding-system 'utf-8)
;; Adding other repositories here
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/")) ;; Melpa
	;;(add-to-list 'package-archives '("name" . "url")) ;; Name
)

(tool-bar-mode -1)

;; Auto indentation
(define-key global-map (kbd "RET") 'newline-and-indent)

;; lateral numbers
(global-linum-mode 1)

;; yasnippet
(require 'yasnippet)
(yas-global-mode 1)

;; COMPlete ANYthing mode enabling @ emacs startup
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(add-to-list 'company-backend 'company-c-headers)
(setq company-backends (delete 'company-semantic company-backends))
(company-mode 1)

;; auto-complete
(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)

;; flymake-ruby
(require 'flymake-ruby)
(add-hook 'ruby-mode-hook 'flymake-ruby-load)
(add-hook 'ruby-mode-hook 'robe-mode)
(add-hook 'ruby-mode-hook 'ruby-accurate-end-of-block)
(add-hook 'ac-modes 'enh-ruby-mode)

;; Enabling semantic mode
(semantic-mode 1)
(defun my:semantic_to_ac()
  (add-to-list 'ac-sources 'ac-source-semantic)
  )

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

;; Python
(add-to-list 'company-backends 'company-jedi)
(add-hook 'python-mode 'elpy-mode)
(add-hook 'python-mode 'jedi-mode)
(add-hook 'python-mode 'anaconda-mode)

;; GDB Multi-window
(setq
 gdb-many-windows t
 gdb-show-main t
 )

;; go
(require 'go-eldoc)
(add-hook 'go-mode-hook 'go-eldoc-setup)

;; Enabling semantic mode
(semantic-mode 1)
(defun my:semantic_to_ac()
  (add-to-list 'ac-sources 'ac-source-semantic)
  )

;; My keybindings

(global-set-key (kbd "C-M-m") 'minimap-mode) ;; Opens a window contain source's minimap
(global-set-key (kbd "C-M-d") 'diff-hl-mode) ;; enables diff-hl-mode
(global-set-key (kbd "C-M-p") 'package-list-packages) ;; Opens package manager
(global-set-key (kbd "C-M-s") 'sr-speedbar-open) ;; Opens speedbar
(global-set-key (kbd "C-M-c") 'sr-speedbar-close) ;; Closes speedbar
(global-set-key (kbd "C-M-o") 'highlight-changes-mode) ;; Highlight changes since last edit
(global-set-key (kbd "C-M-i") 'iedit-mode) ;; Starts iedit mode (great)
(global-set-key (kbd "<f6>") 'company-c-headers) ;; completes headers under point
(global-set-key (kbd "C-M-g") 'man-follow) ;; opens another window which contain under point string's man 
(global-set-key (kbd "C-M-f") 'man) ;; Asks for man entry 

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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes (quote (suscolors)))
 '(custom-safe-themes
   (quote
    ("97d039a52cfb190f4fd677f02f7d03cf7dbd353e08ac8a0cb991223b135ac4e6" default)))
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(global-semantic-idle-summary-mode 1)
(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)
(global-semantic-decoration-mode 1)
(global-semantic-show-unmatched-syntax-mode 1)
(global-semantic-highlight-func-mode 1)
(global-semantic-idle-local-symbol-highlight-mode 1)
(add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)
(which-function-mode 1)
;;(global-diff-hl-mode)
(electric-pair-mode 1)
