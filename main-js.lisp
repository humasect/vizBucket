(in-package :vizbucket)

(defun main-js (stream)
  (ps-to-stream* stream
    `(progn

       (var *show-dead* t)
       (var *refresh-ms* 300)
       (var *info-ms* 3000)
       (var *image-size* 192)
       (var *image-outset* 16)

       (defun request-json (method successf failuref)
         (let ((url (concatenate 'string
               "http://" (chain window location host) "/bucket/" method)))
           ((chain $ ajax)
            (create url url
                    success (lambda (data text-status req)
                              (var object null)
                              (try (setf object ((chain *json* parse) data))
                                   (:catch (err)
                                     (progn
                                       (clogf err ": " data)
                                       (var do-alert t)
                                       (if failuref
                                           (setf do-alert (failuref err)))
                                       (if do-alert
    (alert (concatenate 'string err ": request '" url "' failed: " data))))))
                              (if (not (chain object error))
                                  (successf object))
                              )))))
       
       (defun start-main ()
         (request-json
          "vinfo"
          (lambda (d)
            ((chain ($ "#loading") html) "")
            (add-servers (chain d "vBucketServerMap" "serverList"))
            ;; poll for changes
            (if *server-polling* (set-timeout start-main *info-ms*))
            (return)
            )
          (lambda (d)
            ((chain ($ "#loading") html)
             (concatenate 'string "Failed to load: " d))))

         (setprop *screen* fill-style "blue")
         (layer-render *screen*))

       (var *servers-need-update* f)
       (var *server-polling* t)
       (var *servers* (array))
       
       (defun add-servers (lst)
         (if (not lst) return)

         (clog lst)
         (var ips (_ map *servers* (lambda (s) (chain s "server"))))
         (var sames (_ intersect lst ips))
         (if (or *servers-need-update*
                 (and (= (length ips) (length sames))
                      (= (length lst) (length sames))))
             (return)
             (clog "Server list changed."))

         ;; remove old servers display
         (stop-polling)
         ;(setf *server-polling* t)
         (setf *servers* (array))

         ;; reset views

         ;; add server icons and images

         (setf *servers-need-update* f)
         (return))

       (defun stop-polling ()
         (setf *server-polling* f)
         (_ each *servers* (lambda (s)
                   (setprop s polling f)
                   (clear-timeout (chain s pid)))))

       )))


