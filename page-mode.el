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

(defun page-mode-build-keymap ()
  "Build the mode keymap for page mode."
  (let  ((map (make-keymap)))
    (define-key map "\C-c\C-n" 'next-page)
    (define-key map "\C-c\C-p" 'prev-page)
    (define-key map "\C-cq" 'page-mode)
    (define-key map "\C-cs" 'split-page)
    map))

(defun page-mode-setup ()
  "Setup for entering or leaving page mode."
  (if page-mode
      (progn
	(delete-other-windows)
	(widen)
	(narrow-to-page))
      (widen)))

;; Define the mode.
;; When mode is activated,
;; narrow on current page.
;; When mode is deactivated,
;; widen.
(define-minor-mode page-mode
  "Toggle minor mode for display of pages."
  nil " Page" (page-mode-build-keymap)
  (page-mode-setup))

;; move to the next page
(defun next-page ()
  "Go to next page."
  (interactive)
  (widen)
  (forward-page)
  (narrow-to-page))

;; move to the previous page
(defun prev-page ()
  "Go to previous page."
  (interactive)
  (widen)
  (backward-page 1)
  (narrow-to-page))

(defun split-page ()
  "Split page at cursor.
Views top portion of split."
  (interactive)
  (widen)
  (let ((ipoint (point))
	(page-delimiter-string
	 (substring page-delimiter 1)))
    (beginning-of-line nil)
    (if (not (= (point) ipoint))
	(progn
	  (goto-char ipoint)
	  (insert "\n")))
    (insert page-delimiter-string "\n")
    (goto-char ipoint)
    (narrow-to-page)))
