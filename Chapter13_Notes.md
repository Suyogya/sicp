# 1.3 Formulating Abstractions with Higher-Order procedures
Procedures that manipulate procedures are called higher-order procedures.

## 1.3.1 Procedure as Arguments
Consider following methods:
```lisp
;Compute sum of integers from a through b:
(define (sum-integers a b)
    (if (> a b)
        0
        (+ a (sum-integers (+ a 1) b))
    )
)
```

```lisp
;compute sum of cubes of integers from a through b:
(define (sum-cubes a b)
    (if (> a b)
        0
        (+ (cube a) (sum-cubes (+ a 1) b))
    )
)
```

```lisp
;computes the sum of sequence of terms in series: 1/1.3 + 1/5.7 + 1/9.11 + ....
(define (pi-sum a b)
    (if (> a b)
        0
        (+ (/ 1 (* a (+ a 2))) (pi-sum (+ a 4) b))
    )
)
```

These procedures are almost identical and can be generalized as
```lisp
(define (<name> a b)
    (if (> a b)
        0
        (+ (<term> a) (<name> (<next> a) b))
    )
)
```

This is the abstraction of *summation of a series*

We can define the procedure as,
```lisp
(define (sum term a next b)
    (if (> a b)
        0
        (+ (term a) (sum (next a) b))
    )
)
```

So procedure to calculate sum of cubes of numbers a through b becomes
```lisp
(define (sum-cubes a b)
    (define (next x) (+ x 1))
    (sum cube a next b)
)
```

Sum of integers from a through b can be defined as,
```lisp
(define (sum-integers a b)
    (define (identity x) x)
    (define (next x) (+ x 1))
    (sum identity a next b)
)
```

Pi summation can be defined as,
```lisp

(define (pi-sum a b)
    (define (term x) (/ 1 (* x (+ x 2))))
    (define (next x) (+ x 4))
    (sum term a next b)
)
```

Similarly, we can define procedure to calculate integration of function &fnof; between the limits a and b,

```lisp
(define (integration f a b dx)
    (define (next x)
        (+ x dx)
    )
    (* dx (sum f (+ a (/ dx 2)) next b))
)
``` 
