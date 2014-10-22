(setq mine-directory (concat user-emacs-directory "mine"))
(add-to-list 'load-path mine-directory)

(load-theme 'manoj-dark t)

(require 'mine-builtin)
(require 'mine-defuns)
(require 'mine-advice)
(require 'mine-bindings)
(require 'mine-pretty)
(require 'mine-packages)
(require 'mine-eshell)
(require 'mine-org)
(require 'mine-irc)
(require 'mine-json)
(require 'mine-mode-line)

(when (eq system-type 'darwin) (require 'mine-osx))
(when (eq system-type 'gnu/linux) (require 'mine-linux))

(setq mine-custom-dir (concat user-emacs-directory "/custom/"))
(when (file-exists-p mine-custom-dir)
  (let ((custom-files (directory-files mine-custom-dir t "\.el$")))
    (mapcar 'load-file custom-files)))

(cd (getenv "HOME"))
(server-start)
