;Methods that can be reused later

(define (^ a b)
    (cond ((= b 0) 1)
          ((even? b) (square (^ a (/ b 2))))
          (else (* a (^ a (- b 1)))) 
    )
)

(define (even? x)
    (= (remainder x 2) 0)
)

(define (square x)
    (* x x)
)

(define (sum-of-square a b)
    (+ (square a) (square b))
)

(define (sqrt x)
    (define (improve guess)
        (average guess (/ x guess))
    )
    (define (good-enough? guess improved-guess)
        (< (abs (- guess improved-guess)) 0.0001)
    )
    (define (iter guess)
        (let ((improved-guess (improve guess)))
            (if (good-enough? guess improved-guess)
                guess
                (iter improved-guess)
            )
        )
    )
    (iter 1.0)
)

(define (average x y)
    (/ (+ x y) 2)
)

(define (double x)
    (* x 2)
)

(define (cube x)
    (* x x x)
)

(define (abs x)
    (if (< x 0) (- 0 x) x)
)