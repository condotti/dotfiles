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
;; autoinsert
;; ----------------------------------------------------------------------
(require 'autoinsert)
(add-hook 'find-file-hooks 'auto-insert)
(add-to-list 'auto-insert-alist
	     '((".*/content/\\(post\\|fixed\\).*\\.md$" . "Hugo blog frontmatter")
	       nil
	       "---\n"
	       "date: " (format-time-string "%F") "\n"
	       "title: " _ "\n"
	       "tags: []\n"
	       "---\n\n"
	       "<!-- Local Variables: -->\n"
	       "<!-- truncate-lines: t -->\n"
	       "<!-- End: -->\n"))

;; ----------------------------------------------------------------------
;; anthy for chromebook
;;   assumes anthy is configured with default prefix (/usr/local)
;; ----------------------------------------------------------------------
(when (eq system-type 'gnu/linux)
  (let* ((anthy-prefix "/usr/local")
	 (anthy-lispdir (concat anthy-prefix "/share/emacs/site-lisp/anthy")))
    (add-to-list 'load-path anthy-lispdir)
    (define-obsolete-variable-alias 'last-command-char 'last-command-event
      "at least 19.34")
    (load-library "anthy")
    (load-library "leim-list")
    (setq default-input-method 'japanese-anthy)))

;; ----------------------------------------------------------------------
;; Packages
;; ----------------------------------------------------------------------

(use-package counsel
  :bind (("C-x C-r" . counsel-recentf)
	 ("C-x b" . counsel-switch-buffer))
  :init
  (counsel-mode 1))

(use-package company
  :bind (:map company-active-map
              ("C-n" . company-select-next)
              ("C-p" . company-select-previous)) 
  :init
  (setq company-idle-delay 0
        company-minimum-prefix-length 2
        company-selection-wrap-around t
        company-dabbrev-downcase nil)
  (global-company-mode 1))

(use-package ddskk
  :bind ("C-x C-j" . skk-mode))

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

(use-package eshell-toggle
  :straight (:type git :host github :repo "4DA/eshell-toggle")
  :custom (eshell-toggle-size-fraction 3)
  :bind ("C-c s" . eshell-toggle))

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
	 ("\\.md$" . markdown-mode)
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
  (set-face-attribute 'markdown-table-face nil :inherit 'default))

(use-package my
  :straight (:type git :host github :repo "condotti/my-util-el"))

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

;; ----------------------------------------------------------------------
;; End of init.el
;; ----------------------------------------------------------------------
