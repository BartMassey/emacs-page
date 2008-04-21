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

;; The page separator string.
(defvar page-mode-separator "\C-l"
  "The page separator string.")

(defun page-mode-make-separator-pattern (SEP)
  "Make SEP into a line pattern with optional trailing whitespace."
  (concat "^" SEP "[ \C-i]*$"))

;; The page separator pattern.
(defvar page-mode-separator-pattern
  (page-mode-make-seperator-pattern page-mode-separator)
  "Regexp describing the page separator line.
This expression currently must start with ^ and end with $,
thus marking an entire line.")

(defun page-mode-set-separator (SEP)
  "Set page-mode-separator to SEP.
Updates page-mode-separator-pattern."
  (interactive "s" "Separator: ")
  (setq page-mode-separator SEP)
  (setq page-mode-separator-pattern
	(page-mode-make-seperator-pattern SEP)))

(defun page-mode-build-keymap ()
  "Build the mode keymap for page mode."
  (let  ((map (make-keymap)))
    (define-key map "\C-c\C-n" 'page-mode-next-page)
    (define-key map "\C-c\C-p" 'page-mode-previous-page)
    (define-key map "\C-cs" 'page-mode-set-separator)
    map))

(define page-mode-search-backward ()
  "Back up to previous page separator."
  (re-search-backward page-mode-separator-pattern nil t))

(define page-mode-search-forward ()
  "Move forward to end of current page." 
  (re-search-forward page-mode-separator-pattern nil t))

;; Actually show the current page.
;; Must be widened at entry,
;; will be narrowed at exit.
(defun page-mode-show-current ()
  (let (start (here (point)))
    (if (page-mode-search-backward)
	(beginning-of-line 2)
        (goto-char (point-min)))
    (setq start (point))
    (if (page-mode-search-forward)
	(beginning-of-line nil)
        (goto-char (point-max)))
    (narrow-to-region start (point))
    (goto-char (point-min))
    (set-window-start nil (point))))

(define page-mode-setup ()
  "Setup for entering or leaving page mode."
  (if page-mode
      (progn
	(delete-other-windows)
	(widen)
	(page-mode-show-current))
      (widen)))

;; Define the mode.
;; When mode is activated,
;; narrow on current page.
;; When mode is deactivated,
;; widen.
(define-minor-mode page-mode
  "Toggle minor mode for display of pages."
  nil " Page" (page-mode-build-keymap)
  (make-variable-buffer-local page-mode-separator)
  (make-variable-buffer-local page-mode-separator-pattern)
  (page-mode-setup))

;; move to the next page
(defun page-mode-next-page ()
  "Go to next page."
  (interactive)
  (widen)
  (if (page-mode-search-forward)
      (beginning-of-line 2))
  (page-mode-show-current))

;; move to the previous page
(defun page-mode-previous-page ()
  "Go to previous page."
  (interactive)
  (widen)
  (if (page-mode-search-backward)
      (beginning-of-line nil))
  (page-mode-show-current))
