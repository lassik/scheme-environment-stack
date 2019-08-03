(define (string-index s ch)
  (let ((n (string-length s)))
    (let loop ((i 0))
      (cond ((= i n) #f)
            ((char=? (string-ref s i) ch) i)
            (else (loop (+ i 1)))))))

;;;

(define stack #f)

(define os-release-filename "/etc/os-release")

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
                                  (substring line (+ pivot 1))))))))))))))

(define (generate-computer uname-m)
  `(computer (architecture . ,uname-m)
             (cpu-bits ,(%cpu-bits))
             (byte-order ,(case (%byte-order)
                            ((0) 'little-endian)
                            ((1) 'big-endian)
                            (else 'mixed-endian)))))

(define (generate-stack)
  (let ((s (%uname-sysname))
        (r (%uname-release))
        (m (%uname-machine)))
    (cond ((equal? "Darwin" s)
           `(,(generate-computer m)
             (os "MacOS")))
          ((equal? "DragonFly") "DragonFly BSD")
          ((equal? "FreeBSD" s) "FreeBSD")
          ((or (equal? "Linux" s) (equal? "GNU/Linux" s))
           `(,(generate-computer m)
             (os (family "Linux"))))
          ((equal? "Android" s) "Android")
          ((equal? "NetBSD" s) "NetBSD")
          ((equal? "OpenBSD" s)
           `(,(generate-computer m)
             (os (name "OpenBSD"))))
          ((string-prefix? "CYGWIN_NT-" s) "Windows")
          ((string-prefix? "MINGW" s) "Windows")
          ((string-prefix? "MSYS_NT-" s) "Windows"))))

(define (envs)
  (generate-stack))

(define (writeln x)
  (write x)
  (newline))

(define (test)
  (for-each (lambda (fields)
              (for-each writeln fields)
              (newline))
            (map parse-os-release-file
                 '("os-release_alpine"
                   "os-release_debian"
                   "os-release_void"))))
