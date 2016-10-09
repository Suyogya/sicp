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