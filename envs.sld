(define-library (envs)
  (export environment-stack
          environment-computer
          environment-computer?
          environment-os
          environment-os?)
  (import (scheme base)
          (scheme cxr)
          (scheme file)
          (scheme read)
          (scheme write))
  (cond-expand
    (chibi
     (import (srfi 69) (srfi 130))
     (include-shared "chibi-envs")
     (include "chibi-envs.scm")
     (include "envs-portable.scm"))
    (gauche
     (import (srfi 112))
     (include "envs-gauche.scm")
     (include "envs-portable.scm"))
    (kawa
     (include "envs-kawa.scm")
     (include "envs-portable.scm"))))
