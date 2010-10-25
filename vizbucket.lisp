(defpackage :vizbucket
  (:documentation "Membase vizBucket visualizer web console interface")
  (:nicknames :vb)
  (:use :cl :cl-who :parenscript)
  ;;(:export ...)
  )

(in-package :vizbucket)

;;;

(defun index-html (stream)
  (cl-who:with-html-output (stream nil :indent t)
  ;;(with-html-output-to-string (s)
    (:html
           (:head (:title "Membase Bucket Migration")
                  (:link :rel "stylesheet"
                         :type "text/css"
                         :href "console.css")

                  (:script :src "jquery-1.4.2.min.js")
                  (:script :src "underscore-1.1.0.min.js")

                  (:script :src "geom.js")
                  (:script :src "anim.js")
                  (:script :src "graph.js")
                  (:script :src "main.js"))
           (:body
            (:div
             :id "container"

             (:div
              :class "page-header"
              (:div
               :class "cnt_holder main_holder"
               (:div
                :class "topper_nav"
                (:button :onclick "stop_polling()" "Stop")
                (:a :href "javascript:showAbout()" "About")
                (:b "&bull;")
                (:a :href "javascript:ThePage.signOut()" "Sign Out"))
               (:a :href "/index.html" (:span "&nbsp;"))))

             (:div :id "view")
             (:div :id "cells")
             (:div :id "loading")

             (:div :id "mainContainer"
                   :class "main_holder"
                   (:canvas :id "screen_canvas"
                            :width *screen-width*
                            :height *screen-height*)
                   ;; (:table :id "server_table"
                   ;;         (:tr :id "server_icons")
                   ;;         (:tr (:td))
                   ;;         (:tr :id "server_active")
                   ;;         (:tr (:td))
                   ;;         (:tr :id "server_replica"))
                   (:br))

             (:div :class "page-footer"
                   (:div :class "main_holder"
                         (:h1 "Copyright &copy; 2010"
                              (:a :href "http://membase.com"
                                  "Membase, Inc.")))))
            ))))

;;;

(defun output-file (name fun)
  (let* ((fname (concatenate 'string "./htdocs/" name))
         (stream (open fname :direction :output :if-exists :supersede)))
    (setf *parenscript-stream* nil)
    (funcall fun stream)
    (close stream)
    (format t "done writing ~s~%" fname)))

(defun output-js (name body)
  (output-file (concatenate 'string name ".js")
               (lambda (stream)
                 (setf *parenscript-stream* stream)
                 (parenscript:ps* (macroexpand-1 body)))))

(defun output-all ()
  (output-file "index.html" #'index-html)
  (output-geom)
  (output-anim)
  (output-graph)
  (output-main))


;; some utility stuff

(defpsmacro clog (fmt)
  `((@ console log) ,fmt))

(defpsmacro clogf (fmt &rest args)
  `((@ console log) (concatenate 'string ,fmt ,@args)))

(defpsmacro defproto (class name &body body)
  `(setf (@ ,class prototype ,name) ,@body))

(defpsmacro setprop (object key value)
  `(setf (@ ,object ,key) ,value))

(defpsmacro setthis (key value)
  `(setf (@ this ,key) ,value))

(defpsmacro for-each (x f)
  `(for-in (i ,x) (,f (getprop ,x i))))

