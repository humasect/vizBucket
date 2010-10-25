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
                   (:table :id "server_table"
                           (:tr :id "server_icons"))))

            ;; (:canvas :id "canvas"
            ;;          :width (* *tile-width* *scr-width*)
            ;;          :height (* *tile-height* *scr-height*))
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
  (output-main)
  (output-geom)
  (output-anim))
