(setq inhibit-startup-message t)

(setq initial-scratch-message (format "\
;; Welcome to my emacs config %s %s.
;; If you used my previous config, it is tagged 1.0.0.
;; Any questions? Email me at %s. -- %s

" jw-config-github-url jw-config-version jw-config-author-email jw-config-author-name)
 )
