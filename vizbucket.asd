(defpackage :vizbucket-asd)
(in-package :vizbucket-asd)

(asdf:defsystem vizbucket
  :name "vizBucket"
  :version "9"
  :maintainer "Lyndon Tremblay"
  :author "Lyndon Tremblay"
  :description "Membase vBucket visualiser web console interface"
  :serial t
  :depends-on (:cl-who :parenscript)
  :components ((:file "vizbucket")
               (:file "geom-js")
               (:file "anim-js")
               (:file "graph-js")
               (:file "main-js")))
