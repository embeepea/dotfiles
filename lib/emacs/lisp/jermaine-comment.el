;;;
;;; jermaine-comment.el: functions for editing Jermaine comments
;;;
;;;     (For use with js2-mode.el)
;;;
;;; To use the functions in this file, put the following in your .emacs file:
;;;
;;;    (load-file "jermaine-comment.el")
;;;
;;; Then, in js2-mode you can type
;;;
;;;   M-C-c
;;;
;;; to insert a JavaScript comment immediately preceeding the next
;;; Jermaine method or attribute declaration.  Point (your cursor
;;; position in emacs) should be somewhere just before the "hasA",
;;; "hasAn", "hasMany", or "respondsTo" declaration.
;;;
;;; by Mark Phillips (mbp@geomtech.com)
;;; Wed Nov 14 17:22:12 2012

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq js2-mode-hook
      '(lambda ()
	 (progn
	   (define-key js2-mode-map "\M-\C-c" 'jermaine-comment))))

(defun jermaine-comment (arg)
  "Insert a JS comment for docmenting the next Jermaine method or property (attribute) found in the current buffer."
  (interactive "p")
  (re-search-forward "\.hasA\\|\.hasAn\\|\.hasMany\\|\.respondsTo")
  (beginning-of-line)
  (cond
   ((string-equal ".hasA" (match-string 0)) (jermaine-comment-property-comment))
   ((string-equal ".hasAn" (match-string 0)) (jermaine-comment-property-comment))
   ((string-equal ".hasMany" (match-string 0)) (jermaine-comment-property-comment))
   ((string-equal ".respondsTo" (match-string 0)) (jermaine-comment-method-comment))
   (t (message "nothing found to comment!"))
   )
  )

(defun jermaine-comment-property-comment ()
  "Insert a JS comment for docmenting the next Jermaine property (attribute) found in the current buffer."
  (interactive)
  (re-search-forward "\.hasA\\|\.hasAn\\|\.hasMany")
  (beginning-of-line)
  (insert "/**
         * 
         *
         * @property 
         * @type {}
         * @author " (user-login-name) "
         * @modified " (current-time-string) "
         */
")
  (search-backward "@property")
  (end-of-line)
  (insert (jermaine-comment-inferred-property-name))
  (jermaine-comment-indent)
  (search-backward "/**")
  (next-line)
  (end-of-line)
  )

(defun jermaine-comment-method-comment ()
  "Insert a JS comment for docmenting the next Jermaine method found in the current buffer."
  (interactive)
  (re-search-forward "respondsTo")
  (beginning-of-line)
  (insert "/**
         * 
         *
         * @method " (jermaine-comment-inferred-method-name) "
         * @author " (user-login-name) "
         * @modified " (current-time-string) "
         */
")
  (search-backward "@method")
  (next-line)
  (beginning-of-line)
  (jermaine-comment-insert-args (jermaine-comment-inferred-argument-names))
  (jermaine-comment-indent)
  (search-backward "/**")
  (next-line)
  (end-of-line)
  )

(defun jermaine-comment-indent ()
  "Assuming that point lies somewhere within a comment delimited by /** and */, re-indent
the entire comment, leaving point where it was"
  (save-excursion
    (let (comment-begin-pos comment-end-pos)
      (search-backward "/**")
      (setq comment-begin-pos (point))
      (search-forward "*/")
      (setq comment-end-pos (point))
      (indent-region comment-begin-pos comment-end-pos))))

(defun jermaine-comment-inferred-property-name ()
  "Find the name of the first Jermaine-declared property at or after point, and return it."
  (let (local-start local-end)
  (save-excursion
    (re-search-forward "\.hasA\\|\.hasAn\\|\.hasMany")
    (re-search-forward "'\\|\"")
    (setq local-start (point))
    (re-search-forward "'\\|\"")
    (backward-char 1)
    (setq local-end (point))
    (buffer-substring-no-properties local-start local-end)
    )
  )
)

(defun jermaine-comment-inferred-method-name ()
  "Find the name of the first Jermaine-declared method at or after point, and return it."
  (let (local-start local-end)
  (save-excursion
    (re-search-forward "respondsTo")
    (re-search-forward "'\\|\"")
    (setq local-start (point))
    (re-search-forward "'\\|\"")
    (backward-char 1)
    (setq local-end (point))
    (buffer-substring-no-properties local-start local-end)
    )
  )
)

(defun jermaine-comment-inferred-argument-names ()
  "Find the names of arguments to the first Jermaine-declared method at or after point, and return them in a list."
  (let (local-start local-end argstring argbuf)
  (save-excursion
    (re-search-forward "respondsTo")
    (re-search-forward "(")
    (re-search-forward "function")
    (re-search-forward "(")
    (setq local-start (point))
    (re-search-forward ")")
    (backward-char 1)
    (setq local-end (point))
    (setq argstring (buffer-substring-no-properties local-start local-end))
    (set-buffer (setq argbuf (generate-new-buffer "argbuf")))
    (insert argstring)
    ;; at this point, argbuf contains the argument list, as a string,
    ;; formatted as it appears in the original source file
    ;; replace commas with spaces:
    (goto-char (point-min))
    (while (search-forward "," nil t) (replace-match "" nil t))
    ;; put quotes around each word
    (goto-char (point-min))
    (replace-regexp "\\([^[:space:]]+\\)" "\"\\1\"")
    (goto-char (point-max))
    (insert ")")
    (goto-char (point-min))
    (insert "(")
    (goto-char (point-min))
    (setq arglist (read argbuf))
    arglist
    )
  )
)

(defun jermaine-comment-insert-args (arglist)
  "Insert function arguments, given as strings in ARGLIST, into comment."
  (progn
    (if (> (length arglist) 0)
        (progn
          (mapcar
           '(lambda (arg) (insert " * @param {} " arg "\n"))
           arglist)
          )
      )
    )
  )

;;; not used but saved in case it's needed later:
;;;
;;;
;;; (defun jermaine-comment-delete ()
;;;   "Search forward from point in current buffer for a JS comment, and
;;; delete it if found.  Returns t if a comment was found and deleted, nil
;;; otherwise."
;;;   (interactive)
;;;   (if
;;;       (save-excursion
;;;         (if
;;;             (search-forward "/*" (point-max) t)
;;;             (let (beg end)
;;;               (forward-char -2)
;;;               (setq beg (point))
;;;               (search-forward "*/" (point-max) 1)
;;;               (setq end (point))
;;;               (delete-region beg end)
;;;               t)
;;;           nil
;;;           )
;;;         )
;;;       t
;;;     (if
;;;         (search-forward "//" (point-max) t)
;;;         (let (beg end)
;;;           (forward-char -2)
;;;           (setq beg (point))
;;;           (end-of-line)
;;;           (setq end (point))
;;;           (delete-region beg end)
;;;           t)
;;;       nil
;;;       )
;;;     )
;;;   )
