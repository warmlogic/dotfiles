;; ~/.emacs

;; Defined Keys:
;;
;; C-c $           -- TeX-dollar-sign-skeleton
;; M-+             -- word-count mode
;; C-$             -- ispell-word
;; C-M-q           -- unfill-paragraph
;; C-M-x           -- tex-frame (pdflatex on \begin{frame})
;; M-y             -- browse-kill-ring (unless last command was a yank,
;;                                      then it just runs yank-pop as usual)
;; C-x b / C-x C-b -- iswitchb-buffer1
;; A-mouse-1       -- mouse-2
;; M-mouse-1       -- mouse-3

;; Set up path to addons
(add-to-list 'load-path "~/.emacs.d/lisp/")

; start up emacs server so I can run emacs-client calls
(server-start)

;; Don't give me the startup message
(setq inhibit-startup-message t)

;; I'm not a big fan of the toolbar
(when (boundp 'aquamacs-version)
  (tool-bar-mode -1)
)

;; make a flash, not a beep
(setq visible-bell t)

;; add in muse customizations
;; https://github.com/alexott/muse
;(load "muse-conf")

;; TeX customizations
(load "tex-conf")

;(autoload 'flyspell-mode "flyspell" "On-the-fly ispell" t)
(add-hook 'TeX-mode-hook (lambda () (flyspell-mode 1)))
(add-hook 'LaTeX-mode-hook (lambda () (flyspell-mode 1)))
;(add-hook 'muse-mode-hook (lambda () (flyspell-mode 1)))
(add-hook 'text-mode-hook (lambda () (flyspell-mode 1)))

;; option-click to get flyspell correction menu
(setq flyspell-mouse-map
      (let ((map (make-sparse-keymap)))
        ;(define-key map [A-mouse-1] 'flyspell-correct-word)
        (define-key map [mouse-2] 'flyspell-correct-word)
        map))

(global-set-key [M-backspace] 'backward-kill-word)

;; commenting, not really key-bindings
(defalias 'c 'comment-region)
(defalias 'u 'uncomment-region)

;; A-mouse-1: mouse-2; M-mouse-1: mouse-3
(setq mac-emulate-three-button-mouse t)
;; M-mouse-1: mouse-2; A-mouse-1: mouse-3
;; (setq mac-emulate-three-button-mouse 'reverse)

;; Set up browse-kill-ring.  M-y invokes browse-kill-ring.
(require 'browse-kill-ring+)
(browse-kill-ring-default-keybindings)

;; Turn on IswitchBuffers
;(iswitchb-mode 1)

;; set some aquamacs customizations
(when (boundp 'aquamacs-version)
  ;; put the emacs kill-ring on the clipboard
  (setq x-select-enable-clipboard t)
  (setq osx-key-mode nil)
  (setq auto-word-wrap-default-function nil)
  )

(when (boundp 'aquamacs-version)
  ;; set the font
  ;(set-default-font "-apple-monaco-medium-r-normal--14-140-72-72-m-140-mac-roman")
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'alt)
  ;;(defun delete-window-if-created-for-buffer () nil)
  ;; do not load persistent scratch buffer
  (setq aquamacs-scratch-file nil)
  ;; do not make initial frame visible
  ;(setq show-scratch-buffer-on-startup nil)
  ;(setq max-specpdl-size 10000)
  ;; open *help* in current frame for `one-buffer-one-frame-mode'
  ;(setq obof-other-frame-regexps (remove "\\*Help\\*" obof-other-frame-regexps))
  ;(add-to-list 'obof-same-frame-regexps "\\*Help\\*")
  ;(add-to-list 'obof-same-frame-switching-regexps "\\*Help\\*")
  ;; don't turn on auto-word-wrap (i.e., soft word wrap)
  ;(setq auto-word-wrap-default-function nil)
  ;; if we turn on the toolbar, only show labels
  ;;(setq mac-tool-bar-display-mode 'labels)
  )

;; -----------------------------------------------------------------------------
;; Key Bindings
;; -----------------------------------------------------------------------------

;; Set up word count
(autoload 'word-count-mode "word-count"
           "Minor mode to count words." t nil)
(global-set-key "\M-+" 'word-count-mode)

;; run ispell on the current word
(global-set-key (kbd "C-$") 'ispell-word) ;normally bound to M-$, but
                                          ;that conflicts with OS X
                                          ;key combo for picture grab

;; iswitch buffer in addition to C-x b
(global-set-key "\C-x\C-b" 'iswitchb-buffer)

;; -----------------------------------------------------------------------------
;; Functions
;; -----------------------------------------------------------------------------

;;; Stefan Monnier <foo at acm.org>. It is the opposite of
;;; fill-paragraph Takes a multi-line paragraph and makes it into a
;;; single line of text.
(defun unfill-paragraph ()
  (interactive)
  (let ((fill-column (point-max)))
        (fill-paragraph nil)))
(global-set-key [(alt meta q)] 'unfill-paragraph)

(defun find-next-double-word ()
  "move to next doubled word, ignoring <...> tags and any
  whitespace (including new lines)."
  (interactive)
  (re-search-forward "\\<\\([a-z]+\\)\\([\n \t]\\|<[^>]+>\\)+\\1\\>"))

;; (defun kill-buffer-and-frame ()
;;   (interactive)
;;   (progn
;;     (kill-buffer (buffer-name))
;;     (delete-frame)
;;     ))
;; (global-set-key [(control alt k)] 'kill-buffer-and-frame)

(defun kill-buffer-only ()
  (interactive)
  (progn
    (kill-buffer (buffer-name))
;;    (delete-frame)
    ))
(global-set-key [(control alt k)] 'kill-buffer-only)

;; Set initial frame dimensions
(setq initial-frame-alist
      '(
	(top . 30)
	(left . 10)
;;	(width . 80)
;;	(height . 51) ;; large display
;;	(height . 45) ;; 15"
;;	(alpha . (100 90))  ;; transparency; active inactive
	))

;; set up frame defaults
(setq default-frame-alist
      '(
	(width . 80)
;;	(height . 51) ;; large display
	(height . 45) ;; 15"
	(alpha . (100 90))  ;; transparency; active inactive
	(cursor-color . "Black")
        ;; don't use the following font with a small display
;;	(font . "-apple-monaco-medium-r-normal--14-160-72-72-m-160-iso10646-1")
;;	(font . "-apple-anonymous-medium-r-normal--14-0-0-0-m-0-iso10646-1")
	))

(when (boundp 'aquamacs-version)
  ;; Some fancy frame color stuph
  ;;"#9ADFC2" not great
  (defvar frame-colors-list `("#DEDF96" "#B9DE91" "#C8C3DF"))
  ;(defvar frame-colors-list `("DarkOliveGreen2" "LightBlue" "lavender"))
  (defvar frame-colors-index 0)

  (defun make-frame-cycle-color (frame)
    (let ((old-frame (selected-frame)))
      (select-frame frame)
      ;;(set-foreground-color "white")
      (set-background-color (nth frame-colors-index frame-colors-list))
      (select-frame old-frame))
    (setq frame-colors-index (1+ frame-colors-index))
    (if (<= (length frame-colors-list) frame-colors-index)
	(setq frame-colors-index 0)))
  (add-hook `after-make-frame-functions `make-frame-cycle-color)

  ;; set the starting color (random, then cycle from there)
  (random t)
  (setq frame-colors-index (random (length frame-colors-list)))
  (set-background-color (nth frame-colors-index frame-colors-list))
  (setq frame-colors-index (1+ frame-colors-index))
  (if (<= (length frame-colors-list) frame-colors-index)
      (setq frame-colors-index 0))
  )
;; -----------------------------------------------------------------------------
;; -----------------------------------------------------------------------------

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(LaTeX-command "latex -synctex=1")
 '(c-offsets-alist (quote ((substatement-open . 0))))
 '(case-fold-search t)
 '(column-number-mode t)
 '(comint-completion-addsuffix t)
 '(comint-completion-autolist t)
 '(comint-input-ignoredups t)
 '(comint-scroll-show-maximum-output t)
 '(comint-scroll-to-bottom-on-input t)
 '(comint-scroll-to-bottom-on-output t)
 '(current-language-environment "Latin-1")
 '(default-input-method "latin-1-prefix")
 '(flyspell-issue-welcome-flag nil)
 '(flyspell-tex-command-regexp "\\(\\(begin\\|end\\)[ 	]*{\\|\\(shortcite[a-z*]*\\|\\cite[a-z*]*\\|label\\|ref\\|eqref\\|usepackage\\|documentclass\\)[ 	]*\\(\\[[^]]*\\]\\)?{[^{}]*\\)")
 '(global-font-lock-mode t nil (font-lock))
 '(global-hl-line-mode 1)
 '(matlab-auto-fill t)
 '(matlab-fill-code nil)
 '(mouse-wheel-mode t nil (mwheel))
 '(mouse-wheel-scroll-amount (quote (1 ((shift) . 5) ((control shift)))))
 ;'(muse-wiki-ignore-implicit-links-to-current-page t)
 ;'(muse-wiki-match-all-project-files t)
 ;'(muse-wiki-use-wikiword t)
 ;'(muse-wiki-wikiword-regexp "\\<\\(\\(?:[[:upper:]]+[[:lower:]]+\\)\\(?:[[:upper:]]+[[:lower:]]+\\)+\\(?:[[:alnum:]]*\\)\\)")
 ;'(pc-selection-mode t nil (pc-select))
 '(show-paren-mode t)
 '(transient-mark-mode t)
 '(truncate-partial-width-windows nil))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
