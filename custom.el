(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#242728" "#ff0066" "#63de5d" "#E6DB74" "#06d8ff" "#ff8eff" "#53f2dc" "#f8fbfc"])
 '(backup-directory-alist (quote ((".*" . "~/.emacs.d/backup"))))
 '(calendar-week-start-day 1)
 '(compilation-message-face (quote default))
 '(cua-enable-cua-keys nil)
 '(cua-mode t nil (cua-base))
 '(custom-enabled-themes (quote (dark-mint)))
 '(custom-safe-themes
   (quote
    ("6ee6f99dc6219b65f67e04149c79ea316ca4bcd769a9e904030d38908fd7ccf9" "3acd6c080ef00f41997222d10253cb1eefc6f5229a63ccf0a7515fb98b09e88a" "1b1e54d9e0b607010937d697556cd5ea66ec9c01e555bb7acea776471da59055" "70403e220d6d7100bae7775b3334eddeb340ba9c37f4b39c189c2c29d458543b" "eb1d693e6296837a7c9e63d8707f72a97b9c071960f06849ec6a332f23eae276" "c8741cb6c1da21f3d45f644a0e6a3ac72b535e1fb9986c0839ca53a13e743a61" "a01c1f02e2397a1932988bbd2b096e858b497a3de063f8191ae113b310d9ca1c" "92a2e4197b19ff8f868d254c673a329fca57e04e284bb5fa0255b6cbe470641b" "2b6a809384ba9a07cb4ac89f6f5762249e67dd28f024cc54b7d1d996b7e1b65a" "62258a0a519f829f4993295cc172805bd60a1591af4c82522d8025187e86f2a4" "b9530ae98abde52a570e083296f8b80e034a153675fd5ddbf7f9897119da4a85" "c0cc8bb8ec991869bceb9472791a09abc4749c0360961171f3b8ef6329e9d180" "83e584d74b0faea99a414a06dae12f11cd3176fdd4eba6674422539951bcfaa8" default)))
 '(dired-listing-switches "-alh")
 '(display-time-mode t)
 '(eww-search-prefix "http://www.google.com/search?q=")
 '(fci-rule-color "#424748")
 '(fringe-mode 0 nil (fringe))
 '(global-hl-line-mode nil)
 '(global-hl-line-sticky-flag t)
 '(global-prettify-symbols-mode t)
 '(glyphless-char-display-control (quote ((no-font . empty-box))))
 '(highlight-changes-colors (quote ("#ff8eff" "#ab7eff")))
 '(highlight-tail-colors
   (quote
    (("#424748" . 0)
     ("#63de5d" . 20)
     ("#4BBEAE" . 30)
     ("#1DB4D0" . 50)
     ("#9A8F21" . 60)
     ("#A75B00" . 70)
     ("#F309DF" . 85)
     ("#424748" . 100))))
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(magit-diff-use-overlays nil)
 '(mouse-avoidance-mode (quote proteus) nil (avoid))
 '(org-src-lang-modes
   (quote
    (("ocaml" . tuareg)
     ("elisp" . emacs-lisp)
     ("ditaa" . artist)
     ("asymptote" . asy)
     ("dot" . graphviz-dot)
     ("sqlite" . sql)
     ("calc" . fundamental)
     ("C" . c)
     ("cpp" . c++)
     ("C++" . c++)
     ("screen" . shell-script))))
 '(package-selected-packages
   (quote
    (markdown-preview-eww markdown-preview-mode request edit-server atomic-chrome dark-mint-theme ein nubox darkokai-theme i3wm recentf-ext simple-httpd all-the-icons-dired all-the-icons sql-indent paredit dired-icon ox-twbs dired-filter kosmos-theme material-theme ag sicp lyrics vdiff highlight-indentation visutal-indentation-mode highlight-indent-guides multiple-cursors dumb-jump dump-jump sunshine wttrin org company-go go-eldoc powershell yalinum w3m undo-tree tiny tabbar sunrise-commander stripe-buffer shrink-whitespace popwin peep-dired mozc-popup markdown-mode+ lacarte jade-mode j-mode gnuplot-mode gnuplot fuzzy frame-cmds evil-numbers esup direx cyberpunk-theme clojure-mode-extra-font-locking auto-package-update auto-compile adoc-mode ac-mozc 2048-game)))
 '(paradox-automatically-star t)
 '(paradox-github-token t)
 '(pos-tip-background-color "#E6DB74")
 '(pos-tip-foreground-color "#242728")
 '(prettify-symbols-unprettify-at-point (quote right-edge))
 '(read-buffer-completion-ignore-case t)
 '(recentf-max-menu-items 50)
 '(recentf-mode t)
 '(safe-local-variable-values
   (quote
    ((cider-cljs-lein-repl . "(do (dev) (go) (cljs-repl))")
     (cider-refresh-after-fn . "reloaded.repl/resume")
     (cider-refresh-before-fn . "reloaded.repl/suspend")
     (org-html-preamble-format
      ("en" "<h1 class='mytitle'>%t</h1>"))
     (org-html-postamble-format
      ("en" "<div style='text-align:right'>以上</div>"))
     (org-html-postamble . t)
     (org-html-postamble)
     (org-html-preamble-format
      ("en" "<h1 class='mytitle'>%t (%d)</h1>"))
     (org-html-preamble . t))))
 '(save-place-mode t)
 '(scroll-margin 3)
 '(server-mode t)
 '(show-paren-mode t)
 '(tab-always-indent (quote complete))
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#ff0066")
     (40 . "#CF4F1F")
     (60 . "#C26C0F")
     (80 . "#E6DB74")
     (100 . "#AB8C00")
     (120 . "#A18F00")
     (140 . "#989200")
     (160 . "#8E9500")
     (180 . "#63de5d")
     (200 . "#729A1E")
     (220 . "#609C3C")
     (240 . "#4E9D5B")
     (260 . "#3C9F79")
     (280 . "#53f2dc")
     (300 . "#299BA6")
     (320 . "#2896B5")
     (340 . "#2790C3")
     (360 . "#06d8ff"))))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   (unspecified "#242728" "#424748" "#F70057" "#ff0066" "#86C30D" "#63de5d" "#BEB244" "#E6DB74" "#40CAE4" "#06d8ff" "#FF61FF" "#ff8eff" "#00b2ac" "#53f2dc" "#f8fbfc" "#ffffff")))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(hl-line ((t (:inherit highlight :inverse-video t))))
 '(j-adverv-face ((t (:foreground "Green"))))
 '(j-conjunction-face ((t (:foreground "Blue"))))
 '(j-other-face ((t (:foreground "White"))))
 '(j-verv-face ((t (:foreground "Red"))))
 '(markdown-header-face ((t (:inherit default :foreground "#A6E22E"))))
 '(markdown-header-face-1 ((t (:inherit markdown-header-face :foreground "snow1" :height 1.0))))
 '(markdown-header-face-2 ((t (:inherit markdown-header-face :foreground "medium spring green" :height 1.0))))
 '(markdown-header-face-3 ((t (:inherit markdown-header-face :foreground "yellow" :height 1.0))))
 '(markdown-header-face-4 ((t (:inherit markdown-header-face :height 1.0))))
 '(org-document-title ((t (:background "#000000" :foreground "#add8e6" :weight bold :height 1.0))))
 '(org-level-1 ((t (:inherit fixed-pitch :foreground "#ff1493" :height 1.0))))
 '(org-level-2 ((t (:inherit fixed-pitch :foreground "#ffff00" :height 1.0))))
 '(org-level-3 ((t (:inherit fixed-pitch :foreground "#4c83ff" :height 1.0))))
 '(org-level-4 ((t (:inherit fixed-pitch :foreground "#E6DB74" :height 1.0))))
 '(org-level-5 ((t (:inherit fixed-pitch :foreground "#53f2dc"))))
 '(org-level-6 ((t (:inherit fixed-pitch :foreground "#63de5d"))))
 '(tabbar-default ((t (:inherit nil :background "white" :foreground "black" :height 1))))
 '(yalinum-face ((t (:inherit linum :foreground "gray70")))))
