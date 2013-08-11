(defun mine-eshell-rename-buffer-pwd ()
  (let ((pwd (eshell/pwd)))
    (rename-buffer
     (concat "*"
             "eshell " "<" pwd ">"
             "*")
     t)))

(defun mine-eshell-buffer-p (buffer)
  (and (eq 'eshell-mode (buffer-local-value 'major-mode buffer))
       buffer))

(defun mine-get-eshell-buffers ()
  (delq nil (mapcar 'mine-eshell-buffer-p (buffer-list))))

(defun mine-eshell-create ()
  (interactive)
  (eshell t)
  (mine-eshell-rename-buffer-pwd))

(defun mine-eshell-find-best-match (dir)
  (let ((pwd (expand-file-name dir))
        (best-match-buffer nil))
    (dolist (b (mine-get-eshell-buffers) best-match-buffer)
      (let* ((b-pwd       (with-current-buffer b (expand-file-name ".")))
             (b-match     (string-match b-pwd pwd))
             (b-match-end (and b-match (match-end 0)))
             (best-match-pwd (and best-match-buffer (with-current-buffer best-match-buffer (expand-file-name "."))))
             (best-match     (and best-match-buffer (string-match best-match-pwd pwd)))
             (best-match-end (and best-match-buffer (and best-match (match-end 0)))))
        (if (or (and (eq nil best-match-end)
                     b-match-end)
                (and b-match-end
                     (> b-match-end best-match-end)))
            (setq best-match-buffer b))))))

(defun mine-eshell-switch-to-closest-or-create (create-new)
  (if create-new
      (mine-eshell-create)
    (let ((best-match-buffer (mine-eshell-find-best-match default-directory)) )
      (if best-match-buffer
          (switch-to-buffer best-match-buffer)
        (mine-eshell-create)))))

(defun mine-fullscreen-eshell (create-new)
  (interactive "P")
  (if create-new
      (mine-eshell-switch-to-closest-or-create create-new)
    (if (eq 'eshell-mode (buffer-local-value 'major-mode (current-buffer)))
        (jump-to-register :before-eshell-fullscreen)
      (progn
        (window-configuration-to-register :before-eshell-fullscreen)
        (mine-eshell-switch-to-closest-or-create nil)
        (delete-other-windows)))))

(global-set-key (kbd "C-c t") 'mine-fullscreen-eshell)

(add-hook 'eshell-directory-change-hook 'mine-eshell-rename-buffer-pwd)

(setq eshell-highlight-prompt t)
(custom-set-faces '(eshell-prompt ((t (:foreground "#87cefa" :bold t)))))

;; Plan 9 9term
(require 'em-smart)

;; commands

(defun eshell/d (&optional dir)
  (interactive)
  (let ((dir (or dir default-directory)))
    (dired dir)))

(provide 'mine-eshell)
