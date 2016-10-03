# 1.1 The Elements of Programming
Two kinds of elements in programming language
* procedure - "stuff" we want to manipulate
* data - descriptions of the rules for manipulating the data

## 1.1.1 Expressions
In lisp, you type an *expression*, interpreter responds with result of *evaluating* expression. Number is a type of expression.
Expressions representing numbers may be combined with an expression representing primitive procedure

```lisp
(+ 137 349)
486
```

Combination - Expressions formed by delimiting list of expressions within parentheses in order to denote procedure application (leftmost element => operator, Rest of the element => operands)

## 1.1.2 Naming and Environment
Name identifies a *variable* whose *value* is the object.

In Scheme, we name things with `define` 
``` lisp
(define size 2)
size
=> 2
(*5 size)
=> 10
```

## 1.1.3 Evaluating Combination
To evaluate combinations, interpreter
1. evaluates the subexpressions of the combinations
2. Apply the procedure *that is the value of the leftmost subexpression (the operator)* to the arguments *that are the values of the other subexpressions (the operands)* 

First step dictates, in order to evaluate combination, we must first evaluate each element of the combination. Thus, evaluation rule is *recursive*.

For exampble,
```lisp
(* (+ 2 (* 4 6)) (+ 3 5 7))
(* (+ 2 24) (+ 3 5 7))
(* 26 (+ 3 5 7))
(* 26 15)
390
```

Also, repeated application of the first step brings us to point where we need to evaluate primitive expressions (numerals and built-in operators)
We stipulate
* the values of numerals are the numbers that they name
* the values of built-in operators are machine instruction that carry out the corresponding operation
* the values of other names are the objects associated with those names in the Environment

In Lisp, it is meaningless to speak of the value of an expression `(+ x 1)` without specifying any information about the environment that would provide a meaning for symbol `x`

This evaluation rule does not handle definition. When we say `(define x 3)`, the purpose of `define` is precisely to associate `x` with value.

## 1.1.4 Compound Procedures
Some elements of powerful programming language discussed so far,
* Numbers and arithmetic operations are primitive data and Procedures.
* Nesting of combinations provides a mean of combining operations.
* Definitions that associate name with values provide a limited means of abstraction.

*procedure definition* is a technique by which compound operation can be given a name and then referred to as a unit.
```lisp
(define (square x ) (* x x))
```
 To Square someting, multiply it by itself.

 This is a *compound procedure* named square. The procedure represents the operation of multiplying something by itself.

 General form of procedure definition is
 ```lisp
 ( define (<name> <formal parameters>) <body>)
 ```

`<name>` is symbol to be associated with procedure definition in the environment.

`<formal parameter>` names used within the body of the procedure to refer to corresponding arguments

`<body>` is an expression that will yield the value of the procedure application when formal parameters are replaced by the actual argument.

## 1.1.5 The Substitution Model for Procedure application
Assuming the mechanism for applying primitive procedures to arguments is built into interpreter, application process for compound procedures is,
* To apply a compound procedure to arguments, evaluate the body of the procedure with each formal parameter replaced by corresponding argument.

```lisp
(define (sum-of-square x y)
    (+ (square x) (square y))
)

(define (f a)
    (sum-of-squares (+ a 1) (* a 2))
)
```

To evaluate `(f 5)`

Body of `f`:
```lisp
(sum-of-square (+ a 1) (* a 2))
```
Replace formal parameter `a` by the argument `5`:
```lisp
(sum-of-square (+ 5 1) (* 5 2))
```

Continuing evaluation
```lisp
(sum-of-square 6 10)

;Replacing body of sum-of-square
(+ (square 6) (square 10))

;using definition of square
(+ (* 6 6) (* 10 10))

;reduces to
(+ 36 100)

;gives
136
```

This process is called *substitution model* for procedure application.
* it helps us think about procedure application (not how the interpreter actually works).

### Applicative order Vs. Normal order
In previous method of evaluation, interpreter first evaluates the operator and the operand, then applies the resulting procedure to the resulting argument.

Alternately, interpreter would not evaluate the operands until their values were needed.  Instead, *first substitute operand expressions for parameters until it obtained an expression involving only primitive operators*

For e.g. `(f 5)` would proceed as,
```lisp
(sum-of-square (+ 5 1) (* 5 2))
(+ (square (+ 5 1)) (square (* 5 2)))
(+ (* (+ 5 1) (+ 5 1)) (* (* 5 2) (* 5 2)))
(+ (* 6 6) (* 10 10))
(+ 36 100)
136
```
*Note: evaluation of `(+ 5 1)` and `(* 5 2)` are performed twice*

