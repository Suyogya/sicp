# 2.1 Introduction to Data Abstraction
Abstracting procedure - separate the way procedure would be used from the details of the how procedure would be implemented.

*Data Abstraction* - methodology that enables us to isolate how a compound data object is used from the details of how it is constructed from more primitive data objects

**Structure the programs that are to use compound data objects so that they operate on "abstract data"**
- Program should use data in such a way as to make no assumption the data that are not strictly necessary for performing the task at hand.
- "concrete" data representation is defined independent of the programs that use the data.
- Interface between these two parts of our system will be a set of procedures called *selectors* 
- procedure that implement the abstract data in terms of the concrete represenation are called *constructors*

## 2.1.1 Example: Arithmetic Operations for Rational Numbers
To be able to add, substract, multiply and divide rational numbers.

Assume, we have a way of construction rational numbers from a numerator and denominator. Also, given rational number we have a way of extracting (or selecting) its numerator and denominator.

Let us further assume that the constructor and selectors are procedures
- (make-rat \<n> \<d>) returns the rational number whose numerator is the integer \<n> and denominator is the integer \<d>
- (numer \<x>) returns the numerator of the rational number \<x>
- (denom \<x>) returns the denominator of the rational number \<x>

 Rational number basic mathematical operations are:
 1. (n<sub>1</sub>/d<sub>1</sub>) + (n<sub>2</sub>/d<sub>2</sub>) = (n<sub>1</sub>d<sub>2</sub> + n<sub>2</sub>d<sub>1</sub>)/(d<sub>1</sub>d<sub>2</sub>)
 2. (n<sub>1</sub>/d<sub>1</sub>) - (n<sub>2</sub>/d<sub>2</sub>) = (n<sub>1</sub>d<sub>2</sub> - n<sub>2</sub>d<sub>1</sub>)/(d<sub>1</sub>d<sub>2</sub>)
 3. (n<sub>1</sub>/d<sub>1</sub>) - (n<sub>2</sub>/d<sub>2</sub>) = (n<sub>1</sub>n<sub>2</sub>/d<sub>1</sub>d<sub>2</sub>)
 4. (n<sub>1</sub>/d<sub>1</sub>) / (n<sub>2</sub>/d<sub>2</sub>) = (n<sub>1</sub>d<sub>2</sub>/d<sub>1</sub>n<sub>2</sub>)
 5. (n<sub>1</sub>/d<sub>1</sub>) = (n<sub>2</sub>/d<sub>2</sub>) if and only if n<sub>1</sub>d<sub>2</sub> = n<sub>2</sub>d<sub>1</sub>

Procedures in lisp
```lisp
(define (add-rat x y)
   (make-rat (+ (* (numer x) (denom y)) (* (numer y) (denom x)))
            (* (denom x) (denom y))
   )
)
(define (sub-rat x y)
   (make-rat (- (* (numer x) (denom y)) (* (numer y) (denom x)))
            (* (denom x) (denom y))
   )
)
(define (mul-rat x y)
   (make-rat (* (numer x) (numer y))
            (* (denom x) (denom y))
   )
)
(define (div-rat x y)
   (make-rat (* (numer x) (denom y))
            (* (denom x) (numer y))
   )
)
(define (equal-rat? x y)
   (= (* (numer x) (denom y))
      (* (denom x) (numer y))
   )
)
``` 

This defines the rational numbers in terms of selector and constructor.

### Pairs
Language provides a compound called  a `pair` constructed with primitive procedure `cons`.

```lisp
(define x (cons 1 2))
=> (car x)
1
=> (cdr x)
2
 ```
`cons` can be used to form pairs whose elements are pairs

```lisp
(define x (cons 1 2))
(define y (cons 3 4))
(define z (cons x y))
=> (car (car z))
1
=> (car (cdr z))
3
```

Data objects constructed from paris are called *list-structured* data.

### Representing rational numbers
We can use `cons` to define rational number selector and constructors

```lisp
(define (make-rat n d) (cons n d))
(define (numer x) (car x))
(define (denom x) (cdr x))
(define (print-rat x)
    (newline)
    (display (numer x))
    (display "/")
    (display (denom x))
)
```

Now we can try our procedures,
```lisp
(define one-half (make-rat 1 2))
(define one-third (make-rat 1 3))
(print-rat (add-rat one-half one-third))
(print-rat (mult-rat one-half one-third))
(print-rat (add-rat one-third one-third))
```

We can write a better definition for make-rat (reduce rational number to lowest terms) as,
```lisp
(define (make-rat n d)
    (let ((div (gcd n d)))
            (cons 
                ((if (> (* n d) 0) + -) 0 (abs (/ n div))) 
                (abs (/ d div))
            )
    )
)
```

## 2.1.2 Abstraction Barriers
The underlying idea of data abstraction is
- to identify for each type of data object a basic set of operations
- then to use only those operations in manipulating the data

For e.g. Programs that use rational numbers manipulate them solely in terms of procedure supplied "for public use": `add-rat`, `sub-rat`, `mul-rad`, `div-rat` and `equal-rat`?

Thise, in turn, are implemented solely in terms of constructor and selector `make-rat`, `numer` and `denom`

These again are implemented in terms of pairs which provide `cons`, `car` and `cdr` procedure

** The procedures at each level are the interfaces that define the abstraction barriers and connect the different levels.

- This makes program much easier to maintain and modify.

For e.g. if we modify the selectors of rational number (`numer` and `denom`) to perform reduction whenever we access the parts,
```lisp
(define (make-rat n d)
  (cons n d))
(define (numer x)
  (let ((g (gcd (car x) (cdr x))))
    (/ (car x) g)))
(define (denom x)
  (let ((g (gcd (car x) (cdr x))))
    (/ (cdr x) g)))
```

When we change from one representation to the other, the procedures, `add-rat`, `sub-rat` and so on do not have to be modified at all.