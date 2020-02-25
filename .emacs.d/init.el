;; -------------------packageの設定------------------
(package-initialize)
;; package.elのリポジトリの追加
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("melpa" . "http://melpa.org/packages/")
        ("org" . "http://orgmode.org/elpa/")))


(add-hook 'c++-mode-hook
          (lambda ()
            (setq lsp-prefer-flymake nil)
            (require 'ccls)
            (setq c-basic-offset 4)
            (lsp)
            ))

(global-set-key (kbd "C-x g") 'magit-status)
(move-text-default-bindings)

;; 全モード共通の初期化設定を書きます。
;; 0から始まる設定ファイルは、全モード共通の設定です。

;;;---------------背景色の設定----------------
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background "black" :foreground "#ffffff"))))
 '(cursor ((((class color) (background dark)) (:background "#ffffff")) (((class color) (background light)) (:background "#999999")) (t nil))))

;; フォントサイズの設定
(set-face-attribute 'default nil :height 110)

(set-fontset-font
    t 'japanese-jisx0208
    (font-spec :family "Ricty-10"))


(setq-default default-tab-width 4   ;タブ幅の設定
			  make-backup-files nil ; *.~ とかのバックアップファイルを作らない
			  transient-mark-mode t; 選択範囲の置換を有効化する
			  indent-tabs-mode nil)  ;タブにスペースを使用する
;; M-x tool-bar-mode で表示非表示を切り替えられる
;;;メニューバーを非表示にする
;; (menu-bar-mode -1)
;; ツールバーを非表示
(tool-bar-mode -1)
(show-paren-mode t)         ; 対応する括弧を光らせる
;;スクロールする行数を変更する
(setq-default scroll-conservatively 35
			  scroll-margin 0
			  scroll-step 3)

;; 左側に行番号を表示する
(global-linum-mode)

;; (yes/no) を (y/n)に
(fset 'yes-or-no-p 'y-or-n-p)

(set-scroll-bar-mode 'nil) ;;;スクロールバーを消す
;;;マウスホイールでのスクロールに関する設定
(setq-default mouse-wheel-scroll-amount '(1 ((shift) . 1)) ;; one line at a time
              mouse-wheel-progressive-speed nil ;; don't accelerate scrolling
              mouse-wheel-follow-mouse 't) ;; scroll window under mouse

;; 日本語入力の設定
(when (eq system-type 'gnu/linux)
  (require 'mozc)
  ;; mozcがキーバンドを奪うため再設定
  (bind-keys :map mozc-mode-map
			 ("C-x h" . mark-whole-buffer)
			 ("C-x C-s" . save-buffer))
  (progn ;toggle input method
	(setq default-input-method "japanese-mozc")
	(define-key global-map [henkan]
	  (lambda ()
		(interactive)
		(if current-input-method (inactivate-input-method))
		(toggle-input-method)))
	;; (define-key global-map [muhenkan]
	;;   (lambda ()
	;;     (interactive)
	;;     (inactivate-input-method)))
	(define-key global-map [zenkaku-hankaku]
	  (lambda ()
		(interactive)
		(toggle-input-method)))

	(defadvice mozc-handle-event (around intercept-keys (event))
	  "Intercept keys muhenkan and zenkaku-hankaku, before passing keys to mozc-server (which the function mozc-handle-event does), to properly disable mozc-mode."
	  (if (member event (list 'zenkaku-hankaku 'muhenkan))
		  (progn
			(mozc-clean-up-session)
			(toggle-input-method))
		(progn ;(message "%s" event) ;debug
		  ad-do-it)))
	(ad-activate 'mozc-handle-event))
  )

;; windowsでコマンドが動くようにパスを通す
(when (eq system-type 'windows-nt)
  (setq find-program "\"F:\\Program Files\\Git\\usr\\bin\\find.exe\""
		grep-program "\"F:\\Program Files\\Git\\usr\\bin\\grep.exe\""
		null-device "/dev/null"))

;; 選択範囲の削除の設定
;; このようにすることで選択中に文字を入力されると文字を入力された文字に入れ替わる
(delete-selection-mode nil)

;;括弧の補完
(electric-pair-mode t)

;; yasnippetの設定
;; (require 'yasnippet)
;; (yas-global-mode 1)

;; 起動時の画面を消す
(setq-default inhibit-startup-message t
              ;; スクラッチバッファの文字を消す
              initial-scratch-message nil)

;; 指定したディレクトリにあるelファイルを読み込んだ時にコンパイルします
(defun add-to-load-path-recompile (dir)
  (add-to-list 'load-path dir)
  (let (save-abbrevs) (byte-recompile-directory dir)))

;; -----------変数をハイライトする設定------------------------
;;0.5秒後自動ハイライトされるようになる
(setq-default highlight-symbol-idle-delay 0.5)
;;; プログラムを書く時、自動ハイライトをする
(add-hook 'prog-mode-hook 'highlight-symbol-mode)
;;; ソースコードにおいてM-p/M-nでシンボル間を移動
(add-hook 'prog-mode-hook 'highlight-symbol-nav-mode)
;;; シンボル置換
(global-set-key (kbd "M-s M-r") 'highlight-symbol-query-replace)
;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(package-selected-packages
;;    (quote
;;     (company-lsp mozc lsp-ui lsp-treemacs highlight-symbol flycheck dap-mode ccls bind-key))))