* *normal-order evaluation* 
    - Fully expand and then reduces
    - Lazy evaluation - Delay evaluation of procedure arguments until the last possible moment
* *applicative-order evaluation* 
    - evaluate the arguments and then apply


Lisp uses applicative-order evaluation because of
- added efficiency
- normal-order evaluation becomes much more complicated when we leave the realm of procedures that can be modeled by substitution

## 1.1.6 Conditional Expressions and Predicates
*case analysis* is done using `cond`

e.g.
```lisp
(define (abs x)
    (cond ((> x 0) x)
          ((= x 0) x)
          ((< x 0) (- 0 x))
    )
)
```

General form of this expression
```lisp
(cond (<p1> <e1>)
      (<p2> <e2>)
      (<pn> <en>)
)
```

expressions `(<p> <e>)` are the *clauses*.
`<p>` is the Predicate
`<e>` is the consequent expression

*predicate* - procedure that returns true or false

procedure absolute value can be written as

```lisp
(define (abs x)
    (cond ((< x 0) (- 0 x))
          (else x)
    )
)
```
`else` is special symbol used in place of <p> in the final clause

`if` is a restricted type of conditional. Absolute value using `if`:
```lisp
(define (abs x)
    (if (< x 0) (- 0 x) x)
)
```

General form of expression
```lisp
(if <predicate> <consequent> <alternate>)
```

Lisp also supports logical composition operators
* (and \<e<sub>1</sub>\> ... \<e<sub>n</sub>\>)
* (or \<e<sub>1</sub>\> ... \<e<sub>n</sub>\>)
* (not \<e<sub>1</sub>\> ... \<e<sub>n</sub>\>)

## 1.1.7 Square Roots by Newton's method
Difference between methematical functions and computer procedure - **Procedures must be effective**

square-root function can be defined as,
square-root of x = y such that y &ge; 0 and y<sup>2</sup> = x

Direct translation of this definition to computer procedure would be,
```lisp
(define (sqrt x)
    (the y (and (> y = 0)
                (= (square y) x)
            )
    )
)
```

The contrast is, describing properties of things (math) and describing how to do thing.

Most common way to compute square root is to use Newton's method of successive approximation.
- If we have guess y, we can get better guess by averaging y with x/y.

In terms of procedure,
```lisp
(define (sqrt-iter guess x)
    (if (good-enough? guess x)
            guess
            (sqrt-iter (improve guess x) x)
    )
)
(define (improve guess x)
    (average guess (/ x guess))
)

(define (average x y)
    (/ (+ x y) 2)
)

(define (good-enough guess x)
    (< (abs (- (square guess) x)) 0.00001)
)

(define (sqrt x)
    (sqrt-iter 1.0 x)
)
```

## 1.1.8 Procedures as Black-Box abstraction
Not concerned with how the procedure computes its result, only with what it does, *procedural abstraction*.

For e.g. as far as good-enough? procedure is concerned square is not quite a procedure but abstraction of a procedure

Procedure definition should be able to suprress detail.

### Local names
Implementer's choice of names for procedure's formal parameters should not matter.

Parameters are local to the bodies of their respective procedures.

Name of the formal parameter does not matter. Such name is called *bound variable* and procedure definition is said to *bind* its formal parameter. If variable is not bound, its *free*.

Set of expressions for which a binding defines a name is called the *scope* of that name.

Formal parameters of the procedure have the body of the procedure as their scope.

### Internal definitions and block structure
We can rewrite square root so the procedures like `sqrt-iter, good-enough? and improve` are not separate procedures

```lisp
(define (sqrt x)
    (define (good-enough? guess x)
        (< (abs (- (square guess) x)) 0.0001)
    )
    (define (improve guess x)
        (average guess (/ x guess))
    )
    (define (sqrt-iter guess x)
        (if (good-enough? guess x)
            guess
            (sqrt-iter (mprove guess x) x)
        )
    )
    (sqrt-iter 1.0 x)
)
```

Such nesting of definition is called *block structure*
- simplest solution to name packaging problem.

We can simplify such internalized procedure by using the bound variables. For e.g. `x` is bound in the definition of sqrt, all internalized procedures (`good-enough?, improve, and sqrt-iter`) are in the scope of `x`.
- We do not need to pass `x` explicitly to each procedure.
- We allow `x` to be free variable in the internal definitions

This is called *lexical scoping*

```lisp
(define (sqrt x)
    (define (good-enough? guess)
        (< (abs (- (square guess) x)) 0.0001)
    )
    (define (improve guess)
        (average guess (/ x guess))
    )
    (define (sqrt-iter guess x)
        (if (good-enough? guess x)
            guess
            (sqrt-iter (improve guess x) x)
        )
    )
    (sqrt-iter 1.0 x)
)
```


