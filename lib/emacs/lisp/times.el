(defun times (YEAR)
  "Edit my times file.  YEAR specifies the year; if YEAR <= 1, edit
the file for the current year.  If YEAR > 1 it should be a 2 digit
number like 92 or 91 specifying the year.  Times files are in
/home/mbp/etc."
  (interactive "p")
  (let ((buffer-name (concat "times" (if (> YEAR 1) YEAR ""))))
    (if (get-buffer buffer-name)
	(progn
	  (switch-to-buffer buffer-name)
	  (message "using existing times buffer")
	  )
      (let ((file-name (concat "/home/mbp/etc/" buffer-name)))
	(find-file (if (file-exists-p file-name) file-name "/home/mbp/etc/times"))
	(goto-char (point-max))
	(if (search-backward "" (point-min) t) (next-line -1))
      )
    )
  )
)

(global-set-key "\M-m"	'times)
