;; -*- coding: utf-8 -*-
(add-hook 'after-init-hook
          `(lambda nil (setq gc-cons-threshold ,gc-cons-threshold)))
(setq gc-cons-threshold (* 128 1024 1024))
(set-buffer-file-coding-system 'utf-8)
(modify-frame-parameters nil '((wait-for-wm . nil)))
(prefer-coding-system 'utf-8)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(add-to-list 'default-frame-alist '(font . "Ricty 12"))
(add-to-list 'default-frame-alist '(width . 100))
(add-to-list 'default-frame-alist '(alpha . (100 80)))
(defalias 'yes-or-no-p 'y-or-n-p)
;; ----------------------------------------------------------------------
;; Bootstrap `use-package'
;; ----------------------------------------------------------------------
(require 'package)
(setq package-enable-at-startup nil
      use-package-verbose t)
;; (add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
;; (add-to-list 'package-archives '("SC" . "http://joseito.republika.pl/sunrise-commander/"))
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
;; ----------------------------------------------------------------------
;; system-specific settings (trial)
;; ----------------------------------------------------------------------
(when (equal system-name "isidg58935")
  (setenv "PATH"
          (concat "d:/USER/Program/cygwin/bin"
                  path-separator
                  (getenv "PATH"))))
;; ----------------------------------------------------------------------
;; Local function definitions
;; ----------------------------------------------------------------------
(defun my/sample-text-j nil
  "Insert sample japanese text into the buffer."
  (interactive
   (insert
    "月日は百代の過客にして、行かふ年も又旅人也。舟の上に生涯をうかべ、"
    "馬の口とらえて老をむかふる物は、日々旅にして旅を栖とす。古人も多く"
    "旅に死せるあり。予もいづれの年よりか、片雲の風にさそはれて、漂泊の"
    "思ひやまず、海浜にさすらへ、去年の秋江上の破屋に蜘の古巣をはらひて、"
    "やゝ年も暮、春立る霞の空に白川の関こえんと、そゞろ神の物につきて心"
    "をくるはせ、道祖神のまねきにあひて、取もの手につかず。もゝ引の破を"
    "つゞり、笠の緒付かえて、三里に灸すゆるより、松島の月先心にかゝりて、"
    "住る方は人に譲り、杉風が別墅に移るに、\n\n"
    
    "  草の戸も住替る代ぞひなの家\n\n"
    
    "面八句を庵の柱に懸置。")))
(defun my/sample-text nil
  "Insert sample english (er, latin) text into the buffer."
  (interactive
   (insert
    "Lorem ipsum dolor sit amet, illud bonorum id mei, at duo paulo regione. "
    "Agam scaevola interesset eam cu, est in maiorum abhorreant assueverit, "
    "vero quaeque reprimique ad nam. Mundi nonumy no vix, in eam noster sanctus "
    "dissentias, ne sed denique deterruisset. Eam vero viderer delicata id, "
    "voluptatum eloquentiam ex his, per everti denique ne. Virtute philosophia "
    "usu et, qui dicta feugiat tibique eu. Nec ad populo possit singulis, ei his "
    "falli definitionem. Solet delicata pro ad.\n\n"
    
    "Id mutat periculis nec, nisl aliquando gloriatur qui ne. An pro dolor "
    "laoreet, at nec placerat corrumpit. Simul malorum adversarium mea te, "
    "enim rebum ea vim, ut prima inermis explicari nam. Mel perpetua oportere "
    "similique ea.\n\n"
    
    "Eum eu purto tota aeque, est at illum clita splendide, cu alia purto cibo "
    "vel. Cu duo tale vocent intellegat, animal facilis ea vis, dicant numquam "
    "facilisis et mea. Modo duis summo an per, an sed veniam labores graecis. "
    "Quando libris no est, et usu malis aperiam, ad novum accusata mea. Animal "
    "definitionem ut nam, eam no vidit accumsan. Ea nam vitae numquam.\n\n"
    
    "Doctus sadipscing appellantur in eum, dolor corrumpit conclusionemque sit ex, "
    "mea graeco perpetua id. Has meis graece ad. Dolore consequuntur ne vix, "
    "nec eirmod audiam definitiones ex. Vel ei invenire intellegat scribentur.\n\n"
    
    "Qui wisi dictas periculis ut, eu qui ferri viderer corrumpit. Eam no solet "
    "prompta veritus, fabulas ullamcorper vis eu, ei vis probo erroribus. Modus "
    "debitis sed ei. Has dolorem constituam eu, quo te omnis impetus.")))
(defun my/excel-to-org-table ()
  "Convert pasted excel region to org table"
  (interactive)
  (save-excursion
    (mapc #'(lambda (lst)
              (replace-regexp (car lst) (cdr lst) nil (region-beginning) (region-end)))
          '(("^" . "|")
            ("\t" . "|")
            ("#[^!]+!" . "")))))
(defun my/space-etc ()
  "Remove zenkaku space etc."
  (interactive)
  (save-excursion
    (save-restriction
      (mapc #'(lambda (lst)
                (progn
                  (goto-char (point-min))
                  (while (re-search-forward (car lst) nil t)
                    (replace-match (cdr lst)))))
            '(("　" . " ")
              ("◎" . " ")
              ("\t" . " ")
              ("（" . "(")
              ("）" . ")")
              )))))
