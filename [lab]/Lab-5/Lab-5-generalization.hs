{- we generalize expressions such that they contain variables -}
data Expr a = Val a | CVar Var | Plus (Expr a) (Expr a) | Mult (Expr a) (Expr a) | Par (Expr a)

{-- display an expression nicely --}
instance Show a => Show (Expr a) where
    show (Val a) = show a
    show (CVar a) = a
    show (e `Plus` e') = show e++" + "++show e'
    show (e `Mult` e') = show e++" * "++show e'
    show (Par e) = "("++show e++")"
    
e0 = (CVar "X") `Mult` (Par ((Val 5) `Plus` (Val 6)))
e1 = (Val 4) `Mult` (Par ((Val 5) `Plus` (Val 6)))

{- this function evaluates an expression given that some variables are bound to some values in a list called l
    The addition consists in the list l of bound variables
-}
evale :: Num a => [(Var,a)] -> Expr a -> a
evale _ (Val a) = a
evale l (CVar x) = snd $ head $ filter (\(v,e)->v == x) l -- return the value assigned to x in l
evale l (e `Plus` e') = (evale l e) + (evale l e')
evale l (e `Mult` e') = (evale l e) * (evale l e')
evale l (Par e) = evale l e

{- The ADT remains the same
 -}
type Var = String
data Prog a = Is Var (Expr a) | If (Expr a) (Prog a) (Prog a) | S (Prog a) (Prog a) | Return Var

{- display a program nicely -}
instance Show a => Show (Prog a) where
    show (v `Is` e) = v++" = "++show e
    show (If e e' e'') = "if ("++show e++") then "++show e'++"\n else "++show e''
    show (S e e') = show e++";\n"++show e'
    show (Return v) = "return "++v
    
e3 = (("X" `Is` (Val 3)) `S` ("Y" `Is` (Val 4))) `S` (If ((Val 0) `Mult` (Val 5)) (Return "X") (Return "Y"))

{- b: tipul containerului (Expr a, sau Prog a)
 - a: tipul continut
 -}

class (Num a) => Evaluable t a where
    eval :: (Num a) => [(Var,a)] -> t a -> a

instance (Num a) => Evaluable Expr a where
    eval = evale

instance (Num a) => Evaluable Prog a where
    eval l' e = let f l (v `Is` e) = (v, eval l e):l
                    f l (If e e' e'') = if (eval l e) == 0 then f l e'' else f l e'
                    f l (S e e') = f (f l e) e' -- evaluate e and get the bindings we need. Using the latter, evaluate e'
                    f l (Return x) = (filter (\(v,_)->v==x) l) -- simply leave only the returned variable in the context
                in snd $ head $ f l' e 

e4 = (("X" `Is` (Val 3)) `S` ("Y" `Is` ((CVar "X") `Mult` (Val 4)))) `S` (If ((CVar "Y") `Plus` (Val (-12))) (Return "X") (Return "Y"))
