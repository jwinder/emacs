(require 'magit) ;; for magit-anything-modified-p

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(jw--set-font-size "14")

(set-face-attribute 'mode-line nil :font (jw--font-name "14") :background "#22083397778B" :foreground "#7db5d6" :box '(:style released-button))
(set-face-attribute 'mode-line-inactive nil  :background "#263238" :foreground "gray" :box '(:style released-button))
(set-face-attribute 'mode-line-buffer-id nil :foreground "white")
(set-face-attribute 'mode-line-highlight nil :foreground "#7db5d6")
(set-face-attribute 'header-line nil :background "#005858" :foreground "white")

(setq-default mode-line-format '(" " (vc-mode vc-mode) " " mode-line-buffer-identification " " mode-line-misc-info))

(advice-add 'vc-mode-line :after #'(lambda (file &optional backend)
                                     (when (stringp vc-mode)
                                       (setq vc-mode (if (magit-anything-modified-p) "✘" "✔")))))

(custom-set-faces '(eshell-prompt ((nil (:foreground "#d68f7d")))))

(add-hook 'minibuffer-setup-hook '(lambda ()
                                    (set (make-local-variable 'face-remapping-alist) '((default :height 1.3)))))
