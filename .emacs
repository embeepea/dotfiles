(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(line-move-visual nil))

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(comint-highlight-prompt ((t (:foreground "cyan"))))
 '(dired-directory ((t (:inherit font-lock-function-name-face :foreground "cyan"))))
 '(font-lock-function-name-face ((((class color) (min-colors 88) (background light)) (:foreground "cyan"))))
 '(minibuffer-prompt ((t (:foreground "cyan"))))
)

;; arrange to untabify .js files before saving them
(defun add-auto-untabify-on-save-hook ()
   (make-local-variable 'write-file-functions)
   (add-hook 'write-file-functions
	     (lambda ()
	       (untabify (point-min) (point-max)))))
(add-hook 'js-mode-hook 'add-auto-untabify-on-save-hook)
(add-hook 'js2-mode-hook 'add-auto-untabify-on-save-hook)

;; turn off ridiculous visual line movement behavior, so next-line, previous-line, etc
;; behave as I expect (they operate on logical lines in the buffer, independent of
;; any wrapping):
(setq line-move-visual 'nil)

;; prepend our own personal elisp dir to the load path
(setq load-path (cons "~/lib/emacs/lisp" load-path))

;; arrange to use the js2-mode in our personal elisp dir for editing .js files
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;; load the spec-src-switch library, and bind a key for convenient switching between
;; src and spec files
(load-library "spec-src-switch")
(global-set-key "\C-cs" 'sss-src-spec-switch)

;; some misc convenient key bindings
(global-set-key "\C-xw"         'compare-windows)
(global-set-key "\C-x\C-m"      'set-mark-command)
(global-set-key "\C-xn"         'jump-to-next-window)
(global-set-key "\C-xp"         'jump-to-previous-window)
(global-set-key "\M-g"          'goto-line)
(global-set-key "\M-s"          'center-line)
(global-set-key "\M-r"          'replace-string)
(global-set-key "\M-\C-r"       'replace-regexp)
(global-set-key "\C-x9"         'compile)
(global-set-key "\C-x8"         'next-error)
(global-set-key "\C-x7"         'grep)
