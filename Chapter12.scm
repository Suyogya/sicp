;Ackermann's function


(define (A x y)
    (cond ((= y 0) 0)
          ((= x 0) (* 2 y))
          ((= y 1) 2)
          (else (A (- x 1)
                (A x (- y 1)))
          )
    )
)


; Fibonacci using iterative process
(define (fib-iter n)
    (define (iter a b count)
        (if (= count n)
            a
            (iter b (+ a b) (1+ count))
        )
    )
    (iter 0 1 0)
)

;Counting change
(define (count-change amount)
    (define (cc amount kind-of-coin)
        (cond ((= amount 0) 1)
              ((or (< amount 0) (= kind-of-coin 0)) 0)
              (else
                (+ (cc (- amount (denomination kind-of-coin)) kind-of-coin)
                   (cc amount (- kind-of-coin 1))
                )
              )
        )
    )
    (define (denomination kind-of-coin)
        (cond ((= kind-of-coin 1) 1)
              ((= kind-of-coin 2) 5)
              ((= kind-of-coin 3) 10)
              ((= kind-of-coin 4) 25)
              ((= kind-of-coin 5) 50)
        )
    )
    (cc amount 5)
)

;Ex1.11 f(n) = n if n < 3 and f(n) = (n - 1) + 2f(n - 2) + 3f(n-3) if n >= 3

;recursive
(define (f11-recur n)
    (if (< n 3)
        n
        (+ (f11-recur (- n 1)) 
           (* 2 (f11-recur (- n 2))) 
           (* 3 (f11-recur (- n 3)))
        )
    )
)

;iterative
(define (f11-iter n)
    (define (iter a b c count)
        (if (> count n)
            a
            (iter b c (+ (* 3 a) (* 2 b) c) (1+ count))
        )
    )
    (iter 0 1 2 1)
)

;Ex1.12 Pascal's triangle
(define (pascal r c)
    (cond ((or (= c 0) (= r c)) 1)
          ((or (< c 0) (< r c)) 0)
          (else (+ (pascal (- r 1) (- c 1))
                   (pascal (- r 1) c)
                )
          )
    )
)

;Ex1.13 Fibonacci approximation
(define phi (/ (+ 1 (sqrt 5)) 2))

(define (phi-fib n)
    (/ (^ phi n) (sqrt 5))
)


;Ex1.15 Sine approximation
(define (cube x) (* x x x)))
(define (p x) (- (* 3 x) (* 4 (cube x))))
(define (sine angle)
   (if (not (> (abs angle) 0.1))
       angle
       (p (sine (/ angle 3.0)))))


;Ex1.16 Fast Exponential iterative
(define (fast-expt-iter b n)
    (define (iter a num p)
        (cond ((= p 0) a)
              ((even? p) (iter a (square num) (/ p 2)))
              (else  (iter (* num a) num (- p 1)))
        )
    )
    (iter 1 b n)
)

;Ex.1.17 Fast Multiplication with sum
(define (fast-mult a b)
    (cond ((= b 0) 0)
          ((even? b) (double (fast-mult a (/ b 2))))
          (else (+ a (fast-mult a (- b 1))))
    )
)

;Ex1.18 Fast Multiplication iterative with sum
(define (fast-mult-iter a b)
    (define (iter result y z)
        (cond ((= z 0) result)
              ((even? z) (iter result (double y) (/ z 2)))
              (else (iter (+ result y) y (- z 1)))
        )
    )
    (iter 0 a b)
)

;Ex1.19 Fibonacci with logarithmic order of growth

(define (fib n)
    (define (fib-iter a b p q count)
        (cond ((= count 0) b)
            ((even? count)
                (fib-iter a
                          b
                          (sum-of-square p q)
                          (+ (square q) (* 2 p q))
                          (/ count 2)
                )
            )
            (else 
                (fib-iter (+ (* b q) (* a q) (* a p))
                            (+ (* b p) (* a q))
                            p
                            q
                            (- count 1)
                )
            )
        )
    )
    (fib-iter 1 0 0 1 n)
)

;Greatest Common Divisor

(define (GCD a b)
    (if (= b 0) a
        (GCD b (Remainder a b))
    )
)

;Prime Number

