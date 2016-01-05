;; Adding other repositories here
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/")) ;; Melpa
	;;(add-to-list 'package-archives '("name" . "url")) ;; Name
)

;; auto-complete
(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)

;; yasnippet
(require 'yasnippet)
(yas-global-mode 1)

;; auto-complete-c-headers
(defun my:complete-c-cpp-header()
  (require 'auto-complete-c-headers)
  (add-to-list 'ac-sources 'ac-source-c-headers))

(add-hook 'c++-mode-hook 'my:complete-c-cpp-header)
(add-hook 'c-mode-hook 'my:complete-c-cpp-header)

;; lateral numbers
(global-linum-mode 1)

(custom-set-variables

 '(current-language-environment "UTF-8")
 '(custom-enabled-themes (quote (wombat)))
 '(line-number-mode nil))
(custom-set-faces

 '(default ((t (:family "Source Code Pro" :foundry "adobe" :slant normal :weight normal :height 90 :width normal)))))
(global-set-key (kbd "C-M-u") 'memory-usage)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

(global-set-key (kbd "C-M-m") 'minimap-mode)
(global-set-key (kbd "C-M-d") 'diff-hl-mode)

