#lang racket/base

(require racket/place)

(provide
 start-evaluator-place)

(define (start-evaluator-place)
  (place ch
    (define ns (make-base-namespace))
    (let loop ()
      (parameterize ([current-namespace ns])
        (eval '(+ 1 2)))
      (sleep 0.05)
      (loop))))
