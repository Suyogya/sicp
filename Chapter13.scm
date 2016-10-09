(define (sum term a next b)
    (if (> a b)
        0
        (+ (term a) (sum term (next a) next b))
    )
)

(define (sum-cubes a b)
    (define (next x) (+ x 1))
    (sum cube a next b)
)


(define (sum-integers a b)
    (define (identity x) x)
    (define (next x) (+ x 1))
    (sum identity a next b)
)

(define (pi-sum a b)
    (define (term x) (/ 1 (* x (+ x 2))))
    (define (next x) (+ x 4))
    (sum term a next b)
)

;Integral of function f between a and b
(define (integration f a b dx)
    (define (next x)
        (+ x dx)
    )
    (* dx (sum f (+ a (/ dx 2)) next b))
)

;Ex1.29 Simpson integration

(define (simpson-integral f a b n)
    (define h (/ (- b a) n))
    (define (next x) (+ x 2))
    (define (term x)
        (f (+ a (* x h)))
    )
    (* (/ h 3)
       (+  (term 0)
           (* 4 (sum term 1 next (- n 1)))
           (* 2 (sum term 2 next (- n 1)))
           (term n)
        )
    )
)

;Simpson integration using single summation
(define (simpson-integral-single f a b n)
    (define h (/ (- b a) n))
    (define (next x) (+ x 1))
    (define (term x)
        (define (func x)
            (f (+ a (* x h)))
        )
        (cond ((or (= x 0) (= x n)) (func x))
              ((even? x) (* 2 (func x)))
              (else (* 4 (func x)))
        )
    )
    (* (/ h 3) (sum term 0 next n))
)

;Ex 1.30 iterative summation
(define (sum-iter term a next b)
    (define (iter sum item)
        (if (> item b) 
            sum
            (iter (+ sum (term item)) (next item))
        )
    )
    (iter 0 a)
)

;Ex 1.31 product a through b
(define (product term a next b)
    (if (> a b)
        1
        (* (term a) (product term (next a) next b))
    )
)

(define (pi-prod a b)
    (define (term n)
        (if (even? n)
            (/ (+ n 2) (+ n 1))
            (/ (+ n 1) (+ n 2))
        )
    )
    (define (next n)
        (1+ n)
    )
    (product term a next b)
)

;Iterative product a through b
(define (product-iter term a next b)
    (define (iter product a)
        (if (> a b) product
            (iter (* product (term a)) (next a))
        )
    )
    (iter 1 a)
)

(define (pi-prod-iter a b)
    (define (term n)
        (if (even? n)
            (/ (+ n 2) (+ n 1))
            (/ (+ n 1) (+ n 2))
        )
    )
    (define (next n)
        (1+ n)
    )
    (product-iter term a next b)
)

;Ex 1.32 a) Accumulator
(define (accumulate combiner null-value term a next b)
    (if (> a b)
        null-value
        (combiner (term a) (accumulate combiner null-value term (next a) next b))
    )
)

(define (pi-prod-accumulator a b)
    (define (term n)
        (if (even? n)
            (/ (+ n 2) (+ n 1))
            (/ (+ n 1) (+ n 2))
        )
    )
    (define (next n)
        (1+ n)
    )
    (accumulate * 1 term a next b)
)

(define (pi-sum-accumulator a b)
    (define (term x) (/ 1 (* x (+ x 2))))
    (define (next x) (+ x 4))
    (accumulate + 0 term a next b)
)

;Ex 1.32 b) Iterative accumulator
(define (accumulate-iter combiner null-value term a next b)
    (define (iter result item)
        (if (> item b) result
            (iter (combiner result (term item)) (next item))
        )
    )
    (iter null-value a)
)

(define (pi-prod-accumulator-iter a b)
    (define (term n)
        (if (even? n)
            (/ (+ n 2) (+ n 1))
            (/ (+ n 1) (+ n 2))
        )
    )
    (define (next n)
        (1+ n)
    )
    (accumulate-iter * 1 term a next b)
)

(define (pi-sum-accumulator-iter a b)
    (define (term x) (/ 1 (* x (+ x 2))))
    (define (next x) (+ x 4))
    (accumulate-iter + 0 term a next b)
)

;Ex 1.33 Accumulator with filter
(define (filtered-accumulator predicate combiner null-value term a next b)
    (cond ((> a b) null-value)
          ((predicate a) (combiner (term a) (filtered-accumulator predicate combiner null-value term (next a) next b)))
          (else (filtered-accumulator predicate combiner null-value term (next a) next b))
    )
)

;Iterative accumulator with filter
(define (filtered-accumulator-iter predicate combiner null-value term a next b)
    (define (iter result item)
        (cond ((> item b) result)
              ((predicate item) (iter (combiner result (term item)) (next item)))
              (else (iter result (next item)))
        )
    )
    (iter null-value a)
)

