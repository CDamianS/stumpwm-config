(in-package :stumpwm)
(setf *default-package* :stumpwm)

;; General config
(run-shell-command "xss-lock -- slock &")
(init-load-path #p"~/.config/stumpwm/modules/")
(run-shell-command "xwallpaper --zoom ~/.config/stumpwm/gruv.jpg" t)
(run-shell-command "polybar --reload")

;; Slynk
(ql:quickload :slynk)
(defcommand slynk () ()
  (sb-thread:make-thread
   (lambda ()
     (slynk:create-server :port 4005 :dont-close t))))

;; Colors
(setf *colors*
      '("#32302f"   ;black
        "#fb4934"   ;red
        "#8ec07c"   ;green
        "#d79921"   ;yellow
        "#458588"   ;blue
        "#b16286"   ;magenta
        "#83a598"   ;cyan
        "#ebdbb2")) ;white

;; Fonts
;; (load-module "ttf-fonts")
;; (ql:quickload :clx-truetype)
;; (clx-truetype:cache-fonts)

;; (set-font (make-instance 'xft:font
;;                          :family "Agave Nerd Font"
;;                          :subfamily "Regular"
;;                          :size 10
;;                          :antialias t))

;; Gaps
(load-module "swm-gaps")
(setf swm-gaps:*inner-gaps-size* 4
      swm-gaps:*outer-gaps-size* 2)
(swm-gaps:toggle-gaps-on)

;; Workspaces
(defvar *workspaces* (list "1" "2" "3" "4" "5"))
(stumpwm:grename (nth 0 *workspaces*))
(dolist (workspace (cdr *workspaces*))
  (stumpwm:gnewbg workspace))

(defvar *move-to-keybinds* (list "!" "@"  "#" "$" "%" "^" "&" "*" "("))
(dotimes (y (length *workspaces*))
  (let ((workspace (write-to-string (+ y 1))))
    (define-key *root-map* (kbd workspace) (concat "gselect " workspace))
    (define-key *root-map* (kbd (nth y *move-to-keybinds*)) (concat "gmove-and-follow " workspace))))

;; Keymaps



(define-key *root-map* (kbd "space") "exec")
(define-key *top-map* (kbd "M-space") "exec")
(define-key *top-map* (kbd "M-;") "colon")
(define-key *root-map* (kbd "w") "exec brave-browser")
(define-key *root-map* (kbd "RET") "exec kitty")

(defcommand hsplit-and-focus () ()
  "create a new frame on the right and focus it"
  (hsplit)
  (move-focus :right))

(defcommand vsplit-and-focus () ()
  "create a new frame below and focus it"
  (vsplit)
  (move-focus :down))

(define-key *root-map* (kbd "v") "hsplit-and-focus")
(define-key *root-map* (kbd "s") "vsplit-and-focus")

(define-key *top-map* (kbd "XF86AudioMute") "exec pamixer -t")
(define-key *top-map* (kbd "XF86AudioRaiseVolume") "exec pamixer --allow-boost -i 5")
(define-key *top-map* (kbd "XF86AudioLowerVolume") "exec pamixer --allow-boost -d 5")
(define-key *top-map* (kbd "XF86MonBrightnessUp") "exec brightnessctl set 7%+")
(define-key *top-map* (kbd "XF86MonBrightnessDown") "exec brightnessctl set 7%-")
