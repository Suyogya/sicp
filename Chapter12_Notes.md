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