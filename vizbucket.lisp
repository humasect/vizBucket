(defpackage :vizbucket
  (:documentation "Membase vizBucket visualizer web console interface")
  (:nicknames :vb)
  (:use :cl :cl-who :parenscript :humaweb)
  ;;(:export ...)
  )

(in-package :vizbucket)

(defun output ()
  (output-project :dir "./htdocs"
                  :width 800
                  :height 600
                  :html '("index")
                  :js '("main")))

;;;

(define-htmloutput index
    :title "Membase Bucket Migration"
    :styles '("console")
    :scripts '("main")
    :body
    (htm
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
            (:p (:canvas :id "screen-canvas"
                         :width *screen-width*
                         :height *screen-height*))
            ;; (:table :id "server_table"
            ;;         (:tr :id "server-icons")
            ;;         (:tr (:td))
            ;;         (:tr :id "server-active")
            ;;         (:tr (:td))
            ;;         (:tr :id "server-replica")
            ;;         (:tr (:td) (:td :rowspan 3
            ;;                         (:canvas :id "screen-canvas"
            ;;                                  :width *screen-width*
            ;;                                  :height *screen-height*))))
            (:br))
      
      (:div :class "page-footer"
            (:div :class "main_holder"
                  (:h1 "Copyright &copy; 2010"
                       (:a :href "http://membase.com" "Membase, Inc."))))))) 

