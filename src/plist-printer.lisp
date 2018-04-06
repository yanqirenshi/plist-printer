(defpackage plist-printer
  (:nicknames :pp)
  (:use #:cl)
  (:export #:make-column
           #:pprints))
(in-package :plist-printer)

(defun make-column (&key key label (width-size nil) (width-sizing :auto) (getter :getf))
  (assert key (key) "keyは必須です。")
  (assert (keywordp key) (key) "key はキーワード・シンボルにしてください。val=~a")
  `(:key ,key
    :width (:size ,width-size :sizing ,width-sizing)
    :getter ,getter
    :label ,(or label (princ-to-string key))))

(defun make-columns (data)
  (when data
    (let ((d (car data)))
      (cons (apply #'make-column d)
            (make-columns (cdr data))))))

(defun make-value (data column)
  (let ((key (getf column :key))
        (getter (getf column :getter)))
    (if (eq :getf getter)
        (getf data key)
        (funcall getter data))))

(defun make-values (data columns)
  (when columns
    (let ((column (car columns)))
      (cons (make-value data column)
            (make-values data (cdr columns))))))

(defun make-control-string (columns)
  (if (null columns)
      "~%"
      (let ((column (car columns)))
        (concatenate 'string
                     "| ~"
                     (princ-to-string (getf (getf column :width) :size))
                     "a "
                     (make-control-string (cdr columns))))))

(defun make-header-values (columns)
  (when columns
    (let ((column (car columns)))
      (cons (getf column :key)
            (make-header-values (cdr columns))))))

(defun get-value-length (plist column)
  (let ((value (make-value plist column)))
    (length (if (stringp value)
                value
                (princ-to-string value)))))

(defun set-column-width (columns-data plist)
  (dolist (column columns-data)
    (when (eq :auto (getf (getf column :width) :sizing))
      (let ((size (get-value-length plist column))
            (size_now (getf (getf column :width) :size)))
        (when (or (null size_now)
                  (> size size_now))
          (setf (getf (getf column :width) :size)
                size))))))

(defun cal-columns-width (columns-data plists)
  (if (null plists)
      columns-data
      (let ((plist (car plists)))
        (set-column-width columns-data plist)
        (cal-columns-width columns-data (cdr plists)))))

(defun print-header-line (control-string columns)
  (apply #'format t
         control-string
         (make-header-values columns)))

(defun print-body-lines (control-string columns plists)
  (dolist (plist plists)
    (apply #'format t
           control-string
           (make-values plist columns))))

(defun pprints (plists columns-data)
  (let* ((columns (cal-columns-width (make-columns columns-data)
                                     plists))
         (control-string (make-control-string columns)))
    (print-header-line control-string columns)
    (print-body-lines control-string columns plists)))
