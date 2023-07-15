;;-*- lexical-binding: t; -*-

;; go install golang.org/x/tools/...@latest
;; go install golang.org/x/tools/cmd/goimports@latest
;; go install golang.org/x/tools/gopls@latest
;; go install github.com/fatih/gomodifytags@latest
;; go install github.com/davidrjenni/reftools/cmd/fillstruct@latest
;; go install github.com/davidrjenni/reftools/cmd/fillswitch@latest
;; go install github.com/davidrjenni/reftools/cmd/fixplurals@latest
;; go install github.com/cweill/gotests/...@latest
;; go install github.com/go-noisegate/noisegate/cmd/gate@latest
;; go install github.com/go-noisegate/noisegate/cmd/gated@latest
;; go install github.com/go-delve/delve/cmd/dlv@latest

(use-package go-mode
  :init
  (advice-add 'gofmt :around #'buffer-save-2)
  :custom
  (gofmt-command "goimports")
  :bind
  (:map go-mode-map
	("C-c b" . (lambda ()
		     (interactive)
		     (compile "go build")))
	("C-c r" . (lambda ()
		     (interactive)
		     (compile "go run main.go")))
	("C-c t a" . go-noisegate-test-all)
	("C-c t r" . go-noisegate-test)
	("M-\\" . gofmt))
  :hook
  (go-mode . (lambda ()
	       (setq-local tab-width 4)
	       (lsp-deferred)))
  :config
  (use-package go-tag)
  (use-package go-fill-struct)
  (use-package go-gen-test)
  (use-package go-noisegate
    :hook
    (go-mode . (lambda ()
		 (add-hook 'after-change-functions #'go-noisegate-record-change)
		 (add-hook 'after-save-hook #'go-noisegate-hint)))))

(use-package dockerfile-mode)

(provide 'init-golang)
