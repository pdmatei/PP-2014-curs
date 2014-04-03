; Conventie 0: Un program este "o serie de liste"
'(1 2 3)
;[1,2,3]
; ' lista vazuta ca date
'(1 (+ 3 4) 5)
`(1 2 3)
; lista in care anumite elemente sunt vazute ca date, si altele sunt vazute ca program
`(1 ,(+ 5 6) ,3)
(if #f 0 (+ 2 1))
(display "Here !!\n")
(car '(1 2 3))
(cdr '(1 2 3))
(cons 1 '(2 3))
(null? '())

; Conventie 1 (apelul unei functii):
;(numele_unei_functii p1 p2 p3 p4 ...)
;(1 2 3 4)
(lambda (x) (+ x 1))
(lambda (x) 1)
(lambda (x) x)

; Conventie 2 (definitia unei functii anonime):
; (simbol1 simbol2 simbol3) unde:
; - simbol1 este cuvantul cheie "lambda"
; - simbol2 este o lista de parametri formali
; - simbol3 este corpul functiei

(lambda (x y) (+ x y))

; Conventie 3 (legarea unei variabile la o expresie)
(define func (lambda (x y) (+ x y)))
;(define var expr)
(define one 1)
(define lst '(1 2 3))

; O functie este in forma curry, daca isi primeste parametrii __ P E   R A N D __
; ---------- || --------  uncurrry --------- || ------------ __ TOTI ODATA __

(define fcurry (lambda (x) (lambda (y) (+ x y))))
; \x -> \y -> x + y
; \x y -> x + y

(define int (fcurry 4))
(define high (lambda (f) (f 10)))


; A. Write a piece of code which proves that expressions need not have a type
(define bogusList '(1 (2 3) #f "Matei" (1 . 2)))
(define bogusFunc (lambda (x) (if x 0 '())))
; B. Write a piece of code which proves that typing is done at runtime
(define runtimeTest (lambda (x) (+ 4 "c" x)))
(define rn (lambda (x) (if x 0 (+ 4 '()))))

; C. Write a piece of code which proves that evaluation is applicative
(define apl (lambda (x) 1))

(define x 1)

(eq? x 1)

; 1) the length of a list:
; 2) compute the sum of the elements from a list
; 3) find the maximum from a list
; 4) merge two sorted lists
; 5) reverse a list

(define g (lambda(x) (+ x 1)))
(define gg (lambda(x) (+ 2 4)))
(define ggg (lambda() (set! x 99)))

