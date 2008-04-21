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
    (define-key map "\C-cn" 'new-page)
    (define-key map "\C-ci" 'insert-page)
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
  (backward-page 2)
  (narrow-to-page))

(defun insert-page-split ()
  "Insert a page split at point.
The page-delimiter variable is assumed to point at a regexp
consisting of a string with a preceding ^.  The page split
is assumed to be that string on a line by itself. Leaves
point at the start of the new page."
  (let ((ipoint (point)))
    (beginning-of-line nil)
    (if (not (= ipoint (point)))
	(progn
	  (goto-char ipoint)
	  (insert "\n"))))
  (insert (substring page-delimiter 1) "\n"))


(defun split-page ()
  "Split page at point.
Leaves point at start of new page."
  (interactive)
  (widen)
  (insert-page-split)
  (narrow-to-page))

(defun new-page ()
  "Append a new page after the current page and enter it."
  (interactive)
  (widen)
  (backward-page)
  (forward-page)
  (beginning-of-line 2)
  (insert-page-split)
  (backward-page 2)
  (insert "\n")
  (narrow-to-page))

(defun insert-page ()
  "Insert a new page before the current page and enter it."
  (interactive)
  (widen)
  (backward-page)
  (if (not (= (point) (point-min)))
      (beginning-of-line 2))
  (insert-page-split)
  (backward-page 2)
  (insert "\n")
  (narrow-to-page))
