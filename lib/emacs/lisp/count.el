;;;
;;; count.el
;;;
;;; simple counting functions

(defun count-start (arg)
  (interactive "p")
  (setq count-value (- arg 1))
  (message (concat "count-next will start with " (number-to-string (+ count-value 1)) ".")))

(defun count-next (step)
  (interactive "p")
  (setq count-value (+ count-value step))
  (insert-string count-value))

(setq count-value 0)
