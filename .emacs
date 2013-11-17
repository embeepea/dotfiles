(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(comint-highlight-prompt ((t (:foreground "cyan"))))
 '(dired-directory ((t (:inherit font-lock-function-name-face :foreground "cyan"))))
 '(font-lock-function-name-face ((((class color) (min-colors 88) (background light)) (:foreground "cyan"))))
 '(minibuffer-prompt ((t (:foreground "cyan")))))

;;; enable some normally-disabled functions
(put 'narrow-to-region 'disabled nil)
(put 'eval-expression 'disabled nil)
(put 'set-goal-column 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;;; define some useful functions:
(defun jump-to-next-window ()
  "select the window under the current window"
  (interactive)
  (other-window 1))
(defun jump-to-previous-window ()
  "select the window above the current window"
  (interactive)
  (other-window -1))
(defun narr ()
  "shorthand for 'narrow-to-region'"
  (interactive)
  (narrow-to-region (point) (mark)))
(defun query-save-buffers-kill-emacs ()
  "do save-buffers-kill-emacs after confirmation"
  (interactive)
  (if (yes-or-no-p "Do you really want to quit? ")
      (save-buffers-kill-emacs)))
(defun time-stamp ()
  "inserts current time string in buffer"
  (interactive)
  (insert (current-time-string)))

;;
;; Commenting this out on Mon Sep  9 14:09:05 2013, because of strange
;; behavior where emacs never seems to finish saving a .json file.
;; (Only seems to happen with .json files!)
;;
;; ;; arrange to untabify .js files before saving them
;; (defun add-auto-untabify-on-save-hook ()
;;    (make-local-variable 'write-file-functions)
;;    (add-hook 'write-file-functions
;; 	     (lambda ()
;; 	       (untabify (point-min) (point-max)))))
;; (add-hook 'js-mode-hook 'add-auto-untabify-on-save-hook)
;; (add-hook 'js2-mode-hook 'add-auto-untabify-on-save-hook)

;; turn off ridiculous visual line movement behavior, so next-line, previous-line, etc
;; behave as I expect (they operate on logical lines in the buffer, independent of
;; any wrapping):
(setq line-move-visual 'nil)

;; don't ask for confirmation when editing a symlink to a version-controlled file;
;; just display a warning
(setq vc-follow-symlinks nil)

;; hide the standard emacs welcome screen
(setq inhibit-splash-screen t)

;; hide the initial minibuffer message; this line has to have your username hardcoded in,
;; so if you want it to work for you, you should change "mbp" to whatever your username is.
(setq inhibit-startup-echo-area-message "mbp")

;; prepend my own personal elisp dir to the load path
(setq load-path (cons "~/lib/emacs/lisp" load-path))

;; arrange to use the js2-mode in our personal elisp dir for editing .js files
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;; actionscript-mode stuff
;;   note: files actionscript-mode.el and actionscript-config.el are from
;;         https://github.com/austinhaas/actionscript-mode
(autoload 'actionscript-mode "actionscript-mode" "Major mode for actionscript." t)
(add-to-list 'auto-mode-alist '("\\.as$" . actionscript-mode))
(add-to-list 'auto-mode-alist '("\\.mxml$" . actionscript-mode))
(eval-after-load "actionscript-mode" '(load "actionscript-config"))

(autoload 'markdown-mode "markdown-mode" "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))

;; load the spec-src-switch library, and bind a key for convenient switching between
;; src and spec files
(load-library "spec-src-switch")
(global-set-key "\C-cs" 'sss-switch)

(autoload 'count-start "count" "Arrange for the count-next to start at the integer ARG" t)
(autoload 'count-next "count" "Insert the next integer in a sequence into the current buffer at point" t)

;; mybuffers.el, in lib/emacs/lisp, provides transpose-buffers function (C-M-t) which swaps
;; the current buffer with the next one
(load-library "mybuffers")

;; load the jermaine-comment library for JavaScript comments
(load-library "jermaine-comment")

;;; Function cs: Control the case sensitivity of searches in the current
;;;              buffer.
;;; 
;;; 	With no arg: toggle
;;; 	    arg  = 1: make case SENSITIVE
;;; 	    arg != 1: make case insensitive
;;; 
(defun cs (arg)
  (interactive "P")
  (if arg
      (if (eq arg 1)
	  (setq case-fold-search nil)
	  (setq case-fold-search t))
      (setq case-fold-search (not case-fold-search))
  )
  (if case-fold-search
      (message "Searches are now case-insensitive in this buffer")
      (message "Searches are now case-SENSITIVE in this buffer"))
)


;; Visual feedback on selections
(setq-default transient-mark-mode t)

(setq-default tab-width 4)

(setq-default indent-tabs-mode nil)

;; Always end a file with a newline
(setq require-final-newline t)

;; Stop at the end of the file, not just add lines
(setq next-line-add-newlines nil)

;; Enable wheelmouse support by default
(cond (window-system
       (mwheel-install)
))

;;;
;;; Shell-mode stuff:
;;;
(autoload 'clear-comint-output "shell-functions" "erase contents of entire shell buffer" t)
(setq shell-mode-hook
      '(lambda ()
         (define-key shell-mode-map "\C-c\C-o" 'clear-comint-output)
         (define-key shell-mode-map "\M-n" 'notes)
         (abbrev-mode 1)
         )
      )
(autoload 'newshell "shell-functions" "start a new shell buffer, first renaming the current one, if any" t)

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
(global-set-key "\C-x\C-c"	'query-save-buffers-kill-emacs)


(add-to-list 'auto-mode-alist '("\\.module$" . php-mode))

;; use scheme-mode for editing racket files
(add-to-list 'auto-mode-alist '("\\.rkt$" . scheme-mode))

(autoload 'geben "geben" "PHP Debugger on Emacs" t)

;; The following snippet, which I got from 
;;    http://www.emacswiki.org/emacs/PhpMode
;; causes emacs to have better indentation rules for array literals
;; in php-mode.  In particular, it changes
;;     $somevar = array(
;;                      'key' => 'value'
;;                     );
;; to
;;     $somevar = array(
;;       'key' => 'value'
;;     );
;; Yay!
(add-hook 'php-mode-hook (lambda ()
    (defun ywb-php-lineup-arglist-intro (langelem)
      (save-excursion
        (goto-char (cdr langelem))
        (vector (+ (current-column) c-basic-offset))))
    (defun ywb-php-lineup-arglist-close (langelem)
      (save-excursion
        (goto-char (cdr langelem))
        (vector (current-column))))
    (c-set-offset 'arglist-intro 'ywb-php-lineup-arglist-intro)
    (c-set-offset 'arglist-close 'ywb-php-lineup-arglist-close)))

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)
;;; (unless (package-installed-p 'scala-mode2)
;;;   (package-refresh-contents) (package-install 'scala-mode2))

;; use octave-mode for editing *.m files
(add-to-list 'auto-mode-alist '("\\.m$" . octave-mode))

;;; start a shell buffer
(shell)
