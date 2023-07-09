;;-*- lexical-binding: t; -*-

;; pip install pyright isort black black-macchiato autoflake --user -U

(use-package python-mode
  :straight
  (:host nil :type git :repo "https://gitlab.com/python-mode-devs/python-mode")
  :init
  (defun python-format ()
    (interactive)
    (save-buffer)
    (let ((output (shell-command-to-string
		   (format
		    "autoflake --in-place --remove-all-unused-imports %s"
		    (buffer-file-name)))))
      (revert-buffer t t t)
      (display-message-or-buffer output "*autoflake*"))
    (if (region-active-p)
	(progn
	  (python-isort-region (region-beginning) (region-end))
	  (python-black-region (region-beginning) (region-end)))
      (progn
	(python-isort-buffer)
	(python-black-buffer)))
    (save-buffer))
  :hook
  (python-mode . (lambda ()
		   (define-key python-mode-map (kbd "M-\\") #'python-format)
		   (require 'lsp-pyright)
		   (lsp-deferred)))
  :config
  (use-package python-isort)
  (use-package python-black)
  (use-package lsp-pyright))

(provide 'init-python)
