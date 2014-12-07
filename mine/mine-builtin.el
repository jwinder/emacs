(setq max-lisp-eval-depth 10000) ;; scary stuff
(setq gc-cons-threshold 20000000)

;; ido-mode
(require 'ido)
(ido-mode t)
(ido-everywhere t)
(setq ido-default-file-method 'selected-window
      ido-default-buffer-method 'selected-window)

;; ido setup
(setq ido-enable-prefix nil
      ido-enable-flex-matching t
      ido-create-new-buffer 'always
      ido-use-filename-at-point nil
      ido-max-prospects 10
      ido-show-dot-for-dired nil)

;; inf-ruby-key renamed, this should not be needed
;; (defun inf-ruby-setup-keybindings ()
;;   (interactive)
;;   (require 'inf-ruby)
;;   (inf-ruby-keys))

;; using cookies in w3m
(setq w3m-use-cookies t)

;; use uniquify
(require 'uniquify)
(setq
  uniquify-buffer-name-style 'post-forward
  uniquify-separator ":")

;; tramp
(set-default 'tramp-default-proxies-alist (quote ((".*" "\\`root\\'" "/ssh:%h:"))))
(setq shell-prompt-pattern "^[^#$>\n]*[#$%>] *") ;; allow percent signs in the prompt

(require 'recentf)
(recentf-mode t)
(setq recentf-max-saved-items 50)

(winner-mode t)

;; Setup Environmental Variables
(setq default-major-mode 'text-mode)
(setq inhibit-startup-message t)

;; Auto revert files
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)

(fset 'yes-or-no-p 'y-or-n-p)

(setq enable-recursive-minibuffers t)
(minibuffer-depth-indicate-mode t)

;; Buffer selection setup
(setq bs-configurations
      '(("all" nil nil nil nil nil)
        ("files" nil nil nil bs-visits-non-file bs-sort-buffer-interns-are-last)
        ("rcirc" nil nil nil
         (lambda (buf)
           (with-current-buffer buf
             (not (eq major-mode 'rcirc-mode)))) nil)
        ("dired" nil nil nil
         (lambda (buf)
           (with-current-buffer buf
             (not (eq major-mode 'dired-mode)))) nil)
        ("eshell" nil nil nil
         (lambda (buf)
           (with-current-buffer buf
             (not (eq major-mode 'eshell-mode)))) nil)
        ("magit" nil nil nil
         (lambda (buf)
           (with-current-buffer buf
             (not (eq major-mode 'magit-mode)))) nil)
        ("sbt" nil nil nil
         (lambda (buf)
           (with-current-buffer buf
             (not (string-prefix-p "*sbt:" (buffer-name buf))))) nil)
        ("sql" nil nil nil
         (lambda (buf)
           (with-current-buffer buf
             (and
              (not (eq major-mode 'sql-mode))
              (not (eq major-mode 'sql-interactive-mode))))) nil)))

(setq bs-mode-font-lock-keywords
  (list
   ; Headers
   (list "^[ ]+\\([-M].*\\)$" 1 font-lock-keyword-face)
   ; Boring buffers
   (list "^\\(.*\\*.*\\*.*\\)$" 1 font-lock-comment-face)
   ; Dired buffers
   '("^[ .*%]+\\(Dired.*\\)$" 1 font-lock-type-face)
   ; Modified buffers
   '("^[ .]+\\(\\*\\)" 1 font-lock-warning-face)
   ; Read-only buffers
   '("^[ .*]+\\(\\%\\)" 1 font-lock-variable-name-face)))

;; Always use subwords to to move around
(if (fboundp 'subword-mode)
    (subword-mode t)
  (c-subword-mode t))

(require 'dired-x)
(add-hook 'dired-load-hook
          (lambda ()
            (define-key dired-mode-map (kbd "M-RET") 'dired-external-open)))
(put 'dired-find-alternate-file 'disabled nil)

(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;; Create non-existent directories containing a new file before saving
(add-hook 'before-save-hook
          (lambda ()
            (when buffer-file-name
              (let ((dir (file-name-directory buffer-file-name)))
                (when (and (not (file-exists-p dir))
                           (y-or-n-p (format "Directory %s does not exist. Create it?" dir)))
                  (make-directory dir t))))))

;; Make #! scripts executable automatically
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

;; Use soft tabs
(setq-default indent-tabs-mode nil)
(setq default-tab-width 2)

;; Don't make backups
(setq make-backup-files nil)
(setq version-control nil)

;; Allow to be able to select text and start typing or delete
(delete-selection-mode t)

;; delete trailing whitespace on save
(setq mine-delete-trailing-whitespace t)
(defun mine-leave-whitespace-in-buffer ()
  (interactive)
  (make-variable-buffer-local 'mine-leave-whitespace)
  (setq mine-delete-trailing-whitespace nil))
(add-hook 'before-save-hook '(lambda () (if mine-delete-trailing-whitespace (delete-trailing-whitespace))))

;; auto indentation of yanked/pasted text
(setq major-modes-to-auto-indent-yanked-text '(emacs-lisp-mode
                                               clojure-mode
                                               c-mode
                                               c++-mode
                                               objc-mode
                                               scala-code
                                               ruby-mode))

(defun yank-and-indent ()
  (interactive)
  (yank)
  (call-interactively 'indent-region))

;; Misc Aliases
(defalias 'qrr 'query-replace-regexp)
(defalias 'scala 'scala-run-scala)
(defalias 'elisp-shell 'ielm)
(defalias 'colors 'list-colors-display)
(defalias 'buffers 'bs-show)
(defalias 'git 'magit-status)
(defalias 'web 'w3m)
(defalias 'ps 'proced)
(defalias 'find-anything 'apropos)

(defalias 'filter-lines 'keep-lines)
(defalias 'filter-out-lines 'flush-lines)
(defalias 'remove-lines 'flush-lines)

(defalias 'gist-dired-all-marked 'dired-do-gist)

;; dired things
(add-hook 'dired-mode-hook '(lambda ()
                              (local-set-key (kbd "C-c R") 'wdired-change-to-wdired-mode)))
(setq wdired-allow-to-change-permissions "advanced")
(setq wdired-confirm-overwrite t)
(setq wdired-use-dired-vertical-movement t)
(defalias 'wdired 'wdired-change-to-wdired-mode)

;; Midnight mode to clean up old buffers
(require 'midnight)

(add-to-list 'clean-buffer-list-kill-regexps '("^ \\*ag search text.*\\*$"))

(add-hook 'emacs-lisp-mode-hook '(lambda () (eldoc-mode t)))

;; Miscallaneous Things
(if (fboundp 'mouse-wheel-mode) (mouse-wheel-mode t))
(setq visible-bell t)
(setq x-select-enable-clipboard t)
(setq save-place-file "~/.saved-places-emacs") ;; the default .emacs-places is annoying in ido-find-file

;; Backups
(setq version-control nil)
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))
(setq create-lockfiles nil)

(add-to-list 'auto-mode-alist '("\\.proto\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.less\\'" . css-mode))

;; auto revert logs by tail
;; (add-to-list 'auto-mode-alist '("\\.log\\'" . auto-revert-tail-mode))

;; viewing gists in browse-url after gisting
(setq gist-view-gist t)

;; pop-to-buffer to split horizontally rather than vertically
(setq split-width-threshold nil)

;; (toggle-case-fold-search)

(setq mine-shell-cmds-filename "shell-cmds")

(defun mine-shell-cmds ()
  (interactive)
  (find-file (concat user-emacs-directory mine-shell-cmds-filename)))

(defalias 'shell-cmds 'mine-shell-cmds)

(defun mine-shell-cmds-run-line ()
  (let ((cmd (trim-string (thing-at-point 'line))))
    (when (not (string= "" cmd))
      (save-excursion (shell-command cmd)))))

(defun mine-shell-cmds-run-lines ()
  (interactive)
  (if (region-active-p)
      (save-restriction
        (narrow-to-region (region-beginning) (region-end))
        (goto-char (point-min))
        (while (< (point) (point-max))
          (mine-shell-cmds-run-line)
          (forward-line)))
    (mine-shell-cmds-run-line)))

(defvar shell-cmds-mode-map (make-sparse-keymap))
(define-key shell-cmds-mode-map (kbd "C-c C-c") 'mine-shell-cmds-run-lines)

;;;###autoload
(add-to-list 'auto-mode-alist `(,mine-shell-cmds-filename . shell-cmds-mode))

(defun shell-cmds-mode ()
  "My Shell commands mode."
  (interactive)
  (kill-all-local-variables)
  (setq major-mode 'shell-cmds-mode)
  (setq mode-name "shell-cmds")
  (use-local-map shell-cmds-mode-map))

(provide 'mine-builtin)
