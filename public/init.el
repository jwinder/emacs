(require 'jw-lib)

(defalias 'qrr 'query-replace-regexp)
(defalias 'filter-lines 'keep-lines)
(defalias 'filter-out-lines 'flush-lines)
(defalias 'elisp-shell 'ielm)

(defalias 'count-lines-region 'count-words-region)
(defalias 'count-lines 'count-words)

(defun emacs-reload-config ()
  (interactive)
  (load-file (concat user-emacs-directory "init.el")))

(defun emacs-hard-reload-config ()
  (interactive)
  (when (file-exists-p package-user-dir)
        (delete-directory package-user-dir t))
  (emacs-reload-config))

(defun date ()
  (interactive)
  (message (current-time-string)))

(defalias 'time 'date)

(defun scratch-lisp ()
  (interactive)
  (let ((scratch-buffer (get-buffer-create "*scratch*")))
    (switch-to-buffer scratch-buffer)
    (lisp-interaction-mode)))

(defun scratch-text ()
  (interactive)
  (let ((scratch-buffer (get-buffer-create "*text*")))
    (switch-to-buffer scratch-buffer)
    (text-mode)))

(defun ping-google ()
  (interactive)
  (ping "google.com"))

(defun uuid ()
  (interactive)
  (insert (jw--make-uuid)))

(defun json-prettify ()
  (interactive)
  (if (region-active-p)
      (json-pretty-print (region-beginning) (region-end))
    (json-pretty-print-buffer)))

(defun hub-browse ()
  (interactive)
  (shell-command "hub browse"))

(defun increment-number (&optional arg)
  (interactive "p*")
  (save-excursion
    (save-match-data
      (let (inc-by field-width answer)
        (setq inc-by (if arg arg 1))
        (skip-chars-backward "0123456789")
        (when (re-search-forward "[0-9]+" nil t)
          (setq field-width (- (match-end 0) (match-beginning 0)))
          (setq answer (+ (string-to-number (match-string 0) 10) inc-by))
          (when (< answer 0)
            (setq answer (+ (expt 10 field-width) answer)))
          (replace-match (format (concat "%0" (int-to-string field-width) "d")
                                 answer)))))))

(defun decrement-number (&optional arg)
  (interactive "p*")
  (mine-increment-decimal (if arg (- arg) -1)))

(defun toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))

(defun beginning-of-line-or-indentation ()
  (interactive)
  (let ((previous-point (point)))
    (back-to-indentation)
    (if (equal previous-point (point))
        (beginning-of-line))))

(defun comment-dwim-region-or-line (&optional arg)
  (interactive "*P")
  (if (region-active-p)
      (comment-dwim arg)
    (comment-or-uncomment-region (line-beginning-position) (line-end-position))))

(defun open-line-next ()
  (interactive)
  (end-of-line)
  (open-line 1)
  (next-line 1)
  (indent-according-to-mode))

(defun open-line-previous ()
  (interactive)
  (beginning-of-line)
  (open-line 1)
  (indent-according-to-mode))

(defun newline-and-open-line-previous ()
  (interactive)
  (newline-and-indent)
  (open-line-previous))

(defun kill-matching-buffers-silently (pattern)
  (interactive "sKill buffers matching: ")
  (dolist (buffer (buffer-list))
    (when (string-match pattern (buffer-name buffer))
      (kill-buffer buffer))))

(defun kill-ag-buffers ()
  (interactive)
  (kill-matching-buffers-silently "*ag "))

(defun kill-log-buffers ()
  (interactive)
  (kill-matching-buffers-silently ".+\\.log$"))

(defun toggle-fullscreen ()
  (interactive)
  (if (frame-parameter (selected-frame) 'fullscreen)
      (set-frame-parameter (selected-frame) 'fullscreen nil)
    (set-frame-parameter (selected-frame) 'fullscreen 'fullboth)))