(defun my/html-body ()
  "To paste as a html fragment, copy the content of the body tag to paste buffer."
  (interactive)
  (save-excursion
    (save-restriction
      (let ((beg (progn
                   (goto-char (point-min))
                   (search-forward-regexp "<body.*>")
                   (point)))
            (end (progn
                   (goto-char (point-max))
                   (search-backward-regexp "</body>")
                   (point))))
        (copy-region-as-kill beg end)))))
(defun my/insert-date-string (y m d)
  (interactive "nyyyy: \nnmm: \nndd: ")
  (insert (format-time-string "%m/%d(%a) "
                              (encode-time 0 0 0 d m y))))
(defun my/org-export-to-pdf ()
  "Export .org to pdf file using wkhtmltopdf."
  (interactive)
  (save-excursion
    (when (eq major-mode 'org-mode)
      (let* ((html-file (org-html-export-to-html))
             (pdf-file (concat (file-name-sans-extension html-file) ".pdf")))
        (shell-command (mapconcat #'identity
                                  (list my-htmltopdf-program my-htmltopdf-args
                                        (expand-file-name html-file)
                                        (file-name-nondirectory pdf-file))
                                  " "))
        (find-file pdf-file)))))
(setq my-htmltopdf-program (if (eq system-type 'windows-nt)
                               "\"c:/Program Files/wkhtmltopdf/bin/wkhtmltopdf.exe\""
                             "wkhtmltopdf")
      my-htmltopdf-args (mapconcat #'identity
                                   '("--header-left [doctitle]"
                                     "--footer-center [page]/[toPage]"
                                     "--header-line --footer-line"
                                     "--header-right [date]"
                                     "--header-font-size 10"
                                     "--footer-font-size 10"
                                     "--margin-top 20"
                                     "--header-spacing 2"
                                     "--footer-spacing 2"
                                     "--disable-smart-shrinking"
                                     "--print-media-type")
                                   " "))
(defun my/adoc-export (arg)
  "Convert asciidoc file to a html or a pdf by using asciidoctor.
Default to a pdf, or a html if ARG is not nil."
  (interactive "p")
  (save-excursion
    (when (eq major-mode 'adoc-mode)
      (let* ((pdf-file (concat (file-name-sans-extension buffer-file-name) ".pdf"))
             (html-file (concat (file-name-sans-extension buffer-file-name) ".html")))
        (if (= arg 1)
            (progn
              (shell-command (mapconcat #'identity
                                        (list my/adoc-to-html-program
                                              my/adoc-to-html-args
                                              buffer-file-name)
                                        " "))
              (eww-open-file html-file)) ; View with eww
          (progn
            (shell-command (mapconcat #'identity
                                      (list my/adoc-to-pdf-program
                                            my/adoc-to-pdf-args
                                            buffer-file-name)
                                      " "))
            (find-file pdf-file)))))    ; View with docview
    )
  )
(setq my/adoc-to-pdf-program (if (eq system-type 'windows-nt)
                                 (concat "d:/USER/Program/cygwin/bin/ruby.exe "
                                         (expand-file-name "~/bin/asciidoctor-pdf"))
                               "asciidoctor-pdf")
      my/adoc-to-pdf-args "-r asciidoctor-pdf-cjk"
      my/adoc-to-html-program (if (eq system-type 'windows-nt)
                                  (concat "d:/USER/Program/cygwin/bin/ruby.exe "
                                          (expand-file-name "~/bin/asciidoctor"))
                                "asciidoctor")
      my/adoc-to-html-args "")
(defun my/ido-recentf-open nil
  "Use `ido-completing-read' to \\[find-file] a recent file."
  (interactive)
  (if (find-file (ido-completing-read "Find recent file: " recentf-list))
      (message "Opening file...")
    (message "Aborting...")))
(defun my/clojure-cheatsheet nil
  (interactive)
  (eww "http://clojure.org/cheatsheet"))
(defun my/dummy-function (&optional arg)
  (message "dummy"))
;; ----------------------------------------------------------------------
;; some useful functions
;; ----------------------------------------------------------------------
;;  from: http://ensime.github.io/editors/emacs/hacks/
(defun contextual-backspace ()
  "Hungry whitespace or delete word depending on context."
  (interactive)
  (if (looking-back "[[:space:]\n]\\{2,\\}" (- (point) 2))
      (while (looking-back "[[:space:]\n]" (- (point) 1))
        (delete-char -1))
    (cond
     ((and (boundp 'smartparens-strict-mode)
           smartparens-strict-mode)
      (sp-backward-kill-word 1))
     (subword-mode
      (subword-backward-kill 1))
     (t
      (backward-kill-word 1)))))
(global-set-key (kbd "C-<backspace>") 'contextual-backspace)
;; ----------------------------------------------------------------------
;; from http://endlessparentheses.com/disable-mouse-only-inside-emacs.html
;; ----------------------------------------------------------------------
(define-minor-mode disable-mouse-mode
  "A minor-mode that disables all mouse keybinds."
  :global t
  :lighter "🐭"
  :keymap (make-sparse-keymap))
(dolist (type '(mouse down-mouse drag-mouse
                      double-mouse triple-mouse))
  (dolist (prefix '("" C- M- S- M-S- C-M- C-S- C-M-S-))
    ;; Yes, I actually HAD to go up to 7 here.
    (dotimes (n 7)
      (let ((k (format "%s%s-%s" prefix type n)))
        (define-key disable-mouse-mode-map
          (vector (intern k)) #'ignore)))))
;; ----------------------------------------------------------------------
;; Handle Japanese file name for ntemacs
;; ----------------------------------------------------------------------
(when (eq system-type 'windows-nt)
  (advice-add #'shell-command :filter-args
              (lambda (args)
                (cons (encode-coding-string (car args) 'cp932) (cdr args)))))
;; ----------------------------------------------------------------------
;; Packages
;; ----------------------------------------------------------------------
;; number etc.
;; A
(use-package adoc-mode
  :ensure t
  :mode "\\.adoc\\'"
  :bind (:map adoc-mode-map ("C-c p" . my/adoc-export)))
(use-package ag
  :ensure t
  :config
  (when (eq system-type 'windows-nt)
    (setq default-process-coding-system '(utf-8-dos . cp932))))
(use-package aggressive-indent
  :ensure t
  :config
  (defalias 'aggressive-indent--check-parens 'my/dummy-function) ; temporary fix
  (add-to-list 'aggressive-indent-excluded-modes 'html-mode)
  (global-aggressive-indent-mode 1)
  :diminish "⇒")
(use-package alchemist
  :ensure t)
(use-package auto-package-update
  :disabled t
  :config (setq auto-package-update-interval 14)
  :init (auto-package-update-maybe))
;; B
(use-package bug-hunter
  :ensure t                             ; disable if not used
  )
;; C
(use-package cargo
  :ensure t
  :init
  (add-hook 'rust-mode-hook 'cargo-minor-mode))
(use-package cider
  :ensure t
  :config
  (when (eq system-type 'windows-nt)
    (setq cider-lein-command (expand-file-name "~/bin/lein.bat")))
  (setq cider-lein-parameters "trampoline repl :headless"))
;; (use-package clojure-cheatsheet
;;   :bind (:map clojure-mode-map ("C-c C-h" . clojure-cheatsheet))
;;   :ensure t
;;   :init
;;   (defalias 'nrepl-current-connection-buffer 'nrepl-connection-buffer-name))
(use-package company
  :ensure t
  :bind (:map company-active-map
              ("C-n" . company-select-next)
              ("C-p" . company-select-previous)) 
  :init
  (setq company-idle-delay 0
        company-minimum-prefix-length 2
        company-selection-wrap-around t)
  (global-company-mode)
  :diminish "🏢")
(use-package company-go
  :init
  (when (eq system-type 'windows-nt)
    (setq company-go-gocode-command
          (expand-file-name "bin/gocode.exe" (getenv "GOPATH"))))
  (add-hook 'go-mode-hook
            (lambda nil
              (set (make-local-variable 'company-backends) '(company-go))))
  :ensure t)
(use-package counsel
  :ensure t
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)))
(use-package cyberpunk-theme
  :disabled t
  :config
  (load-theme 'cyberpunk t))
;; D
(use-package darkokai-theme
  :ensure t
  :config
  (setq darkokai-mode-line-padding 1)
  (load-theme 'darkokai t))
(use-package deft
  :ensure t
  :bind (("C-c d" . deft))
  :config (setq deft-directory "~/.deft"
                deft-extensions "org"
                deft-default-extension "org"
                deft-text-mode 'org-mode
                deft-use-filename-as-title t
                deft-use-filter-string-for-filename t
                deft-auto-save-interval 0))
(use-package dired
  :bind (:map dired-mode-map ("r" . wdired-change-to-wdired-mode)))
(use-package dired-narrow
  :ensure t
  ;; :bind (:map dired-mode-map ("/" . dired-narrow))
  :commands dired-narrow
  :init (add-hook 'dired-load-hook
                  #'(lambda nil (define-key dired-mode-map "/" 'dired-narrow))))
(use-package doc-view
  :ensure t
  :config
  (when (eq system-type 'windows-nt)
    (setq doc-view-ghostscript-program
          "C:/Program Files/Bullzip/PDF Printer/gs/gswin64c.exe"
          doc-view-pdftotext-program
          "d:/USER/Program/PortableApps/PortableApps/xpdf-3.04/pdftotext.exe"
          doc-view-odf->pdf-converter-program
          "d:/USER/Program/PortableApps/PortableApps/LibreOfficePortable/LibreOfficePortable.exe")))
(use-package dumb-jump
  :config
  (when (equal system-type 'windows-nt)
    (setq dumb-jump-grep-cmd "d:/USER/Program/cygwin/bin/grep.exe"
          dumb-jump-ag-cmd "d:/USER/Program/cygwin/bin/ag.exe"))
  :ensure t)
;; E
(use-package eldoc
  :defer t
  :config
  (dolist (h '(emacs-lisp-mode-hook
               lisp-interaction-mode-hook
               eval-expression-minibuffer-setup-hook
               cider-repl-mode-hook))
    (add-hook h 'turn-on-eldoc-mode))
  :diminish "📖")
(use-package elixir-mode
  :ensure t
  :defer t)
(use-package elnode
  :ensure t)
(use-package emoji-fontset
  :ensure t
  :init
  (emoji-fontset-enable "Segoe UI Symbol"))
;; F
;; G
(use-package go-eldoc
  :ensure t)
(use-package go-mode
  :ensure t)
(use-package graphviz-dot-mode
  :ensure t)
;; H
(use-package haskell-mode
  :ensure t
  :mode "\\.hs\'")
(use-package helm
  :defer t
  :disabled t
  :bind (("M-x" . helm-M-x)
         ;; ("C-x C-f" . helm-find-files)
         ("C-x C-r" . helm-recentf)
         ("M-y" . helm-show-kill-ring)
         ;; ("C-c i" . helm-imenu)
         ("C-x b" . helm-buffers-list)
         :map helm-map ("C-h" . delete-backward-char)
         :map helm-find-files-map ("C-h" . delete-backward-char)
         :map helm-find-files-map ("TAB" . helm-execute-persistent-action)
         :map helm-read-file-map ("TAB" . helm-execute-persistent-action))
  :config
  (require 'helm-config)
  (setq helm-M-x-always-save-history t)
  :diminish "")
(use-package highlight-indentation
  :ensure t
  :config
  (add-hook 'emacs-lisp-mode-hook 'highlight-indentation-mode)
  (add-hook 'web-mode-hook 'highlight-indentation-mode))
;; I
(use-package ivy
  :diminish "🌿")
;; (use-package ido
;;   :ensure t
;;   :bind (("C-x C-r" . my/ido-recentf-open))
;;   :config (setq ido-everywhere t
;;                 ido-enable-dot-prefix t
;;                 ido-use-filename-at-point 'guess))
;; (use-package ido-ubiquitous
;;   :ensure t
;;   :config (ido-ubiquitous-mode 1))
;; (use-package ido-vertical-mode
;;   :ensure t
;;   :config
;;   (ido-vertical-mode 1)
;;   (setq ido-vertical-define-keys 'C-n-C-p-up-and-down))
;; J
;; K
(use-package key-chord
  :disabled t
  :config
  (dotimes (i 26)
    (key-chord-define-global
     (concat " " (string (+ i ?a)))
     (string (+ i ?A))))
  (key-chord-mode 1))
;; L
(use-package lispy
  :defer t
  :ensure t
  :init
  (dolist (h '(emacs-lisp-mode-hook
               clojure-mode-hook
               cider-repl-mode-hook))
    (add-hook h (lambda nil (lispy-mode 1))))
  :bind (:map lispy-mode-map-lispy (":" . self-insert-command))
  :diminish "λ")
;; M
(use-package magit
  :defer t
  :ensure t)
(use-package migemo
  ;; :ensure t
  :disabled t
  :config
  (if (eq system-type 'windows-nt)
      (setq migemo-command (expand-file-name "~/bin/cmigemo.exe")
            migemo-dictionary (expand-file-name "~/.emacs.d/dict/utf-8/migemo-dict"))
    (setq migemo-command "cmigemo"
          migemo-dictionary "/usr/share/cmigemo/utf-8/migemo-dict"))
  (setq migemo-options '("-q" "--emacs" "-i" "\a")
        migemo-coding-system 'utf-8-unix
        migemo-user-dictionary nil
        migemo-regex-dictionary nil))
(use-package mozc
  :when (eq system-type 'gnu/linux)
  :ensure t
  :bind (("<hankaku>" . toggle-input-method)
         ("<zenkaku>" . toggle-input-method))
  :init
  (advice-add 'mozc-session-execute-command
              :after (lambda (&rest args)
                       (when (eq (nth 0 args) 'CreateSession)
                         (mozc-session-sendkey '(hiragana)))))
  (setq default-input-method 'japanese-mozc))
(use-package mozc-popup
  :when (eq system-type 'gnu/linux)
  :ensure t
  :init
  (setq mozc-candidate-style 'popup))
(use-package multiple-cursors
  :ensure t
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)))
;; N
(use-package neotree
  :ensure t
  :config
  (setq neo-smart-open t
        neo-create-file-auto-open t
        neo-keymap-style 'concise))
;; O
(use-package org
  :ensure t
  :mode ("\\.org\\'" . org-mode)
  :config
  (setq org-list-description-max-indent t
        org-adapt-indentation nil
        org-ditaa-jar-path "~/.emacs.d/etc/ditaa0_9.jar")
  (add-hook 'org-mode-hook #'(lambda nil (setq mode-name "📓")))
  :init
  (org-babel-do-load-languages
   'org-babel-load-languages '((dot . t)))
  :bind (:map org-mode-map ("C-c p" . my/org-export-to-pdf)))
;; P
(use-package peep-dired
  :ensure t
  :defer t
  :bind (:map dired-mode-map ("P" . peep-dired)))
(use-package powerline
  :if (eq system-type 'gnu/linux)
  :ensure t
  :config
  (powerline-default-theme))
(use-package powershell
  :if (eq system-type 'windows-nt)
  :ensure t
  :mode ("\\.ps1\\'" . powershell-mode))
;; Q
;; R
(use-package racer
  :ensure t
  :config
  (add-hook 'cargo-minor-mode-hook 'racer-mode)
  (add-hook 'racer-mode-hook 'company-mode))
(use-package recentf
  :ensure t
  :config
  (setq recentf-max-menu-items 100
        recentf-max-saved-items 100))
(use-package re-builder
  :bind (("C-c R" . re-builder))
  :config (setq reb-re-syntax 'string))
(use-package rust-mode
  :ensure t
  :mode "\\.rs\\'"
  :config
  (add-hook 'rust-mode-hook 'electric-pair-mode))
;; S
(use-package shrink-whitespace
  :ensure t
  :bind (("M-\\" . shrink-whitespace)))
(use-package sicp
  :ensure t)
(use-package smex
  :disabled t
  :bind (("M-x" . smex))
  :config (smex-initialize))
(use-package spu
  :ensure t
  :defer 10
  :config
  (spu-package-upgrade-daily))
(use-package sql-indent
  :init
  (add-hook 'sql-mode-hook (lambda nil (load-library "sql-indent"))))
(use-package sunshine
  :ensure t
  :config
  (setq sunshine-location "Tokyo, JP"
        sunshine-appid "f47775f279d8a2678be89e39dd3f9653"
        sunshine-units 'metric
        sunshine-show-icons t))
(use-package swiper
  :ensure t
  :bind (("C-s" . swiper)
         ("C-c C-r" . ivy-resume)
         ("C-x C-r" . ivy-recentf))
  :init
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t))
;; T
(use-package timp
  :demand t)
(use-package toml-mode
  :ensure t
  :mode "\\.toml\\'")
;; U
;; V
(use-package vdiff
  :ensure t
  :bind (:bind vdiff-mode-map ("C-c" . vdiff-mode-prefix-map)))
(use-package volatile-highlights
  :ensure t
  :config
  (volatile-highlights-mode t)
  :diminish "")
;; W
(use-package web-mode
  :ensure t
  :mode ("\\.phtml$"
         "\\.tpl\\.php$"
         "\\.[agj]sp$"
         "\\.as[cp]x\\'"
         "\\.erb\\'"
         "\\.mustache\\'"
         "\\.djhtml\\'"
         "\\.html?\\'")
  :config (setq
           web-mode-html-offset 2
           web-mode-css-offset 2
           web-mode-script-offset 2
           web-mode-php-offset 2
           web-mode-java-offset 2
           web-mode-asp-offset 2))
(use-package which-key
  :ensure t
  :config
  (which-key-mode 1)
  :diminish "")
(use-package wttrin
  :disabled t
  :commands (wttrin)
  :init
  (setq wttrin-default-cities '("Tokyo" "Yokohama")))
;; X
;; Y
(use-package yalinum
  :ensure t
  :config
  (setq yalinum-delay t
        yalinum-eager nil
        yalinum-format "%5d ")
  :init
  ;; (defadvice yalinum-on (around yalinum-on-around)
  ;;   (when (buffer-file-name)
  ;;     ad-do-it))
  (advice-add #'yalinum-on :around
              (lambda (f &rest args) (when (buffer-file-name) (apply f args))))
  ;; (add-function :before-until 'yalinum-on #'(lambda nil (null (buffer-file-name))))
  (global-yalinum-mode 1))
;; Z
;; ----------------------------------------------------------------------
;; misc settings
;; ----------------------------------------------------------------------
(add-hook 'lisp-interaction-mode-hook #'(lambda nil (setq mode-name "🏩")))
(add-hook 'emacs-lisp-mode-hook #'(lambda nil (setq mode-name "🌌")))
(add-hook 'doc-view-mode-hook #'(lambda nil (setq mode-name "📜")))
(add-hook 'messages-buffer-mode-hook #'(lambda nil (setq mode-name "💬")))
(add-hook 'text-mode-hook #'(lambda nil (setq mode-name "✎")))
(add-to-list 'auto-mode-alist '("\\.eml\\'" . text-mode))
;; ----------------------------------------------------------------------
;; Customize interface
;; ----------------------------------------------------------------------
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)
;; ----------------------------------------------------------------------
;; End of init.el
;; ----------------------------------------------------------------------
