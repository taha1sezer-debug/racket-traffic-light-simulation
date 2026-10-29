;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |CMPE-100 PROJECT-2|) (read-case-sensitive #t) (teachpacks ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "gui.rkt" "teachpack" "htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "gui.rkt" "teachpack" "htdp")) #f)))
;CMPE-100 PROJECT-2
;TAHA SEZER [redacted]

;Visual constants
(define R 50)                                    ;R is the radius of each traffic light circle (red, yellow, green).
(define W (* 2 R))                               ;W is the width of the traffic light.
(define D (* 6 R))                               ;D is the height of the traffic light.
(define ES (empty-scene W D))                    ;This is the background where the traffic light will be drawn.
(define FRAME (rectangle W D "outline" "black")) ;Creates a black rectangular frame that shows the outer body of the traffic light.




; TrafficLight (TL) is one of
;  - "red"
;  - "yellow"
;  - "green"
;  interp. each string above represents a corresponding traffic light.

; Time for each color
(define RT 17)
(define GT 13)
(define YT 9)



(define REDL 
  (place-image
   (overlay/xy
    (overlay/xy
     (overlay/xy FRAME  0 0 (circle R "solid" "red")) ;Red light ON (solid)
      0 (* 2 R) (circle R "outline" "yellow")) ; Yellow light OFF (outline only)
    0 (* 4 R) (circle R "outline" "green"))  ;Green light OFF (outline only)
   (/ W 2) (/ D 2) ES))  ;Place the combined image at the center of the empty scene

(define YELLOWL (place-image 
                 (overlay/xy
                  (overlay/xy
                   (overlay/xy FRAME  0 0 (circle R "outline" "red"))  ;Red light OFF
                   0 (* 2 R) (circle R "solid" "yellow")) ; Yellow light ON
                 0 (* 4 R) (circle R "outline" "green")) ;Yellow light ON
                (/ W 2) (/ D 2) ES))  ;Place at the center

(define GREENL (place-image
                (overlay/xy
                 (overlay/xy
                  (overlay/xy FRAME  0 0 (circle R "outline" "red")) ; Red light OFF
                  0 (* 2 R) (circle R "outline" "yellow")) ;Yellow light OFF
                 0 (* 4 R) (circle R "solid" "green")) ; Green light ON
                (/ W 2) (/ D 2) ES)) ; Place at the center

; Logic:
; - overlay/xy layers images on top of each other. Frame first, then red circle, then yellow and green outlines.
; - X, Y coordinates shows position each light vertically: 0, 2*R, 4*R.
; - place-image places the final image on the empty scene (ES).



;CONSTURUCTORS:
;make-NTL : string number -> NTL

(define-struct NTL (Light Timer)) ;Defines the NTL structure with two fields: Light and Timer

(define TL-1 (make-NTL "red" RT))    ; Creates an example traffic light with red color and timer value RT
(define TL-2 (make-NTL "green" GT))  ; Creates an example traffic light with red color and timer value GT
(define TL-3 (make-NTL "yellow" YT)) ; Creates an example traffic light with yellow color and timer value YT


; SELECTORS:
; NTL-Light : NTL -> String
; NTL-Timer : NTL -> Number
; These functions extract the fields from an NTL object.

(NTL-Light TL-1)   ; "red"      Returns "red"    -> gets the Light field from TL-1
(NTL-Timer TL-1)   ; 17         Returns 17       -> gets the Timer field from TL-1
(NTL-Light TL-2)   ; "green"    Returns "green"  -> Light field of TL-2
(NTL-Timer TL-2)   ; 13         Returns 13       -> Timer field of TL-2
(NTL-Light TL-3)   ; "yellow"   Returns "yellow" -> Light field of TL-3
(NTL-Timer TL-3)   ; 9          Returns 9        -> Timer field of TL-3


;PREDICATORS:
;NTL? : anything -> boolean
;Checks whether a given value is an NTL object.
;Returns true or false.

(NTL? (make-NTL "red" 17))    ; true
(NTL? (make-NTL "green" 13))  ; true
(NTL? (make-NTL "yellow" 9))  ; true
(NTL? "red")                  ; false
(NTL? 9)                      ; false
(NTL? "yelllow")              ; false
(NTL? 13)                     ; false





; FUNCTION: change-light

; Contract:change-light : String -> NTL
; Purpose: Changes the given light and produces a new NTL

; "red"    -> "green"
; "green"  -> "yellow"
; "yellow" -> "red"
; The timer is reset according to the new light (GT, YT, RT)

;EXAMPLES:
(check-expect (change-light "red")   (make-NTL "green" GT))
(check-expect (change-light "green") (make-NTL "yellow" YT))
(check-expect (change-light "yellow")(make-NTL "red" RT))
(check-expect (change-light "red")   (make-NTL "green" GT))   ; repeated but different usage
(check-expect (change-light "green") (make-NTL "yellow" YT)) ; repeated but different usage

;TEMPLATE:

; light : String
; produce : NTL

(define (change-light-template light)
  (cond
    [(string=? light "red")    ...]   ; red situation
    [(string=? light "green")  ...]   ; green situation
    [(string=? light "yellow") ...]   ; yellow situation
    [else ...]))                     ; other situations (error)

;FUNCTION:

(define (change-light light)
  (cond
    [(string=? light "red")    (make-NTL "green" GT)]  ; If the current light is red, switch to green and reset timer to GT
    [(string=? light "green")  (make-NTL "yellow" YT)] ; If the current light is green, switch to yellow and reset timer to YT
    [(string=? light "yellow") (make-NTL "red" RT)]    ; If the current light is yellow, switch to red and reset timer to RT
    [else (error "Invalid light")]))   ; If the light is not valid, show an error



; FUNCTION: tick-f: 

; Contract: tick-f : NTL -> NTL
; Purpose: Check the timer of NTL. If it is equal to 0,
;change the light, otherwise subtract one from counter

; Red --> Green
; Green --> Yellow
; Yellow --> Red

;EXAMPLES:
(check-expect (tick-f (make-NTL "green" 3))  (make-NTL "green" 2))
(check-expect (tick-f (make-NTL "green" 0))  (make-NTL "yellow" YT))
(check-expect (tick-f (make-NTL "yellow" 2)) (make-NTL "yellow" 1))
(check-expect (tick-f (make-NTL "yellow" 0)) (make-NTL "red" RT))
(check-expect (tick-f (make-NTL "red" 0))(make-NTL "green" GT))
(check-expect (tick-f (make-NTL "red" 2)) (make-NTL "red" 1))


; TEMPLATE:
; ntl : NTL
(define (tick-f-template ntl)
  (cond
    ; Timer = 0 → need to change the light
    [(zero? (NTL-Timer ntl)) 
     ...]  ; use (change-light (NTL-Light ntl))

    ; Timer > 0 → same light, decrease timer
    [(string=? (NTL-Light ntl) "red")   ; make-NTL with same light, timer-1  
     ...]  
    [(string=? (NTL-Light ntl) "green") ; make-NTL with same light, timer-1
     ...]  
    [(string=? (NTL-Light ntl) "yellow"); make-NTL with same light, timer-1
     ...]  

    ; Else → unknown light, stay current state
    [else ...])) ; return ntl


;FUNCTION:

(define (tick-f ntl)
  (cond
    [(zero? (NTL-Timer ntl))  ; Timer = 0 → change the light
     (change-light (NTL-Light ntl))]
    ; Timer > 0 → same light, decrease timer
    [(string=? (NTL-Light ntl) "red")   (make-NTL "red" (- (NTL-Timer ntl) 1))]
    [(string=? (NTL-Light ntl) "green") (make-NTL "green" (- (NTL-Timer ntl) 1))]
    [(string=? (NTL-Light ntl) "yellow")(make-NTL "yellow" (- (NTL-Timer ntl) 1))]
    [else ntl])) ; Else → unknown light, stay same state





;FUNCTION: draw-f

; Contract: draw-f : NTL -> Image
; Purpose: Takes a traffic light structure (NTL)
; and produces the corresponding traffic light image

;EXAMPLE:
(check-expect (draw-f (make-NTL "red" 0)) REDL)
(check-expect (draw-f (make-NTL "green" 1)) GREENL)
(check-expect (draw-f (make-NTL "yellow" 3)) YELLOWL)
(check-expect (draw-f (make-NTL "red" 4)) REDL)



;TEPMPLATE:
; ntl : NTL

(define (draw-f-template ntl)
  (cond
     [(string=? (NTL-Light ntl) "red")    ...]
     [(string=? (NTL-Light ntl) "green")  ...]
     [(string=? (NTL-Light ntl) "yellow") ...]
     [else ...]))

;FUNCTION:

(define (draw-f ntl)
  (cond
    [(string=? (NTL-Light ntl) "red")    REDL]   ; If the traffic light color is red, return the red light image
    [(string=? (NTL-Light ntl) "green")  GREENL]  ; If the traffic light color is green, return the green light image
    [(string=? (NTL-Light ntl) "yellow") YELLOWL] ; If the traffic light color is yellow, return the yellow light image
    [else ES])) ; unknown light → empty scene




; FUNCTION: police-officer: key-event

; Contract: police-officer : NTL KeyEvent -> NTL
; Purpose: to change the light according to key event.

; if KeyEvent is r --> "red"
; if KeyEvent is g --> "green"
; if KeyEvent is y --> "yellow"

;EXAMPLE:
(check-expect (police-officer (make-NTL "green" 2) "r") (make-NTL "red" RT))
(check-expect (police-officer (make-NTL "red" 5) "g") (make-NTL "green" GT))
(check-expect (police-officer (make-NTL "yellow" 1) "y") (make-NTL "yellow" YT))
(check-expect (police-officer (make-NTL "red" 4) "x") (make-NTL "red" 4))

;TEMPLATE:

; ntl : NTL
; key : KeyEvent

(define (police-officer-Template ntl key)
  (cond
     [(string=? key "r") ...]
     [(string=? key "g") ...]
     [(string=? key "y") ...]
     [else ...]))

;FUNCTION:

(define (police-officer ntl key)
  (cond
    [(string=? key "r") (make-NTL "red" RT)]    ; If the key pressed is "r", switch the light to red and reset the timer to RT
    [(string=? key "g") (make-NTL "green" GT)]  ; If the key pressed is "g", switch the light to green and reset the timer to GT
    [(string=? key "y") (make-NTL "yellow" YT)] ; If the key pressed is "y", switch the light to yellow and reset the timer to YT
    [else ntl]))  ; If another key is pressed, stay the current traffic light state not changed


;BIG-BANG
; NTL --> Images

(define (main init)       ; Defines the main function that starts ;the traffic light simulation
(big-bang init            ; big-bang starts the program with the given initial traffic light state
(on-tick tick-f)          ; on-tick updates the traffic light every time the clock ticks
(on-draw draw-f)          ; on-draw draws the current traffic light on the screen
(on-key police-officer))) ; on-key changes the traffic light when a key is pressed


(main (make-NTL "green" 9)) ; Starts the program with a green light and timer value of 9

