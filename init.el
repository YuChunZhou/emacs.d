;;-*- lexical-binding: t; -*-

;; install straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
	"straight/repos/straight.el/bootstrap.el"
	user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent
	 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)

(use-package straight
  :custom
  (straight-use-package-by-default t)
  (straight-vc-git-default-protocol 'ssh))

;; hide welcome message
(customize-set-value 'inhibit-startup-screen t)

;; for better performance
(setq read-process-output-max (* 1024 1024)
      gc-cons-threshold (* 100 1024 1024))

;; custom file
(customize-set-value 'custom-file (expand-file-name "custom.el" user-emacs-directory))

;; add lisp directory to load-path
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; backup related
(setq backup-directory (expand-file-name "backup" user-emacs-directory))
(custom-set-variables '(backup-directory-alist `((".*" . ,backup-directory)))
		      '(delete-old-versions t)
		      '(version-control t))

;; disable lockfile function
(customize-set-value 'create-lockfiles nil)

;; electric mode
(electric-indent-mode)
(electric-layout-mode)
(electric-pair-mode)
(electric-quote-mode)

;; show paren mode
(add-hook 'prog-mode-hook #'show-paren-mode)

;; auto reverting buffer
(auto-revert-mode)

;; compiler related
(custom-set-variables '(compilation-ask-about-save nil)
		      '(compilation-scroll-output t))

;; close menu bar
(menu-bar-mode -1)

;; close tool bar
(tool-bar-mode -1)

;; close scroll bar
(scroll-bar-mode -1)

;; display line number
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;; highlight current line
(custom-set-faces '(hl-line ((t (:extend t :background "#303030")))))
(global-hl-line-mode)

;; display column number on modeline
(column-number-mode)

;; remember file's last visited position
(save-place-mode)

;; ignore ring bell
(setq ring-bell-function 'ignore)

;; answer yes or no question with y and n
(fset 'yes-or-no-p 'y-or-n-p)

;; process safe file local variable
(customize-set-value 'enable-local-variables :safe)

;; visit real file
(customize-set-value 'vc-follow-symlinks t)

;; disable confirmation to kill process on Emacs exit
(customize-set-value 'confirm-kill-processes nil)

;; define toolkit function
(defun buffer-save-1 () (save-buffer))
(defun buffer-save-2 (orig-func &rest args)
  (save-buffer)
  (apply orig-func args)
  (save-buffer))

;; define basic keybinding
(global-set-key (kbd "M-a") #'beginning-of-line-text)
(global-set-key (kbd "M-e") #'(lambda ()
				(interactive)
				(let* ((line (buffer-substring-no-properties
					      (line-beginning-position)
					      (line-end-position)))
				       (clean-line (string-trim-right line)))
				  (goto-char (+ (line-beginning-position) (length clean-line))))))
(global-set-key (kbd "M-g") #'(lambda (line)
				(interactive "ngoto line: ")
				(goto-line line)))
(global-set-key (kbd "S-<up>") #'windmove-up)
(global-set-key (kbd "S-<down>") #'windmove-down)
(global-set-key (kbd "S-<left>") #'windmove-left)
(global-set-key (kbd "S-<right>") #'windmove-right)
(define-key prog-mode-map (kbd "M-,") #'pop-global-mark)
(define-key emacs-lisp-mode-map (kbd "M-\\") #'(lambda ()
						 (interactive)
						 (save-buffer)
						 (if (region-active-p)
						     (indent-region (region-beginning) (region-end))
						   (indent-region (point-min) (point-max)))
						 (save-buffer)))

;; eshell mode
(add-hook 'eshell-mode-hook #'(lambda () (global-hl-line-mode -1)))
(add-hook 'eshell-exit-hook #'global-hl-line-mode)


(use-package doom-themes
  :config
  (use-package all-the-icons)
  (doom-themes-neotree-config)
  (load-theme 'doom-gruvbox t))

(use-package doom-modeline
  :custom
  (doom-modeline-icon nil)
  (doom-modeline-buffer-file-name-style 'truncate-nil)
  :config
  (doom-modeline-mode)
  (doom-modeline-def-modeline 'my-doom-modeline '(buffer-info) '(buffer-position))
  (doom-modeline-set-modeline 'my-doom-modeline t)
  (advice-add 'doom-modeline-set-modeline
	      :before-while
	      #'(lambda (key &optional default)
		  (if (string-equal (symbol-name key) "my-doom-modeline")
		      t
		    nil))))

(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package expand-region
  :custom-face
  (region ((t (:background "#666"))))
  :bind
  ("M-m" . er/expand-region)
  :hook
  (after-init . delete-selection-mode))

(use-package hungry-delete
  :custom
  (hungry-delete-join-reluctantly t)
  :config
  (global-hungry-delete-mode))

(use-package undo-tree
  :init
  (setq undo-tree-history-directory
	(expand-file-name "undo-tree-history" user-emacs-directory))
  :custom
  (undo-tree-history-directory-alist `(("." . ,undo-tree-history-directory)))
  :config
  (global-undo-tree-mode))

(use-package super-save
  :custom
  (super-save-auto-save-when-idle t)
  (auto-save-default nil)
  :config
  (add-to-list 'super-save-triggers 'compile)
  (super-save-mode))

(use-package neotree
  :custom
  (neo-create-file-auto-open t)
  (neo-auto-indent-point t)
  (neo-smart-open t)
  (neo-show-hidden-files t)
  (neo-autorefresh t)
  (neo-window-fixed-size nil)
  (neo-theme 'arrow)
  (neo-mode-line-type 'none)
  :bind
  ("<f8>" . neotree-toggle))

(use-package helm
  :init
  (custom-set-faces
   '(helm-selection-line ((t (:extend t :distant-foreground "black")))))
  :custom
  (enable-recursive-minibuffers t)
  (projectile-indexing-method 'alien)
  (helm-display-source-at-screen-top nil)
  (helm-display-header-line nil)
  (helm-split-window-inside-p t)
  (helm-move-to-line-cycle-in-source t)
  (helm-follow-mode-persistent t)
  (helm-mini-default-sources '(helm-source-buffers-list))
  :custom-face
  (helm-match ((t (:extend t :background "#282828" :foreground "#e74c3c" :weight bold))))
  :bind
  (("C-f" . helm-projectile-find-file)
   ("C-p" . helm-projectile-rg)
   ("C-s" . helm-occur)
   ("C-x b" . helm-mini)
   ("M-x" . helm-M-x)
   :map helm-projectile-find-file-map
   ("<up>" . helm-follow-action-backward)
   ("<down>" . helm-follow-action-forward)
   ("<left>" . left-char)
   ("<right>" . right-char)
   :map helm-rg-map
   ("<up>" . helm-follow-action-backward)
   ("<down>" . helm-follow-action-forward)
   ("<left>" . left-char)
   ("<right>" . right-char)
   :map helm-occur-map
   ("<left>" . left-char)
   ("<right>" . right-char))
  :hook
  (after-init . projectile-mode)
  :config
  (use-package helm-projectile)
  (use-package helm-rg
    :custom-face
    (helm-rg-preview-line-highlight ((t (:background "Darkorange1"))))
    (helm-rg-line-number-match-face
     ((t (:inherit default :foreground "#6f6f6f" :slant italic :weight normal)))))
  (use-package helm-xref
    :init
    (setq xref-auto-jump-to-first-definition t)))

(use-package exec-path-from-shell
  :custom
  (exec-path-from-shell-arguments nil)
  :hook
  (prog-mode . exec-path-from-shell-initialize))

(use-package smart-comment
  :bind
  (:map prog-mode-map
	("C-\\" . (lambda (arg)
		    (interactive "*P")
		    (smart-comment arg)
		    (next-line)))))

(use-package company
  :custom
  (company-tooltip-align-annotations t)
  (company-minimum-prefix-length 1)
  (company-selection-wrap-around t)
  (company-global-modes '(not eshell-mode))
  :custom-face
  (company-tooltip-selection ((t (:background "#666"))))
  :config
  (global-company-mode))

(use-package lsp-mode
  :custom
  (lsp-headerline-breadcrumb-enable nil)
  (lsp-lens-enable nil)
  (lsp-modeline-code-actions-enable nil)
  (lsp-diagnostics-provider :none)
  (lsp-modeline-diagnostics-enable nil)
  (lsp-signature-render-documentation nil)
  (lsp-file-watch-threshold nil)
  :bind
  (:map lsp-mode-map
	("C-c C-f" . lsp-find-references)
	("C-c C-h" . lsp-describe-thing-at-point)
	("C-c C-r" . lsp-rename)
	("M-." . lsp-find-definition))
  :hook
  (lsp-mode . yas-minor-mode)
  :config
  (use-package yasnippet))


(require 'init-c)
(require 'init-golang)
(require 'init-python)
(require 'init-rust)
(require 'init-zig)
