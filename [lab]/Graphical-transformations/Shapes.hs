{-# LANGUAGE TypeSynonymInstances #-}

{-# LANGUAGE TypeSynonymInstances, FlexibleInstances, OverlappingInstances, UndecidableInstances #-}

{-
     An image can be seen as a matrix of pixels, here represented by the character *
-}
type Image = [String]
type Point = (Integer,Integer)

{-   The class draw models drawable elements, namely those which can be drawn on an image -}
class Draw a where
    draw :: a -> Image -> Image
    
{-   A point is drawable -}
instance Draw Point where
    draw (x,y) img = let (x',y') = (fromIntegral x,fromIntegral y) -- this conversion is necessary due to the type of take/drop
                         -- changes the element at pos i with e
                         put e i img = (take (i-1) img) ++ [e] ++ (drop i img)
                         -- extracts the element at pos i
                         get i img = head $ drop (i-1) img
                     in put (put '*' x' $ get y' img) y' img
  
  
                     {- 
     Unary and Binary symbolically encode image transformations
-}

-- draw ((1,2)::Point)  ... -> eroare (de tip)
-- :t (1,2) :: (Num a, Num b) => (a,b)
-- :t draw (Draw a) => a -> Image -> Image


data Unary = Rotate90 | FlipV | FlipH | Invert
data Binary = Combine 

flipV = reverse

{-
       A shape is a vectorial entity, defined by it's coordinates
-}
data Shape = Circle Point Integer | 
--             Rectangle Point Point | 
             Segment Point Point deriving Eq
             
{-     The class Rasterize models entities which can be transformed to a collection of points   
       A rasterizable element is automatically drawable.
-}
class Rasterize a where
    rasterize :: a -> [Point]

{-    All Rasterizable entities are also drawable. This is an enrollment in Draw of all rasterizable elements
      Note that this enrollment will fail at compile-time if the "Overlapping Instances" flag is turned off. 
-}
instance (Rasterize a) => Draw a where
    draw x img = foldr draw img $ rasterize x

instance Rasterize Shape where
    rasterize (Circle (cx,cy) r) = 
        let step = pi/8
            angles = map (\x->x*step) [1..]
            -- computes pairs: ( r*cos(angle), r*sin(angle))
            sincosList = map (\a-> (round $ (fromIntegral r)*(cos a),round $ (fromIntegral r)*(sin a))) angles
            points = map (\(cos,sin)-> (cx+cos,cy+sin)) $ take 20 sincosList  
        in points    

                           -- y - y' = m (x - x')
    rasterize (Segment (x,y) (x',y')) = 
        let [nx,ny,nx',ny'] = map fromIntegral [x,y,x',y'] 
            slope = (nx'-nx)/(ny'-ny)
            xvalues = drop ((fromIntegral x)-1) $ take ((fromIntegral x')-(fromIntegral x)) [1..]
            pointsFloat = map (\vx->(vx,slope*(vx-nx')+ny')) xvalues
            -- we need to make points Integers, to be able to draw them
            points = map (\(x,y)->(round x,round y)) pointsFloat
            in points                                 

{-
     A canvas describes a sequence of operations which construct an image. It consists of:
     - drawing shapes in the current canvas
     - applying an unary transformation on the canvas
     - applying a binary transformation on the canvas
-}
data Canvas = Empty Integer | Put Shape Canvas | Transform Unary Canvas -- | Combine Binary Canvas Canvas

{-
    A canvas can be transformed to an image, by applying all transformations:  
-}
toImage :: Canvas -> Image
-- creating an empty canvas of a given size
toImage (Empty i) = 
        let rep a 0 = []
            rep a sz = a:(rep a (sz-1))
            canvas sz = rep (rep ' ' sz) sz
        in canvas i
        
toImage (Put s c) = draw s $ toImage c
--toImage (Transform FlipV c) = flipV $ toImage c
-- etc.


{--  A canvas can also be displayed, which is useful for tests
-}
display c = putStr $ format $ toImage c
format x = unwords $ map (\l -> l++"\n") x


cv1 = Put (Segment (1,1) (15,15)) $ Put (Circle (8,8) 5) (Empty 20)

s1 = Segment (1,2) (6,7)
c1 = Circle (20,20) 5

