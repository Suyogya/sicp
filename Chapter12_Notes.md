# 1.2 Procedures and the Process They Generate

A procedure is a pattern for the *local evolution* of a computational process.
- specifies how each stage of process is built upon the previous stage.

## 1.2.1 Linear Recursion and Iteration

We define factorial as

`n! = n * (n - 1) * (n - 2) * ..... * 3 *2 * 1`

`n! = n * (n - 1)!`

Procedure for factorial:
```lisp
(define (factorial n)
    (if (< n 2)
        1
        (* n (factorial (- n 1)))
    )
)
```

By substitution model
```lisp
(factorial 6)
(* 6 (factorial 5))
(* 6 (* 5 (factorial 4)))
(* 6 (* 5 (* 4 (factorial 3))))
(* 6 (* 5 (* 4 (* 3 (factorial 2)))))
(* 6 (* 5 (* 4 (* 3 (* 2 (factorial 1))))))
(* 6 (* 5 (* 4 (* 3 (* 2 1)))))
(* 6 (* 5 (* 4 (* 3 2))))
(* 6 (* 5 (* 4 6)))
(* 6 (* 5 24))
(* 6 120)
720
```

This is the linear recursive process

Another way to define factorial would be
```lisp
(define (factorial n)
    (define (iter product count)
        (if (> count n)
            product
            (iter (* product count) (1+ count)) 
        )
    )
    (iter 1 1)
)
```

By Substitution model
```lisp
(factorial 6)
(iter 1 1)
(iter 1 2)
(iter 2 3)
(iter 6 4)
(iter 24 5)
(iter 120 6)
(iter 720 7)
720
```

This is the iterative process

Recursive process:
- expansion occurs as process builds up a chain of *deferred operations*
- Contraction occurs as the operations are performed

Iterative process
- Method does not grow or sink
- **The program variable provide a complete description of the state of the process at any point**

*Note: recursive procedure is not recursive process. When we say procedure is recursive, we are referring to the syntactic fact that the procedure definition refers to procedure itself.*

Most implementation of common languages interpret any recursive procedure in such a way that the amount of memory grows with number of procedure calls, even when the process is, in principle, iterative. Hence, languages can describe iterative process only by using special purpose "looping constructs"

The property to execute iterative process in a constant space, even if described by recursive procedure, is called *tail recursive*.

## 1.2.2 Tree Recursion

Fibonacci numbers can be defined by the rule
Fib (n) = 0 if n = 0
Fib (n) = 1 if n = 1
Fib (n) = Fib (n - 1) + Fib (n - 2) otherwise

It can be defined as
```lisp
(define (fib n)
    (cond ((< n 2) n)
          (else (+ (fib (- n 1)) (fib (- n 2))))
    )
)
```

Notice, that the fib procedure calls itself twice each time it is invoked. It is a terrible way to compute Fibonacci numbers because, it does so much redundant computation.

The value of Fib(n) grows exponentially with n.
Fib (n) is the closest integer to &#x3a6;<sup>n</sup> / 5<sup>&#xbd;</sup>

&#x3a6; = (1 + 5<sup>&#xbd;</sup>) / 2

is the *golden ration*, which satisfies the equation

&#x3a6;<sup>2</sup> = &#x3a6; + 1

Thus, the process uses number of steps that grows exponentially with input.

Also, the space required grows linearly with the input.

Better way to calculate Fibonacci would be the iterative process

```lisp
(define (fib-iter n)
    (define (iter a b count)
        (if (= count n)
            a
            (iter b (+ a b) (1+ count))
        )
    )
    (iter 0 1 0)
)

```

Although, iterative process of fibonacci is better than the recursive process, tree-recursive process are not useless. When writing process that operate on hierarchically structured data, tree recursion is natural and powerful.

 ### Example: Counting Change
 How many different ways can we make change of $ 1.00, given half-dollars, quarters, dimes, nickels, and pennies? More generally, can we write a procedure to compute the number of ways to change any given amount of money?

 The number of ways to change amount a using n kinds of coins equals
 - The number of ways to change amount a using all but the first kind of coin, plus
 - The number of ways to change amount a - d using all n kinds of coins, where d is the denomination of the first kind of coin

 We can use following rules:
 - If a is 0, we should count that as 1 way to make change
 - If a is less than 0, we should count that as 0 ways to make change
 - If n is 0, we should count that as 0 ways to make change

The definition of the procedure is,
```lisp
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
```

## 1.2.3 Orders of Growth
*order of growth* is used to measure the resources required by a process as input becomes larger.

