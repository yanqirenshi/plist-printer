(in-package :plist-printer)

(defun get-first-line (str)
  (let ((pos (position #\Newline str)))
    (if (null pos)
        str
        (concatenate 'string
                     (subseq str 0 pos)
                     " ..."))))

(defun value2string (value)
  (cond ((or (stringp value)
             (numberp value))
         (princ-to-string value))
        (t (format nil "~S" value))))

(defun get-value (column data key)
  (let ((getter (getf column :getter)))
    (if (eq :getf getter)
        (getf data key)
        (funcall getter data))))

(defun make-print-value (data column)
  (let ((key (getf column :key)))
    (get-first-line
     (value2string (get-value column data key)))))

(defun make-print-values (data columns)
  (when columns
    (let ((column (car columns)))
      (cons (make-print-value data column)
            (make-print-values data (cdr columns))))))

(defun make-control-string (columns)
  (if (null columns)
      "~%"
      (let ((column (car columns)))
        (concatenate 'string
                     "| ~"
                     (princ-to-string (getf (getf column :width) :size))
                     "a "
                     (make-control-string (cdr columns))))))

(defun make-header-value (column)
  (or (getf column :label)
      (getf column :key)))

(defun make-header-values-plist (columns)
  (when columns
    (let ((column (car columns)))
      (nconc (list (getf column :key)
                   (make-header-value column))
             (make-header-values-plist (cdr columns))))))

(defun make-header-values (columns)
  (when columns
    (let ((column (car columns)))
      (cons (make-header-value column)
            (make-header-values (cdr columns))))))

(defun cal-value-length (str)
  (if (= 0 (length str))
      0
      (+ (if (= 1 (length (sb-ext:string-to-octets (subseq str 0 1))))
             1 2)
         (cal-value-length (if (= 1 (length str))
                               ""
                               (subseq str 1))))))

(defun get-value-length (plist column)
  (let ((value (make-print-value plist column)))
    (cal-value-length (if (stringp value)
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

(defun cal-columns-width-at-body (columns-data plists)
  (if (null plists)
      columns-data
      (let ((plist (car plists)))
        (set-column-width columns-data plist)
        (cal-columns-width-at-body columns-data (cdr plists)))))

(defun cal-columns-width-at-header (columns-data)
  (set-column-width columns-data
                    (make-header-values-plist columns-data)))

(defun cal-columns-width (columns-data plists)
  (cal-columns-width-at-header columns-data)
  (cal-columns-width-at-body columns-data plists))

(defun print-header-line (control-string columns)
  (apply #'format t
         control-string
         (make-header-values columns)))

(defun print-body-lines (control-string columns plists)
  (dolist (plist plists)
    (apply #'format t
           control-string
           (make-print-values plist columns))))

(defun plprints (plists columns-data)
  (let* ((columns (cal-columns-width (make-columns columns-data)
                                     plists))
         (control-string (make-control-string columns)))
    (print-header-line control-string columns)
    (print-body-lines  control-string columns plists)))

(defun plrints (plists columns-data)
  (warn "plrints は廃止予定です。 plprints を利用してください。")
  (plprints plists columns-data))
