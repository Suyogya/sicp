;Mathematical operations on rational number
(define (add-rat x y)
   (make-rat (+ (* (numer x) (denom y)) (* (numer y) (denom x)))
            (* (denom x) (denom y))
   )
)
(define (sub-rat x y)
   (make-rat (- (* (numer x) (denom y)) (* (numer y) (denom x)))
            (* (denom x) (denom y))
   )
)
(define (mul-rat x y)
   (make-rat (* (numer x) (numer y))
            (* (denom x) (denom y))
   )
)
(define (div-rat x y)
   (make-rat (* (numer x) (denom y))
            (* (denom x) (numer y))
   )
)
(define (equal-rat? x y)
   (= (* (numer x) (denom y))
      (* (denom x) (numer y))
   )
)

;Constructor and selector for rational number implemented using Constructor
(define (make-rat n d) (cons n d))
(define (numer x) (car x))
(define (denom x) (cdr x))
(define (print-rat x)
    (newline)
    (display (numer x))
    (display "/")
    (display (denom x))
)

;improve make-rat to reduce rational number to lowest terms
(define (make-rat n d)
    (let ((div (gcd n d)))
        (cons (/ n div) (/ d div))
    )
)

;Ex2.1 make-rat that handles positive and negative argument
(define (make-rat n d)
    (let ((div (gcd n d)))
            (cons 
                ((if (> (* n d) 0) + -) 0 (abs (/ n div))) 
                (abs (/ d div))
            )
    )
)

;Ex 2.2 Line segment
(define (make-point x y)
    (cons x y)
)

(define (x-point pt)
    (car pt)
)

(define (y-point pt)
    (cdr pt)
)

(define (pt-distance p1 p2)
    (let
        (
            (x1 (x-point p1))
            (x2 (x-point p2))
            (y1 (y-point p1))
            (y2 (y-point p2))
        )
        (sqrt (+ (square (- x2 x1)) (square (- y2 y1))))
    )
)

(define (make-segment start end)
    (cons start end)
)

(define (start-segment segment)
    (car segment)
)

(define (end-segment segment)
    (cdr segment)
)

(define (mid-point segment)
    (let
        (
            (x1 (x-point (start-segment segment)))
            (x2 (x-point (end-segment segment)))
            (y1 (y-point (start-segment segment)))
            (y2 (y-point (end-segment segment)))
        )
        (make-point 
            (average x1 x2)
            (average y1 y2)
        )
    )
)

(define (print-point p)
  (newline)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")"))

;Ex2.3 Define rectangle and procedure to calculate are and perimeter
(define (make-rectangle corner1 corner2)
    (cons corner1 corner2)
)

(define (width-rectangle rectangle)
    (abs (- (x-point (cdr rectangle)) (x-point (car rectangle))))
)

(define (height-rectangle rectangle)
    (abs (- (y-point (cdr rectangle)) (y-point (car rectangle))))
)

(define (area rectangle)
    (* (width-rectangle rectangle) (height-rectangle rectangle))
)

(define (perimeter rectangle)
    (* 2 (+ (width-rectangle rectangle) (height-rectangle rectangle)))
)

;Alternate definition of rectangle
(define (make-rectangle ptA ptB ptC ptD)
)
