;;;
;;; count.el
;;;
;;; simple counting functions

(defun count-start (arg)
  "Arrange for the count-next to start at the integer ARG"
  (interactive "p")
  (setq count-value (- arg 1))
  (message (concat "count-next will start with " (number-to-string (+ count-value 1)) ".")))

(defun count-next (step)
  "Insert the next integer in a sequence into the current buffer at point"
  (interactive "p")
  (setq count-value (+ count-value step))
  (insert-string count-value))

(setq count-value 0)
