#lang racket
(require racket/gui)

; Names of Players
(define name1 "Player1")
(define name2 "Player2")

; Reading previous highscore from a file high-score
(define high "")
(define in (open-input-file "/home/ankit/project/high-score.txt"
                            #:mode 'binary))
(file-position in 0)
(define prev-highscore (read in))
(close-input-port in)

; Creating user interface menu
(define welcome (new frame%
                     [label "Welcome to Othello Masters"]
                     [min-width 600]
                     [min-height 80]
                     [stretchable-width #f]
                     [stretchable-height #f]))

(define rowpanel (new vertical-panel%
                      [parent welcome]
                      [alignment '(center bottom)]
                      [vert-margin 30]
                      [horiz-margin 50]
                      [spacing 10]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define single (new frame%
                    [label "Single Player"]
                    [min-width 600]
                    [min-height 100]
                    [stretchable-width #f]
                    [stretchable-height #f]))

(define pl (new text-field%
                [label "Player name: "]
                [parent single]
                [vert-margin 10]
                [init-value ""]
                [enabled #t]
                [min-width 200]
                [stretchable-width #f]
                [stretchable-height #f]))

;;;;;;;;;;Checkboxes for choosing whether cpu plays first or second;;;;;;;;;;;;;;
(define black1 (new check-box% [parent single]
                    [label "Player 1"]
                    [value #t]
                    [callback (lambda (checkbox event)
                                (cond [(send checkbox get-value) (begin
                                                                   (set! state -1)
                                                                   (send white1 set-value #f))]
                                      [else (begin
                                              (set! state -1)
                                              (send black1 set-value #t))]
                                      ))]))

(define white1 (new check-box% [parent single]
                    [label "Player 2"]
                    [callback (lambda (checkbox event)
                                (cond [(send checkbox get-value) (begin
                                                                   (set! state 1)
                                                                   (send black1 set-value #f))]
                                      [else (begin
                                              (set! state 1)
                                              (send white1 set-value #t))]))]))

(define rowpanel-single (new horizontal-panel%
                             [parent single]
                             [alignment '(right bottom)]
                             [horiz-margin 20]
                             [spacing 25]))

;;;;;single-player window call button;;;;;;;;;;
(define ok1 (new button%
                 [label "OK"]
                 [parent rowpanel-single]
                 [min-width 50]
                 [min-height 30]
                 [callback (lambda (button event) (begin
                                                    (set! name1 (send pl get-value))
                                                    (cond [(eq? "" name1) (set! name1 "Player")])
                                                    (send single on-exit)
                                                    (send pl set-value "")
                                                    (set! num-players 1)
                                                    (define str
                                                      (string-append "Highscore : "
                                                                     (number->string (car prev-highscore))
                                                                     "-"
                                                                     (number->string (cdr prev-highscore))))
                                                    (send highscore-msg set-label str)
                                                    (send frame show #t)
                                                    ))]))

(define cancel1 (new button%
                     [label "Cancel"]
                     [parent rowpanel-single]
                     [min-width 50]
                     [min-height 30]
                     [callback (lambda (button event) (begin
                                                        (send single on-exit)
                                                        (send pl set-value "")))]))

(define single-player (new button%
                           [label "Single Player"]
                           [parent rowpanel]
                           [min-width 250]
                           [min-height 50]
                           [callback (lambda (button event) (send single show #t))]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define double (new frame%
                    [label "Double Player"]
                    [min-width 600]
                    [min-height 80]
                    [stretchable-width #f]
                    [stretchable-height #f]))

(define pl1 (new text-field%
                 [label "Player 1 name: "]
                 [parent double]
                 [vert-margin 5]
                 [init-value ""]
                 [enabled #t]
                 [min-width 200]
                 [stretchable-width #f]
                 [stretchable-height #f]))

(define pl2 (new text-field%
                 [label "Player 2 name: "]
                 [parent double]
                 [vert-margin 5]
                 [init-value ""]
                 [enabled #t]
                 [min-width 200]
                 [stretchable-width #f]
                 [stretchable-height #f]))

(define rowpanel-double (new horizontal-panel%
                             [parent double]
                             [alignment '(right bottom)]
                             [horiz-margin 20]
                             [spacing 25]))

;;;;;;;;;;;;;Double player window call button;;;;;;;;;;
(define ok2 (new button%
                 [label "OK"]
                 [parent rowpanel-double]
                 [min-width 50]
                 [min-height 30]
                 [callback (lambda (button event) (begin
                                                    (set! name1 (send pl1 get-value))
                                                    (set! name2 (send pl2 get-value))
                                                    (cond [(eq? "" name1) (set! name1 "Player1")])
                                                    (cond [(eq? "" name2) (set! name2 "Player2")])
                                                    (send double on-exit)
                                                    (send pl1 set-value "")
                                                    (send pl2 set-value "")
                                                    (send welcome on-exit)
                                                    (set! num-players 2)
                                                    (send highscore-msg set-label "")
                                                    (send frame show #t)
                                                    ))]))

(define cancel2 (new button%
                     [label "Cancel"]
                     [parent rowpanel-double]
                     [min-width 50]
                     [min-height 30]
                     [callback (lambda (button event) (begin
                                                        (send double on-exit)
                                                        (send pl1 set-value "")
                                                        (send pl2 set-value "")))]))

(define double-player (new button%
                           [label "Double Player"]
                           [parent rowpanel]
                           [min-width 250]
                           [min-height 50]
                           [callback (lambda (button event) (send double show #t))]))

;;;;;;;;;;;;;;Imported photos in Learn How to Play window;;;;;;;;;;;;;;;;
(define learn (new frame%
                   [label "Learn How to Play!"]
                   [min-width 600]
                   [min-height 630]
                   [stretchable-width #t]
                   [stretchable-height #t]))
(define (pics url-path)
  (read-bitmap (string->path url-path)))

(define setup (pics "/home/ankit/project/setup.jpg"))
(define gameplay (pics "/home/ankit/project/gameplay.jpg"))
(define validmoves (pics "/home/ankit/project/validmoves.jpg"))
(define endgame (pics "/home/ankit/project/endgame.jpg"))
(define photo setup)

(define learn-panel (new tab-panel%
                         [choices '("Setup" "Game-play" "Valid Moves" "End Game")]
                         [parent learn]
                         [stretchable-height #t]
                         [style '(no-border)]
                         [callback (lambda (b e) (begin (cond [(eq? (send b get-selection) 0) (send learn-msg set-label setup)]
                                                              [(eq? (send b get-selection) 1) (send learn-msg set-label gameplay)]
                                                              [(eq? (send b get-selection) 2) (send learn-msg set-label validmoves)]
                                                              [(eq? (send b get-selection) 3) (send learn-msg set-label endgame)])
                                                        (send learn-msg refresh)))]))

(define learn-msg (new message%
                       [parent learn-panel]
                       [label photo]
                       [stretchable-height #f]))

(define rowpanel-learn (new horizontal-panel%
                            [parent learn]
                            [alignment '(right bottom)]
                            [horiz-margin 20]
                            [stretchable-height #f]))

(define close1 (new button%
                    [label "Close"]
                    [parent rowpanel-learn]
                    [min-width 80]
                    [min-height 30]
                    [callback (lambda (button event) (send learn on-exit))]))

(define learn-to-play (new button%
                           [label "Learn How to Play"]
                           [parent rowpanel]
                           [min-width 200]
                           [min-height 50]
                           [callback (lambda (button event) (send learn show #t))]))

;;;;;;;;;;;;;;;;;;Imported photo in Credits window;;;;;;;;;;;;;;;;;;;;;
(define cred (new frame%
                  [label "Credits!!!"]
                  [min-width 600]
                  [min-height 80]
                  [stretchable-width #f]
                  [stretchable-height #f]))

(define credit-pic (pics "/home/ankit/project/credits.jpg"))
(define cred-msg (new message%
                      [parent cred]
                      [label credit-pic]))

(define rowpanel-credits (new horizontal-panel%
                              [parent cred]
                              [alignment '(right bottom)]
                              [horiz-margin 20]
                              [spacing 25]))

(define close2 (new button%
                    [label "Close"]
                    [parent rowpanel-credits]
                    [min-width 80]
                    [min-height 30]
                    [callback (lambda (button event) (send cred on-exit))]))

(define credits (new button%
                     [label "Credits"]
                     [parent rowpanel]
                     [min-width 150]
                     [min-height 50]
                     [callback (lambda (button event) (send cred show #t))]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define start (new frame%
                   [label "Welcome to Othello Masters"]
                   [min-width 600]
                   [min-height 400]
                   [stretchable-width #f]
                   [stretchable-height #f]))

(define othello-pic (pics "/home/ankit/project/othello.jpg"))

(define othello-msg (new message%
                         [parent start]
                         [label othello-pic]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define closemain (new button%
                       [label "Close"]
                       [parent rowpanel]
                       [min-width 80]
                       [min-height 30]
                       [callback (lambda (button event) (send welcome on-exit))]))

(send start show #t)
(sleep/yield 1)
(send start on-exit)
(send welcome show #t)

; GRAPHICS MODULE
(define frame-size 800)
(define bitmap-size 800)

; Make a 800 x 800 frame
(define frame (new frame% [label "Othello-playboard"]
                   [min-width frame-size]
                   [min-height frame-size]
                   [stretchable-width #t]))

; Make the drawing area with a paint callback
(define (gif x)
  (if(or (< x 0) (>= x 8))7
     x))


;;;;;;;;;;over-rides canvas%;;;;;;;;;
(define main-canvas%
  (class canvas%
    (define/override (on-event event)
      (let* ((x (gif (quotient (floor (send event get-x)) 100)))
             (y (gif (quotient (floor (send event get-y)) 100))))
        (if(not (game-end))   
           (begin (cond[(= -1 state) (send turn-double set-value name1)])
                  (cond[(and (or (= num-players 2) (= state -1)) (send event button-down?) (valid-block x y))
                        (begin (define t (make-2d-vector 8 8))
                               (traverse (lambda(i j) (2d-vector-set! t i j (2d-vector-ref board i j))))
                               (vector-set! board-list moves t)
                               (update-board x y)
                               (draw-board)  
                               (set! moves (+ moves 1))
                               (set! state (- 0 state))
                               (cond[(= num-players 2)(cond[(= -1 state) (send turn-double set-value name1)]
                                                           [else (send turn-double set-value name2)])]
                                    [(= num-players 1)(send turn-double set-value "cpu")])
                               (cond[(game-end)(begin (draw-board)(display-end1)(display-end2))]))]       
                       [(and (= state 1) (= num-players 1)) 
                        (begin (define posn (cpu-turn))
                               (update-board (car posn) (cdr posn))
                               (draw-board)
                               (set! state (- 0 state))
                               (send turn-double set-value name1)
                               (cond[(game-end)(begin (draw-board)(display-end1)(display-end2))]))]
                       [(and (or (= num-players 2) (= state -1)) (valid-block x y))
                        (begin (draw-board)
                               (highlight x y))]
                       [else (draw-board)]))
           (display-end1))))
    (super-new))) 


(define (highlight a b)
  (let*([diameter 50]
        [x (- (+ (* 100 a) 50) (/ diameter 2))]
        [y (- (+ (* 100 b) 50) (/ diameter 2))])
    (if (= state -1)
        (begin
          (send bm-dc set-pen dsg-pen)
          (send bm-dc set-brush dsg-brush)
          (send bm-dc draw-ellipse x y diameter diameter))
        (begin
          (send bm-dc set-brush msg-brush)
          (send bm-dc set-pen msg-pen)
          (send bm-dc draw-ellipse x y diameter diameter)))))

(define top-double (new horizontal-panel%
                        [parent frame]
                        [alignment '(left top)]
                        [horiz-margin 10]
                        [min-height 40]
                        [stretchable-height #t]
                        [stretchable-width #t]
                        [spacing 25]))

(define canvas
  (new main-canvas% [parent top-double]
       [paint-callback
        (lambda (canvas dc) (paint dc))]
       [min-width 800]
       [stretchable-width #t]))

(define column-double
  (new vertical-panel%
       [parent top-double]
       [alignment '(left top)]
       [min-width 10]
       [stretchable-width #f]))

(define undo-double (new button%
                         [label "Undo"]
                         [parent column-double]
                         [min-width 80]
                         [min-height 35]
                         [callback (lambda (button event)  (define (undo)
                                                             (cond[(and (> moves 0) (= num-players 2))(set! state (- 0 state))])
                                                             (cond
                                                               [(> moves 0)(set! moves (- moves 1))
                                                                           (set! board (vector-ref board-list moves))]))(undo)(draw-board))]))


(define turn-double (new text-field%
                         [label "Turn: "]
                         [parent column-double]
                         [vert-margin 10]
                         [horiz-margin 5]
                         [init-value name1]
                         [enabled #f]
                         [min-width 100]
                         [stretchable-width #f]
                         [stretchable-height #f]))

(define retry-double (new button%
                          [label "Back to Main Menu"]
                          [parent column-double]
                          [min-width 80]
                          [min-height 35]
                          [callback (lambda (button event) (begin
                                                             (send frame on-exit)
                                                             (initial-board)
                                                             (set! state -1)
                                                             (send welcome show #t)
                                                             (set! num-players 0)))]));;;;;;;;;;;;;;;;;;;;;

(define highscore-msg
  (new message%
       [parent column-double]
       [label ""]))

; Function to display board after game ends
(define dialog
  (new dialog%
       [label "Results"]
       [parent frame]
       [width 300]
       [height 100]
       [stretchable-height #t]
       [alignment '(center bottom)]))

(define msg (new message%
                 [label ""]
                 [parent dialog]
                 [vert-margin 50]	 
                 [horiz-margin 75]
                 [stretchable-width #t]	 
                 [stretchable-height #f]))

(define new-game (new button%
                      [label "Back to Main Menu"]
                      [parent dialog]
                      [min-width 100]
                      [min-height 40]
                      [callback (lambda (button event) (begin
                                                         (send frame on-exit)
                                                         (initial-board)
                                                         (send black1 set-value #t)
                                                         (send white1 set-value #f)
                                                         (set! state -1)
                                                         (send dialog on-exit)
                                                         (send welcome show #t)
                                                         (set! num-players 0)))]))

(define exit (new button%
                  [label "Exit"]
                  [parent dialog]
                  [min-width 60]
                  [min-height 25]
                  [callback (lambda (button event) (send frame on-exit)
                              (send dialog on-exit)
                              (send welcome on-exit)
                              (set! num-players 0))]))

; Fuctions to display end result
(define (display-end1)
  (send bm-dc set-brush tblack-brush)
  (send bm-dc set-pen tblack-pen)
  (send bm-dc draw-rectangle 0 0 800 800))

(define (display-end2)
  (let*[(counts (count))
        (black-count (car counts))
        (white-count (cdr counts))]
    (cond ((= num-players 0) (cond ((> black-count white-count)
                                    (send msg set-label "     Greedy algorithm wins"))
                                   ((= black-count white-count)
                                    (send msg set-label "      Game tied"))
                                   (else (send msg set-label "           Cpu wins"))))
          ((= black-count white-count) (send msg set-label (string-append  "No. of black discs :   " (number->string black-count)
                                                                           "\n" "No. of white discs :   " (number->string white-count) "\n" "              Game Tied")))
          ((= num-players 2)
           (if (> black-count white-count)
               (send msg set-label (string-append  "No. of black discs :   " (number->string black-count)
                                                   "\n" "No. of white discs :   " (number->string white-count) "\n" "            " name1 "   wins"))
               (send msg set-label (string-append "No. of black discs :    " (number->string black-count)
                                                  "\n" "No. of white discs :   " (number->string white-count) "\n" "             " name2 "   wins"))))
          (else (if (> black-count white-count)
                    (send msg set-label (string-append "No. of black discs :   " (number->string black-count)
                                                       "\n" "No. of white discs :   " (number->string white-count) "\n" "               You win"))
                    (send msg set-label (string-append "No. of black discs :   " (number->string black-count)
                                                       "\n" "No. of white discs :   " (number->string white-count) "\n" "                You lose")))))
    (define out (open-output-file "/home/ankit/project/high-score.txt"
                                  #:mode 'binary
                                  #:exists 'replace))
    (cond [(= num-players 2) (set! high "")]
          [(= num-players 1) (if (and (> (car counts) (cdr counts))
                                      (< (car prev-highscore) (car counts)))
                                 (begin (set! prev-highscore counts)
                                        (write counts out))
                                 (write prev-highscore out))])
    (close-output-port out))
  (send dialog show #t)
  (send dialog on-exit))

(define (paint dc) (send dc draw-bitmap face-bitmap 0 0))

; Create a bitmap
(define face-bitmap (make-object bitmap% bitmap-size bitmap-size ))
; Create a drawing context for the bitmap
(define bm-dc (make-object bitmap-dc% face-bitmap))
; A bitmap's initial content is undefined; clear it before drawing
(send bm-dc clear)
; Make some colors
(define dsg (make-color 31 93 58))
(define tblack (make-color 0 0 0 0.5))

; Make some pens and brushes
(define tblack-brush (make-object brush% tblack 'solid))
(define tblack-pen (make-object pen% tblack 1 'solid))
(define black-pen (make-object pen% "BLACK" 1 'solid))
(define black-brush (make-object brush% "BLACK" 'solid))
(define white-brush (make-object brush% "WHITE" 'solid))
(define white-pen (make-object pen% "WHITE" 1 'solid))
(define dsg-brush (make-object brush% dsg 'solid))
(define dsg-pen (make-object pen% dsg 1 'solid))
(define msg-brush (make-object brush% "MEDIUMSEAGREEN" 'solid))
(define msg-pen (make-object pen% "MEDIUMSEAGREEN" 1 'solid))
(define green-brush (make-object brush% "SEAGREEN" 'solid))


;  draw the current board
(define (draw-board)
  (begin
    (send bm-dc clear)
    (send bm-dc set-pen white-pen)
    (send bm-dc set-brush green-brush)
    (map (lambda (x) (map (lambda(y) (send bm-dc draw-rectangle (* 100 x) (* 100 y) 100 100)) (range 8))) (range 8))
    
    (define (h i j)
      (let*([diameter 50]
            [x (- (+ (* 100 i) 50) (/ diameter 2))]
            [y (- (+ (* 100 j) 50) (/ diameter 2))]
            [d (2d-vector-ref board i j)]
            [t (square-disc d)])
        (cond[(= t 1)(begin
                       (send bm-dc set-brush white-brush)
                       (send bm-dc set-pen white-pen)
                       (send bm-dc draw-ellipse x y diameter diameter))]
             [(= t -1)(begin
                        (send bm-dc set-brush black-brush)
                        (send bm-dc set-pen black-pen)
                        (send bm-dc draw-ellipse x y diameter diameter))])))
    (traverse h)
    
    (send canvas refresh)))

; End of the GRAPHICS MODULE

; SYNTAX DEFINITIONS

(define-syntax  lc (syntax-rules (: <- @)
                     [(lc expr : var <- drawn-from) (map (lambda (var) expr) drawn-from)]
                     [(lc expr : @ guard) (if guard (list expr) `())]
                     [(lc expr : @ guard qualifier ...)
                      (append* (lc (lc expr : qualifier ...) : @ guard))] [(lc expr : var <- drawn-from qualifier ...)
                                                                           (append* (lc (lc expr : qualifier ... ) : var <- drawn-from))]))

(define-syntax while
  (syntax-rules ()
    [(while bool-exp body ...)(begin
                                (define (while-loop)
                                  (when bool-exp (begin body ... (while-loop))))
                                (while-loop))]))

(define (traverse function)
  (begin
    (define i 0)
    (while (< i 8)
           (define j 0)
           (while (< j 8) (begin (function i j) (set! j (+ j 1))))
           (set! i (+ 1 i)))))

(define (make-2d-vector r c)
  (build-vector r (lambda (x) (make-vector c (square 0 0)))))

(define (2d-vector-ref vec r c)
  (vector-ref (vector-ref vec r) c))

(define (2d-vector-set! vec r c val)
  (let ((v (vector-ref vec r)))
    (begin
      (vector-set! v c val) (vector-set! vec r v))))

; End of SYNTAX DEFINITIONS

; State of the game determines the turn. First turn is black.
(define state -1)
(define cpuwin 0)
(define greedywin 0)
(define draw 0)
(define num-players 0)
(define moves 0)
(struct square (disc weight) #:transparent #:mutable)
(define board (make-2d-vector 8 8))
(define board-list (make-vector 61 #f))

; Functions to allocate weights
(define (initial-weight x y)
  (let[(a (abs (- x 3.5)))
       (b (abs (- y 3.5)))]
    (cond[(and (= a 3.5)(= b 3.5))40]
         [(and (= a 2.5)(= b 2.5))-4]
         [(= a b)1]
         [(= 6 (+ a b))-3]
         [(or (= 3.5 a)(= 3.5 b))2]
         [(or (= 2.5 a)(= 2.5 b))-1]
         [else 0])))

(define (dynamic-weight x y)
  (* moves (increase-in-discs x y) 0.001)) 


; Function to initialise board
(define (initial-board)
  (traverse (lambda (i j)
              (2d-vector-set! board i j (square 0 (initial-weight i j)))))
  (2d-vector-set! board 3 3 (square 1 (initial-weight 3 3)))
  (2d-vector-set! board 3 4 (square -1 (initial-weight 3 4)))
  (2d-vector-set! board 4 3 (square -1 (initial-weight 4 3)))
  (2d-vector-set! board 4 4 (square 1 (initial-weight 4 4)))
  (set! moves 0))

; Function to count the number of black and white discs
(define (count)
  (define black-count 0)
  (define white-count 0)
  (traverse (lambda (i j)
              (let[(s (square-disc (2d-vector-ref board i j)))]
                (cond[(= s 1)(set! white-count (+ 1 white-count))]
                     [(= s -1)(set! black-count (+ 1 black-count))]))))
  (cons black-count white-count))

; Function to determine cpu's turn
(define (cpu-turn)
  (let[(vbl (valid-blocks-list))]
    (map (lambda (posn)
           (let[(x (car posn))
                (y (cdr posn))]
             (2d-vector-set! board x y (square (square-disc (2d-vector-ref board x y))  (+ (dynamic-weight x y) (initial-weight x y))))))
         vbl)
    (foldr (lambda(a b) (let[(c (square-weight (2d-vector-ref board (car a) (cdr a))))
                             (d (square-weight (2d-vector-ref board (car b) (cdr b))))]
                          (if(= c d)(rand a b)
                             (if(> c d)a b)))) (car vbl) (cdr vbl))))

; Function to check validity of a block along ai+ bj
(define (valid-block-dir x y a b)
  (define k 1)
  (define prod 1)
  (define x1 (+ x a))
  (define y1 (+ y b)) 
  (while (and (> prod 0) (>= x1 0) (< x1 8) (>= y1 0) (< y1 8))           
         (begin (set! prod (* prod -1 state (square-disc (2d-vector-ref board x1 y1))))
                (set! k (+ k 1))
                (set! x1 (+ x (* a k)))
                (set! y1 (+ y (* b k)))))
  (if(and (> k 2) (< prod 0))(cons (- x1 a) (- y1 b))
     #f))

; Functions to check validity of a block along all eight possible directions
(define (valid-block-s x y)
  (valid-block-dir x y 0 1))

(define (valid-block-n x y)
  (valid-block-dir x y 0 -1))

(define (valid-block-e x y)
  (valid-block-dir x y 1 0))

(define (valid-block-w x y)
  (valid-block-dir x y -1 0))

(define (valid-block-se x y)
  (valid-block-dir x y 1 1))

(define (valid-block-sw x y)
  (valid-block-dir x y -1 1))

(define (valid-block-ne x y)
  (valid-block-dir x y 1 -1))

(define (valid-block-nw x y)
  (valid-block-dir x y -1 -1))

; Function to check validity of a block
(define (valid-block x y)
  (let[(block (2d-vector-ref board x y))]
    (if (not (= (square-disc block) 0))#f
        (not (and (boolean? (valid-block-n x y))
                  (boolean? (valid-block-s x y))
                  (boolean? (valid-block-e x y))
                  (boolean? (valid-block-w x y))
                  (boolean? (valid-block-ne x y))
                  (boolean? (valid-block-nw x y))
                  (boolean? (valid-block-sw x y))
                  (boolean? (valid-block-se x y)))))))

; Function which returns the list of positions of valid blocks
(define (valid-blocks-list)
  (lc (cons x y): x <- (range 8) y <- (range 8) @ (valid-block x y)))

; Function which updates the discs and weights on the board
(define (update-board a b)
  (let[(n (valid-block-n a b))
       (s (valid-block-s a b))
       (e (valid-block-e a b))
       (w (valid-block-w a b))
       (nw (valid-block-nw a b))
       (ne (valid-block-ne a b))
       (sw (valid-block-sw a b))
       (se (valid-block-se a b))]
    (begin
      (cond[(not (boolean? s))(begin (define i a) (define j b) (while (< j (cdr s)) (begin (2d-vector-set! board i j (square state (square-weight (2d-vector-ref board i j)))) (set! j (+ j 1)))))])
      (cond[(not (boolean? n))(begin (define i a) (define j b) (while (> j (cdr n)) (begin (2d-vector-set! board i j (square state (square-weight (2d-vector-ref board i j)))) (set! j (- j 1)))))])
      (cond[(not (boolean? e))(begin (define i a) (define j b) (while (< i (car e)) (begin (2d-vector-set! board i j (square state (square-weight (2d-vector-ref board i j)))) (set! i (+ i 1)))))])
      (cond[(not (boolean? w))(begin (define i a) (define j b) (while (> i (car w)) (begin (2d-vector-set! board i j (square state (square-weight (2d-vector-ref board i j)))) (set! i (- i 1)))))])
      (cond[(not (boolean? se))(begin (define i a) (define j b) (while (< j (cdr se)) (begin (2d-vector-set! board i j (square state (square-weight (2d-vector-ref board i j)))) (set! j (+ j 1)) (set! i (+ i 1)))))])
      (cond[(not (boolean? sw))(begin (define i a) (define j b) (while (< j (cdr sw)) (begin (2d-vector-set! board i j (square state (square-weight (2d-vector-ref board i j)))) (set! j (+ j 1)) (set! i (- i 1)))))])
      (cond[(not (boolean? nw))(begin (define i a) (define j b) (while (> j (cdr nw)) (begin (2d-vector-set! board i j (square state (square-weight (2d-vector-ref board i j)))) (set! j (- j 1)) (set! i (- i 1)))))])
      (cond[(not (boolean? ne))(begin (define i a) (define j b) (while (> j (cdr ne)) (begin (2d-vector-set! board i j (square state (square-weight (2d-vector-ref board i j)))) (set! j (- j 1)) (set! i (+ i 1)))))])
      )))

; Function to check the terminating condition
(define (game-end)
  (cond[(null? (valid-blocks-list)) (set! state (- 0 state))])
  (null? (valid-blocks-list)))

;Function to implement greedy algorithm
(define (greedy-algorithm-player-turn)
  (let[(vbl (valid-blocks-list))]
    (foldr (lambda(a b) (let[(x (increase-in-discs  (car a) (cdr a)))
                             (y (increase-in-discs  (car b) (cdr b)))]
                          (if(= x y)(rand a b)
                             (if (> x y)a b)))) (car vbl) (cdr vbl))))
; Initialises the board
(initial-board)

;Function to test our algorithm against greedy algorithm
(define (testing)
  (if(game-end)
     (begin
       (let*[(c (count))
             (bl (car c))
             (wh (cdr c))]
         (cond[(< bl wh)(set! cpuwin (+ cpuwin 1))]
              [(= bl wh)(set! draw (+ draw 1))]
              [(> bl wh)(set! greedywin (+ greedywin 1))]))
       (initial-board))
     (if(= state -1)
        (let[(c1 (greedy-algorithm-player-turn))]
          (begin (update-board (car c1) (cdr c1))
                 (set! state (- 0 state))
                 (set! moves (+ moves 1))
                 (testing)))  
        (let[(c2 (cpu-turn))]
          (begin (update-board (car c2) (cdr c2))
                 (set! state (- 0 state))
                 (set! moves (+ moves 1))
                 (testing))))))

; Function to display a sample run
(define (testrun)
  (set! num-players 0)
  (initial-board)
  (send frame show #t)
  (define (tester)
    (if(game-end)
       (begin
         (let*[(c (count))
               (bl (car c))
               (wh (cdr c))]
           (cond[(< bl wh)(set! cpuwin (+ cpuwin 1))]
                [(= bl wh)(set! draw (+ draw 1))]
                [(> bl wh)(set! greedywin (+ greedywin 1))]))
         (display-end1) (display-end2)
         (initial-board))
       (if(= state -1)
          (let[(c1 (greedy-algorithm-player-turn))]
            (begin (update-board (car c1) (cdr c1))
                   (set! state (- 0 state))
                   (draw-board)
                   (sleep/yield 0.2)
                   (set! moves (+ moves 1))
                   (tester)))  
          (let[(c2 (cpu-turn))]
            (begin (update-board (car c2) (cdr c2))
                   (draw-board)
                   (set! state (- 0 state))
                   (sleep/yield 0.2)
                   (set! moves (+ moves 1))
                   (tester))))))
  (tester))

; Test the algorithm n times
(define (test n)
  (cond [(= n 0)(begin0 (list cpuwin draw greedywin)(set! moves 0)(set! cpuwin 0)(set! greedywin 0)(set! draw 0))]
        [(> n 0)(testing)(test (- n 1))]))

; Function to calculate the no. of discs that will be flipped by placing a disc on x y
(define (increase-in-discs x y)
  (+(id valid-block-n x y)
    (id valid-block-s x y)
    (id valid-block-w x y)
    (id valid-block-e x y)
    (id valid-block-nw x y)
    (id valid-block-ne x y)
    (id valid-block-sw x y)
    (id valid-block-se x y)))

; A higher order function which gives no. of discs flipped along different directions according to different f 
(define (id f x y)
  (let[(p (f x y))]
    (if(boolean? (f x y))0
       (- (max (abs (- x (car p))) (abs (- y (cdr p)))) 1))))

; Returns one of a and b randomly
(define (rand a b)
  (list-ref (list a b) (random 2)))

(draw-board)