(defpackage :vizbucket
  (:documentation "Membase vizBucket visualizer web console interface")
  (:nicknames :vb)
  (:use :cl :cl-who :parenscript :humaweb)
  ;;(:export ...)
  )

(in-package :vizbucket)

(defvar *screen-width* 800)
(defvar *screen-height* 600)

(defun output ()
  (output-project :dir "./htdocs"
                  :html '("index")
                  :js '("main")))

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
                (:button :onclick "stopPolling()" "Stop")
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


