(require 'package)
(add-to-list 'package-archives
	     '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;; TAKE A LOOK HERE!!
;; comment these lines if you need autosave and backup files
(setq make-backup-files nil)
(setq auto-save-default nil)

(setq-default tab-width 3)
(setq shell-file-name "/bin/bash")
(set-frame-font "Ubuntu Mono derivative powerline" '10)
(setq select-enable-clipboard t)
(tool-bar-mode -1)
(which-function-mode 1)
(load-theme 'monokai t)

(smex-initialize)
(ace-popup-menu-mode 1)
(dashboard-setup-startup-hook)
(global-undo-tree-mode)
(nyan-mode)
(yas-global-mode 1)
(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'after-init-hook 'global-flycheck-mode)
(global-git-gutter-mode)

(defun enable-rainbow-delim-mode()
  (add-hook 'c-mode-hook 'rainbow-delimiters-mode)
  (add-hook 'c++-mode-hook 'rainbow-delimiters-mode)
  (add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)
  )

(eval-after-load 'company
  '(add-to-list
    'company-backends '(company-irony-c-headers company-irony)))

(add-hook 'python-mode-hook 'anaconda-mode)
(add-hook 'python-mode-hook 'anaconda-eldoc-mode)

(enable-rainbow-delim-mode)

(global-set-key (kbd "C-M-z") 'kill-whole-line)
(global-set-key (kbd "<f9>") 'hs-minor-mode)
(global-set-key (kbd "C-t") 'hs-toggle-hiding)
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-M-g") 'goto-line)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "<f5>") 'execute-extended-command)
(global-set-key (kbd "<f8>") 'neotree)
(global-set-key (kbd "C-c r") 'vr/replace)
(global-set-key (kbd "C-c q") 'vr/query-replace)
(global-set-key (kbd "C-M-0") 'comment-or-uncomment-region)
(global-set-key (kbd "C-M-e") 'end-of-defun)
(global-set-key (kbd "C-M-a") 'beginning-of-defun)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (cmake-mode coverage comment-tags commenter fish-mode json-mode jvm-mode lua-mode markdown-mode nasm-mode nginx-mode nhexl-mode systemd google-this gist git-gutter magit anaconda-mode company-irony-c-headers flycheck flycheck-color-mode-line flycheck-gometalinter flycheck-pycheckers flycheck-status-emoji company yasnippet nyan-mode highlight-symbol rainbow-delimiters rainbow-identifiers rainbow-mode undo-tree visual-regexp neotree dashboard ace-popup-menu smex monokai-theme))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; clang flags customization
;;  Put in .dir-locals.el project root
;;
;; ((nil . ((company-clang-arguments . ("-I/home/<user>/project_root/include1/"
;;                                      "-I/home/<user>/project_root/include2/"))))) 
