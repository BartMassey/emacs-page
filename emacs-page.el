;; Copyright (C) 2008 Bart Massey
;; ALL RIGHTS RESERVED
;; 
;; [This program is licensed under the GPL version 3 or later.]
;; Please see the file COPYING in the source
;; distribution of this software for license terms.

;; "Page Mode"
;; Minor mode for displaying or working on just
;; a page of content at a time in Emacs, where pages
;; are user-defined subsets of a buffer.
;; Bart Massey 2008/4/17

;; make the keymap
(defun page-build-mode-map ()
  "Build the mode map for page mode."
  (let  ((map (make-keymap)))
    (define-key map "\C-c\C-n" 'next-page)
    (define-key map "\C-c\C-p" 'previous-page)
    map))

;; Actually display the current page.
;; Must be widened at entry,
;; will be narrowed at exit.
(defun display-page ()
  (let (start (here (point)))
    (if (re-search-backward "^\C-l$" nil t)
	(beginning-of-line 2)
        (goto-char (point-min)))
    (setq start (point))
    (if (re-search-forward "^\C-l$" nil t)
	(beginning-of-line nil)
        (goto-char (point-max)))
    (narrow-to-region start (point))
    (goto-char (point-min))
    (set-window-start nil (point))))

;; Define the mode.
;; When mode is activated,
;; narrow on current page.
;; When mode is deactivated,
;; widen.
(define-minor-mode page-mode
  "Toggle minor mode for display of pages."
  nil " Page" (page-build-mode-map)
  (widen)
  (if page-mode
      (progn
	(delete-other-windows)
	(display-page))))

;; move to the next page
(defun next-page ()
  "Go to next page."
  (interactive)
  (widen)
  (if (re-search-forward "^\C-l$" nil t)
      (beginning-of-line 2)
      (point-max))
  (display-page))

;; move to the previous page
(defun previous-page ()
  "Go to previous page."
  (interactive)
  (widen)
  (if (re-search-backward "^\C-l$" nil t)
      (beginning-of-line nil)
      (point-min))
  (display-page))
