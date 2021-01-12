#lang racket/base

(require racket/port
         "place.rkt")

(provide ev)

(define ns (make-base-namespace))
(start-evaluator-place)

(define (ev s)
  (displayln s)
  (define res
    (parameterize ([current-namespace ns])
      (eval (read (open-input-string s)))))
  (call-with-output-bytes
   (lambda (out)
     (write res out))))
