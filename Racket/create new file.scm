#lang racket
(define out (open-output-file "/home/ankit/project/high-score.txt"
                        #:mode 'binary
                        #:exists 'replace))
(write (cons 0 0) out)
(close-output-port out)
;(with-output-to-file 