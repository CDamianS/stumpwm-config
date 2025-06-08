;; -*- mode: lisp -*-
#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp"
				                       (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(ql:quickload "stumpwm")
(in-package :stumpwm)

(init-load-path #p"~/.config/stumpwm/modules/")

(run-shell-command "xsetroot -cursor_name left_ptr")

(set-focus-color "#5ccc96")
(setf *window-border-style* :thin)
(set-win-bg-color "#0f111b")

;; Options
(setf *mouse-focus-policy* :sloppy)
(setf *data-dir* ".config/stumpwm/")
(setf *colors*
      '("#0f111b"   ;black
        "#e33400"   ;red
        "#5ccc96"   ;green
        "#f2ce00"   ;yellow
        "#00a3cc"   ;blue
        "#ce6f8f"   ;magenta
        "#00a3cc"   ;cyan
        "#e39400"))
(when *initializing*
  (update-color-map (current-screen)))

(load-module "swm-gaps")
(setf swm-gaps:*inner-gaps-size* 6
      swm-gaps:*outer-gaps-size* 3
      swm-gaps:*head-gaps-size* 0)
(when *initializing* (swm-gaps:toggle-gaps))

;; Workspaces
(defvar *workspaces* (list "" "" "󰈹" "" "󰍡"))
(stumpwm:grename (nth 0 *workspaces*))
(dolist (workspace (cdr *workspaces*))
  (stumpwm:gnewbg workspace))

;; Keybinds
;;; Apps
(define-key *root-map* (kbd "e") "exec emacsclient -c")
(define-key *root-map* (kbd "w") "exec firefox")
(define-key *root-map* (kbd "y") "exec ytfzf -D")
(define-key *root-map* (kbd "Y") "exec ytfzf -D -c youtube-subscriptions")
(define-key *root-map* (kbd "d") "exec dmenu_run")
(define-key *root-map* (kbd "RET") "exec st")
(define-key *root-map* (kbd "l") "exec slock")

;;; Shortcuts
;; (define-key *root-map* (kbd "l") "exec /home/damian/.config/stumpwm/scripts/blur-lock")
(define-key *root-map* (kbd "q") "quit-confirm")
(define-key *root-map* (kbd "f") "fullscreen")

;;; Power Keys
(load-module "pamixer")
(define-key *top-map* (kbd "XF86AudioRaiseVolume") "pamixer-volume-up")
(define-key *top-map* (kbd "XF86AudioLowerVolume") "pamixer-volume-down")
(define-key *top-map* (kbd "XF86AudioMute") "pamixer-toggle-mute")
(define-key *top-map* (kbd "XF86MonBrightnessUp") "exec brightnessctl set 5%+")
(define-key *top-map* (kbd "XF86MonBrightnessDown") "exec brightnessctl set 5%-")
