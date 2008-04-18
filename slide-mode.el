;; Copyright (C) 2008 Bart Massey
;; ALL RIGHTS RESERVED
;; 
;; [This program is licensed under the GPL version 3 or later.]
;; Please see the file COPYING in the source
;; distribution of this software for license terms.

;; "Slide show" mode
;; Be able to flip slide pages in Emacs
;; Bart Massey 2008/4/17

;; make the keymap
(defun slide-build-mode-map ()
  "Build the mode map for slide mode."
  (let  ((map (make-keymap)))
    (define-key map "\C-c\C-n" 'next-slide)
    (define-key map "\C-c\C-p" 'previous-slide)
    map))

;; Actually display the current slide.
;; Must be widened at entry,
;; will be narrowed at exit.
(defun display-slide ()
  (setq here (point))
  (if (re-search-backward "^\C-l$" (point-min) t)
      (beginning-of-line 2)
      (goto-char (point-min)))
  (setq start (point))
  (if (re-search-forward "^\C-l$" (point-max) t)
      (beginning-of-line nil)
      (goto-char (point-max)))
  (narrow-to-region start (point))
  (goto-char (point-min))
  (recenter)
  (goto-char (point-max)))

;; Define the mode.
;; When mode is activated,
;; narrow on current slide.
;; When mode is deactivated,
;; widen.
(define-minor-mode slide-mode
  "Toggle minor mode for display of slides."
  nil " Slides" (slide-build-mode-map)
  (widen)
  (if slide-mode
      (display-slide)))

;; move to the next slide
(defun next-slide ()
  "Go to next slide."
  (interactive)
  (widen)
  (if (re-search-forward "^\C-l$" (point-max) t)
      (progn
	(beginning-of-line 2)
	(display-slide))))

;; move to the previous slide
(defun previous-slide ()
  "Go to previous slide."
  (interactive)
  (widen)
  (if (re-search-backward "^\C-l$" (point-min) t)
      (progn
       (beginning-of-line nil)
       (display-slide))))