;Smallest-Divisor
(define (smallest-divisor n)
    (define (find-divisor n test-divisor)
        (cond ((> (square test-divisor) n) n)
              ((divides? test-divisor n) test-divisor)
              (else (find-divisor n (1+ test-divisor)))
        )
    )
    (define (divides? a b)
        (= (remainder b a) 0)
    )
    (find-divisor n 2)
)

(define (is-prime? n)
    (= (smallest-divisor n) n)
)


;Fermat's Test
(define (expmod base exp n)
    (cond ((= exp 0) 1)
          ((even? exp) (remainder (square (expmod base (/ exp 2) n)) n))
          (else (remainder (* base (expmod base (- exp 1) n)) n))
    )
)


(define (fermat-test n)
    (define (try-it a)
        (= (expmod a n n) a)
    )
    (try-it (+ 1 (random (- n 1))))
)

(define (fast-prime? n times)
    (cond ((= times 0) true)
          ((fermat-test n) (fast-prime? n (- times 1)))
          (else false)
    )
)

;Ex1.22
(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime))
)

(define (start-prime-test n start-time)
  (if (fast-prime? n 100)
      (begin
          (report-prime (- (runtime) start-time))
          true
      )
      false
  )
)

(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time)
)

(define (search-for-prime a n)
    (define (iter number count)
        (if (< count n)
            (begin
                (if (timed-prime-test number)
                    (iter (+ number 2) (1+ count))
                    (iter (+ number 2) count) 
                )
            )
        )
    )
    (if (even? a)
        (iter (+ a 1) 0)
        (iter (+ a 2) 0)
    )
)

;Ex 1.23 Smallest divisor with next test-divisor
(define (smallest-divisor n)
    (define (find-divisor n test-divisor)
        (cond ((> (square test-divisor) n) n)
              ((divides? test-divisor n) test-divisor)
              (else (find-divisor n (next test-divisor)))
        )
    )
    (define (divides? a b)
        (= (remainder b a) 0)
    )
    (define (next divisor)
        (if (even? divisor)
            (1+ divisor)
            (+ divisor 2)
        )
    )
    (find-divisor n 2)
)

;Ex 1.27 Carmichael numbers
(define (carmichael n)
    (define (fermat-test a n)
        (= (expmod a n n) a)
    )
    (define (iter count)
        (cond ((= count n) true)
              ((fermat-test count n) (iter (1+ count)))
              (else false)
        )
    )
    (iter 1)
)

;Ex. 1.28 Miller-Rabin test
(define (miller-rabin-expmod base exp m)
    (define (squaremod-with-check x)
        (define (non-trivial-sqrt? x square)
            (if (and (= square 1)
                     (not (= x 1))
                     (not (= x (- m 1)))
                )
                0
                square
            )
        )
        (non-trivial-sqrt? x (remainder (square x) m))
    )
    (cond ((= exp 0) 1)
          ((even? exp) (squaremod-with-check
                            (miller-rabin-expmod base (/ exp 2) m)
                       )
          )
          (else
            (remainder (* base (miller-rabin-expmod base (- exp 1) m)) m)
          )
    )
)

(define (miller-rabin-test n)
    (define (try-it a)
        (define (check-it x)
            (and (not (= x 0)) (= x 1))
        )
        (check-it (miller-rabin-expmod a (- n 1) n))
    )
    (try-it (+ 1 (random (- n 1))))
)


(define (fast-prime? n times)
    (cond ((= times 0) true)
          ((= n 1) false)
          ((miller-rabin-test n) (fast-prime? n (- times 1)))
          (else false)
    )
)

(define (prime? n)
    (fast-prime? n 100)
)

;;Another implementation for Miller Rabin
(define (expmod-mr base exp n)
    (define (square-non-trivial-check x)
        (let ((y (remainder (square x) n)))
            (if (and (not (= x 1)) (not (= x (- n 1))) (= y 1))
                0
                y
            )
        )
    )
    (cond ((= exp 0) 1)
          ((even? exp) (square-nontrivial-check (expmod-mr base (/ exp 2) n)))
          (else (remainder (* base (expmod-mr base (- exp 1) n)) n))
    )
)

(define (mr-test n)
    (define (check a)
        (= (expmod a (- n 1) n) 1)
    )
    (check (+ 1 (random-integer (- n 1))))
)

(define (mr-prime? n)
    (define (test a)
        (cond ((= a 0) true)
              ((mr-test n) (test (- a 1)))
              (else false)
        )
    )
    (if (= n 1) #f (test 100))
)