(in-package :vizbucket)

(defvar *screen-width* 800)
(defvar *screen-height* 600)

(defpsmacro cg-fill-style (style)
  `(setf (@ *ctx* fill-style) ,style))

(defpsmacro cg-fill-rect (r)
  `((@ *ctx* fill-rect)
    (rect-x ,r) (rect-y ,r)
    (rect-width ,r) (rect-height ,r)))

(defpsmacro cg-stroke-style (style)
  `(setf (@ *ctx* stroke-style) ,style))

(defpsmacro cg-font (size name)
  `(setf (@ *ctx* font) (concatenate 'string ,size "px " ,name)))

(defmacro graph-js ()
  `(progn
     (var *screen-width* ,*screen-width*)
     (var *screen-height* ,*screen-height*)
     (var *ctx* null)
     (var *screen* null)

     (defun start-graph ()
       (setf *ctx* (chain (@ ($ "#screen_canvas") 0) (get-context "2d")))
       (cg-font 32 "helvetica")

       (setf *screen* (new-layer :name "*screen*"
                                 :bounds (rect-make 0 0
                                                    ,*screen-width*
                                                    ,*screen-height*)))
       (start-main))

     (chain ($ document) (ready start-graph))
     ))

(defun output-graph ()
  (output-js "graph" '(graph-js)))
