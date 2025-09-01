;; -*- lexical-binding: t; -*-
(setq 
  inhibit-startup-screen t
  server-client-instructions nil
  sentence-end-double-space nil
  gc-cons-threshold 100000000
  initial-scratch-message nil
  custom-file (locate-user-emacs-file "custom.el")
  select-enable-clipboard t
  backup-directory-alist `(("." . "~/.emacs.d/backups/"))
  auto-save-file-name-transforms `((".*" "~/.emacs.d/backups/" t))
  project-list-file "/tmp/.emacs-project-list-file"
  compilation-scroll-output t
  auto-save-visited-mode t
  create-lockfiles nil
  vc-handled-backends '(Git Hg SVN RCS CVS SCCS SRC Bzr)
  display-line-numbers-type 'relative
  initial-major-mode 'fundamental-mode
  read-process-output-max (* 1024 1024)
  scroll-conservatively 101
  scroll-margin 3
  scroll-step 1
  mouse-wheel-scroll-amount '(2 ((shift) . 5))
  mouse-wheel-progressive-speed nil
  mouse-wheel-follow-mouse t
  epa-file-encrypt-to '("C250A18D4905F80C")
  ediff-window-setup-function 'ediff-setup-windows-plain
  ediff-split-window-function 'split-window-horizontally
  ispell-program-name "hunspell"
  ispell-extra-args '("--sug-mode=ultra" "--lang=en_US")
  ring-bell-function 'ignore
  bidi-inhibit-bpa t
  ;;use-default-font-for-symbols nil
  undo-limit 67108864
  undo-strong-limit 100663296
  undo-outer-limit 1006632960
  )

(scroll-bar-mode -1)
;;(blink-cursor-mode -1)
;;(pixel-scroll-precision-mode 1)
(load custom-file :no-error-if-file-is-missing t)
(set-face-attribute 'default nil
                    :family "JetBrainsMono Nerd Font")

(electric-pair-mode 1)
(global-auto-revert-mode t)
(setq-default tab-width 4
			  indent-tabs-mode nil
              bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right)
;;(add-hook 'fundamental-mode-hook
;;		  (lambda ()
;;			(setq tab-width 4
;;				  indent-tabs-mode nil)))
(fset 'yes-or-no-p 'y-or-n-p)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
;;(which-function-mode 1)

