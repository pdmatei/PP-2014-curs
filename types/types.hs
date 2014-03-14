data Boolean = Top | Bot deriving (Show,Eq)

land :: Boolean -> Boolean -> Boolean
land Top Top = Top
land _ _ = Bot

lor Bot Bot = Bot
lor _ _ = Top

data Nat = Zero | Succ Nat deriving (Show,Eq)

add Zero x = x
add (Succ y) x = Succ $ add y x

showBoolean Top = "Top"
showBoolean Bot = "Bot"

showNat Zero = "Zero"
showNat (Succ x) = "Succ ("++showNat x++")"

n1 = Succ $ Succ $ Succ Zero
n2 = Succ $ Succ Zero

data List a = Nil | Cons a (List a) deriving Eq

l1 = Cons n1 $ Cons n2 Nil
l2 = Cons l1 Nil

len :: (List a) -> Nat
len Nil = Zero
len (Cons _ l) = Succ $ len l

-- ...
showListOfBooleans Nil = "Nil"
showListOfBooleans (Cons e l) = "Cons ("++showBoolean e++", "++showListOfBooleans l++")"

class PPShow a where
	ppshow :: a -> String

instance PPShow Boolean where
	ppshow = showBoolean

instance PPShow Nat where
	ppshow = showNat

showLis Nil = "Nil"
showLis (Cons e l) = "Cons ("++ppshow e++", "++showLis l++")"

instance (PPShow a) => PPShow (List a) where
	ppshow = showLis 


data Tree a = Empty | Node (Tree a) a (Tree a) deriving Show
t1 = Node (Node Empty Nil Empty) l1 Empty 

tcount Empty = Zero
tcount (Node l k r) = Succ $ (tcount l) `add` (tcount r)

class Container t where
	count :: t a -> Nat
	isEmpty :: t a -> Boolean
	isEmpty x = case count x of 
	               Zero -> Top
	               _ -> Bot
	contains :: (Eq a) => a -> t a -> Boolean
--  contains Zero (Cons Zero Nil)

instance Container Tree where
	count = tcount
	contains x Empty = Bot
	contains x (Node l k r) = if x == k then Top else (contains x l) `lor` (contains x r)
instance Container List where
	count = len

class PPFunctor t where
	ppmap :: (a->b) -> t a -> t b

instance PPFunctor List where
	ppmap f Nil = Nil
	ppmap f (Cons e l) = Cons (f e) $ ppmap f l

instance PPFunctor Tree where
	ppmap f Empty = Empty
	ppmap f (Node l k r) = Node (ppmap f l) (f k) (ppmap f r)

