(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(setq gc-cons-threshold 100000000)
(setq inhibit-startup-message t)

(defalias 'yes-or-no-p 'y-or-n-p)

(defconst demo-packages
  '(anzu
    company
    duplicate-thing
    ggtags
    helm
    helm-gtags
    helm-projectile
    helm-swoop
    helm-c-yasnippet
    function-args
    clean-aindent-mode
    comment-dwim-2
    dtrt-indent
    ws-butler
    iedit
    yasnippet
    smartparens
    projectile
    volatile-highlights
    undo-tree
    zygospore
    org-trello))

(defun install-packages ()
  "Install all required packages."
  (interactive)
  (unless package-archive-contents
    (package-refresh-contents))
  (dolist (package demo-packages)
    (unless (package-installed-p package)
      (package-install package))))

(install-packages)

;; this variables must be set before load helm-gtags
;; you can change to any prefix key of your choice
(setq helm-gtags-prefix-key "\C-cg")

(add-to-list 'load-path "~/.emacs.d/custom")

(require 'setup-helm)
(require 'setup-helm-gtags)
;; (require 'setup-ggtags)
(require 'setup-cedet)
(require 'setup-editing)

(windmove-default-keybindings)

;; function-args
(require 'function-args)
(fa-config-default)
(define-key c-mode-map  [(tab)] 'company-complete)
;; (define-key c++-mode-map  [(tab)] 'company-complete)

;; company
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(delete 'company-semantic company-backends)
(define-key c-mode-map  [(tab)] 'company-complete)
(define-key c++-mode-map  [(tab)] 'company-complete)
;; (define-key c-mode-map  [(control tab)] 'company-complete)
;; (define-key c++-mode-map  [(control tab)] 'company-complete)

;; company-c-headers
(add-to-list 'company-backends 'company-c-headers)

;; hs-minor-mode for folding source code
(add-hook 'c-mode-common-hook 'hs-minor-mode)

;; Available C style:
;; “gnu”: The default style for GNU projects
;; “k&r”: What Kernighan and Ritchie, the authors of C used in their book
;; “bsd”: What BSD developers use, aka “Allman style” after Eric Allman.
;; “whitesmith”: Popularized by the examples that came with Whitesmiths C, an early commercial C compiler.
;; “stroustrup”: What Stroustrup, the author of C++ used in his book
;; “ellemtel”: Popular C++ coding standards as defined by “Programming in C++, Rules and Recommendations,” Erik Nyquist and Mats Henricson, Ellemtel
;; “linux”: What the Linux developers use for kernel development
;; “python”: What Python developers use for extension modules
;; “java”: The default style for java-mode (see below)
;; “user”: When you want to define your own style
(setq
 c-default-style "linux" ;; set style to "linux"
 )

(global-set-key (kbd "RET") 'newline-and-indent)  ; automatically indent when press RET

;; activate whitespace-mode to view all whitespace characters
(global-set-key (kbd "C-c w") 'whitespace-mode)

;; show unncessary whitespace that can mess up your diff
(add-hook 'prog-mode-hook (lambda () (interactive) (setq show-trailing-whitespace 1)))

;; use space to indent by default
(setq-default indent-tabs-mode nil)

;; set appearance of a tab that is represented by 4 spaces
(setq-default tab-width 4)

;; Compilation
(global-set-key (kbd "<f5>") (lambda ()
                               (interactive)
                               (setq-local compilation-read-command nil)
                               (call-interactively 'compile)))

;; setup GDB
(setq
 ;; use gdb-many-windows by default
 gdb-many-windows t

 ;; Non-nil means display source file containing the main routine at startup
 gdb-show-main t
 )

;; Package: clean-aindent-mode
(require 'clean-aindent-mode)
(add-hook 'prog-mode-hook 'clean-aindent-mode)

;; Package: dtrt-indent
(require 'dtrt-indent)
(dtrt-indent-mode 1)

;; Package: ws-butler
(require 'ws-butler)
(add-hook 'prog-mode-hook 'ws-butler-mode)

;; Package: yasnippet
(require 'yasnippet)
(require 'helm-c-yasnippet)
(setq helm-yas-space-match-any-greedy t)
(global-set-key (kbd "C-c y") 'helm-yas-complete)
(yas-global-mode 1)

;; Package: smartparens
(require 'smartparens-config)
(setq sp-base-key-bindings 'paredit)
(setq sp-autoskip-closing-pair 'always)
(setq sp-hybrid-kill-entire-symbol nil)
(sp-use-paredit-bindings)

(show-smartparens-global-mode +1)
(smartparens-global-mode 1)

;; Package: projejctile
(require 'projectile)
(projectile-global-mode)
(setq projectile-enable-caching t)

(require 'helm-projectile)
(helm-projectile-on)
(setq projectile-completion-system 'helm)
(setq projectile-indexing-method 'alien)

;; Package zygospore
(global-set-key (kbd "C-x 1") 'zygospore-toggle-delete-other-windows)

;; org-trello
(require 'org-trello)
(custom-set-variables
 '(orgtrello-log-level orgtrello-log-debug) ;; log level to debug
 '(orgtrello-setup-use-position-in-checksum-computation nil) ;; checksum without position
 '(org-trello-files '("/Users/mikeqin/Documents/virtualpc/share/trello")))

(add-hook 'org-trello-mode-hook
          (lambda ()
            (define-key org-trello-mode-map (kbd "C-c x v") 'org-trello-version)
            (define-key org-trello-mode-map (kbd "C-c x i") 'org-trello-install-key-and-token)
            (define-key org-trello-mode-map (kbd "C-c x I") 'org-trello-install-board-metadata)
            (define-key org-trello-mode-map (kbd "C-c x c") 'org-trello-sync-card)
            (define-key org-trello-mode-map (kbd "C-c x s") 'org-trello-sync-buffer)
            (define-key org-trello-mode-map (kbd "C-c x a") 'org-trello-assign-me)
            (define-key org-trello-mode-map (kbd "C-c x d") 'org-trello-check-setup)
            (define-key org-trello-mode-map (kbd "C-c x D") 'org-trello-delete-setup)
            (define-key org-trello-mode-map (kbd "C-c x b") 'org-trello-create-board-and-install-metadata)
            (define-key org-trello-mode-map (kbd "C-c x k") 'org-trello-kill-entity)
            (define-key org-trello-mode-map (kbd "C-c x K") 'org-trello-kill-cards)
            (define-key org-trello-mode-map (kbd "C-c x a") 'org-trello-archive-card)
            (define-key org-trello-mode-map (kbd "C-c x A") 'org-trello-archive-cards)
            (define-key org-trello-mode-map (kbd "C-c x j") 'org-trello-jump-to-trello-card)
            (define-key org-trello-mode-map (kbd "C-c x J") 'org-trello-jump-to-trello-board)
            (define-key org-trello-mode-map (kbd "C-c x C") 'org-trello-add-card-comments)
            (define-key org-trello-mode-map (kbd "C-c x o") 'org-trello-show-card-comments)
            (define-key org-trello-mode-map (kbd "C-c x l") 'org-trello-show-card-labels)
            (define-key org-trello-mode-map (kbd "C-c x u") 'org-trello-update-board-metadata)
            (define-key org-trello-mode-map (kbd "C-c x h") 'org-trello-help-describing-bindings)))

;; Behave like vi's o command
(defun open-next-line (arg)
        "Move to the next line and then opens a line.
    See also `newline-and-indent'."
        (interactive "p")
        (end-of-line)
        (open-line arg)
        (next-line 1)
        (when newline-and-indent
          (indent-according-to-mode)))

;; Behave like vi's O command
(defun open-previous-line (arg)
        "Open a new line before the current one.
     See also `newline-and-indent'."
        (interactive "p")
        (beginning-of-line)
        (open-line arg)
        (when newline-and-indent
          (indent-according-to-mode)))

(global-set-key (kbd "C-o") 'open-next-line)
(global-set-key (kbd "C-M-o") 'open-previous-line)
