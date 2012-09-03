(defun sss-replace-last-substring (string substring replacement)
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

(defun sss-visit-related-file (this-component related-component other-window)
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
              (related-file-name (sss-replace-last-substring filename this-substring related-substring))
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

(defun sss-spec ()
  "Visit the current src file's spec file, in the same buffer window."
  (interactive)
  (sss-visit-related-file "src" "spec" nil)
)
(defun sss-spec-other-window ()
  "Visit the current src file's spec file, in a different buffer window."
  (interactive)
  (sss-visit-related-file "src" "spec" t)
)
(defun sss-src ()
  "Visit the current spec file's src file, in the same buffer window."
  (interactive)
  (sss-visit-related-file "spec" "src" nil)
)
(defun sss-src-other-window ()
  "Visit the current spec file's src file, in a different buffer window."
  (interactive)
  (sss-visit-related-file "spec" "src" t)
)

(defun sss-src-spec-switch (arg)
  "Switch from src file to spec file, or vice versa.  If given an argument greater than one,                                  
open the other file in a different buffer."
  (interactive "p")
  (let ((other-window (> arg 1)))
    (if (string-match "/src/" (buffer-file-name))
        (sss-visit-related-file "src" "spec" other-window)
      (if (string-match "/spec/" (buffer-file-name))
          (sss-visit-related-file "spec" "src" other-window)
        (message "The current buffer does not appear to be visiting either a src or spec file."))
      )
    )
  )
