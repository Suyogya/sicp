# Exercise Chapter 1

## 1.1
Below is a sequence of expressions. What is the result printed by the interpreter in response to each expression? Assume that the sequence is to be evaluated in the order in which it is presented.

```lisp
10
(+ 5 3 4)
(- 9 1)
(/ 6 2)
(+ (* 2 4) (- 4 6))
(define a 3)
(define b (+ a 1))
(+ a b (* a b))
(= a b)
(if (and (> b a) (< b (* a b)))
    b
    a)
(cond ((= a 4) 6)
      ((= b 4) (+ 6 7 a))
      (else 25))
(+ 2 (if (> b a) b a))
(* (cond ((> a b) a)
         ((< a b) b)
         (else -1))
   (+ a 1))
```

### Answer
```lisp
=>10
10

=>(+ 5 3 4)
12

=>(- 9 1)
8

=>(/ 6 2)
3

=>(+ (* 2 4) (- 4 6))
- 16

=>(define a 3)
=> (define b (+ a 1))
=>(+ a b (* a b))
19

=>(= a b)
#f

=>(if (and (> b a) (< b (* a b)))
      b
      a)
4

=>(cond ((= a 4) 6)
      ((= b 4) (+ 6 7 a))
      (else 25))
16

=>(+ 2 (if (> b a) b a))
6

=>(* (cond ((> a b) a)
         ((< a b) b)
         (else -1))
   (+ a 1))
16
```

## 1.2
Translate the following expression into prefix form

(5 + 4 + (2 - (3 - (6 + 4/5)))) / (3(6 - 2)(2 - 7))

### Answer
```lisp
(/ (+ 5 6 (- 2 (- 3 (+ 6 (/ 4 5))))) (* 3 (- 6 2) (- 2 7)))
```

## 1.3
Define a procedure that takes three numbers as arguments and returns the sum of the squares of the two larger numbers.

###Answer

```lisp
=>(define (sum-square-larger a b c)
    (cond ((and (> a c) (> b c)) 
                (sum-of-square a b))
          ((and (> b a) (> c a)) 
                (sum-of-square b c))
          (else (sum-of-square a c))
    )
)

=> (sum-square-larger 2 3 4)
25
```

##1.4
Observe that our model of evaluation allows for combinations whose operators are compound expressions. Use this observation to describe the behavior of the following procedure:
```lisp
(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b))
```

###Answer
```lisp
;Evaluation of procedure a-plus-abs-b when a = 4, b = -6
=> (a-plus-abs-b 4 -6)
=> ((if (> -6 0) + -) 4 -6))
=> ((if #f + -) 4 -6)
=> (- 4 -6)
=> 10
```

##1.5
Ben Bitdiddle has invented a test to determine whether the interpreter he is faced with is using applicative-order evaluation or normal-order evaluation. He defines the following two procedures:
```lisp
(define (p) (p))

(define (test x y)
  (if (= x 0)
      0
      y))
```
Then he evaluates the expression
```lisp
(test 0 (p))
```

### Answer
Normal-order evaluation
```lisp
(test 0 (p))
(if (= 0 0) 0 (p))
(if #t 0 (p))
0
```

Applicative-order evaluation
```lisp
(test 0 (p))
(test 0 (p))
(test 0 (p))
;infinitely
```
Here, interpreter tries to evaluate (p) which expands to itself infinitely

Since Lisp is applicative-order evaluation the procedure will execute infinitely

## 1.6
Alyssa P. Hacker doesn't see why if needs to be provided as a special form. ``Why can't I just define it as an ordinary procedure in terms of cond?'' she asks. Alyssa's friend Eva Lu Ator claims this can indeed be done, and she defines a new version of if:
```lisp
(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
        (else else-clause)))
```
Eva demonstrates the program for Alyssa:
```lisp
(new-if (= 2 3) 0 5)
5

(new-if (= 1 1) 0 5)
0
```
Delighted, Alyssa uses new-if to rewrite the square-root program:
```lisp
(define (sqrt-iter guess x)
  (new-if (good-enough? guess x)
          guess
          (sqrt-iter (improve guess x)
                     x)))
```

What happens when Alyssa attempts to use this to compute square roots? Explain.

### Answer
By substitution model and applicative-order evaluation
```lisp
(new-if (good-enough? guess x) guess (sqrt-iter (improve guess x) x))
```
substitutes to:
```lisp
(cond ((good-enough? guess x) guess)
      (else (sqrt-iter (improve guess x) x))
)
```
By applicative-order evaluation:
```lisp
(cond ((good-enough? guess x) guess)
      (else (new-if (good-enough (improve guess x) x)
                    guess
                    (sqrt-iter (improve (improve guess x) x) x)
            )
      )
)
```

the recursive portion `sqrt-iter` gets evaluated infinitely and function doesn't return

## 1.7
The good-enough? test used in computing square roots will not be very effective for finding the square roots of very small numbers. Also, in real computers, arithmetic operations are almost always performed with limited precision. This makes our test inadequate for very large numbers. Explain these statements, with examples showing how the test fails for small and large numbers. An alternative strategy for implementing good-enough? is to watch how guess changes from one iteration to the next and to stop when the change is a very small fraction of the guess. Design a square-root procedure that uses this kind of end test. Does this work better for small and large numbers?

Answer
```lisp
=> (sqrt 0.0001)
0.0323
```

The problem with calculating square root of very small number is, the tolerance 0.001 is significantly large.
As in example, expected value is 0.01 (error of 200%).

The problem with calculating square root of large numbers is, machine precision is unable to represent small differences between large numbers
```(sqrt 10000000000000)``` enters an infinite loop although ```(sqrt 100000000000)` evaluates promptly.

The answer is due to the nature of floating-point numbers. As values get larger and larger, their floating-point representation becomes less precise. As we keep recursively refining our guess in the square root procedure, if the value of the guess is large enough we're unable to represent it to within our tolerance of 0.001. This causes an endless sequence of recursive calls, since the interpreter will never reach a point where the guess is good enough.

```lisp

(define (good-enough? guess improved-guess)
    (< (abs (- guess improved-guess)) 0.001)
)

(define (sqrt-iter guess x)
    (let ((improved-guess (improve guess x)))
        (if (good-enough? guess improved-guess)
            guess
            (sqrt-iter improved-guess x) 
        )
    )
)
```