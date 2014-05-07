(define i 0)
(define f (lambda (x y) (if (= (x) 0) y (f (lambda()(- (x) (y))) (lambda()(+ ((g y)) ((g y))))))))
(define g (lambda (x) (begin (set! i (+ i 1)) (lambda()(* 2 (x))))))

((f (lambda() 5) (lambda() 1)))
i

;global i=0
;def f(x,y){
;           if (x == 0)
;              return y
;           else return f(x-y,g(y)+g(y))
;           }
;def g(x) {i++, return 2*x}
; f(5,1)

; f(5-1,g(1)+g(1)) nimic nu e evaluat inca
; f(5-1-(g(1)+g(1)),g(g(1)+g(1)) + g(g(1)+g(1)))
; la ultima iteratie:
; - se evalueaza 5-1-(g(1)+g(1)) la 0 (i este acum 2)
; - se evalueaza g(g(1)+g(1)) + g(g(1)+g(1)) (i este 2 + 6)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;      Cum facem ca evaluarea sa fie normala in Scheme      
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; cum intarzii evaluarea unei expresii arbitrare e ?
; (lambda () e)
; cum fortez evaluarea unei expresii e a carei evaluare a fost intarziata?
; (e)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;      Cum facem ca evaluarea sa fie LENESA in Scheme      
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; cum produc evaluarea lenesa a unei expresii arbitrare e ?
; (delay e)
; cum fortez evaluarea unei expresii e a carei evaluare a fost facuta sa fie lenesa?
; (force e)

(define i 7)
(define normale (lambda()(+ 1 (begin (display "Lazy !!!!") 1))))
(define lazye (delay (+ 1 (begin (display "Lazy !!!!") 1))))
(define e2 (delay (+ 1 i)))
(define e3 (lambda() (+ 1 i)))
