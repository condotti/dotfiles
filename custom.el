(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(backup-directory-alist (quote ((".*" . "~/.emacs.d/backup"))))
 '(calendar-week-start-day 1)
 '(cua-enable-cua-keys nil)
 '(cua-mode t nil (cua-base))
 '(custom-safe-themes
   (quote
    ("83e584d74b0faea99a414a06dae12f11cd3176fdd4eba6674422539951bcfaa8" default)))
 '(dired-listing-switches "-alh")
 '(display-time-mode t)
 '(eww-search-prefix "http://www.google.com/search?q=")
 '(fringe-mode 0 nil (fringe))
 '(global-hl-line-mode nil)
 '(global-hl-line-sticky-flag t)
 '(global-prettify-symbols-mode t)
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
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
    (all-the-icons-dired all-the-icons sql-indent paredit dired-icon ox-twbs dired-filter kosmos-theme material-theme ag sicp lyrics vdiff highlight-indentation visutal-indentation-mode highlight-indent-guides multiple-cursors dumb-jump dump-jump sunshine wttrin org company-go go-eldoc powershell yalinum w3m undo-tree tiny tabbar sunrise-commander stripe-buffer shrink-whitespace popwin peep-dired mozc-popup markdown-mode+ lacarte jade-mode j-mode gnuplot-mode gnuplot fuzzy frame-cmds evil-numbers esup direx cyberpunk-theme clojure-mode-extra-font-locking auto-package-update auto-compile adoc-mode ac-mozc 2048-game)))
 '(paradox-automatically-star t)
 '(paradox-github-token t)
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
 '(tab-always-indent (quote complete)))
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
