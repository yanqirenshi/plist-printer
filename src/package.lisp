(defpackage plist-printer
  (:nicknames :pp)
  (:use #:cl)
  (:import-from :alexandria
                #:plist-alist)
  (:export #:make-column
           #:plrints  ;; TODO: 廃棄予定
           #:plprints
           #:plist-keys
           #:plists-keys))
(in-package :plist-printer)
