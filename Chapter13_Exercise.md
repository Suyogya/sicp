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

## 1.35
Show that the golden ratio  (section 1.2.2) is a fixed point of the transformation x   1 + 1/x, and use this fact to compute  by means of the fixed-point procedure.

given,<br>
x = 1 + 1/x<br>
x<sup>2</sup> = x + 1<br>
x<sup>2</sup> - x - 1 = 0<br>
Solving quardratic equation we get,<br>
x = (1 + sqrt (5))/ 2

```lisp
(fixed-point (lambda (x) (+ 1 (/ 1 x))) 1.0)
```

## 1.36
Modify fixed-point so that it prints the sequence of approximations it generates, using the newline and display primitives shown in exercise 1.22. Then find a solution to xx = 1000 by finding a fixed point of x   log(1000)/log(x). (Use Scheme's primitive log procedure, which computes natural logarithms.) Compare the number of steps this takes with and without average damping. (Note that you cannot start fixed-point with a guess of 1, as this would cause division by log(1) = 0.)

### Answer
Modified fixed-point to display approximation it generates

```lisp
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
```

The fixed point solution for both with and without average damping
```lisp
(newline)
(display "solution for x^x = 1000")
(newline)
(fixed-point (lambda (x) (/ (log 1000) (log x))) 2.0)

(newline)
(display "solution for x^x = 1000 with average damping")
(newline)
(fixed-point (lambda (x) (average x (/ (log 1000) (log x)))) 2.0)
```

without average damping it takes **29** steps to converge and with average damping it converges in **8** steps

## 1.37
 a. An infinite continued fraction is an expression of the form<br>
f = N<sub>1</sub>(D<sub>1</sub> + N<sub>2</sub>/(D<sub>2</sub> + N<sub>3</sub>/(D<sub>3</sub> + ...)))

As an example, one can show that the infinite continued fraction expansion with the N<sub>i</sub> and the D<sub>i</sub> all equal to 1 produces 1/&phi;, where &phi; is the golden ratio (described in section 1.2.2). One way to approximate an infinite continued fraction is to truncate the expansion after a given number of terms. Such a truncation -- a so-called k-term finite continued fraction -- has the form,<br>
f = N<sub>1</sub>(D<sub>1</sub> + N<sub>2</sub>/(... + N<sub>k</sub>/(D<sub>k</sub>)))

Suppose that n and d are procedures of one argument (the term index i) that return the  N<sub>i</sub> and the D<sub>i</sub> of the terms of the continued fraction. Define a procedure cont-frac such that evaluating (cont-frac n d k) computes the value of the k-term finite continued fraction. Check your procedure by approximating 1/&phi; using

(cont-frac (lambda (i) 1.0)
           (lambda (i) 1.0)
           k)

for successive values of k. How large must you make k in order to get an approximation that is accurate to 4 decimal places?

b. If your cont-frac procedure generates a recursive process, write one that generates an iterative process. If it generates an iterative process, write one that generates a recursive process.

### Answer
a.Procedure for Continued fraction
```lisp
(define (cont-frac func-n func-d k)
    (define (recur i)
        (if (> i k) 0
            (/ (func-n i) (+ (func-d i) (recur (1+ i))))
        )
    )
    (recur 1)
)
```

It required 12 steps to get golden ratio accurate to 4 decimal places
```lisp
(/ 1 (cont-frac (lambda (i) 1.0)
            (lambda (i) 1.0)
            12)
)
```

b. Continued fraction procedure that generates iterative process

```lisp
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
```

## 1.38
In 1737, the Swiss mathematician Leonhard Euler published a memoir De Fractionibus Continuis, which included a continued fraction expansion for e - 2, where e is the base of the natural logarithms. In this fraction, the N<sub>i</sub> are all 1, and the D<sub>i</sub> are successively 1, 2, 1, 1, 4, 1, 1, 6, 1, 1, 8, .... Write a program that uses your cont-frac procedure from exercise 1.37 to approximate e, based on Euler's expansion.

### Answer
```lisp
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

;(integer-truncate n1 n2) gets quotient of n1/n2
```

## 1.39
A continued fraction representation of the tangent function was published in 1770 by the German mathematician J.H. Lambert:

tan x = x/(1 - x<sup>2</sup>/(3 - x<sup>2</sup>/(5 - x<sup>2</sup>/(7 - ...))))

where x is in radians. Define a procedure (tan-cf x k) that computes an approximation to the tangent function based on Lambert's formula. K specifies the number of terms to compute, as in exercise 1.37.

### Answer
```lisp
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
```

## 1.40
Define a procedure cubic that can be used together with the newtons-method procedure in expressions of the form

(newtons-method (cubic a b c) 1)

to approximate zeros of the cubic x3 + ax2 + bx + c.

### Answer
```lisp
(define (cubic a b c)
    (lambda (x)
        (+ (cube x) (* a (square x)) (* b x) c)
    )
)
```

## 1.41
Define a procedure double that takes a procedure of one argument as argument and returns a procedure that applies the original procedure twice. For example, if inc is a procedure that adds 1 to its argument, then (double inc) should be a procedure that adds 2. What value is returned by

(((double (double double)) inc) 5)

### Answer
```lisp
(define (double f)
    (lambda (x) (f (f x)))
)

(define (inc x)
    (1+ x)
)
```


```lisp
(((double (double double)) inc) 5)
(((double (lambda (x) (double (double x)))) inc) 5)
(((lambda (x) (double (double (double (double x))))) inc) 5)
((lambda (x) (double (double (double (inc (inc x)))))) 5)
...
...
((lambda (x) (double (double (inc (inc (inc (inc x))))))) 5)
((lambda (x) (double (inc (inc (inc (inc (inc (inc (inc (inc x)))))))))) 5)
((lambda (x) (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc x))))))))))))))))) 5)
21
```

## 1.42
 Let f and g be two one-argument functions. The composition f after g is defined to be the function x  f(g(x)). Define a procedure compose that implements composition. For example, if inc is a procedure that adds 1 to its argument

 ### Answer
 ```lisp
 (define (compose f g)
    (lambda (x) (f (g x)))
)
 ```

## 1.43
If f is a numerical function and n is a positive integer, then we can form the nth repeated application of f, which is defined to be the function whose value at x is f(f(...(f(x))...)). For example, if f is the function x   x + 1, then the nth repeated application of f is the function x   x + n. If f is the operation of squaring a number, then the nth repeated application of f is the function that raises its argument to the 2nth power. Write a procedure that takes as inputs a procedure that computes f and a positive integer n and returns the procedure that computes the nth repeated application of f. Your procedure should be able to be used as follows:

((repeated square 2) 5)
625

### Answer
```lisp
(define (repeated f n)
    (cond ((= n 1) f)
          ((even? n) (double (repeated f (/ n 2))))
          (else (compose f (repeated f (- n 1))))
    )
)
```

```lisp
;iterative version
(define (repeated-iter f n)
    (define (iter i result)
        (cond ((= i 1) result)
              ((even? i) (repeated (double result) (/ n 2)))
              (else (repeated (compose f result) (- n 1)))
        )
    )
    (iter n f)
)
```

## 1.44
The idea of smoothing a function is an important concept in signal processing. If f is a function and dx is some small number, then the smoothed version of f is the function whose value at a point x is the average of f(x - dx), f(x), and f(x + dx). Write a procedure smooth that takes as input a procedure that computes f and returns a procedure that computes the smoothed f. It is sometimes valuable to repeatedly smooth a function (that is, smooth the smoothed function, and so on) to obtained the n-fold smoothed function. Show how to generate the n-fold smoothed function of any given function using smooth and repeated from exercise 1.43.

### Answer
```lisp
(define (smooth f)
    (define dx 0.00001)
    (lambda (x) (/ (+ (f (- x dx)) (f x) (f (+ x dx)))))
)

(define (n-fold-smoothed f n)
    ((repeated smooth n) f)
)
```

## 1.45
We saw in section 1.3.3 that attempting to compute square roots by naively finding a fixed point of y  x/y does not converge, and that this can be fixed by average damping. The same method works for finding cube roots as fixed points of the average-damped y  x/y2. Unfortunately, the process does not work for fourth roots -- a single average damp is not enough to make a fixed-point search for y  x/y3 converge. On the other hand, if we average damp twice (i.e., use the average damp of the average damp of y  x/y3) the fixed-point search does converge. Do some experiments to determine how many average damps are required to compute nth roots as a fixed-point search based upon repeated average damping of y  x/yn-1. Use this to implement a simple procedure for computing nth roots using fixed-point, average-damp, and the repeated procedure of exercise 1.43. Assume that any arithmetic operations you need are available as primitives.

### Answer

It seems that average damping needs to be repeated x times for nth root such that,<br>
2<sup>x</sup> &le; n<br>
2<sup>x + 1</sup> &gt; n

i.e. for nth root between 2<sup>x</SUP> and 2<sup>x + 1</sup> it needs to be average damped x times
for e.g. for nth root between 16 and 31, it needs to be average damped 4 times since, 2<sup>4</sup> = 16 &le; n < 2<sup>5</sup>  

```lisp
(define (nth-root x n)
    (fixed-point 
        (
            (repeated average-damp 
                      (floor->exact (/ (log n) (log 2)))
            ) 
            (lambda (y) 
                (/ x (^ y (- n 1)))
            )
        ) 
        1.0)
)
```

## 1.46
Several of the numerical methods described in this chapter are instances of an extremely general computational strategy known as iterative improvement. Iterative improvement says that, to compute something, we start with an initial guess for the answer, test if the guess is good enough, and otherwise improve the guess and continue the process using the improved guess as the new guess. Write a procedure iterative-improve that takes two procedures as arguments: a method for telling whether a guess is good enough and a method for improving a guess. Iterative-improve should return as its value a procedure that takes a guess as argument and keeps improving the guess until it is good enough. Rewrite the sqrt procedure of section 1.1.7 and the fixed-point procedure of section 1.3.3 in terms of iterative-improve.

### Answer

```lisp
(define (iterative-improve improve close-enough?)
    (lambda (guess)
        (let ((new-guess (improve guess)))
            (if (close-enough? new-guess guess) 
                new-guess
                ((iterative-improve improve close-enough?) new-guess)
            )
        )
    )
)
```

```lisp
(define (sqrt-iterative-improve x)
    (
        (iterative-improve (average-damp (lambda (y) (/ x y)))
                            close-enough?
        )
        1.0
    )
)
```
```lisp
(define (fixed-point-iterative-improve f guess)
    (
        (iterative-improve f close-enough?)
        guess
    )
)
```