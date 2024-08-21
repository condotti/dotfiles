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
  (set-face-attribute 'default nil :family "MeiryoKe_Console" :height 120)
  (setq line-spacing 0.5)
  (setq use-default-font-for-symbols nil)
  (add-to-list 'default-frame-alist '(width . 110))
  (add-to-list 'default-frame-alist '(height . 55))
  (when (eq system-type 'windows-nt)
    (set-fontset-font t 'unicode "Segoe UI Emoji" nil 'prepend)))
(advice-add #'display-line-numbers-mode :around
	    #'(lambda (f &rest args) (when (buffer-file-name) (apply f args))))
(set-language-environment "Japanese")
(set-default 'buffer-file-coding-system 'utf-8)
(when (eq system-type 'gnu/linux)
  (global-set-key [zenkaku-hankaku] 'toggle-input-method)
)
;; ----------------------------------------------------------------------
;; To avoid hanging-up when glyphless chars are displayed
;; ----------------------------------------------------------------------

;; ----------------------------------------------------------------------
;; autoinsert
;; ----------------------------------------------------------------------
(use-package autoinsert
  :hook
  (find-file . auto-insert)
  :config
  (add-to-list 'auto-insert-alist
	       '((".*/content/\\(post\\|fixed\\).*\\.md$" . "Hugo blog frontmatter")
		 nil
		 "---\n"
		 "date: " (format-time-string "%F %T %z") "\ntitle: " _ "\ntags: []\n---\n\n"))
  (add-to-list 'auto-insert-alist
	       '((".*/content/post/[0-9]...-[0-9].-[0-9].\\.md$" . "Hugo blog frontmatter")
		 nil
		 "---\n"
		 "date: " (format-time-string "%F %T %z") "\ntitle: " _ "\ntags: []\n---\n"
		 "### 記録\n"
		 "| 歩数 | 就寝 | トイレ | 起床 | 記録 | 備考 |\n"
		 "|------|------|--------|------|------|------|\n\n"
		 "### 朝\n### 昼\n### 夜\n### 雑記\n"))
  (add-to-list 'auto-insert-alist
	       '(("memo/.*\\.md$" . "Scribbled memo")
		 nil
		 "---\ntitle: " _ "\ndate: " (format-time-string "%F")
		 "\nauthor: \n---\n")))
;; ----------------------------------------------------------------------
;; Calendar
;; ----------------------------------------------------------------------
(use-package calendar
  :init
  (setq calendar-week-start-day 1
	calendar-day-name-array ["日曜日" "月曜日" "火曜日" "水曜日" "木曜日" "金曜日" "土曜日"]
	calendar-day-abbrev-array ["日" "月" "火" "水" "木" "金" "土"]
	calendar-day-header-array ["日" "月" "火" "水" "木" "金" "土"]
	)
  (add-hook 'calendar-today-visible-hook 'calendar-mark-today))

;; ----------------------------------------------------------------------
;; Packages
;; ----------------------------------------------------------------------
(use-package japanese-holidays
  :straight (:type git :host github :repo "emacs-jp/japanese-holidays")
  :config
  (with-eval-after-load "calendar"
    (setq calendar-holidays ; 他の国の祝日も表示させたい場合は適当に調整
          (append japanese-holidays holiday-local-holidays holiday-other-holidays))
    (setq calendar-mark-holidays-flag t) ; 祝日をカレンダーに表示
    ;; 土曜日・日曜日を祝日として表示する場合、以下の設定を追加します。
    ;; デフォルトで設定済み
    (setq japanese-holiday-weekend '(0 6) ; 土日を祝日として表示
          japanese-holiday-weekend-marker ; 土曜日を水色で表示
          '(holiday nil nil nil nil nil japanese-holiday-saturday))
    (add-hook 'calendar-today-visible-hook 'japanese-holiday-mark-weekend)
    (add-hook 'calendar-today-invisible-hook 'japanese-holiday-mark-weekend)
    (set-face-attribute 'japanese-holiday-saturday nil :background nil :inherit 'holiday)
    (set-face-attribute 'holiday nil :foreground "red" :background nil)
    (setq calendar-month-header
	  '(propertize (format "%d年 %s" year (calendar-month-name month)) 'font-lock-face 'calendar-month-header))))

(use-package jinja2-mode)

(use-package dired
  :straight nil
  :bind (:map dired-mode-map ("r" . wdired-change-to-wdired-mode)))

(use-package edit-server
  :config
  (edit-server-start))

;; (use-package elpy
;;   :ensure t
;;   :init
;;   (elpy-enable))

(use-package emacs
  :init
  (setq-default enable-recursive-minibuffers t
		inhibit-splash-screen t
		inhibit-startup-message t
		indent-tabs-mode nil
		show-trailing-whitespace t
		inhibit-compacting-font-caches t
		backup-directory-alist '((".*" . "~/.emacs.d/backup"))
		auto-save-file-name-transforms '((".*" "~/.emacs.d/backup" t)))
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (fido-vertical-mode 1))

(use-package hideshow
  :straight nil
  :bind (:map hs-minor-mode-map
	      ("C-c h" . hs-hide-all)
	      ("C-c s" . hs-show-all)
	      ("C-c t" . hs-toggle-hiding))
  :config
  (dolist (hook '(emacs-lisp-mode-hook lisp-mode-hook))
    (add-hook hook #'(lambda nil (hs-minor-mode 1)))))

;; (use-package ein)

(use-package lispy
  :init
  (dolist (hook '(lisp-mode-hook
		  emacs-lisp-mode-hook))
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
			   (windows-nt (format "C:/Users/%s/PortableApps/Pandoc/pandoc.exe" user-login-name))
			   (gnu/linux " pandoc")
			   (t "markdown"))
	markdown-split-window-direction 'right)
  :config
  (set-face-attribute 'markdown-table-face nil :inherit 'default)
  (setq-default markdown-hide-urls t)
  (setopt markdown-fontify-code-blocks-natively t
          markdown-indent-on-enter 'indent-and-new-item))

(use-package modus-themes
  :config
  (setq modus-themes-italic-constructs t
        modus-themes-bold-constructs t
        modus-themes-mixed-fonts nil
        modus-themes-variable-pitch-ui t
        modus-themes-custom-auto-reload t
        modus-themes-disable-other-themes t
        modus-themes-prompts '(italic bold))
  (load-theme 'modus-vivendi-tinted))

(use-package mozc
  :init
  (setq default-input-method "japanese-mozc")
  (setq mozc-candidate-style 'echo-area)
  (when (eq system-type 'windows-nt)
    (advice-add #'mozc-session-execute-command :after
		#'(lambda (&rest args)
		    (when (eq (nth 0 args) 'CreateSession)
		      ;; (mozc-session-sendkey '(Hankaku/Zenkaku))
		      (mozc-session-sendkey '(hiragana)))))))

(use-package powerline
  :init (powerline-default-theme))

(use-package python
  :config
  (setq python-shell-interpreter "ipython" ; linux-> ipython3
        python-shell-interpreter-args "-i --simple-prompt --InteractiveShell.display_page=True"))

;; (use-package pytest
;;   :config
;;   (defun pytest-cmd-format (&rest _) "pytest")
;;   (defun pytest-find-test-runner () nil))

(use-package recentf
  :ensure t
  :bind
  (("C-c r" . recentf-open))
  :config
  (setq recentf-auto-save-timer (run-with-idle-timer 30 t #'recentf-save-list)))

(use-package ripgrep
  :init (when (eq system-type 'windows-nt)
	  (setq ripgrep-executable (format "c:/Users/%s/AppData/Roaming/PortableApps/ripgrep/rg.exe" user-login-name))))

(use-package savehist
  :init
  (savehist-mode 1))

(use-package saveplace
  :init
  (save-place-mode t))

(use-package yaml-mode)

(use-package treemacs)

;; ----------------------------------------------------------------------
;; some util
;; ----------------------------------------------------------------------
(defun exercism-run-pytest ()
  (interactive)
  (eshell-command "python -m pytest -o marker=task *_test.py"))
;; ----------------------------------------------------------------------
;; End of init.el
;; ----------------------------------------------------------------------
