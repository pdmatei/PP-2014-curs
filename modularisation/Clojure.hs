f x y = x + y
--f = \x y-> x + y
close x = \x->f x 5
r1 = close 6
high g = g 6
r2 = high close
r3 = high (f 5)
r4 = high f
--r5 = high (f 5 6)