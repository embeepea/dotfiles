;;;
;;; c-comment.el: functions for making C comments, especially associated
;;;	with documenting function definitions
;;;
;;; by Mark Phillips (mbp@geom.umn.edu)
;;; Wed Jul 10 12:44:28 1991

;;;
;;; These functions are in beta-test form.  Please email me if you
;;; have problems with them.
;;;

;;;
;;; To use the functions in this file, put the following in your .emacs file:
;;;
;;; (load-file "/home/gcg/ngrap/doc/c-comment.el")
;;;
;;; If you don't yet have a .emacs file, create one in your home dir and
;;; put the above line in it.
;;;
;;; If you created or modified your .emacs file with emacs, exit emacs
;;; and start it up again.
;;;
;;; Then, in C-mode (i.e. when editing a C program), you can type
;;;
;;;   ESC :	to insert a blank function header comment at point
;;;   C-u ESC :	to insert (at point) a function header comment before an
;;;		existing function declaration, with the function
;;;		name and arguments already filled in.
;;;   C-c d	to change the "Date" string in an existing function comment
;;;		to the current time & date.
;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defconst c-function-date-string " * Date:\t")
(defconst c-function-description-string " * Description:\t\n")
(defconst c-function-name-string " * Function:\t\n")

(defun c-empty-function-comment ()
  "Insert an empty template for describing a C function.  The template
is inserted starting at point."
  (interactive)
  (beginning-of-line)
  (insert "/*-----------------------------------------------------------------------\n"
	  c-function-name-string
	  c-function-description-string
	  " * Args:\t\n"
	  " * Returns:\t\n"
	  " * Author:\t" (user-login-name) "\n"
	  c-function-date-string (current-time-string) "\n"
	  " * Notes:\t\n" 
	  " */\n" )
  (search-backward c-function-name-string)
  (end-of-line)
  )

(defun c-declared-function-comment ()
  "Insert a template for describing a C function whose delcartion is in
the current buffer.  The template is inserted starting at point.  The
name of the function and its arguments are read from the buffer and
inserted into the appropriate places in the comment."
  (interactive)
  (let (tree name arglist)
    (setq tree (parse-function-declaration))
    (setq name (car tree))
    (setq arglist (car (cdr tree)))
    (beginning-of-line)
    (insert "/*-----------------------------------------------------------------------\n"
	    " * Function:\t" name "\n"
	    c-function-description-string)
    (insert-args arglist)
    (insert " * Returns:\t\n"
	    " * Author:\t" (user-login-name) "\n"
	    c-function-date-string (current-time-string) "\n"
	    " * Notes:\t\n" 
	    " */\n" )
    (search-backward c-function-description-string)
    (end-of-line)
    )
)

(defun c-function-comment (arg)
  "Insert a C comment for describing a function declaration.  When
called interactively with no prefix argument, inserts an empty
template.  With a prefix-argument, inserts function name and
arguments, which are read from the current buffer after point, into
the comment."
  (interactive "p")
  (if (> arg 1)
      (c-declared-function-comment)
    (c-empty-function-comment)))

(defun c-redate-function-comment ()
  "Change date in function comment to current date.  Point must be
somewhere within the comment."
  (interactive)
  (search-backward "/*" (point-min) t)
  (if (search-forward c-function-date-string (point-max) t)
      (let (beg)
	(setq beg (point))
	(end-of-line)
	(delete-region beg (point))
	(insert (current-time-string)))
    (progn
      (message (concat "string \"" c-function-date-string "\" not found."))
      (beep))))

(defun cbox ()
  "Insert a blank comment box into a C program"
  (interactive)
  (beginning-of-line)
  (insert
  "/************************************************************************"
  "\n\n"
  " ************************************************************************/"
  )
  (forward-line -1)
  (beginning-of-line)
  (insert " ")
)

