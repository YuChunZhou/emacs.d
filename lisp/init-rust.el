;;-*- lexical-binding: t; -*-

(use-package rustic
  :init
  (advice-add 'rust-toggle-mutability :around #'buffer-save-2)
  (defun rust-format ()
    (interactive)
    (save-buffer)
    (if (region-active-p)
	(progn
	  (rustic-format-region (region-beginning) (region-end))
	  (set-process-sentinel
	   (get-process rustic-format-process-name)
	   #'(lambda (proc output)
	       (rustic-format-file-sentinel proc output)
	       (save-buffer))))
      (progn
	(rustic-format-buffer)
	(set-process-sentinel
	 (get-process rustic-format-process-name)
	 #'(lambda (proc output)
	     (rustic-format-sentinel proc output)
	     (save-buffer))))))
  :custom
  (rustic-compile-directory-method 'rustic-buffer-workspace)
  :bind
  (:map rustic-mode-map
	("C-c m" . rust-toggle-mutability)
	("C-c c b" . rustic-cargo-build)
	("C-c c c" . rustic-cargo-check)
	("C-c c r" . rustic-cargo-run)
	("C-c t c" . rustic-cargo-current-test)
	("C-c t p" . rustic-cargo-test)
	("M-\\" . rust-format))
  :hook
  (rustic-mode . lsp-deferred))

(provide 'init-rust)
