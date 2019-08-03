(define (environment-computer? env)
  (eqv? 'computer (car env)))

(define (environment-os? env)
  (eqv? 'os (car env)))

;;

(define (environment-find match? stack)
  (cond ((null? stack) #f)
        ((match? (car stack)) (car stack))
        (else (environment-find match? (cdr stack)))))

(define (environment-computer)
  (environment-find environment-computer? (environment-stack)))

(define (environment-os)
  (environment-find environment-os? (environment-stack)))
