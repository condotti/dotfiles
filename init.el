;; ----------------------------------------------------------------------
;; init.el reloaded
;; ----------------------------------------------------------------------

;; ----------------------------------------------------------------------
;; from https://yiufung.net/post/pure-emacs-lisp-init-skeleton/
;; ----------------------------------------------------------------------

;; Speed up startup
(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6)
(add-hook 'after-init-hook
          `(lambda ()
             (setq gc-cons-threshold 800000
                   gc-cons-percentage 0.1)
             (garbage-collect)) t)

;; ----------------------------------------------------------------------
;; Customize interface
;; ----------------------------------------------------------------------
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

;; ----------------------------------------------------------------------
;; Straight.el
;; ----------------------------------------------------------------------
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;; ----------------------------------------------------------------------
;; workaround to the problem of ~/.emacs.d/server/
;; ----------------------------------------------------------------------
(advice-add #'server-ensure-safe-dir :around
            #'(lambda (f &rest args) (ignore-errors (apply f args))))

;; ----------------------------------------------------------------------
;; Miscelanneous settings
;; ----------------------------------------------------------------------
(defalias 'yes-or-no-p 'y-or-n-p)
(defalias 'message-box 'message)
(setq use-dialog-box nil)
(when window-system
  ;; (add-to-list 'default-frame-alist '(font . "MeiryoKe_Console 12"))
  (set-face-attribute 'default nil :family "MeiryoKe_Console" :height 120)
  (setq use-default-font-for-symbols nil)
  (add-to-list 'default-frame-alist '(width . 100)))
(advice-add #'display-line-numbers-mode :around
	    #'(lambda (f &rest args) (when (buffer-file-name) (apply f args))))
(prefer-coding-system 'utf-8)
(setq recentf-auto-save-timer (run-with-idle-timer 30 t #'recentf-save-list))

;; ----------------------------------------------------------------------
;; To avoid hanging-up when glyphless chars are displayed
;; ----------------------------------------------------------------------
(setq inhibit-compacting-font-caches t)

;; ----------------------------------------------------------------------
;; autoinsert
;; ----------------------------------------------------------------------
(require 'autoinsert)
(add-hook 'find-file-hooks 'auto-insert)
(add-to-list 'auto-insert-alist
	     '((".*/content/\\(post\\|fixed\\).*\\.md$" . "Hugo blog frontmatter")
	       nil
	       "---\n"
	       "date: " (format-time-string "%F") "\ntitle: " _ "\ntags: []\n---\n\n<!-- Local Variables: -->\n<!-- truncate-lines: t -->\n<!-- eval: (add-hook 'before-save-hook #'(lambda nil (save-excursion (goto-char (point-min)) (while (re-search-forward \"max-width: *[0-9]+px\" nil t) (replace-match \"max-width: 300px\" nil nil)))) nil t) -->\n<!-- End: -->\n"))

(add-to-list 'auto-insert-alist
	     '(("memo/.*\\.md$" . "Scribbled memo")
	       nil
	       "---\ntitle: " _ "\ndate: " (format-time-string "%F")
	       "\nauthor: \n---\n"))

;; ----------------------------------------------------------------------
;; Packages
;; ----------------------------------------------------------------------
(use-package ace-window
  :bind ("C-x o" . ace-window)
  :config (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l ?\;)))

(use-package all-the-icons)

(use-package anthy
  :straight (:type git :host github :repo "condotti/anthy-el")
  :config
  (define-obsolete-variable-alias 'last-command-char 'last-command-event "at least 19.34")
  (define-obsolete-function-alias 'string-to-int 'string-to-number "at least 26.1")
  :init
  (when (eq system-type 'windows-nt)
    (advice-add 'anthy-do-invoke-agent :around
		#'(lambda (f &rest args) (let ((my/anthy-context t)) (apply f args))))
    (advice-add 'anthy-add-word :around
		#'(lambda (f &rest args) (let ((my/anthy-context t)) (apply f args))))
    (advice-add 'start-process :around
		#'(lambda (f name buffer program &rest args)
		    (if (boundp 'my/anthy-context)
			(apply f (cons name (cons buffer (cons "wsl" (cons program args)))))
		      (apply f (cons name (cons buffer (cons program args))))))))
  (load-library "leim-list")
  (setq default-input-method 'japanese-anthy
	anthy-wide-space " "		; to avoid zenkaku space
	anthy-accept-timeout 1))

(use-package counsel
  :bind (("C-x C-r" . counsel-recentf)
	 ("C-x b" . counsel-switch-buffer)
	 :map minibuffer-local-map ("C-r" . counsel-minibuffer-history))
  :init
  (counsel-mode 1)
  (add-hook 'shell-mode-hook
	    #'(lambda nil (define-key shell-mode-map (kbd "C-r") 'counsel-shell-history))))

(use-package company
  :bind (:map company-active-map
              ("C-n" . company-select-next)
              ("C-p" . company-select-previous)) 
  :init
  (setq company-idle-delay 0
        company-minimum-prefix-length 2
        company-selection-wrap-around t
        company-dabbrev-downcase nil
	company-require-match nil
	company-tooltip-align-annotations t
	company-eclim-auto-save nil)
  (global-company-mode 1)
  :config
  (advice-add #'company-complete-selection :around
	      #'(lambda (fn) (let ((company-dabbrev-downcase t))
			   (call-interactively fn)))))

(use-package company-fuzzy
  :straight (:type git :host github :repo "elpa-host/company-fuzzy") ; not in elapa stable
  :config
  (global-company-fuzzy-mode 1))

(use-package company-go)

(use-package ddskk
  :bind ("C-x C-j" . skk-mode))

(use-package ddskk-posframe
  :custom (ddskk-posframe-mode t))

(use-package dired
  :straight nil
  :bind (:map dired-mode-map ("r" . wdired-change-to-wdired-mode)))

(use-package doc-view
  :straight nil
  :config
  (when (eq system-type 'windows-nt)
    (setq doc-view-ghostscript-program
          "c:/Program Files/gs/gs9.26/bin/gswin64c.exe"
          doc-view-pdftotext-program
          "c:/ProgramData/chocolatey/bin/pdftotext.exe"
          doc-view-odf->pdf-converter-program
          "d:/USER/Program/PortableApps/PortableApps/LibreOfficePortable/LibreOfficePortable.exe"))
  (when (eq system-type 'gnu/linux)
    (setq dired-guess-shell-alist-user
          '(("\\.pdf\\'" "evince"))))
  (when (eq system-type 'windows-nt)
    (setq dired-guess-shell-alist-user
          '(("\\.pdf\\'" "acrord32")))))

(use-package edit-server
  :config
  (edit-server-start))

(use-package eshell-toggle
  :straight (:type git :host github :repo "4DA/eshell-toggle")
  :custom (eshell-toggle-size-fraction 3)
  :bind ("C-c e" . eshell-toggle))

(use-package go-eldoc)

(use-package go-errcheck)

(use-package go-mode
  :init
  (add-hook 'go-mode-hook 'go-eldoc-setup)
  (add-hook 'before-save-hook 'gofmt-before-save))

(use-package go-playground)

(use-package golint
  :straight (:type git :host github :repo "golang/lint" :files ("misc/emacs/golint.el")))

(use-package gotest
  :bind (:map go-mode-map
	      ("C-c f" . go-test-current-file)
	      ("C-c t" . go-test-current-test)
	      ("C-c p" . go-test-cuurent-project)
	      ("C-c b" . go-test-current-benchmark)
	      ("C-c x" . go-run)))

(use-package hideshow
  :straight nil
  :bind (:map hs-minor-mode-map
	      ("C-c h" . hs-hide-all)
	      ("C-c s" . hs-show-all)
	      ("C-c t" . hs-toggle-hiding))
  :config
  (dolist (hook '(emacs-lisp-mode-hook lisp-mode-hook))
    (add-hook hook #'(lambda nil (hs-minor-mode 1)))))

(use-package ivy-posframe
  :after ivy
  :custom-face
  (ivy-posframe ((t (:background "#282a36"))))
  :custom
  (ivy-display-function #'ivy-posframe-display-at-frame-center)
  :config
  (ivy-posframe-mode 1))

(use-package lispy
  :init
  (dolist (hook '(lisp-mode-hook
		  emacs-lisp-mode-hook
					; clojure-mode-hook cider-repl-mode-hook slime-repl-mode-hook scheme-mode-hook geiser-mode-hook
		  
		  ))
    (add-hook hook (lambda nil (lispy-mode 1))))
  :bind (:map lispy-mode-map-lispy
	      (":" . self-insert-command)
	      ("C-c m" . lispy-multiline)
	      ("C-c o" . lispy-oneline)))

(use-package magit
  :bind ("C-x g" . magit-status)
  :config
  (put 'magit-clean 'disabled nil)
  (add-hook 'magit-status-section-hook 'magit-insert-worktrees)
  (setq magit-commit-show-diff nil))

(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("^README\\.md$" . gfm-mode)
	 ("\\.md$" . gfm-mode)
	 ("\\.markdown$" . markdown-mode)
	 ("\\.gfm$" . gfm-mode))
  :init
  (setq markdown-command-needs-filename t
	markdown-command (cl-case system-type
			   ('windows-nt "pandoc.exe")
			   ('gnu/linux " pandoc")
			   (t "markdown"))
	markdown-split-window-direction 'right)
  :config
  (set-face-attribute 'markdown-table-face nil :inherit 'default)
  :bind (:map markdown-mode-map
	      ("C-c p" . my/markdown-export-to-pdf)
	      :map gfm-mode-map
	      ("C-c p" . my/markdown-export-to-pdf)))

(use-package my
  :straight (:type git :host github :repo "condotti/my-util-el"))

(use-package neotree
  :bind ("C-c n" . neotree-toggle)
  :custom
  (neo-theme (if (display-graphic-p) 'classic 'arrow))
  (neo-show-hidden-files t))

(use-package org
  :straight nil
  :config
  (setq org-list-description-max-indent t
	org-adapt-indentation nil)
  :bind (:map org-mode-map ("C-c p" . my/org-export-to-pdf)))

(use-package powerline
  :init (powerline-default-theme))

(use-package recentf-ext)

(use-package smex)

(use-package swiper
  :bind ("M-s M-s" . swiper-thing-at-point))

;; ----------------------------------------------------------------------
;; End of init.el
;; ----------------------------------------------------------------------
