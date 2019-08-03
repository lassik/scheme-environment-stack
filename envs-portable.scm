(define (string-index s ch)
  (let ((n (string-length s)))
    (let loop ((i 0))
      (cond ((= i n) #f)
            ((char=? (string-ref s i) ch) i)
            (else (loop (+ i 1)))))))

;;

(define (without-quotes s)
  (let ((n (string-length s)))
    (if (and (>= n 2)
             (char=? #\" (string-ref s 0))
             (char=? #\" (string-ref s (- n 1))))
        (substring s 1 (- n 1))
        s)))

(define (parse-os-release-file filename)
  (with-input-from-file filename
    (lambda ()
      (let loop ((fields '()))
        (let ((line (read-line)))
          (if (eof-object? line)
              fields
              (let ((pivot (string-index line #\=)))
                (loop
                 (if (not pivot)
                     fields
                     (append
                      fields
                      (list (cons (substring line 0 pivot)
                                  (without-quotes
                                   (substring line (+ pivot 1)))))))))))))))

(define (generate-computer uname-m)
  `(computer (architecture . ,uname-m)
             (cpu-bits . ,(%cpu-bits))
             (byte-order . ,(case (%byte-order)
                              ((0) 'little-endian)
                              ((1) 'big-endian)
                              (else 'mixed-endian)))))

(define (generate-os-linux)
  `(os (family . "Linux")
       ,@(let ((os-release (parse-os-release-file "/etc/os-release")))
           (let ((pair (assoc "NAME" os-release)))
             (if (not pair) '() `((name . ,(cdr pair))))))))

(define (generate-sub-scheme-stack/uname)
  (let ((s (os-name))
        (r (os-version))
        (m (cpu-architecture)))
    (cond ((equal? "Darwin" s)
           `((os (name "MacOS"))
             ,(generate-computer m)))
          ((equal? "DragonFly" s) "DragonFly BSD")
          ((equal? "FreeBSD" s) "FreeBSD")
          ((or (equal? "Linux" s) (equal? "GNU/Linux" s))
           `(,(generate-os-linux)
             ,(generate-computer m)))
          ((equal? "Android" s) "Android")
          ((equal? "NetBSD" s) "NetBSD")
          ((equal? "OpenBSD" s)
           `((os (name "OpenBSD"))
             ,(generate-computer m)))
          ((string-prefix? "SunOS" s) "Solaris")
          ((string-prefix? "CYGWIN_NT-" s) "Windows")
          ((string-prefix? "MINGW" s) "Windows")
          ((string-prefix? "MSYS_NT-" s) "Windows")
          (else '()))))

(define (generate-sub-scheme-stack/java)
  (cond-expand
    (kawa
     (append `((language-implementation
                (language . java)
                (language-version . ,(java.lang.System:getProperty
                                    "java.specification.version"))
                (version . ,(java.lang.System:getProperty
                             "java.vm.version")))
               (language-vm
                (vendor . ,(java.lang.System:getProperty "java.vendor"))))
             (let ((s (java.lang.System:getProperty "os.name")))
               (cond ((equal? "Mac OS X" s)
                      `((os (name . "MacOS"))))
                     (else '())))))
    (else #f)))

(define (generate-sub-scheme-stack)
  (or (generate-sub-scheme-stack/java)
      (generate-sub-scheme-stack/uname)))

;;

(define (generate-scheme-env)
  `(language-implementation
    (language . scheme)
    ,@(cond-expand
        (chibi
         `((implementation . "Chibi-Scheme")))
        (gauche
         `((implementation . "Gauche")
           (version . ,(implementation-version))))
        (kawa
         `((implementation . "Kawa")
           (version . ,(scheme-implementation-version)))))))

;;

(define stack #f)

(define (environment-stack)
  (set! stack (or stack (cons (generate-scheme-env)
                              (generate-sub-scheme-stack))))
  stack)

;;

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
