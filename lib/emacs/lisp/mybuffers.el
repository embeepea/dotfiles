(defun transpose-buffers ()
  "transpose the buffers on display in the current window and the next window"
  (interactive)
  (let (thisbuf thiswin nextbuf nextwin)
    (setq thiswin (selected-window))
    (setq thisbuf (window-buffer thiswin))
    (setq nextwin (next-window thiswin))
    (setq nextbuf (window-buffer nextwin))
    (set-window-buffer thiswin nextbuf)
    (set-window-buffer nextwin thisbuf)
    (select-window nextwin)))

(global-set-key "\M-\C-t" 'transpose-buffers)
