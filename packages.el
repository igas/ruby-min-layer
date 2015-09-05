(setq ruby-min-packages
  '(
    bundler
    company
    ruby-mode
    flycheck
    robe
    ruby-test-mode
    ruby-tools))

(when ruby-version-manager
  (add-to-list 'ruby-min-packages ruby-version-manager))

(defun ruby-min/init-rbenv ()
  "Initialize RBENV mode"
  (use-package rbenv
    :defer t
    :init (global-rbenv-mode)
    :config (add-hook 'ruby-mode-hook
                      (lambda () (rbenv-use-corresponding)))))

(defun ruby-min/init-rvm ()
  "Initialize RVM mode"
  (use-package rvm
    :defer t
    :init (rvm-use-default)
    :config (add-hook 'ruby-mode-hook
                      (lambda () (rvm-activate-corresponding-ruby)))))

(defun ruby-min/init-ruby-mode ()
  "Initialize Ruby Mode"
  (use-package ruby-mode
    :mode (("\\(Rake\\|Thor\\|Guard\\|Gem\\|Cap\\|Vagrant\\|Berks\\|Pod\\|Puppet\\)file\\'" . ruby-mode)
           ("\\.\\(rb\\|rabl\\|ru\\|builder\\|rake\\|thor\\|gemspec\\|jbuilder\\)\\'" . ruby-mode))
    :interpreter "ruby"
    ))

(defun ruby-min/post-init-flycheck ()
  (add-hook 'ruby-mode-hook 'flycheck-mode))

(defun ruby-min/init-ruby-tools ()
  (use-package ruby-tools
    :defer t
    :init
    (add-hook 'ruby-mode-hook 'ruby-tools-mode)
    :config
    (progn
      (spacemacs|hide-lighter ruby-tools-mode)
      (evil-leader/set-key-for-mode 'ruby-mode "mx\'" 'ruby-tools-to-single-quote-string)
      (evil-leader/set-key-for-mode 'ruby-mode "mx\"" 'ruby-tools-to-double-quote-string)
      (evil-leader/set-key-for-mode 'ruby-mode "mx:" 'ruby-tools-to-symbol))))

(defun ruby-min/init-bundler ()
  (use-package bundler
    :defer t
    :init
    (progn
      (evil-leader/set-key-for-mode 'ruby-mode "mbc" 'bundle-check)
      (evil-leader/set-key-for-mode 'ruby-mode "mbi" 'bundle-install)
      (evil-leader/set-key-for-mode 'ruby-mode "mbs" 'bundle-console)
      (evil-leader/set-key-for-mode 'ruby-mode "mbu" 'bundle-update)
      (evil-leader/set-key-for-mode 'ruby-mode "mbx" 'bundle-exec))))

(defun ruby-min/init-robe ()
  "Initialize Robe mode"
  (use-package robe
    :defer t
    :init
    (progn
      (add-hook 'ruby-mode-hook 'robe-mode)
      (when (configuration-layer/layer-usedp 'auto-completion)
        (push 'company-robe company-backends-ruby-mode)))
    :config
    (progn
      (spacemacs|hide-lighter robe-mode)
      ;; robe mode specific
      (evil-leader/set-key-for-mode 'ruby-mode "mgg" 'robe-jump)
      (evil-leader/set-key-for-mode 'ruby-mode "mhd" 'robe-doc)
      (evil-leader/set-key-for-mode 'ruby-mode "mrsr" 'robe-rails-refresh)
      ;; inf-ruby-mode
      (evil-leader/set-key-for-mode 'ruby-mode "msf" 'ruby-send-definition)
      (evil-leader/set-key-for-mode 'ruby-mode "msF" 'ruby-send-definition-and-go)
      (evil-leader/set-key-for-mode 'ruby-mode "msi" 'robe-start)
      (evil-leader/set-key-for-mode 'ruby-mode "msr" 'ruby-send-region)
      (evil-leader/set-key-for-mode 'ruby-mode "msR" 'ruby-send-region-and-go)
      (evil-leader/set-key-for-mode 'ruby-mode "mss" 'ruby-switch-to-inf))))

(defun ruby-min/init-ruby-test-mode ()
  "Define keybindings for ruby test mode"
  (use-package ruby-test-mode
    :defer t
    :init (add-hook 'ruby-mode-hook 'ruby-test-mode)
    :config
    (progn
      (spacemacs|hide-lighter ruby-test-mode)
      (evil-leader/set-key-for-mode 'ruby-mode "mtb" 'ruby-test-run)
      (evil-leader/set-key-for-mode 'ruby-mode "mtt" 'ruby-test-run-at-point))))

(when (configuration-layer/layer-usedp 'auto-completion)
  (defun ruby-min/post-init-company ()
    (spacemacs|add-company-hook ruby-mode)
    (eval-after-load 'company-dabbrev-code
      '(push 'ruby-mode company-dabbrev-code-modes))))
