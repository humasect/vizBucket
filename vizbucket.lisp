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
                  :js '("main")
                  :css '("console")))

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
        :class "cnt-holder main-holder"
        (:div
         :class "topper-nav"
         (:button :onclick "stopPolling()" "Stop")
         (:a :href "javascript:showAbout()" "About")
         (:b "&bull;")
         (:a :href "javascript:ThePage.signOut()" "Sign Out"))
        (:a :href "/index.html" (:span "&nbsp;"))))

      (:div :id "view")
      (:div :id "cells")
      (:div :id "loading")
      
      (:div :id "main-container"
            :class "main-holder"
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
            (:div :class "main-holder"
                  (:h1 "Copyright &copy; 2010"
                       (:a :href "http://membase.com" "Membase, Inc."))))))) 

(define-cssoutput console
  (("html, body, div, span, applet, object, iframe,
    h1, h2, h3, p, blockquote pre,
    a, code, em, font, img,
    small, strike, strong,
    b, u, i, center,
    dl, dt, dd, ol, ul, li, form, label,
    table, tr, th, td")
   (:margin 0
    :padding 0
    :border 0
    :outline 0
    :vertical-align "baseline"
    :background "transparent"))

  ((b) (:font-weight "normal"))

  ((body) (:background "url('images/background.png') repeat-x"))

  ;;
  ;; containers
  ;;
  (("#container") (:background-color "#fff"
                   :position "absolute"
                   :width "100%"
                   :min-width "960px"
                   :min-height "100%"))

  (("#main-container") (:position "relative"
                        :width "960px"
                        ;:left "12%"
                        :margin-top "55px"
                        :padding "0 0 220px 0"
                        ))

  ((.cnt-holder) (:width "960px"
                  ;:left "12%"
                  :position "relative"))

  ((.main-holder) (:width "960px" :position "relative" :left "0px !important"))

  ;;
  ;; header
  ;;
  ((.page-header)
   (:background "url('images/ns_console_headerbg.png') repeat-x"
    :height "100px" ;:left "12%"
    ))

  ((.page-header span)
   (:position "absolute"
    :background "url('images/ns_console_logov2.png') no-repeat"
    :width "361px"
    :height "49px"
    :top "35px"
    :left 0))

  ((.topper-nav) (:float "right" :font-size "11px" :padding "15px 0 0 0"))
  ((.topper-nav a) (:color "#e3e8ea !important" :text-decoration "none"))
  ((.topper-nav b) (:margin "0 2px" :color "#848f96" :font-weight "bolder"))

  ;;
  ;; footer
  ;;
  ((.page-footer) (:position "absolute"
                   :background "url('images/ns_console_footer.png') repeat-x"
                   :width "100%"
                   :height "208px"
                   :bottom 0))

  ((.page-footer h1) (:text-transform "none"
                      :padding-top "32px"
                      ;:margin-left "12%"
                      :font-family "Verdana"
                      :font-weight "normal"
                      :font-size "11pt"
                      :color "#97979A"))

  ((.page-footer a) (:color "#00A6DE" :text-decoration "none"))

  ;;
  ;; server display
  ;;

  )
