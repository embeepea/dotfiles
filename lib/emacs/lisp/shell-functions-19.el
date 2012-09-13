;;;
;;; shell-functions.el: useful functions for shell modes
;;;
;;; by Mark Phillips

;;; (defun clear-shell-output ()
;;;   "erase contents of entire shell buffer"
;;;   (interactive)
;;;   (erase-buffer)
;;;   (shell-send-input)
;;;   (beginning-of-buffer)
;;;   (kill-line)
;;;   (end-of-buffer)
;;; )

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

;;; (defun interrupt-shell-subjob ()
;;;   "Interrupt the current subprocess."
;;;   (interactive)
;;;   (process-send-string nil "\C-?"))
;;; 
;;; (defun stop-shell-subjob ()
;;;   "Stop the current subprocess."
;;;   (interactive)
;;;   (process-send-string nil "\C-z"))

(defun newshell ()
 "  foo bar bar"
  (interactive)
  (let (oldshell)
     (if (setq oldshell (get-buffer "*shell*"))
	 (let ()
	   (set-buffer oldshell)
	   (rename-buffer "*shell*" t)
	   )
       )
     (shell)
     )
  )

