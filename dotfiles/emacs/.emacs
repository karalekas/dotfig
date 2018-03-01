;; SLIME
(load (expand-file-name "~/quicklisp/slime-helper.el"))

;; Path to SBCL implementation
(setq inferior-lisp-program "/usr/local/bin/sbcl")

;; Electric return
(defvar electrify-return-match
  "[\]}\)\"]"
  "If this regexp matches the text after the cursor, do an \"electric\" return.")

(defun electrify-return-if-match (arg)
  "If the text after the cursor matches `electrify-return-match' then
  open and indent an empty line between the cursor and the text.  Move the
  cursor to the new line."
    (interactive "P")
    (let ((case-fold-search nil))
      (if (looking-at electrify-return-match)
      (save-excursion (newline-and-indent)))
      (newline arg)
      (indent-according-to-mode)))

;; Using local-set-key in a mode-hook is a better idea.
(global-set-key (kbd "RET") 'electrify-return-if-match)

;; Robert's SLIME setup
(slime-setup '(slime-fancy
               slime-autodoc
               slime-indentation))

(setq slime-net-coding-system 'utf-8-unix
      slime-truncate-lines nil
      slime-multiprocessing t)

(setq lisp-lambda-list-keyword-parameter-alignment t
      lisp-lambda-list-keyword-alignment t)

;; Some additional settings from Robert
(blink-cursor-mode -1)
(show-paren-mode +1)
(windmove-default-keybindings)
(setq-default indent-tabs-mode nil)
(setq column-number-mode t)
(setq inhibit-startup-screen t)

;; Paredit
(add-to-list 'load-path "~/.emacs.d/lisp")
(autoload 'enable-paredit-mode "paredit"
  "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'ielm-mode-hook #'enable-paredit-mode)
(add-hook 'lisp-mode-hook #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook #'enable-paredit-mode)
(add-hook 'slime-repl-mode-hook (lambda () (paredit-mode +1)))

;; Stop SLIME's REPL from grabbing DEL,
;; which is annoying when backspacing over a '('
(defun override-slime-repl-bindings-with-paredit ()
  (define-key slime-repl-mode-map
    (read-kbd-macro paredit-backward-delete-key) nil))
(add-hook 'slime-repl-mode-hook 'override-slime-repl-bindings-with-paredit)

;; MELPA packages
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; Spaces instead of tabs
(setq-default indent-tabs-mode nil)

;; Color scheme
(load-theme 'sanityinc-tomorrow-night t)

;; Start in full screen
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;;; UI bar settings
(tool-bar-mode -1)
(toggle-scroll-bar -1)
(menu-bar-mode +1)

;; Safe color themes
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("82d2cac368ccdec2fcc7573f24c3f79654b78bf133096f9b40c20d97ec1d8016" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "c7a9a68bd07e38620a5508fef62ec079d274475c8f92d75ed0c33c45fbe306bc" "14f0fbf6f7851bfa60bf1f30347003e2348bf7a1005570fd758133c87dafe08f" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
