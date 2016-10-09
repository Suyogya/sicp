## 1.29
Simpson's Rule is a more accurate method of numerical integration than the method illustrated above. Using Simpson's Rule, the integral of a function f between a and b is approximated as

h/3(y<sub>0</sub> + 4y<sub>1</sub> + 2y<sub>2</sub> + 4y<sub>3</sub> + 2y<sub>4</sub> + ... + 2y<sub>n-2</sub> + 4y<sub>n-1</sub> + y<sub>n</sub>)

where h = (b - a)/n for some even integer n, and y<sub>k</sub> = f(a + kh) (Increasing n increases the accuracy of the approximation.) Define a procedure that takes as arguments f, a, b, and n and returns the value of the integral, computed using Simpson's Rule. Use your procedure to integrate cube between 0 and 1 (with n = 100 and n = 1000), and compare the results to those of the integral procedure shown above.

### Answer
```lisp

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
```

Using single summation instead of multiple,
```lisp
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
```

## 1.30
The sum procedure above generates a linear recursion. The procedure can be rewritten so that the sum is performed iteratively. Show how to do this by filling in the missing expressions in the following definition:

### Answer
```lisp
(define (sum-iter term a next b)
    (define iter (sum item)
        (if (> item b) 
            sum
            (iter (+ sum (term item)) (next item))
        )
    )
    (iter 0 a)
)
```

## 1.31
a. The sum procedure is only the simplest of a vast number of similar abstractions that can be captured as higher-order procedures.51 Write an analogous procedure called product that returns the product of the values of a function at points over a given range. Show how to define factorial in terms of product. Also use product to compute approximations to  using the formula

&pi;/4 = (2/3).(4/3).(4/5).(6/5).(6/7).(8/7)....

b. If your product procedure generates a recursive process, write one that generates an iterative process. If it generates an iterative process, write one that generates a recursive process.

### Answer
```lisp
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
```

Iterative implementation

```lisp
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
```

## 1.32
a. Show that sum and product (exercise 1.31) are both special cases of a still more general notion called accumulate that combines a collection of terms, using some general accumulation function:

(accumulate combiner null-value term a next b)

Accumulate takes as arguments the same term and range specifications as sum and product, together with a combiner procedure (of two arguments) that specifies how the current term is to be combined with the accumulation of the preceding terms and a null-value that specifies what base value to use when the terms run out. Write accumulate and show how sum and product can both be defined as simple calls to accumulate.

b. If your accumulate procedure generates a recursive process, write one that generates an iterative process. If it generates an iterative process, write one that generates a recursive process.

### Answer
```lisp
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
```

Iterative accumulator
```lisp
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
```

## 1.33
You can obtain an even more general version of accumulate (exercise 1.32) by introducing the notion of a filter on the terms to be combined. That is, combine only those terms derived from values in the range that satisfy a specified condition. The resulting filtered-accumulate abstraction takes the same arguments as accumulate, together with an additional predicate of one argument that specifies the filter. Write filtered-accumulate as a procedure. Show how to express the following using filtered-accumulate:

a. the sum of the squares of the prime numbers in the interval a to b (assuming that you have a prime? predicate already written)

b. the product of all the positive integers less than n that are relatively prime to n (i.e., all positive integers i < n such that GCD(i,n) = 1).

### Answer

Recursive accumulator with filter
```lisp
(define (filtered-accumulator predicate combiner null-value term a next b)
    (cond ((> a b) null-value)
          ((predicate a) (combiner (term a) (filtered-accumulator predicate combiner null-value term (next a) next b)))
          (else (filtered-accumulator predicate combiner null-value term (next a) next b))
    )
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
```

Iterative accumulator with filter
```lisp
(define (filtered-accumulator-iter predicate combiner null-value term a next b)
    (define (iter result item)
        (cond ((> item b) result)
              ((predicate item) (iter (combiner result (term item)) (next item)))
              (else (iter result (next item)))
        )
    )
    (iter null-value a)
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
```

## 1.34
Suppose we define the procedure
```lisp
(define (f g)
    (g 2)
)
```

then we have 
```lispe
=>(f square)
4
=>(f (lambda (z) (* z (+ z 1))))
6
```
### Answer

```lisp
;Using substitution method
(f f)
(f 2)
(2 2)
error
```

We get an error, object 2 is not applicable