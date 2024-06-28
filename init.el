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
  (setq line-spacing 0.15)
  (setq use-default-font-for-symbols nil)
  (add-to-list 'default-frame-alist '(width . 100)))
(advice-add #'display-line-numbers-mode :around
	    #'(lambda (f &rest args) (when (buffer-file-name) (apply f args))))
(setq recentf-auto-save-timer (run-with-idle-timer 30 t #'recentf-save-list))
(set-language-environment "Japanese")
(set-default 'buffer-file-coding-system 'utf-8)
(when (eq system-type 'gnu/linux)
  (global-set-key [zenkaku-hankaku] 'toggle-input-method)
)
;; ----------------------------------------------------------------------
;; To avoid hanging-up when glyphless chars are displayed
;; ----------------------------------------------------------------------
(setq inhibit-compacting-font-caches t)

;; ----------------------------------------------------------------------
;; autoinsert
;; ----------------------------------------------------------------------
(use-package autoinsert
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

(use-package emacs
  :bind
  (("C-c r" . recentf-open))
  :init
  (setq enable-recursive-minibuffers t
	inhibit-splash-screen t
	inhibit-startup-message t)
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
  :bind (:map markdown-mode-map
	      ("C-c p" . my/markdown-export-to-pdf)
	      :map gfm-mode-map
	      ("C-c p" . my/markdown-export-to-pdf)))

(use-package mozc
  :init
  (setq default-input-method "japanese-mozc")
  (when (eq system-type 'windows-nt)
    (advice-add #'mozc-session-execute-command :after
		#'(lambda (&rest args)
		    (when (eq (nth 0 args) 'CreateSession)
		      ;; (mozc-session-sendkey '(Hankaku/Zenkaku))
		      (mozc-session-sendkey '(hiragana)))))))

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

(use-package telephone-line
  :init
  (telephone-line-mode 1))

(use-package treemacs)

;; ----------------------------------------------------------------------
;; End of init.el
;; ----------------------------------------------------------------------
