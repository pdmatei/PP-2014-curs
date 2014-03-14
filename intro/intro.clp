(defrule r1
    (headacke ?x)
    (temperature ?x)
    =>
    (assert (flu ?x)))

(defrule r2
    (flu ?x)
    (friend ?x ?y)
    =>
    (assert (fluSuspect ?y)))

(defrule r3
    (fluSuspect ?x)
    (headacke ?x)
    =>
    (assert (flu ?x)))