;sum of square of primes between a to b
(define (sum-square-primes a b)
    (define (next x) (1+ x))
    (filtered-accumulator prime? + 0 square a next b)
)

;product of all i < n such that GCD (i, n) = 1
(define (prod-rel-prime n)
    (define (predicate i)
        (= (GCD i n) 1)
    )
    (define (identity x) x)
    (define (next i) (1+ i))
    (filtered-accumulator predicate * 1 identity 1 next n)
)

;sum of square of primes between a to b using iterative accumulator
(define (sum-square-primes-iter a b)
    (define (next x) (1+ x))
    (filtered-accumulator-iter prime? + 0 square a next b)
)

;product of all i < n such that GCD (i, n) = 1 using iterative accumulator
(define (prod-rel-prime-iter n)
    (define (predicate i)
        (= (GCD i n) 1)
    )
    (define (identity x) x)
    (define (next i) (1+ i))
    (filtered-accumulator-iter predicate * 1 identity 1 next n)
)

;Local variable using lambda
(define (f-local-lambda x y)
    (
        (lambda (a b)
            (+ (* x (square a))
               (* y b)
               (* a b)
            )
        )
        (+ 1 (* x y))
        (- 1 y)
    )
)

(define (f-local-let x y)
    (let (
            (a (+ 1 (* x y)))
            (b (- 1 y))
         )
         (+ (* x (square a))
            (* y b)
            (* a b)
         )
    )
)

;Half Interval method
(define (find-root f a b)
    (let ((x (average a b)))
        (cond ((close-enough? a b) x)
              ((< (f x) 0) (find-root f x b))
              (else (find-root f a x))
        )
    )
)

(define (close-enough? a b)
    (< (abs (- a b)) 0.0001)
)

(define (half-interval f a b)
    (let (
            (a-value (f a))
            (b-value (f b))
         )
         (cond
            ((and (< a-value 0) (> b-value 0)) (find-root f a b))
            ((and (< b-value 0) (> a-value 0)) (find-root f b a))
            (else (error "Values are not of opposite sign " a b))
         )
    )
)

;Fixed point
(define (fixed-point f guess)
    (let (
            (new-guess (f guess))
         )
         (display "New guess ")
         (display new-guess)
         (newline)
         (if (close-enough? guess new-guess) 
             new-guess
             (fixed-point f new-guess)
         )
    )
)

;simple implementation of square root using fixed point. This procedure does not convert.
(define (sqrt-fixed-v1 x)
    (define (f y)
        (/ x y)
    )
    (fixed-point f 1.0)
)

;square root using fixed point with average damping
(define (sqrt-fixed x)
    (define (f y)
        (average y (/ x y))
    )
    (fixed-point f 1.0)
)

;Ex1.35 Fixed point for golden ratio using transformation 1 + 1/x
(newline)
(display "solution for golden ration")
(newline)
(fixed-point (lambda (x) (+ 1 (/ 1 x))) 1.0)

;Ex1.36 find solution for x^x = 1000
(newline)
(display "solution for x^x = 1000")
(newline)
(fixed-point (lambda (x) (/ (log 1000) (log x))) 2.0)

(newline)
(display "solution for x^x = 1000 with average damping")
(newline)
(fixed-point (lambda (x) (average x (/ (log 1000) (log x)))) 2.0)

;Ex1.37 Continued fraction
(define (cont-frac func-n func-d k)
    (define (recur i)
        (if (> i k) 0
            (/ (func-n i) (+ (func-d i) (recur (1+ i))))
        )
    )
    (recur 1)
)

;(newline)
;(display "solution for golden-ratio using Continued fraction, 12 steps")
;(newline)
;(/ 1 (cont-frac (lambda (i) 1.0)
;            (lambda (i) 1.0)
;            12)
;)

;Continued fraction iterative
(define (cont-frac-iter func-n func-d k)
    (define (iter i result)
        (if (= i 0) result
            (iter (- i 1)
                  (/ (func-n i) (+ (func-d i) result)) 
            )
        )
    )
    (iter k 0)
)

(newline)
(display "solution for golden-ratio using Continued fraction iterative, 12 steps")
(newline)
(/ 1 (cont-frac (lambda (i) 1.0)
            (lambda (i) 1.0)
            12)
)

(newline)
(display "Solution for e using continuous fraction")
(newline)
(+ 2 (cont-frac (lambda (i) 1.0)
                (lambda (i)
                    (if (= (remainder i 3) 2)
                        (* 2 (+ 1 (integer-truncate  i 3)))
                        1
                    )
                )
                100
    )
)

;Ex 1.39 function to calculate tan x using continuous fraction
(define (tan-cf x k)
    (cont-frac (lambda (i)
                    (if (= i 1) x (- (square x)))
               )
               (lambda (i)
                    (- (* 2 i) 1)
               )
               k
    )
)