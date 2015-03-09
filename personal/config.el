(message "Loading amidvidy personal config")

(menu-bar-mode -1)
(semantic-mode 1)
(projectile-global-mode)

(setq-default c-basic-offset 4)
(setq-default c-indent-tabs-mode nil)
(setq-default c-indent-level 4)

(set-face-attribute 'default nil
                    :family "Inconsolata" :height 150 :weight 'normal)

(add-hook 'go-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'gofmt-before-save)
            (setq tab-width 4)
            (setq standard-indent 4)
            (setq indent-tabs-mode 1)))
(require 'sr-speedbar)

(require 'helm-config)
(helm-mode 1)
;(helm-autoresize-mode 1)
(require 'helm-projectile)

(setq
 helm-gtags-ignore-case t
 helm-gtags-auto-update t
 helm-gtags-use-input-at-cursor t
 helm-gtags-pulse-at-cursor t
 helm-gtags-prefix-key "\C-cm"
 helm-gtags-suggested-key-mapping t
 )

(require 'helm-gtags)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'c-mode-hook 'helm-gtags-mode)

(define-key prelude-mode-map "\C-cg" nil)

(global-set-key (kbd "C-c h") 'helm-mini)
(global-set-key (kbd "C-c g") 'helm-projectile-ag)
(global-set-key (kbd "C-c l") 'helm-projectile-find-file)
(global-set-key (kbd "C-c i") 'helm-semantic)
(global-set-key (kbd "C-c c") 'compile)
(global-set-key (kbd "C-c r") 'helm-register)

; helm gtags
(define-key helm-gtags-mode-map (kbd "C-c m") 'helm-gtags-tags-in-this-function)
(define-key helm-gtags-mode-map (kbd "C-j") 'helm-gtags-select)
(define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
(define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
(define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
(define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)

; helm specific keybindings
(global-set-key (kbd "M-x") 'helm-M-x) ; use helm-M-x for all the things
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x C-f") 'helm-find-files)

; bind pandoc mode to markdown mode
(add-hook 'markdown-mode-hook 'pandoc-mode)
(add-hook 'pandoc-mode-hook 'pandoc-load-default-settings)

(menu-bar-mode -1)

(defun toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
                  (next-win-buffer (window-buffer (next-window)))
                       (this-win-edges (window-edges (selected-window)))
                            (next-win-edges (window-edges (next-window)))
                                 (this-win-2nd (not (and (<= (car this-win-edges)
                                                              (car next-win-edges))
                                                              (<= (cadr this-win-edges)
                                                                   (cadr next-win-edges)))))
                                      (splitter
                                             (if (= (car this-win-edges)
                                                         (car (window-edges (next-window))))
                                                   'split-window-horizontally
                                               'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
            (funcall splitter)
              (if this-win-2nd (other-window 1))
                (set-window-buffer (selected-window) this-win-buffer)
                  (set-window-buffer (next-window) next-win-buffer)
                    (select-window first-win)
                      (if this-win-2nd (other-window 1))))))

(setq paradox-github-token "73208d188fa6ee9b34eade4975b4cd2710a50fea")

(global-company-mode 1)

(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

;; replace the `completion-at-point' and `complete-symbol' bindings in
;; irony-mode's buffers by irony-mode's function
(defun my-irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))

(add-hook 'irony-mode-hook 'my-irony-mode-hook)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))

;; (optional) adds CC special commands to `company-begin-commands' in order to
;; trigger completion at interesting places, such as after scope operator
;;     std::|
(add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)
