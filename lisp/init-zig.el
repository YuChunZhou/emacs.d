;;-*- lexical-binding: t; -*-

(use-package zig-mode
  :init
  (advice-add 'zig-compile :before #'buffer-save-1)
  (advice-add 'zig-run :before #'buffer-save-1)
  (advice-add 'zig-test-buffer :before #'buffer-save-1)
  (advice-add 'zig-format-region :around #'buffer-save-2)
  (advice-add 'zig-format-buffer :around #'buffer-save-2)
  :custom
  (zig-format-on-save nil)
  :bind
  (:map zig-mode-map
	("C-c b" . zig-compile)
	("C-c r" . zig-run)
	("C-c t" . zig-test-buffer)
	("M-\\" . (lambda ()
		    (interactive)
		    (if (region-active-p)
			(zig-format-region (region-beginning) (region-end))
		      (zig-format-buffer)))))
  :hook
  (zig-mode . lsp-deferred))

(provide 'init-zig)
