(in-package :vizbucket)

(defmacro main-js ()
  `(progn
     (defun start-main ()
       (setprop *screen* fill-style "white")
       (layer-render *screen*))

     ))

(defun output-main ()
  (output-js "main" '(main-js)))
