(define (%cpu-bits) #f)

(define (%byte-order) #f)

(define (os-name)
  (java.lang.System:getProperty "os.name"))