(defun delete-comment ()
  "Search forward from point in current buffer for a C comment, and
delete it if found.  Returns t if a comment was found and deleted, nil
otherwise."
  (if (search-forward "/*" (point-max) t)
      (let (beg end)
	(forward-char -2)
	(setq beg (point))
	(search-forward "*/" (point-max) 1)
	(setq end (point))
	(delete-region beg end)
	t)
    nil))

(defun parse-function-declaration ()
  "Parse a C function declaration, returning a list of the form (name
(arg1 arg2 ...)), where name and the argi are strings.  This function
looks at up to 30 lines around point to find the declaration.  Point
must be located before the final \")\" of the declaration."

  (save-excursion
    (let (here relhere beg end cbuf nambuf argbuf name arglist)

     ;;; record current position in current buffer
      (setq cbuf (current-buffer))
      (setq here (point))

     ;;; put region consisting of up to 15 lines before and 15
     ;;; lines after point in nambuf buffer
      (forward-line -15)
      (setq relhere (- here (point)))
      (setq beg (point))
      (forward-line 30)
      (setq end (point))
      (set-buffer (setq nambuf (generate-new-buffer "nambuf")))
      (insert-buffer-substring cbuf beg end)
      
     ;;; put the mark at the spot where point was in orig buffer
      (set-mark (+ relhere 1))
      
     ;;; delete all C comments from this buffer, starting at beginning
      (goto-char (point-min))
      (while (delete-comment) t)
      
     ;;; return to original position
      (goto-char (mark))
      
     ;;; find the ')'
      (if (not (search-forward ")" (point-max) t))
	  (error "%s" "No ')' found after point."))
      
     ;;; delete everything from the ')' on, including the ')'
      (forward-char -1)
      (delete-region (point) (point-max))
      
     ;;; find the "("
      (if (not (search-backward "(" (point-min) t))
	  (error "%s" "No '(' found near point."))
      
     ;;; delete the "("
      (delete-region (point) (+ (point) 1))
      
     ;;; put the args in argbuf, and delete them from nambuf
      (setq beg (point))
      (setq end (point-max))
      (set-buffer (setq argbuf (generate-new-buffer "argbuf")))
      (insert-buffer-substring nambuf beg end)
      (set-buffer nambuf)
      (delete-region beg end)
      
     ;;; delete everything but the name from nambuf
      (re-search-backward "[a-zA-Z0-9_]" (point-min) 1)
      (re-search-backward "[^a-zA-Z0-9_]" (point-min) 1)
      (delete-region (point-min) (point))
      (goto-char (point-min))
      (replace-regexp "[ \t\n]+" "")
      
     ;;; set name string
      (goto-char (point-min))
      (setq name (buffer-string))
      
     ;;; construct list of args
      (set-buffer argbuf)
      (goto-char (point-min))
      (replace-string "," "\n")		; replaces commas with newlines
      (goto-char (point-min))
      (replace-regexp "[ \t]+$" "")	; remove trailing whitespace from each line
      (goto-char (point-min))
      (replace-regexp "^.*[ \t]+" "")
      (goto-char (point-min))
      (replace-regexp "\\([a-zA-Z0-9_*.]+\\)" "\"\\1\"")
      (goto-char (point-min))
      (insert "(")
      (goto-char (point-max))
      (insert ")")
      (goto-char (point-min))
      (setq arglist (read argbuf))
      
      (kill-buffer nambuf)
      (kill-buffer argbuf)
      
      (list name arglist)
)))

(defun insert-args (arglist)
  "Insert function arguments, given as strings in ARGLIST, into comment."
  (progn
    (if (> (length arglist) 0)
	(progn
	  ;;; do first arg separately
	  (insert " * Args:\t" (car arglist) ":\n")
	  ;;; do other args in loop
	  (mapcar
	   '(lambda (arg) (insert " *\t\t" arg ":\n"))
	   (cdr arglist))))))


(setq c-mode-hook
      '(lambda ()
	 (progn
	   (define-key c-mode-map "\e:" 'c-function-comment)
	   (define-key c-mode-map "\C-cd" 'c-redate-function-comment))))

