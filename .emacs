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

(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                                            
;;                                                                                                                            
;; Beginning of functions to support easy switching between 'src' and 'spec' files                                            
;;                                                                                                                            

(defun replace-last-substring (string substring replacement)
  "Replace the last occurrence of SUBSTRING in STRING with REPLACEMENT; returns the result as a new string."
  (if (string-match substring string)
      (let (
            (parts (split-string string substring))
            )
        (concat
         (mapconcat 'identity (reverse (cdr (reverse parts))) substring)
         replacement
         (car (last parts))
         )
        )
      string
    )
  )

(defun visit-related-file (this-component related-component other-window)
  "Visit a file whose path is related to the current buffer's file by replacing                                               
the last occurrence of THIS-COMPONENT with RELATED-COMPONENT. If OTHER-WINDOW                                                 
is non-nil, visit the new file in a separate window; otherwise visit in the                                                   
current buffer window."
  (let (
        (this-substring (concat "/" this-component "/"))
        (related-substring (concat "/" related-component "/"))
        (filename (buffer-file-name))
        )
    (if (string-match this-substring filename)
        (let (
              (related-file-name (replace-last-substring filename this-substring related-substring))
              )
          (if other-window
              (find-file-other-window related-file-name)
            (find-file related-file-name)
            )
          )
      (message (concat "The current buffer does not appear to be visiting a " this-component " file"))
      )
    )
  )

(defun spec ()
  "Visit the current src file's spec file, in the same buffer window."
  (interactive)
  (visit-related-file "src" "spec" nil)
)
(defun spec-other-window ()
  "Visit the current src file's spec file, in a different buffer window."
  (interactive)
  (visit-related-file "src" "spec" t)
)
(defun src ()
  "Visit the current spec file's src file, in the same buffer window."
  (interactive)
  (visit-related-file "spec" "src" nil)
)
(defun src-other-window ()
  "Visit the current spec file's src file, in a different buffer window."
  (interactive)
  (visit-related-file "spec" "src" t)
)

(defun src-spec-switch (arg)
  "Switch from src file to spec file, or vice versa.  If given an argument greater than one,                                  
open the other file in a different buffer."
  (interactive "p")
  (let ((other-window (> arg 1)))
    (if (string-match "/src/" (buffer-file-name))
        (visit-related-file "src" "spec" other-window)
      (if (string-match "/spec/" (buffer-file-name))
          (visit-related-file "spec" "src" other-window)
        (message "The current buffer does not appear to be visiting either a src or spec file."))
      )
    )
  )

(global-set-key "\C-cs" 'src-spec-switch)

;; OK, whew.  The gist of all this is that if you type 'C-c s' while editing a 'src'                                          
;; file, emacs will open the corresponding 'spec' file.  If you type the same key                                             
;; sequence while editing a spec file, emacs opens the corresponding src file.                                                
;;                                                                                                                            
;; If you prefix the command with C-u, as in 'C-u C-c s', emacs will open the new                                             
;; file in a different buffer window, leaving you viewing whatever you were looking                                           
;; at in the current buffer.  With out the C-u prefix, emacs opens the new file in                                            
;; the same buffer window.  In either case, the current buffer is not affected -- it                                          
;; just might not be displayed.                                                                                               

;;                                                                                                                            
;; End of functions to support easy switching between 'src' and 'spec' files                                                  
;;                                                                                                                            
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                                            

(global-set-key "\C-xw"         'compare-windows)
(global-set-key "\C-x\C-m"      'set-mark-command)
(global-set-key "\C-xn"         'jump-to-next-window)
(global-set-key "\C-xp"         'jump-to-previous-window)
(global-set-key "\M-g"          'goto-line)
(global-set-key "\M-s"          'center-line)
(global-set-key "\M-r"          'replace-string)
;;(global-set-key "\C-x\C-c"      'query-save-buffers-kill-emacs)
(global-set-key "\M-\C-r"       'replace-regexp)
(global-set-key "\C-x9"         'compile)
(global-set-key "\C-x8"         'next-error)
(global-set-key "\C-x7"         'grep)
