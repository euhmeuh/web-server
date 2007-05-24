(module add-param (lib "newcont.ss" "newcont")
  (require (lib "url.ss" "net")
           (lib "servlet-helpers.ss" "web-server" "private"))
  (provide start)
    
  (define msg (make-parameter "unknown"))
  
  (define (gn)
    (printf "gn ~a~n" (msg))
    (let* ([req
            (send/suspend/url
             (lambda (k-url)
               (printf "ssu ~S~n" (msg))
               `(hmtl (head (title ,(format "Get ~a number" (msg))))
                      (body
                       (form ([action ,(url->string k-url)]
                              [method "post"]
                              [enctype "application/x-www-form-urlencoded"])
                             ,(format "Enter the ~a number to add: " (msg))
                             (input ([type "text"] [name "number"] [value ""]))
                             (input ([type "submit"])))))))]
           [num (string->number
                 (extract-binding/single
                  'number
                  (request-bindings req)))])
      (printf "gn ~a ~a~n" (msg) num)
      num))
  
  (define (start initial-request)
    (printf "after s-s~n")
    `(html (head (title "Final Page"))
           (body
            (h1 "Final Page")
            (p ,(format "The answer is ~a"
                        (+ (parameterize ([msg "first"])
                             (gn))
                           (parameterize ([msg "second"])
                             (gn)))))))))