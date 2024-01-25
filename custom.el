(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(backup-directory-alist '((".*" . "~/.emacs.d/backup")))
 '(calendar-week-start-day 1)
 '(custom-enabled-themes '(deeper-blue))
 '(display-time-24hr-format t)
 '(display-time-mode t)
 '(eshell-prompt-function
   '(lambda nil
      #("$ " 0 2
	(rear-nonsticky
	 (font-lock-face read-only)
	 front-sticky
	 (font-lock-face read-only)
	 font-lock-face eshell-prompt read-only t))))
 '(global-display-line-numbers-mode t)
 '(global-prettify-symbols-mode t)
 '(glyphless-char-display-control '((format-control . thin-space) (no-font . empty-box)))
 '(inhibit-startup-screen t)
 '(jit-lock-chunk-size 20)
 '(jit-lock-context-time 5.0)
 '(jit-lock-defer-time 1.0)
 '(jit-lock-stealth-load 300)
 '(jit-lock-stealth-time 20)
 '(mozc-candidate-style 'echo-area)
 '(recentf-auto-cleanup 'never)
 '(recentf-max-saved-items 2000)
 '(recentf-mode t)
 '(safe-local-variable-values
   '((go-test-args . "-v --bench . --benchmem")
     (eval add-hook 'before-save-hook
	   #'(lambda nil
	       (save-excursion
		 (goto-char
		  (point-min))
		 (while
		     (re-search-forward "max-width: *[0-9]+px" nil t)
		   (replace-match "max-width: 300px" nil nil))))
	   nil t)
     (buffer-file-coding-system . utf-8)
     (org-html-postamble-format
      ("en" "<div style='text-align:right'>以上</div>"))
     (org-html-postamble . t)
     (org-html-preamble-format
      ("en" "<h1 class='mytitle'>%t (%d)</h1>"))
     (org-html-preamble . t)))
 '(save-place-mode t)
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(warning-suppress-log-types '((use-package)))
 '(warning-suppress-types '((use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ivy-posframe ((t (:background "#282a36")))))
