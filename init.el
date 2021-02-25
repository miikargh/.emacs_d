; Make everything simpler
(setq inhibit-startup-message t)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 5) ;; Padding on sides
(menu-bar-mode -1)
; (setq visible-bell t)

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))




(unless package-archive-contents
 (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(set-face-attribute 'default nil :font "Iosevka" :height 140 :weight 'light)

;; (load-theme 'wombat t)
;; (use-package kaolin-themes
;;   :config
;;   (load-theme 'kaolin-bubblegum t)
;;   (kaolin-treemacs-theme))

(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-dracula t)

  ;; Enable flashing mode-line on errors
  ;; (doom-themes-visual-bell-config)
  
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
  (doom-themes-treemacs-config)
  
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

;; NOTE: The first time you load your configuration on a new machine, you'll
;; need to run the following command interactively so that mode line icons
;; display correctly:
;;
;; M-x all-the-icons-install-fonts
(use-package all-the-icons)

(use-package exec-path-from-shell
 :init (exec-path-from-shell-initialize))

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)


(column-number-mode)
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)

;; Disable line numbers from some modes
(dolist (mode '(org-mode-hook
		 term-mode-hook
		 eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("M-j" . ivy-next-line)
         ("M-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  :init (ivy-mode 1))


(show-paren-mode 1)

(use-package which-key
  :init (which-key-mode)
  :diminish wich-key-mode
  :config (setq which-key-idle-delay 0.3))

(use-package ivy-rich
  :init (ivy-rich-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq counsel-find-file-ignore-regexp "\\(?:^[#.]\\)\\|\\(?:[#~]$\\)\\|\\(?:^Icon?\\)"))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

;; Open init.el
(defun open-user-init-file ()
  "Edit the `user-init-file', in another window."
  (interactive)
  (find-file user-init-file))


;; Mac stuff
(setq mac-option-key-is-meta nil
      mac-command-key-is-meta t
      mac-command-modifier 'meta
      mac-option-modifier 'none)

(use-package smartparens
  :config
  (smartparens-global-mode t)
  (sp-pair "'" nil :actions :rem))

(use-package evil-smartparens
  :init
  (add-hook 'smartparens-enabled-hook #'evil-smartparens-mode))

(defun miika/visual-shift-left ()
  "Make shifting not loose focus"
  (interactive)
  (call-interactively 'evil-shift-left)
  (evil-normal-state)
  (evil-visual-restore))

(defun miika/visual-shift-right ()
  "Make shifting not loose focus"
  (interactive)
  (call-interactively 'evil-shift-right)
  (evil-normal-state)
  (evil-visual-restore))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)
  (define-key evil-normal-state-map (kbd "ä" ) 'evil-backward-paragraph)
  (define-key evil-visual-state-map (kbd "ä" ) 'evil-backward-paragraph)
  (define-key evil-normal-state-map (kbd "ö" ) 'evil-forward-paragraph)
  (define-key evil-visual-state-map (kbd "ö" ) 'evil-forward-paragraph)
  (define-key evil-normal-state-map (kbd "å") 'evil-first-non-blank)
  (define-key evil-visual-state-map (kbd "å") 'evil-first-non-blank)
  (define-key evil-visual-state-map (kbd ">") 'miika/visual-shift-right)
  (define-key evil-visual-state-map (kbd "<") 'miika/visual-shift-left)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-commentary
  :after evil
  :init (evil-commentary-mode))

(use-package evil-snipe
  :config
    (evil-snipe-mode +1)
    (evil-snipe-override-mode +1)
    (evil-define-key 'visual evil-snipe-local-mode-map "z" 'evil-snipe-s)
    (evil-define-key 'visual evil-snipe-local-mode-map "Z" 'evil-snipe-S))

(use-package evil-multiedit
  :config (evil-multiedit-default-keybinds))

(use-package evil-easymotion)


(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  ;; :bind-keymap
  ;; ("SPC p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/dev")
    (setq projectile-project-search-path '("~/dev")))
  (setq projectile-switch-project-action #'projectile-dired)
  :config
  (setq projectile-globally-ignored-directories (append '(".bloop" ".bsp" ".metals" "target") projectile-globally-ignored-directories))
  (setq projectile-globally-ignored-files (append '(".#*" "#*") projectile-globally-ignored-files))
  )

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package magit
  :config
  (add-hook 'magit-mode-hook 'turn-off-evil-snipe-override-mode))

(defun miika/focus-next-window-or-open-new ()
  "Move focus to the next window or opens a new window if only one is open."
  (interactive)
  (when (one-window-p)
    (evil-window-vsplit))
  (evil-window-next nil))

(defun miika/toggle-lsp-ui-doc ()
  "Show lsp-ui-doc if if it is hidden and hides if not."
  (interactive)
  (if (lsp-ui-doc--visible-p)
      (lsp-ui-doc-hide)
    (lsp-ui-doc-show)))


(use-package general
  :config

  (general-define-key
    :states 'insert
    :keymaps 'override
    "M-j" 'company-select-next)

  (general-define-key
    :states 'insert
    :keymaps 'override
    "M-k" 'company-select-previous)

  (general-create-definer miika/leader-keys
    ;; :keymaps '(normal visual emacs)
    :states '(normal visual emacs)
    :prefix "SPC")
  (miika/leader-keys
    ":" '(counsel-M-x :which-key "M-x")
    ";" '(eval-expression :which-key "Eval expression")
    "." '(projectile-find-file :which-key "Find file in project")
    "SPC" '(:keymap evilem-map :which-key "Easy motion")
    "SPC s" '(evil-avy-goto-char
	      :keymaps: 'override)
    "SPC S" '(evil-avy-goto-char-2
	      :keymaps: 'override)


    "/" '(swiper :which-key "swiper")

    "x" '(:keymap ctl-x-map :which-key "C-x")

    ;; Buffers
    "b" '(:ignore t :which-key "Buffer")
    "bb" '(switch-to-buffer :which-key "Switch to buffer")
    "bk" '(kill-current-buffer :which-key "Kill current buffer")
    "bl" '(evil-switch-to-windows-last-buffer :which-key "Next buffer")

    ;; Eval
    "e" '(:ignore t :which-key "Eval")
    "ed" '(eval-defun :which-key "Eval defun")
    "er" '(eval-region :which-key "Eval region")
    "eb" '(eval-region :which-key "Eval buffer")

    ;; Toggle
    "t" '(:ignore t :which-key "Toggle")
    "tt" '(counsel-load-theme :which-key "Load theme")
    "ts" '(hydra-text-scale/body :which-key "Scale text")

    ;; Window management
    "w" '(:keymap evil-window-map :package evil)
    "ww" '(miika/focus-next-window-or-open-new
	   :keymaps 'override
	   :which-key "Focus on next window or open new")

    ;; Files
    "f" '(:ignore t :which-key "File")
    "fi" '(open-user-init-file :which-key "Open init.el")
    "ff" '(find-file :which-key "Find file")
    "f ." '(projectile-find-file-in-directory :which-key "Find file in dir")

    ;; Mode stuff
    "m" '(:ignore t :which-key "Mode")
    "mf" '(:ignore t :which-key "Format")
    "mfa" '(lsp-format-buffer :which-key "Format buffer")
    "mfr" '(lsp-format-region :which-key "Format region")
    ;; Help
    "h" '(:ignore t :which-key "Help")
    "hv" '(describe-variable :which-key "Describe a variable")
    "hf" '(describe-function :which-key "Describe a function")
    "he" '(view-echo-area-messages :which-key "View echo messages")

    ;; Magit
    "g" '(:ignore t :which-key "Magit")
    "gg" '(magit-status :which-key "Git status")

    ;; Projects
    "p" '(:keymap projectile-command-map :package projectile)

    ;; UI
    "u" '(:ignore t :which-key "UI")
    "ud" '(:ignore t :which-key "Doc")
    "uds" '(miika/toggle-lsp-ui-doc :which-key "Toggle doc")
    ))

;; General coding stuff
(use-package flycheck
  :init (global-flycheck-mode))
(use-package yasnippet)

;; LSP
(use-package lsp-mode
  ;; Optional - enable lsp-mode automatically in scala files
  :hook
  (scala-mode . lsp)
  (lsp-mode . lsp-lens-mode)
  :init
    (setq lsp-enable-file-watchers nil
	    lsp-enable-folding nil
	    lsp-enable-text-document-color nil)
    (setq lsp-enable-indentation nil
	lsp-enable-on-type-formatting nil)

  :config
  ;; Uncomment following section if you would like to tune lsp-mode performance according to
  ;; https://emacs-lsp.github.io/lsp-mode/page/performance/
    (setq gc-cons-threshold 100000000) ;; 100mb
    (setq read-process-output-max (* 1024 1024)) ;; 1mb
    (setq lsp-idle-delay 0.500)
    (setq lsp-log-io nil)
    (setq lsp-prefer-flymake nil))

 

(use-package lsp-ui
  :config
  (setq lsp-ui-doc-position 'at-point
	lsp-ui-doc-delay 0.0
	lsp-ui-doc-show-with-cursor nil
	lsp-ui-sideline-show-diagnostics t))


(use-package company-lsp
  :config
  (setq company-lsp-cache-candidates 'auto))

(use-package company
  :config
  (add-hook 'emacs-lisp-mode-hook 'company-mode))

(use-package posframe)
(use-package dap-mode
  :hook
  (lsp-mode . dap-mode)
  (lsp-mode . dap-ui-mode))


;; Scala
(use-package scala-mode
  :interpreter
  ("scala" . scala-mode))

(use-package sbt-mode
  :commands sbt-start sbt-command
  :config
  ;; WORKAROUND: https://github.com/ensime/emacs-sbt-mode/issues/31
  ;; allows using SPACE when in the minibuffer
  (substitute-key-definition
   'minibuffer-complete-word
   'self-insert-command
   minibuffer-local-completion-map)
   ;; sbt-supershell kills sbt-mode:  https://github.com/hvesalai/emacs-sbt-mode/issues/152
  (setq sbt:program-options '("-Dsbt.supershell=false")))

(use-package lsp-metals
  :config (setq lsp-metals-treeview-show-when-views-received nil))

;; todo highlighting
(use-package hl-todo
  :config (hl-todo-mode))




(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(company-mode hl-todo evil-smartparens smartparens evil-easymotion evil-snipe: evil-multiedit evil-snipe evil-magit magit exec-path-from-shell sbt-mode scala-mode perspective counsel-projectile projectile god-mode kaolin-themes doom-modeline ivy use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
