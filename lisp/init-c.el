;;-*- lexical-binding: t; -*-

(use-package cc-mode
  :init
  (advice-add 'clang-format-region :around #'buffer-save-2)
  (advice-add 'clang-format-buffer :around #'buffer-save-2)
  :bind
  (:map c-mode-map
	("C-c b" . (lambda ()
		     (interactive)
		     (compile "bear -- make")))
	("M-\\" . (lambda ()
		    (interactive)
		    (if (region-active-p)
			(clang-format-region (region-beginning) (region-end))
		      (clang-format-buffer)))))
  :hook
  (c-mode . lsp-deferred)
  :config
  (use-package clang-format))

(provide 'init-c)
