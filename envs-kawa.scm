(define (%cpu-bits)
  (string->number (java.lang.System:getProperty "sun.arch.data.model")))

(define (%byte-order) #f)

(define (os-name)
  (java.lang.System:getProperty "os.name"))
