#|
  This file is a part of plist-printer project.
|#

(defsystem "plist-printer"
  :version "0.1.0"
  :author ""
  :license ""
  :depends-on (:alexandria)
  :components ((:module "src"
                :components
                ((:file "package")
                 (:file "column")
                 (:file "pprint"))))
  :description ""
  :long-description
  #.(read-file-string
     (subpathname *load-pathname* "README.markdown"))
  :in-order-to ((test-op (test-op "plist-printer-test"))))