Let `n` be the size of problem, `R(n)` be the amount of resources the process requires for problem of size `n`.

We say `R(n)` has order of growth &Theta;(f(n)), written R(n) = &Theta;(f(n)) if there are positive constant k<sub>1</sub> and k<sub>2</sub> independent of n such that

k<sub>1</sub>f(n) &le; R(n) &le; k<sub>2</sub>f(n)

for any sufficiently large value of n.

For the recursive process of computing factorial, the number of steps grows proportionally to the input n. Thus, the steps required for this process grows as &Theta;(n).

Also the space required grows as &Theta;(n)

## 1.2.4 Exponentiation
Recursive definition of exponent,<br>
b<sup>n</sup> = b.b<sup>n-1</sup><br>
b<sup>0</sup> = 1

```lisp
(define (expt b n)
    (if (= n 0) 1
        (* b (expt b (- n 1)))
    )
)
```
Order of Growth &Theta;(n) both time and space.

In Linear Iteration
```lisp
(define (expt-iter b n)
    (define (iter result count)
        (if (> count n) result
            (iter (* b result) (1+ count))
        )
    )
    (iter 1 1)
)
```
Order of Growth &Theta;(n) time and &Theta;(1) space

We can interprete exponent as successive squares,<br>
b<sup>n</sup> = (b<sup>2</sup>)<sup>n/2</sup> for even n<br>
b<sup>n</sup> = b.(b<sup>2</sup>)<sup>(n-1)/2</sup> for odd n<br>

```lisp
(define (fast-expt b n)
    (cond ((= n 0) 1)
          ((even? n) (square (expt b (/ n 2))))
          (else (* b (expt b (- n 1))))
    )
)
```
Order of growth &Theta;(log n)

## 1.2.5 Greatest Common Divisor
GCD of two integers a and b is defined as the largest integer that divides both a and b with no remainder.

if r is the remainder when a is divided by b, then the common divisors of a and b are precisely the same as common divisors of b and r.

Thus,<br>
GCD(a, b) = GCD (b, r)

```lisp
(define (GCD a b)
    (if (= b 0) a
        (GCD b (Remainder a b))
    )
)
```

The order of growth is &Theta;(log n)

**Lam&eacute;'s Theorem**: If Euclid's Algorithm requires k steps to compute GCD of some pair, then the smaller number in the pair must be greater than or equal to the kth Fibonacci number.

If the process takes k steps,<br>
n &ge; Fib(k) &#x2248; &phi;<sup>k</sup>/5<sup>1/2</sup>

Therefore the number of steps k grows as logarithm (to the base &phi;) of n. Hence, the order of growth is &Theta;(log n)

## 1.2.6 Testing for Primality

### Searching for divisors
The most straight forward way, is by testing n for divisibility by successive integers starting with 2.
```lisp
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
```

### The Fermat Test
**Fermat's Little Theorem** If n is a prime number and a is any positive integer less than n, then a raised to nth power is congruent to a modulo n.

Two numbers are said to be *congruent modulo n* if they both have the same remainder when divided by n.<br>
    i.e. a and b are *congruent modulo n* if, ` (remainder a n) = (remainder b n)`

The remainder of number a when divided by n is, *remainder of a modulo n* or *a modulo n*

If n is not prime, most of the numbers a < n will not satisfy above relation.

Given a number n,
- Pick a random number a < n
- compute the remainder a<sup>n</sup> modulo n
- If the result is not equal to a, then n is certainly not prime ((remainder a n) = a)
- If it is a, Repeat the test until confident

To calculate a<sup>n</sup> modulo n,

```lisp
(define (expmod base exp n)
    (cond ((= exp 0) 1)
          ((even? exp) (remainder (square (expmod base (/ exp 2) n)) n))
          (else (remainder (* base (expmod base (- exp 1) n) n)))
    )
)
```
This reduction step (in cases where exponent `e` is greater than 1) is based on fact that for any integers x, y, and m,<br>
(x * y) modulo m = (x modulo m * y modulo m) modulo m<br>
so b<sup>e</sup> modulo m = (b<sup>e/2</sup> modulo m * b<sup>e/2</sup> modulo m) modulo m<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;= (b<sup>e/2</sup> modulo m)<sup>2</sup> modulo m

Then Fermat's Test,
```lisp
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

```

### Probabilistic methods
Answer obtained from Fermat's Test is only probably correct.
- If n ever fails the Fermat's test, n is definitely not a prime
- The fact that n passes the test, while strong indication, is not a guarantee that n is prime.

There do exist numbers that fool Fermat test.

These type of algorithms are known as *Probabilistic algorithms*