(global-set-key (kbd "M-e") #'execute-extended-command)
(global-set-key (kbd "M-s") #'shell-command)
(global-set-key (kbd "M-q") #'delete-other-windows)
(global-set-key (kbd "M-c") #'compile)
(with-eval-after-load 'prog-mode
  (define-key prog-mode-map (kbd "M-q") #'delete-other-windows))



;;; package
(require 'package)
(setq package-archives 
  '(("melpa" . "https://melpa.org/packages/")
    ("org" . "https://orgmode.org/elpa/")
    ("gnu"  . "https://elpa.gnu.org/packages/")
    ("nongnu". "https://elpa.nongnu.org/nongnu/")))
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(require 'use-package)


;;; server
(use-package server
  :config
  (unless (server-running-p)
    (server-start)))


;;; evil
(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        evil-undo-system 'undo-fu
        evil-esc-delay 0)
  :config
  (evil-mode 1))
(use-package undo-fu)
(define-key evil-normal-state-map [escape] nil)
(define-key evil-motion-state-map [down-mouse-1] 'mouse-set-point)
(define-key evil-insert-state-map (kbd "C-k") nil)
(define-key evil-insert-state-map (kbd "C-o") nil)
(setq evil-collection-want-unimpaired-p nil)
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))
(evil-define-key 'normal 'global
  (kbd "M-:") #'evil-ex
  (kbd "M-h") #'evil-backward-char
  (kbd "M-j") #'evil-next-line
  (kbd "M-k") #'evil-previous-line
  (kbd "M-l") #'evil-forward-char
  (kbd "M-u") #'evil-undo
  (kbd "M-i") #'evil-insert
  (kbd "M-a") #'evil-append
  (kbd "M-A") #'evil-append-line
  (kbd "M-G") #'evil-goto-line
  (kbd "M-g M-g") #'evil-goto-first-line
  ;;(kbd "M-b") #'evil-backward-word-begin
  ;;(kbd "M-w") #'evil-forward-word-begin
  ;;(kbd "M-e") #'evil-forward-word-end
  (kbd "M-0") #'evil-digit-argument-or-evil-beginning-of-line
  (kbd "M-$") #'evil-end-of-line)

(define-key evil-normal-state-map (kbd "ESC ESC") #'ignore)


;;;crux
(use-package crux)
;;;vlf
(use-package vlf
  :config
  (require 'vlf-setup))

;;; tab-out
(defun my/tab-jump-out-or-indent ()
  (interactive)
  (if (looking-at "[])}\"'`]")
      (forward-char 1)
    (indent-for-tab-command)))

(evil-define-key 'insert 'global (kbd "TAB") 'my/tab-jump-out-or-indent)
(evil-define-key 'emacs vterm-mode-map (kbd "C-z")
  (lambda () (interactive) (vterm-send-key "z" nil nil t)))

;;; vterm
(use-package exec-path-from-shell
   :config
   (exec-path-from-shell-initialize))
(use-package vterm
  :config
  (evil-set-initial-state 'vterm-mode 'emacs)
  (define-key vterm-mode-map (kbd "C-c")
  (lambda () (interactive) (vterm-send-key "c" nil nil t)))
  (define-key vterm-mode-map (kbd "C-d")
  (lambda () (interactive) (vterm-send-key "d" nil nil t)))
  (define-key vterm-mode-map [wheel-up]
  (lambda () (interactive) (vterm-copy-mode 1)))
  (define-key vterm-mode-map (kbd "C-x C-t")
  (lambda () (interactive) (vterm-copy-mode 1)))
  ;;(define-key vterm-mode-map [mouse-1]
  ;;(lambda () (interactive) (vterm-copy-mode 1)))
  (define-key vterm-mode-map (kbd "C-S-v") #'vterm-yank)
  (define-key vterm-mode-map (kbd "M-e") nil)
  (define-key vterm-mode-map (kbd "M-s") nil)
  (define-key vterm-mode-map (kbd "M-q") nil)
  (define-key vterm-mode-map (kbd "M-w") #'ace-window)
  (setq vterm-max-scrollback 10000))


(global-set-key (kbd "M-t") #'vterm)
(global-set-key (kbd "C-M-t") #'vterm-other-window)

;;; eshell
(use-package eshell
  :config
  (evil-set-initial-state 'eshell-mode 'emacs))

;;; window
(use-package ace-window
  :init
   :config
   (setq aw-keys '(?j ?k ?l ?a ?d ?f ?g)
         aw-dispatch-always t
         aw-dispatch-alist
          '((?x aw-delete-window "Delete Window")
           	(?m aw-swap-window "Swap Windows")
           	(?M aw-move-window "Move Window")
           	(?c aw-copy-window "Copy Window")
           	(?j aw-switch-buffer-in-window "Select Buffer")
           	(?p aw-flip-window)
           	(?u aw-switch-buffer-other-window "Switch Buffer Other Window")
           	(?s aw-split-window-fair "Split Fair Window")
           	(?v aw-split-window-vert "Split Vert Window")
           	(?h aw-split-window-horz "Split Horz Window")
           	(?o delete-other-windows "Delete Other Windows")
           	(?? aw-show-dispatch-help))))
(global-set-key (kbd "M-w") 'ace-window)

;;; buffer
(use-package vertico
  :init
  (vertico-mode)
  :bind(:map vertico-map
			 ("C-j" . vertico-next)
			 ("C-k" . vertico-previous)
             ("TAB" . vertico-next)
             ("<tab>" . vertico-next)
             ("S-TAB" . vertico-previous)
             ("<backtab>" . vertico-previous)))

(use-package consult
  :bind(
		("C-x b" . consult-buffer)))
(use-package embark
  :bind
   ("C-'" . embark-act)
   (:map vertico-map
      ("C-'" . embark-act)))

(use-package embark-consult)

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))
(use-package marginalia
  :init
  (marginalia-mode))

(with-eval-after-load 'embark
  (define-key embark-file-map   (kbd "o") #'find-file-other-window)
  (define-key embark-buffer-map (kbd "o") #'switch-to-buffer-other-window))

(with-eval-after-load 'vertico
  (define-key vertico-map (kbd "C-l")
    (lambda ()
      (interactive)
      (let ((embark-default-action-overrides
             '((file   . find-file-other-window)
               (buffer . switch-to-buffer-other-window))))
        (embark-dwim)))))


;;; project
(defvar my/current-project-dir nil
  "Current project-directory set by my/open-project")
(defun my/open-project (dir)
  (interactive
   (list (read-directory-name "Project directory (create if needed): ")))
  (unless (file-exists-p dir)
    (make-directory dir t)
    (message "Created %s" dir))
  (setq my/current-project-dir dir)
  (setq-default default-directory dir)
  (let ((default-directory dir))
    (treemacs-add-and-display-current-project-exclusively)))

(defun my/clear-project ()
  (interactive)
  (setq my/current-project-dir nil)
  (setq-default default-directory (expand-file-name "~/"))
  (when-let* ((window (treemacs-get-local-window)))
    (delete-window window))
  (message "Project cleared"))

(defun my/open-in-vscode ()
  (interactive)
  (if my/current-project-dir
      (let ((proc (start-process "vscode" nil "code"
                                 (expand-file-name my/current-project-dir))))
        (set-process-query-on-exit-flag proc nil)) 
    (message "No project open")))

(defun my/search-project ()
  (interactive)
  (if my/current-project-dir
      (consult-ripgrep my/current-project-dir)
    (message "No project open. Use C-x o to open a project first.")))

(defun my/find-file-project ()
  (interactive)
  (if my/current-project-dir
      (consult-fd my/current-project-dir)
    (message "No project open. Use C-x o to open a project first.")))

(global-set-key (kbd "C-x o") #'my/open-project)
(global-set-key (kbd "C-x s") #'my/search-project)
(global-set-key (kbd "C-x f") #'my/find-file-project)


;;; file tree
(use-package nerd-icons)
(use-package treemacs
  :config
  (setq treemacs-width-is-initially-locked nil
        treemacs-width-is-locked nil
        treemacs-persist-file nil
        treemacs-workspace-switch-cleanup t
        treemacs-restore-workspace nil)
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-fringe-indicator-mode 'always)
  (treemacs-git-mode 'extended))
(use-package treemacs-magit
  :after treemacs magit)
(use-package treemacs-evil
  :after (treemacs evil))
(use-package treemacs-nerd-icons
  :config
  (treemacs-nerd-icons-config))
(defun my/treemacs-toggle ()
  (interactive)
  (if my/current-project-dir
      (treemacs)
    (message "No project open. Use C-x o to open a project first.")))

(defun my/treemacs-jump ()
  (interactive)
  (if my/current-project-dir
      (treemacs-select-window)
    (message "No project open. Use C-x o to open a project first.")))

(global-set-key (kbd "C-x e") #'my/treemacs-toggle)
(global-set-key (kbd "C-x t") #'my/treemacs-jump)

;;; imenu
(global-set-key (kbd "C-x m") #'imenu-list-smart-toggle)
(with-eval-after-load 'imenu-list
  (add-hook 'imenu-list-major-mode-hook #'evil-emacs-state t)
    (define-key imenu-list-major-mode-map (kbd "j") #'next-line)
    (define-key imenu-list-major-mode-map (kbd "k") #'previous-line))

;;; kitty
(defun my/open-in-kitty ()
  (interactive)
  (if my/current-project-dir
      (let ((proc (start-process "kitty" nil "kitty" "--directory" (expand-file-name my/current-project-dir)))))
    (message "No project open")))


;;; transient
(use-package transient
  :init
  (setq transient-levels
        '((magit-log (t . 7))
          (magit-commit (t . 7)))))

;;; vc (git)
(use-package magit)
(define-key magit-mode-map (kbd "M-w") nil)
(define-key magit-section-mode-map [down-mouse-1] #'magit-mouse-set-point)
(define-key magit-section-mode-map [mouse-1] #'ignore)
(define-key magit-section-mode-map [drag-mouse-1] #'ignore)
(define-key magit-section-mode-map [double-down-mouse-1]
            (lambda (event) (interactive "e" (magit-mouse-set-point event nil))))
(define-key magit-section-mode-map [double-mouse-1] #'magit-visit-thing)
(define-key magit-section-mode-map [double-drag-mouse-1] #'ignore)
(use-package git-messenger)
(use-package git-timemachine)
(use-package git-gutter
  :custom-face
  (git-gutter:added    ((t (:background "#2ea043" :foreground "#2ea043"))))
  (git-gutter:modified ((t (:background "#d29922" :foreground "#d29922"))))
  (git-gutter:deleted  ((t (:background "#f85149" :foreground "#f85149"))))
  :config
  (setq git-gutter:update-interval 2
        git-gutter:window-width 2      
        git-gutter:added-sign "  "     
        git-gutter:modified-sign "  "
        git-gutter:deleted-sign "  ")
  (global-git-gutter-mode 1))

;; on the right fringe
(use-package git-gutter-fringe
  :after git-gutter
  :demand t
  :init
  (setq git-gutter-fr:side 'right-fringe)
  :config
  (fringe-helper-define 'git-gutter-fr:added nil
    "XXXXXXXX" "XXXXXXXX" "XXXXXXXX" "XXXXXXXX" "XXXXXXXX" "XXXXXXXX" "XXXXXXXX" "XXXXXXXX")
  (fringe-helper-define 'git-gutter-fr:modified nil
    "XXXXXXXX" "XXXXXXXX" "XXXXXXXX" "XXXXXXXX" "XXXXXXXX" "XXXXXXXX" "XXXXXXXX" "XXXXXXXX")
  (fringe-helper-define 'git-gutter-fr:deleted nil
    "XXXXXXXX" "XXXXXXXX" "XXXXXXXX" "XXXXXXXX" "XXXXXXXX" "XXXXXXXX" "XXXXXXXX" "XXXXXXXX"))

(defun my/git-gutter-fringe-click (event)
  (interactive "e")
  (when git-gutter-mode
    (mouse-set-point event)
    (let ((selection
           (x-popup-menu
            event
            '("Hunk"
              ("Actions"
               ("Stage hunk"  . git-gutter:stage-hunk)
               ("Revert hunk" . git-gutter:revert-hunk)
               ("Diff hunk"   . git-gutter:popup-hunk))))))
      (when selection
        (call-interactively selection)))))
;;(global-set-key [right-fringe mouse-1] #'my/git-gutter-fringe-click)


;;; modeline
(use-package doom-modeline
  :init
  (doom-modeline-mode 1)
  :config
  (setq doom-modeline-modal t))


;;; tabs
(use-package centaur-tabs
  :config
  (centaur-tabs-mode 1)
  (setq centaur-tabs-style "bar"
        centaur-tabs-set-icons t
		centaur-tabs-icon-type 'nerd-icons
        centaur-tabs-set-modified-marker t
        centaur-tabs-modified-marker "●"
        centaur-tabs-close-button "×")
  (defun my/centaur-tabs-hide-tab (buf)
    (let ((name (buffer-name buf)))
      (or
       (window-dedicated-p (selected-window))
       (string-prefix-p "*" name)
       (string-prefix-p " " name)
       (string-prefix-p "magit" name)
       )))

  (defvar my/file-project-table (make-hash-table :test 'equal))
  (defun my/record-file-project ()
    (when (and my/current-project-dir buffer-file-name)
      (let ((file (expand-file-name buffer-file-name))
            (proj (file-name-nondirectory
                   (directory-file-name my/current-project-dir))))
        (when (string-prefix-p (expand-file-name my/current-project-dir) file)
          (puthash file proj my/file-project-table)))))
  (add-hook 'find-file-hook #'my/record-file-project)
  (defun my/centaur-tabs-buffer-groups ()
    (list
     (cond
      ((string-prefix-p "*" (buffer-name)) "Emacs")
      ((memq major-mode '(helpful-mode help-mode)) "Help")
      ((derived-mode-p 'dired-mode) "Dired")
      ((memq major-mode '(org-mode org-agenda-mode org-src-mode)) "Org")
      ;; project: table
      ((and buffer-file-name
            (gethash (expand-file-name buffer-file-name) my/file-project-table)))
      ;; project: opened
      ((and my/current-project-dir
            buffer-file-name
            (string-prefix-p (expand-file-name my/current-project-dir)
                             (expand-file-name buffer-file-name)))
       (file-name-nondirectory
        (directory-file-name my/current-project-dir)))
      ;; file outside any known project 
      (buffer-file-name
       (file-name-nondirectory
        (directory-file-name (file-name-directory buffer-file-name))))
      ((derived-mode-p 'prog-mode) "Editing")
      (t "Misc"))))
(setq centaur-tabs-buffer-groups-function #'my/centaur-tabs-buffer-groups)
(setq centaur-tabs-hide-tab-function #'my/centaur-tabs-hide-tab))

;;(set-face-attribute 'centaur-tabs-default nil
;;                    :background (face-background 'default))
(custom-set-faces
 '(centaur-tabs-default
   ((t (:background "#ffffff" :foreground "#333333"))))
 '(centaur-tabs-selected
   ((t (:background "#ffffff" :foreground "#000000" :bold t))))
 '(centaur-tabs-unselected
   ((t (:background "#eeeeee" :foreground "#666666"))))
 '(centaur-tabs-selected-modified
   ((t (:background "#ffffff" :foreground "#e06c00" :bold t))))
 '(centaur-tabs-unselected-modified
   ((t (:background "#eeeeee" :foreground "#e06c00")))))


;;; treesitter
(use-package treesit-auto
  :custom
  (setq treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (add-to-list 'auto-mode-alist '("CMakeLists\\.txt\\'" . cmake-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.core\\'" . yaml-ts-mode))
;;  (add-to-list 'auto-mode-alist '("\\.s?vh?\\'" . verilog-ts-mode))
;;  (add-to-list 'auto-mode-alist '("\\.cu[h]?\\'" . c++-mode))
  (global-treesit-auto-mode))

(use-package treesit-fold
  :hook (prog-mode . treesit-fold-mode)
  :config (global-treesit-fold-indicators-mode 1)
;;  (setf (alist-get 'verilog-ts-mode treesit-fold-range-alist)
;;        '((module_declaration . treesit-fold-range-seq)
;;          (class_declaration . treesit-fold-range-seq)
;;          (list_of_port_connections . treesit-fold-range-seq)
;;          (parameter_port_list . treesit-fold-range-seq)
;;          (list_of_port_declarations . treesit-fold-range-seq)
;;          (seq_block . treesit-fold-range-seq)
;;          (comment . treesit-fold-range-c-like-comment)))
  ;;(setf (alist-get 'verilog-ts-mode treesit-fold-summary-parsers-alist) nil)
  )


;;; lsp
(use-package symbol-overlay
  :hook (prog-mode . symbol-overlay-mode))
(use-package yasnippet
  :hook (prog-mode . yas-minor-mode))

;; (add-to-list 'load-path (expand-file-name "lisp/lsp-bridge" user-emacs-directory))
(use-package lsp-bridge
  :ensure nil
  :load-path "lisp/lsp-bridge"
  :hook (prog-mode . lsp-bridge-mode)
  :config
(setq acm-enable-doc t
	  acm-enable-icon t
      acm-enable-tabnine nil
      acm-doc-delay 0.5
      lsp-bridge-enable-hover-diagnostic t
      lsp-bridge-enable-inlay-hint t
      acm-backend-lsp-candidate-min-length 2
      acm-backend-yas-candidate-min-length 2
      acm-backend-elisp-candidate-min-length 2
    ;;lsp-bridge-signature-show-function 'lsp-bridge-signature-show-with-frame
      lsp-bridge-c-lsp-server "clangd"
      lsp-bridge-cmake-lsp-server "neocmakelsp"
      lsp-bridge-verilog-lsp-server "verible"
      lsp-bridge-python-multi-lsp-server "basedpyright_ruff"
      lsp-bridge-tex-lsp-server "texlab"
    )
(add-hook 'lsp-bridge-mode-hook #'lsp-bridge-semantic-tokens-mode)
(define-key acm-mode-map (kbd "C-j") 'acm-select-next)
(define-key acm-mode-map (kbd "C-k") 'acm-select-prev)

(define-key acm-mode-map (kbd "RET") nil)
(define-key acm-mode-map (kbd "TAB") nil)
(define-key acm-mode-map (kbd "<tab>") nil)
(define-key acm-mode-map (kbd "C-o") #'acm-complete)

;;(define-key acm-mode-map (kbd "K") #'acm-doc-scroll-up)
;;(define-key acm-mode-map (kbd "J") #'acm-doc-scroll-down)

(evil-define-key 'normal lsp-bridge-mode-map
  (kbd "gd") #'lsp-bridge-find-def
  (kbd "gi") #'lsp-bridge-find-impl
  (kbd "gr") #'lsp-bridge-find-references
  (kbd "gp") #'lsp-bridge-peek
  (kbd "gs") #'lsp-bridge-show-documentation)

(add-hook 'lsp-bridge-mode-hook #'evil-normalize-keymaps)


(add-hook 'lsp-bridge-peek-mode-hook
          (lambda ()
            (if lsp-bridge-peek-mode
                (evil-emacs-state)
              (evil-normal-state))))


(with-eval-after-load 'lsp-bridge-peek
    (let ((m lsp-bridge-peek-keymap))
      (define-key m (kbd "j")   #'lsp-bridge-peek-list-next-line)
      (define-key m (kbd "k")   #'lsp-bridge-peek-list-prev-line)
      (define-key m (kbd "C-j")   #'lsp-bridge-peek-file-content-next-line)
      (define-key m (kbd "C-k")   #'lsp-bridge-peek-file-content-prev-line)
      (define-key m (kbd "RET") #'lsp-bridge-peek-jump)
      (define-key m (kbd "q")   #'lsp-bridge-peek-abort)
      (define-key m (kbd "C-g") #'lsp-bridge-peek-abort)
      ;; Mouse scroll – list pane
      ;;(define-key m (kbd "<mouse-4>")   #'lsp-bridge-peek-file-content-prev-line)
      ;;(define-key m (kbd "<mouse-5>")   #'lsp-bridge-peek-file-content-next-line)
      ;;(define-key m (kbd "<mouse-1>")   #'lsp-bridge-peek-jump)
      ))


(with-eval-after-load 'lsp-bridge-ref
  (evil-set-initial-state 'lsp-bridge-ref-mode 'emacs)
  (defun my/lsp-ref-mouse-preview (event)
    (interactive "e")
    (mouse-set-point event)
    (lsp-bridge-ref-open-file-and-stay))
  (defun my/lsp-ref-mouse-quit (event)
    (interactive "e")
    (lsp-bridge-ref-quit))
  (define-key lsp-bridge-ref-mode-map [mouse-1] #'my/lsp-ref-mouse-preview)
  (define-key lsp-bridge-ref-mode-map [mouse-3] #'my/lsp-ref-mouse-quit)
  )


(defun lsp-bridge-mouse-menu (event)
  "Show a popup menu for lsp-bridge navigation."
  (interactive "e")
  (mouse-set-point event)
  (let ((selection (x-popup-menu 
                    event
                    '("LSP-Bridge" 
                      ("Lsp Actions"
                       ("Definition" . lsp-bridge-find-def)
                       ("References" . lsp-bridge-find-references)
                       ("Implementation" . lsp-bridge-find-impl)
                       ("Type Definition" . lsp-bridge-find-type-def)
					   ("Documentation" . lsp-bridge-popup-documentation)
                       ("Diagnostic list" . lsp-bridge-diagnostic-list)
                       ("Code action" . lsp-bridge-code-action)
                       ("Symbol list" . lsp-bridge-workspace-list-symbol-at-point)
                       ("Rename Symbol" . lsp-bridge-rename)
                       ("Fold Toggle" . treesit-fold-toggle)
                       )))))
    (when selection (call-interactively selection))))
(define-key lsp-bridge-mode-map [mouse-3] 'lsp-bridge-mouse-menu)


)

;;; make
(add-hook 'makefile-mode-hook
          (lambda ()
            (define-key makefile-gmake-mode-map (kbd "M-q") nil)))

;;; sv
(use-package verilog-ext
  :hook ((verilog-mode . verilog-ext-mode))
  :init
  (setq verilog-ext-feature-list
        '(font-lock
          hierarchy
          lsp-bridge
          beautify
          navigation
          template
          compilation
          imenu
          which-func
          hideshow
          block-end-comments
          ports))
  :config
  (verilog-ext-mode-setup)
  ;;(verilog-ext-lsp-bridge-set-server 've-verible-ls)
  (verilog-ext-lsp-bridge-set-server 've-slang-server)
  (setq verilog-ext-hierarchy-backend 'vhier
        verilog-ext-hierarchy-vhier-use-open-buffers t)
  )


;;; cuda
(use-package cuda-ts-mode
  :ensure nil
  :load-path "lisp/cuda-ts-mode")


;;; lean
;;(add-to-list 'load-path (expand-file-name "lisp/lean4-mode" user-emacs-directory))
;;(use-package lean4-mode
;;  :ensure nil
;;  :load-path "lisp/lean4-mode")
(use-package nael) ;; with lspbridge no infoview


;;; ocaml
(add-to-list 'load-path "/home/hl/.opam/default/share/emacs/site-lisp")
(use-package tuareg
  :bind(:map tuareg-mode-map
             ("M-q" . nil)))

(defun opam-shell-command-to-string (command)
  "Similar to shell-command-to-string, but returns nil unless the process
  returned 0, and ignores stderr (shell-command-to-string ignores return value)"
  (let* ((return-value 0)
         (return-string
          (with-output-to-string
            (setq return-value
                  (with-current-buffer standard-output
                    (process-file shell-file-name nil '(t nil) nil
                                  shell-command-switch command))))))
    (if (= return-value 0) return-string nil)))

(defun opam-update-env (switch)
  "Update the environment to follow current OPAM switch configuration"
  (interactive
   (list
    (let ((default
            (car (split-string (opam-shell-command-to-string "opam switch show --safe")))))
      (completing-read
       (concat "opam switch (" default "): ")
       (split-string (opam-shell-command-to-string "opam switch list -s --safe") "\n" t)
       nil t nil nil default))))
  (let* ((switch-arg (if (= 0 (length switch)) "" (concat "--switch " switch)))
         (command (concat "opam env --safe --sexp " switch-arg))
         (env (opam-shell-command-to-string command)))
    (when (and env (not (string= env "")))
      (dolist (var (car (read-from-string env)))
        (setenv (car var) (cadr var))
        (when (string= (car var) "PATH")
          (setq exec-path (split-string (cadr var) path-separator)))))))

