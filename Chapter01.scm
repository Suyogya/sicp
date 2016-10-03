;;;Chapter 01

(define (square x) (* x x))

(define (sum-of-square a b)
    (+ (square a) (square b))
)

;Ex1.5 Define a procedure that takes three numbers as arguments and returns the sum of the squares of the two larger numbers.

(define (sum-square-larger a b c)
    (cond ((and (> a c) (> b c)) 
                (sum-of-square a b))
          ((and (> b a) (> c a)) 
                (sum-of-square b c))
          (else (sum-of-square a c))
    )
)

;Newton's method of finding square root
(define (sqrt-iter guess x)
    (if (good-enough? guess x)
            guess
            (sqrt-iter (improve guess x) x)
    )
)
(define (improve guess x)
    (average guess (/ x guess))
)

(define (average x y)
    (/ (+ x y) 2)
)

(define (good-enough? guess x)
    (< (abs (- (square guess) x)) 0.001)
)

(define (sqrt x)
    (sqrt-iter 1.0 x)
)

;Ex1.7 implementation of good-enough? compare guess change from one iteration to another

(define (good-enough? guess improved-guess)
    (< (abs (- guess improved-guess)) 0.001)
)

;;Implement this to find square root
;;using let 
(define (sqrt-iter guess x)
    (let ((improved-guess (improve guess x)))
        (if (good-enough? guess improved-guess)
            guess
            (sqrt-iter improved-guess x) 
        )
    )
)