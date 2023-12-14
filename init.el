;; ----------------------------------------------------------------------
;; init.el reloaded
;; ----------------------------------------------------------------------

;; ----------------------------------------------------------------------
;; from https://yiufung.net/post/pure-emacs-lisp-init-skeleton/
;; ----------------------------------------------------------------------

;; Speed up startup
;; (setq gc-cons-threshold 402653184
;;       gc-cons-percentage 0.6)
;; (add-hook 'after-init-hook
;;           `(lambda ()
;;              (setq gc-cons-threshold 800000
;;                    gc-cons-percentage 0.1)
;;              (garbage-collect)) t)
;;
;; Default gc parameter for Raspberry Pi (2023-05-30)

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
  ;; (set-face-attribute 'default nil :family "cica" :height 120)
  ;; (set-face-attribute 'default nil :family "Iosevka Term" :height 120)
  (setq line-spacing 0.15)
  (setq use-default-font-for-symbols nil)
  (add-to-list 'default-frame-alist '(width . 100))
  (when (eq system-type 'windows-nt)
    (set-fontset-font t 'unicode "Segoe UI Emoji" nil 'prepend)))
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
(require 'autoinsert)
(add-hook 'find-file-hooks 'auto-insert)
;; (add-to-list 'auto-insert-alist
;; 	     '((".*/content/\\(post\\|fixed\\).*\\.md$" . "Hugo blog frontmatter")
;; 	       nil
;; 	       "---\n"
;; 	       "date: " (format-time-string "%F %T %z") "\ntitle: " _ "\ntags: []\n---\n\n<!-- Local Variables: -->\n<!-- truncate-lines: t -->\n<!-- eval: (add-hook 'before-save-hook #'(lambda nil (save-excursion (goto-char (point-min)) (while (re-search-forward \"max-width: *[0-9]+px\" nil t) (replace-match \"max-width: 300px\" nil nil)))) nil t) -->\n<!-- End: -->\n"))
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
	       "\nauthor: \n---\n"))
;; ----------------------------------------------------------------------
;; Calendar
;; ----------------------------------------------------------------------
(setq calendar-week-start-day 1
      calendar-day-name-array ["日曜日" "月曜日" "火曜日" "水曜日" "木曜日" "金曜日" "土曜日"]
      calendar-day-abbrev-array ["日" "月" "火" "水" "木" "金" "土"]
      calendar-day-header-array ["日" "月" "火" "水" "木" "金" "土"]
      ;; calendar-month-name-array ["睦月" "如月" "弥生" "卯月" "皐月" "水無月" "文月" "葉月" "長月" "神無月" "霜月" "師走"]
      ;; calendar-month-header '(propertize (format "%d年 %s月" year month) 'font-lock-face 'calendar-month-header)
      )
(add-hook 'calendar-today-visible-hook 'calendar-mark-today)

;; ----------------------------------------------------------------------
;; Packages
;; ----------------------------------------------------------------------
(use-package ace-window
  :bind ("C-x o" . ace-window)
  :config (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l ?\;)))

(use-package all-the-icons)

(use-package anthy
  :disabled t
  :straight (:type git :host github :repo "condotti/anthy-el")
  :config
  (define-obsolete-variable-alias 'last-command-char 'last-command-event "at least 19.34")
  (define-obsolete-function-alias 'string-to-int 'string-to-number "at least 26.1")
  ;; from https://gordiustears.net/process-kill-without-query-obsolete/
  (make-obsolete
   'process-kill-without-query
   "use `process-query-on-exit-flag' or `set-process-query-on-exit-flag'."
   "22.1")
  (defun process-kill-without-query (process &optional flag)
    "Say no query needed if PROCESS is running when Emacs is exited.
Optional second argument if non-nil says to require a query.
Value is t if a query was formerly required."
    (let ((old (process-query-on-exit-flag process)))
      (set-process-query-on-exit-flag process nil)
      old))
  :init
  (when (eq system-type 'windows-nt)
    (advice-add 'anthy-do-invoke-agent :around
		#'(lambda (f &rest args) (let ((my/anthy-context t)) (apply f args))))
    (advice-add 'anthy-add-word :around
		#'(lambda (f &rest args) (let ((my/anthy-context t)) (apply f args))))
    (advice-add 'start-process :around
		#'(lambda (f name buffer program &rest args)
		    (if (boundp 'my/anthy-context)
			(let ((proc (apply f name buffer "wsl" program args)))
			  (set-process-coding-system proc 'euc-japan 'euc-japan)
			  proc)
		      (apply f name buffer program args)))))
  (load-library "leim-list")
  (setq default-input-method 'japanese-anthy
	anthy-wide-space " "		; to avoid zenkaku space
	anthy-accept-timeout 1))

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
	  '(propertize (format "%d年 %s" year (calendar-month-name month)) 'font-lock-face 'calendar-month-header)))
  )

(use-package jinja2-mode)

(use-package cape
  ;; Bind dedicated completion commands
  ;; Alternative prefix keys: C-c p, M-p, M-+, ...
  :bind (("C-c p p" . completion-at-point) ;; capf
         ("C-c p t" . complete-tag)        ;; etags
         ;; ("C-c p d" . cape-dabbrev)        ;; or dabbrev-completion
         ("C-c p h" . cape-history)
         ("C-c p f" . cape-file)
         ("C-c p k" . cape-keyword)
         ("C-c p s" . cape-symbol)
         ("C-c p a" . cape-abbrev)
         ("C-c p l" . cape-line)
         ("C-c p w" . cape-dict)
         ("C-c p \\" . cape-tex)
         ("C-c p _" . cape-tex)
         ("C-c p ^" . cape-tex)
         ("C-c p &" . cape-sgml)
         ("C-c p r" . cape-rfc1345))
  :init
  ;; Add `completion-at-point-functions', used by `completion-at-point'.
  ;; NOTE: The order matters!
  ;; (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block)
  ;;(add-to-list 'completion-at-point-functions #'cape-history)
  ;;(add-to-list 'completion-at-point-functions #'cape-keyword)
  ;;(add-to-list 'completion-at-point-functions #'cape-tex)
  ;;(add-to-list 'completion-at-point-functions #'cape-sgml)
  ;;(add-to-list 'completion-at-point-functions #'cape-rfc1345)
  ;;(add-to-list 'completion-at-point-functions #'cape-abbrev)
  ;;(add-to-list 'completion-at-point-functions #'cape-dict)
  ;;(add-to-list 'completion-at-point-functions #'cape-symbol)
  ;;(add-to-list 'completion-at-point-functions #'cape-line)
)

(use-package counsel
  :disabled t
  :bind (("C-x C-r" . counsel-recentf)
	 ("C-x b" . counsel-switch-buffer)
	 :map minibuffer-local-map ("C-r" . counsel-minibuffer-history))
  :init
  (counsel-mode 1)
  (add-hook 'shell-mode-hook
	    #'(lambda nil (define-key shell-mode-map (kbd "C-r") 'counsel-shell-history))))

(use-package company
  :disabled t
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
  ;; (global-company-mode 1)
  :config
  (advice-add #'company-complete-selection :around
	      #'(lambda (fn) (let ((company-dabbrev-downcase t))
			   (call-interactively fn)))))

(use-package company-fuzzy
  :disabled t
  :straight (:type git :host github :repo "elpa-host/company-fuzzy") ; not in elapa stableo
  :config
  (global-company-fuzzy-mode 1))

(use-package company-go
  :disabled t)

(use-package consult
  ;; Replace bindings. Lazily loaded due by `use-package'.
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)
         ("M-s D" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)

  ;; By default `consult-project-function' uses `project-root' from project.el.
  ;; Optionally configure a different project root function.
  ;;;; 1. project.el (the default)
  ;; (setq consult-project-function #'consult--default-project--function)
  ;;;; 2. vc.el (vc-root-dir)
  ;; (setq consult-project-function (lambda (_) (vc-root-dir)))
  ;;;; 3. locate-dominating-file
  ;; (setq consult-project-function (lambda (_) (locate-dominating-file "." ".git")))
  ;;;; 4. projectile.el (projectile-project-root)
  ;; (autoload 'projectile-project-root "projectile")
  ;; (setq consult-project-function (lambda (_) (projectile-project-root)))
  ;;;; 5. No project support
  ;; (setq consult-project-function nil)
)

(use-package corfu
  ;; Optional customizations
  :custom
  (corfu-cycle t)	;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)	;; Enable auto completion
  (corfu-separator ?\s)	;; Orderless field separator
  (corfu-quit-at-boundary nil) ;; Never quit at completion boundary
  (corfu-quit-no-match nil)   ;; Never quit, even if there is no match
  (corfu-preview-current nil) ;; Disable current candidate preview
  (corfu-preselect 'prompt)   ;; Preselect the prompt
  (corfu-on-exact-match nil)  ;; Configure handling of exact matches
  (corfu-scroll-margin 5)     ;; Use scroll margin

  ;; Enable Corfu only for certain modes.
  :hook ((prog-mode . corfu-mode)
         (shell-mode . corfu-mode)
         (eshell-mode . corfu-mode))

  ;; Recommended: Enable Corfu globally.
  ;; This is recommended since Dabbrev can be used globally (M-/).
  ;; See also `corfu-exclude-modes'.
  :init
  (global-corfu-mode))

(use-package ctrlf
  :straight (:type git :host github :repo "raxod502/ctrlf")
  :config (ctrlf-mode 1))

(use-package ddskk
  :bind ("C-x C-j" . skk-mode)
  :init
  (let* ((skk-jisyo-dir "~/.emacs.d/skk-get-jisyo")
	 (skk-large-jisyo-file (concat skk-jisyo-dir "/SKK-JISYO.L")))
    (unless (file-exists-p skk-large-jisyo-file) (skk-get skk-jisyo-dir))
    (setq skk-large-jisyo skk-large-jisyo-file)))

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
	  (format "d:/USER/Program/PortableApps/PortableApps/LibreOfficePortable/LibreOfficePortable.exe" user-login-name)))
  (when (eq system-type 'gnu/linux)
    (setq dired-guess-shell-alist-user
          '(("\\.pdf\\'" "evince"))))
  (when (eq system-type 'windows-nt)
    (setq dired-guess-shell-alist-user
          '(("\\.pdf\\'" "acrord32")))))

(use-package edit-server
  :config
  (edit-server-start))

(use-package emacs
  :bind
  (("C-x C-r" . consult-recent-file))
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))

(use-package eshell-toggle
  :straight (:type git :host github :repo "4DA/eshell-toggle")
  :custom (eshell-toggle-size-fraction 3)
  :bind ("C-c e" . eshell-toggle))

(use-package go-dlv :disabled t)

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
  :config
  (when (eq system-type 'windows-nt)
    (advice-add #'go-test-current-file :around
		#'(lambda (f &rest args)
		    (interactive)
		    (let ((data (go-test--get-current-file-testing-data)))
		      (if (go-test--is-gb-project)
			  (go-test--gb-start (s-concat "-test.v=true -test.run=\"" data "\""))
			(go-test--go-test (s-concat "-run=\"" data "\" ."))))))
    (advice-add #'go-test-current-file-benchmarks :around
		#'(lambda (f &rest args)
		      (interactive)
		      (let ((benchmarks (go-test--get-current-file-benchmarks)))
			(go-test--go-test (s-concat "-run ^NOTHING -bench \"" benchmarks "\""))))))
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

(use-package hyperbole
  :disabled t)

(use-package ivy-posframe
  :disabled t
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
  ;; :straight (:type git :host github :repo "google/mozc")
  ;; :config
  ;; (when (eq system-type 'windows-nt)
  ;;   (setq mozc-helper-program-name (format "d:/Users/%s/PortableApps/emacs/bin/mozc_emacs_helper.exe" user-login-name)
  ;; 	  mozc-helper-process-timeout-sec 10))
  :init
  ;; (setq mozc-candidate-style 'overlay)
  (when (eq system-type 'windows-nt)
    (advice-add #'mozc-session-execute-command :after
		#'(lambda (&rest args)
		    (when (eq (nth 0 args) 'CreateSession)
		      ;; (mozc-session-sendkey '(Hankaku/Zenkaku))
		      (mozc-session-sendkey '(hiragana)))))))

(use-package mozc-cand-posframe
  :disabled t
  :straight (:type git :host github :repo "akirak/mozc-posframe")
  :after mozc
  :config (setq mozc-candidate-style 'posframe))

(use-package mozc-cursor-color
  :disabled t
  :straight (:type git :host github :repo "iRi-E/mozc-el-extensions")
  :config
  (setq mozc-cursor-color-alist '((direct        . "red")
                                  (read-only     . "yellow")
                                  (hiragana      . "green")
                                  (full-katakana . "goldenrod")
                                  (half-ascii    . "dark orchid")
                                  (full-ascii    . "orchid")
                                  (half-katakana . "dark goldenrod"))))

(use-package mozc-im
  ;; :straight (:tipe git :host github :repo "d5884/mozc-im")
  :init (setq default-input-method "japanese-mozc-im"))

(use-package mozc-popup
  ;; :straight (:type git :host github :repo "d5884/mozc-popup")
  :disabled t
  :config (setq mozc-candidate-style 'popup))

(use-package mozc-temp
  :bind ("C-." . mozc-temp-convert))

(use-package my
  :straight (:type git :host github :repo "condotti/my-util-el"))

(use-package neotree
  :bind ("C-c n" . neotree-toggle)
  :custom
  (neo-theme (if (display-graphic-p) 'classic 'arrow))
  (neo-show-hidden-files t))

(use-package olivetti
  :config
  (setq olivetti-body-width 0.7
	olivetti-style 'fancy))

(use-package orderless
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package org
  :straight nil
  :config
  (setq org-list-description-max-indent t
	org-adapt-indentation nil)
  :bind (:map org-mode-map ("C-c p" . my/org-export-to-pdf)))

(use-package powerline
  :init (powerline-default-theme))

(use-package recentf-ext)

(use-package ripgrep
  :init (when (eq system-type 'windows-nt)
	  (setq ripgrep-executable (format "c:/Users/%s/AppData/Roaming/PortableApps/ripgrep/rg.exe" user-login-name))))

(use-package rust-mode)

(use-package savehist
  :init
  (savehist-mode))

(use-package smex)

(use-package swiper
  :disable t
  :bind ("M-s M-s" . swiper-thing-at-point))

(use-package vertico
  :init
  (vertico-mode)

  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

  ;; Show more candidates
  ;; (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  ;; (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  ;; (setq vertico-cycle t)
  )

(use-package yaml-mode)

;; ----------------------------------------------------------------------
;; System specific variables
;; ----------------------------------------------------------------------
(when (and (eq system-type 'windows-nt)
	   (eq window-system 'w32))
  (setq browse-url-chrome-program (format "C:/Users/%s/PortableApps/GoogleChromePortable64/GoogleChromePortable.exe" user-login-name)
	browse-url-firefox-program (format "C:/Users/%s/PortableApps/FirefoxPortable/FirefoxPortable.exe" user-login-name)
	browse-url-firefox-arguments '("-new-tab")
	browse-url-browser-function 'browse-url-chrome))
;; ----------------------------------------------------------------------
;; End of init.el
;; ----------------------------------------------------------------------
