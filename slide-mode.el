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
    (define-key map "\C-n" 'next-slide)
    map))

;; define the mode
(define-minor-mode slide-mode
  "Toggle minor mode for display of slides."
  nil " Slides" (slide-build-mode-map)
  t)

;; move to the next slide
(defun next-slide ()
  "Go to next slide."
  (interactive)
  (widen)
  (if (re-search-forward "^\C-l$" (point-max) t)
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
