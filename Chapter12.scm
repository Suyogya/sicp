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
(define (cube x) (* x x x))
(define (p x) (- (* 3 x) (* 4 (cube x))))
(define (sine angle)
   (if (not (> (abs angle) 0.1))
       angle
       (p (sine (/ angle 3.0)))))