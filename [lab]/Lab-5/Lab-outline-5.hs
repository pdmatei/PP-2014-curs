{- 1. write an ADT which encodes arithmetic expressions containing +, * or parentheses -}
data Expr a = Val a | Plus (Expr a) (Expr a) | Mult (Expr a) (Expr a) | Par (Expr a)

{-- 2. display an expression nicely --}
instance Show a => Show (Expr a) where
    show (Val a) = show a
    show (e `Plus` e') = show e++" + "++show e'
    show (e `Mult` e') = show e++" * "++show e'
    show (Par e) = "("++show e++")"
    

e1 = (Val 4) `Mult` (Par ((Val 5) `Plus` (Val 6)))

{- 3. write a function which evaluates an expression. Also, write it's type -}
evale :: Num a => Expr a -> a
evale (Val a) = a
evale (e `Plus` e') = (evale e) + (evale e')
evale (e `Mult` e') = (evale e) * (evale e')
evale (Par e) = evale e

{- 4. Write a function which eliminates parentheses from an expression.
    e * (3) = e * 3
    (3) * e = e * (3)
    e * (e' + e'') = e * e' + e * e''
    (e' + e'') * e = e * (e' + e'')
    e * (e' * e'') = e * e' * e''
    (e' * e'') * e = e * (e' * e'')
    e + (e') = e + e' 
    (e') + e = e + (e')
 -}
rm v@(Val _) = v
rm (e `Plus` e') = (rm e) `Plus` (rm e')
rm (e `Mult` Par (e' `Plus` e'')) = rm (e `Mult` e') `Plus` rm (e `Mult` e'')
rm (Par((e' `Plus` e'')) `Mult` e) = rm (e' `Mult` e) `Plus` rm (e'' `Mult` e)
rm (e `Mult` e') = (rm e) `Mult` (rm e')
rm (Par e) = rm e

e2 = (Par ((Val 1) `Plus` (Val 2))) `Mult` (Par ((Val 5) `Plus` (Val 6)))

{- 5. Define a mini-programming language working with Numerics.
   The programming language has the following construct:
   x = e (assignment)
   if e then e' else e'' (conditional. Can only be an expression 0 evaluates to false, everything else evaluates to true)
   e ; e' (sequence)
   return x (x can only be a variable)
 -}
type Var = String
data Prog a = Is Var (Expr a) | If (Expr a) (Prog a) (Prog a) | S (Prog a) (Prog a) | Return Var

{- 6. display a program nicely -}
instance Show a => Show (Prog a) where
    show (v `Is` e) = v++" = "++show e
    show (If e e' e'') = "if ("++show e++") then "++show e'++"\n else "++show e''
    show (S e e') = show e++";\n"++show e'
    show (Return v) = "return "++v
    
e3 = (("X" `Is` (Val 3)) `S` ("Y" `Is` (Val 4))) `S` (If ((Val 0) `Mult` (Val 5)) (Return "X") (Return "Y"))

{- 7. define a function whose name must also be eval, which can evaluate a program -}
{- Notice that this class enforces a relation betwen a type constructor of kind * => *, denoted t
   and a type variable a -}
class (Num a) => Evaluable t a where
    eval :: (Num a) => t a -> a

instance (Num a) => Evaluable Expr a where
    eval = evale

{- by convention, we assume that our programs are correct, i.e. terminate with a return, and all used variables are declared. Also, we assume that each declaration is done in the global scope -}
instance (Num a) => Evaluable Prog a where
    eval e = let f l (v `Is` e) = (v, eval e):l
                 f l (If e e' e'') = if (eval e) == 0 then f l e'' else f l e'
                 f l (S e e') = f (f l e) e' -- evaluate e and get the bindings we need. Using the latter, evaluate e'
                 f l (Return x) = (filter (\(v,_)->v==x) l) -- simply leave only the returned variable in the context
              in snd $ head $ f [] e 

{- 8. Modify the current program such that:
        - expressions can also contain variables.
        - they are evaluated in a context, stored as a list of pairs (v,c) where each variable v is bound to a value c
        - evaluation of a program is also done in a context. Now, if can also contain variables
      
      Solution in the attached file
-}              
{- 9. Consider the following sentences:
    A sentence is None
    A sentence is an arbitrary entity such as Integer, String, etc.
    A person is an arbitrary entity such as -------------------------
    If s is a sentence and p is a person then " p likes s" is a sentence.
    If s is a sentence and p is a person then " p says s" is a sentence.
    
    Example:
    "Matei" likes 0
    "Matei" likes "Radu" likes 'c'
    0 likes 1 dislikes "Matei"
    "Matei" likes Nothing
    Build an ADT for sentences
-}
data Sentence a b = None | Entity b | Likes a (Sentence a b) | Says a (Sentence a b)

{- 10. build a function which displays sentences nicely -}
instance (Show a, Show b) => Show (Sentence a b) where
    show None = "Nothing"
    show (Entity x) = "Entity "++(show x)
    show (Likes x s) = (show x)++" likes "++(show s)
    show (Says x s) = (show x)++" says "++(show s)
    
s1 = "Matei" `Likes` ("Radu" `Says` (Entity 0))
s2 = "Radu" `Likes` ("Matei" `Likes` ("Matei" `Says` (Entity 0)))

{- 11. Write a function which takes a sentence and returns true is there is a person which likes what he says. -}
likesWhatSays None = False
likesWhatSays (Entity x) = False
likesWhatSays (Likes x (Says y s)) = x == y || likesWhatSays s
likesWhatSays (Likes x s) = likesWhatSays s
likesWhatSays (Says x s) = likesWhatSays s














{-
   11. Please pay attention to this.
   
   We want to use a function "from", in order to check in an element is a member of a list, or a pair:
    1 `from` [1,2,3]            from :: a -> [a] -> Bool
    1 `from` (1,2)              from :: a -> (a,a) -> Bool
-}

-- t :: * -> *
class From t where
    from :: (Eq a) => a -> t a -> Bool
--  
-- Here we are enrolling the type constructor [] :: * => *
instance From [] where
    from = elem
    
-- Here we are enrolling the type constructor ((,) Integer) :: * => *
-- We shall be examining pairs of type (a,Integer)
-- instance From ((,) Integer) where 
    -- from x (_,y) = x == y 

-- more general implementation than that above. The second element can be of any type.
-- (,) :: * => * => *
-- ((,) b) :: * => * 

instance From ((,) b) where 
    from x (_,y) = x == y 
    
--type UniquePair a = (a,a)
--instance From UniquePair where
    
-- both implementations suffer from a drawback. We only look at the second component of the pair.
-- How do we enroll (a,a) into From, and thus, explicitly saying that both elements need be of the same type:
-- One way would be: but the compiler does not let us define an alias as such.
-- type T a = (a,a)
-- instance From T where
    -- from x (y,z) = x == y || x == z
    
-- Thus, we are left with the ugly alternative, which actually does not solve the problem. But it is the best we can do.
data T a = P (a,a)
-- P :: (a,a) -> T a
instance From T where
    from x (P (y,z)) = x == y || x == z
    