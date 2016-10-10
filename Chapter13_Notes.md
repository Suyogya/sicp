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

## 1.3.2 Constructing Procedures using Lambda
`lambda` is a special form which creates procedure.

e.g.
`(lambda (x) (+ x 4))`

General form:
```lisp
(lambda (<formal-parameters>) <body>)
```

The resulting procedure is just as much a procedure as one created using `define`. The difference is it has not been associated with any name.

```lisp
(define (plus4 x) (+ x 4))
```
is equivalent to,
```lisp
(define plus4 (lambda (x) (+ x 4)))
```

### Using let to create local variables
Use `let` to create local variables.

e.g. we wish to compute the function,<br>
f(x,y) = x(1 + xy)<sup>2</sup> + y(1 - y) + (1 + xy)(1 - y)

Which we could express as,<br>
a = 1 + xy<br>
b = 1 - y<br>
f(x, y) = xa<sup>2</sup> + yb + ab<br>

Creating local variable using lambda,
```lisp
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
```

Creating local variable using let,
```lisp
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
```

General structure

```lisp
(let (
        (<var1> <exp1>)
        (<var2> <exp2>)
        .
        .
        .
        (<varn> <expn>)
     )
)
```

- First part of let expression is list of name-expression pairs
- each name is associated with value of corresponding expression

`let` is interpreted as an alternate syntax for
```lisp
(
    (lambda 
        (<var1> ... <varn>)
        <body>
    )
    <exp1>
    .
    .
    .
    <expn>
)
```

`let` expression is simply syntactic sugar for underlying lambda application.
- The scope of a variable specified by `let` expression is the body of the `let`.
- `let` allows one to bind variables as local.
```lisp
(+ (let ((x 3))
    (+ x (* x 10)))
x)
;when x = 5, it is evaluated to
(+ (+ 3 (* 3 10)) 5)
;so inside the let body, x = 3 and it's 5 outside it
38
```

- The variables' values are computed outside the `let`.
```lisp
(let ((x 3)
      (y (+ x 2)))
(* x y))
;if value of x is 2, inside the body x will be 3 and y will be 4 (which is outer x plus 2)
```

## 1.3.3 Procedures as General methods

### Finding roots of equations by half-interval method
To find roots of equation, f(x) = 0, where f is a continuous function.

If we're given point a and b, such that<br>
f(a) < 0 < f(b), then f must have at least one zero between a and b.

The method to locate zero is,
1. Let x be average of a and b, compute f(x)
2. If f(x) > 0 f must have a zero between a and x, go to step 1 for b = x
3. If f(x) < 0 f must have a zero between x and b, go to step 1 for a = x
4. If f(x) = 0 x is the root

```lisp
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
```

The method assumes negative point and postive point are given in correct order. To be able to handle where they are not in correct order, we write following procedure,

```lisp
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
```

### Finding fixed point of functions
A number x is called fix point of function f if x satisfies f(x) = x.

For some function, we begin with an initial guess and applying f repeatedly, until the value doesn't change very much.

The procedure would be,
```lisp
(define (fixed-point f guess)
    (let (
            (new-guess (f guess))
         )
         (if (close-enough? guess new-guess) 
             new-guess
             (fixed-point f new-guess)
         )
    )
)
```

Fixed point is similar to what we did to find square root.

for a square root, we have<br>
y<sup>2</sup> = x<br>
y = x/y

We can define the procedure,
```lisp
(define (sqrt-fixed-v1 x)
    (define (f y)
        (/ x y)
    )
    (fixed-point f 1.0)
)
```
The `sqrt` method oscillates and never converges.

One way to control this oscillation is to dampen the function. We do this by averaging.
```lisp
(define (sqrt-fixed x)
    (define (f y)
        (average y (/ x y))
    )
    (fixed-point f 1.0)
)
```


## 1.3.4 Procedures as Return Values
Given a function &fnof;, we consider the function whose value at x is equal to average of x and &fnof;(x). This is average damping and can be expressed using following procedure:
```lisp
(define (average-damp f)
    (lambda (x) (average x (f x)))
)
```
The procedure takes another procedure `f` as an argument and returns a procedure, which when applied to x returns average of x and (f x)

We can reformulate the square root procedure as,
```lisp
(define (sqrt-damp x)
    (fixed-point (average-damp (lambda (y) (/ x y))) 1.0)
)
```

Similarly we can write a procedure to find cube root
```lisp
(define (cube-root-damp x)
    (fixed-point (average-damp (lambda (y) (/ x (square y)))) 1.0)
)
```

### Newton's method
Newton's Method states that, if x -> g(x) is differentiable, then solution of equation g(x) = 0 is a fixed point of the function x -> f(x) where,

f(x) = x - g(x)/Dg(x)

and Dg(x) is the derivative of g evaluated at x. Derivative is (like average damping) which transforms one function to another,<br>
Dg(x) = (g(x + dx) - g(x))/dx
where dx is a very small number (say, 0.00001)

```lisp
(define (derivative g)
    (define dx 0.00001)
    (lambda (x) (/ (- (g (+ x dx)) (g x)) dx))
)
```
We can now write Newton's method as,

```lisp
(define (newton-transform g)
    (lambda (x)
        (- x (/ (g x) ((derivative g) x)))
    )
)

(define (newtons-method g guess)
    (fixed-point (newton-transform g) guess)
)
```

So we can see for square root we have<br>y<sup>2</sup> = x<br>y<sup>2</sup> - x = 0

g(y) = y<sup>2</sup> - x

```lisp
(define (sqrt-newton x)
    (newtons-method (lambda (y) (- (square y) x)) 1.0)
)
```

### Abstractions and first-class procedure
Two implementation of square root using general procedures,
- fixed-point search
- Newton's method - also uses fixed-point search
Both of them begins with a function and find fixed point of some transformation of the function.

Generalizing that,
```lisp
(define (fixed-point-of-transform transform method guess)
    (fixed-point (transform method) guess)
)
```
So, we can write square root (average damped version) as,
```lisp
(define (sqrt-transform-avg x)
    (fixed-point-of-transform average-damp (lambda (y) (/ x y)) 1.0)
)
```
We can write square root (newton's method version) as,
```lisp
(define (sqrt-transform-newton x)
    (fixed-point-of-transform newton-transform (lambda (y) (- (square y) x)) 1.0)
)
```

To have a first-class status, elements must have some 'rights and priviliges':
- They may be named by variables
- They may be passed as arguments to procedures
- They may be returned as a results of procedures
- They may be included in data structures

If functions have these priviliges, then they are *first-class element* of the programming language.

