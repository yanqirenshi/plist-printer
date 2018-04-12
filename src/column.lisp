(in-package :plist-printer)

;;;;;
;;;;; utility
;;;;;
(defun plist-keys (plist)
  (mapcar #'first
          (plist-alist plist)))

(defun plists-keys (plists)
  (sort (remove-duplicates
         (apply #'nconc (mapcar #'plist-keys plists)))
        #'(lambda (a b)  (string< (symbol-name a) (symbol-name b)))))

;;;;;
;;;;; column data
;;;;;
(defun make-column (&key key label (width '(:size nil :sizing :auto)) (getter :getf))
  (assert key (key) "keyは必須です。")
  (assert (keywordp key) (key) "key はキーワード・シンボルにしてください。val=~a")
  `(:key ,key
    :width ,(copy-list width)
    :getter ,getter
    :label ,(or label (princ-to-string key))))

(defun ensure-column-data (data)
  (if (keywordp data)
      (list :key data)
      data))

(defun make-columns (datas)
  (when datas
    (let ((data (car datas)))
      (cons (apply #'make-column (ensure-column-data data))
            (make-columns (cdr datas))))))