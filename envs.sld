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
     (include "envs-portable.scm")
     (include "chibi-envs.scm"))))
