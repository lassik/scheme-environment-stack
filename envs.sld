(define-library (envs)
  (export envs)
  (import (scheme base)
          (scheme cxr)
          (scheme file)
          (scheme read)
          (scheme write))
  (cond-expand
    (chibi
     (import (srfi 69) (srfi 130))
     (include-shared "chibi-envs")
     (include "chibi-envs.scm"))))
