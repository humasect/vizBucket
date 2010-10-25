(in-package :vizbucket)

(defmacro main-js ()
  `(progn
     ))

(defun output-main ()
  (output-js "main" '(main-js)))
