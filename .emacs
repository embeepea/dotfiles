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
(add-hook 'js-mode-hook
 '(lambda ()
    (add-hook 'before-save-hook
      (lambda ()
        (untabify (point-min) (point-max))))))
