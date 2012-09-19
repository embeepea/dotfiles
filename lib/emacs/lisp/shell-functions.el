;;;
;;; shell-functions.el: useful functions for shell modes
;;;
;;; by Mark Phillips

(defun clear-gdb-output ()
  "erase contents of entire gdb buffer"
  (interactive)
  (end-of-buffer)
  (beginning-of-line)
  (delete-region (point) (point-min))
  (end-of-buffer)
)

(defun clear-comint-output ()
  "erase contents of entire shell buffer"
  (interactive)
  (erase-buffer)
  (comint-send-input)
  (beginning-of-buffer)
  (kill-line)
  (end-of-buffer)
)

(defun newshell ()
 "start a new shell buffer, first renaming the current one, if any"
  (interactive)
  (if (get-buffer "*shell*")
      (let ()
        (set-buffer (get-buffer "*shell*"))
        (let ((oldshelltmpname (rename-buffer "*shell-tmp*" t)))
          (shell)
          (set-buffer (get-buffer oldshelltmpname))
          (message (concat "The buffer previously named *shell* has been renamed to " (rename-buffer "*shell*" t)))
          (set-buffer (get-buffer "*shell*"))
          )
        )
      (shell)
     )

  )

