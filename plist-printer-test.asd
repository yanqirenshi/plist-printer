#|
  This file is a part of plist-printer project.
|#

(defsystem "plist-printer-test"
  :defsystem-depends-on ("prove-asdf")
  :author ""
  :license ""
  :depends-on ("plist-printer"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "plist-printer"))))
  :description "Test system for plist-printer"

  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
