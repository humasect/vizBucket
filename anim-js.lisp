(in-package :vizbucket)

;; layer
(defpsmacro new-layer (&key (name "")
                            (fill-style "blue")
                            (stroke-style "white")
                            (bounds (rect-make 0 0 1 1)))
  `(create name ,name
           superlayer null
           sublayers (array)
           bounds ,bounds
           fill-style ,fill-style
           stroke-style ,stroke-style))

(defpsmacro set-bounds (l b)
  `(setf (@ ,l bounds) ,b))

(defmacro anim-js ()
  `(progn
     (defun layer-add-sublayer (l s)
       ;; does not check if layer is already present.
       ;;(clog s)
       ;;(append (@ l sublayers) (list s))
       ((chain (@ l sublayers) push) s)
       (setf (@ s parent) l)
       )

     (defun layer-render (l)
       (with-slots (fill-style stroke-style bounds sublayers) l
         (progn
           (setprop *ctx* fill-style fill-style)
           (setprop *ctx* stroke-style stroke-style)
           (cg-fill-rect bounds)
           (for-each sublayers layer-render))))
     
     ))

(defun output-anim ()
  (output-js "anim" '(anim-js)))
