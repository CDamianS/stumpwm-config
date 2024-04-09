;; -*- mode: lisp -*-
#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp"
				       (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(ql:quickload "stumpwm")
(in-package :stumpwm)

(init-load-path #p"~/.config/stumpwm/modules/")
(run-shell-command "picom &")
(run-shell-command "polybar --reload")
(run-shell-command "gsettings set org.gnome.settings-daemon.peripherals.touchpad natural-scroll true")
;; Nat scrolling
(run-shell-command "xwallpaper --zoom ~/.config/stumpwm/mocha.png" t)

;; Slynk Calling
(ql:quickload :slynk)
(defcommand slynk () ()
  (sb-thread:make-thread
   (lambda ()
     (slynk:create-server :port 4005 :dont-close t))))

;; Fonts
(load-module "ttf-fonts")
(pushnew (concat (getenv "HOME")
                 "/.local/share/fonts/")
         xft:*font-dirs* :test #'string=)
(xft:cache-fonts)
(set-font (make-instance 'xft:font :family "DejaVu Sans Mono" :subfamily "Book" :size 11))

;; Colors
(setf *colors*
      '("#1e1e2e"   ;black
        "#f38ba8"   ;red
        "#a6e3a1"   ;green
        "#f9e2af"   ;yellow
        "#89b4fa"   ;blue
        "#eba0ac"   ;magenta
        "#94e2d5"   ;cyan
        "#cdd6f4")) ;white
(when *initializing*
  (update-color-map (current-screen)))

;; Gaps
(load-module "swm-gaps")
(setf swm-gaps:*inner-gaps-size* 6
      swm-gaps:*outer-gaps-size* 3
      swm-gaps:*head-gaps-size* 0)
(when *initializing*
  (swm-gaps:toggle-gaps))

;; Workspaces
(defvar *workspaces* (list "1" "2" "3" "4" "5"))
(stumpwm:grename (nth 0 *workspaces*))
(dolist (workspace (cdr *workspaces*))
  (stumpwm:gnewbg workspace))

;; Keybinds
;;; Navigation
(defvar *move-to-keybinds* (list "!" "@"  "#" "$" "%" "^" "&" "*" "("))
(Dotimes (y (length *workspaces*))
  (let ((workspace (write-to-string (+ y 1))))
    (define-key *top-map* (kbd (concat "M-" workspace)) (concat "gselect " workspace))
    (define-key *top-map* (kbd (concat "M-" (nth y *move-to-keybinds*))) (concat "gmove-and-follow " workspace))))

;;; Apps
(define-key *root-map* (kbd "w") "exec librewolf")
(define-key *root-map* (kbd "RET") "exec st")

;;; Shortcuts
(define-key *root-map* (kbd "d") "exec rofi -show drun")
(define-key *root-map* (kbd "l") "exec /home/damian/.config/stumpwm/scripts/blur-lock")
(define-key *root-map* (kbd "q") "quit-confirm")

;;; Power Keys
(define-key *top-map* (kbd "XF86AudioMute") "exec pamixer -t")
(define-key *top-map* (kbd "XF86AudioRaiseVolume") "exec pamixer --allow-boost -i 5")
(define-key *top-map* (kbd "XF86AudioLowerVolume") "exec pamixer --allow-boost -d 5")
(define-key *top-map* (kbd "XF86MonBrightnessUp") "exec brightnessctl set 5%+")
(define-key *top-map* (kbd "XF86MonBrightnessDown") "exec brightnessctl set 5%-")
(define-key *top-map* (kbd "XF86AudioRaiseVolume") "exec pamixer --allow-boost -i 5")
(define-key *top-map* (kbd "XF86AudioLowerVolume") "exec pamixer --allow-boost -d 5")
(define-key *top-map* (kbd "XF86MonBrightnessUp") "exec brightnessctl set 7%+")
(define-key *top-map* (kbd "XF86MonBrightnessDown") "exec brightnessctl set 7%-")
