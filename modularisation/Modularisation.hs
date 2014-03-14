l1="        ***** **            ***** **    "
l2="     ******  ****        ******  ****   "
l3="    **   *  *  ***      **   *  *  ***  "
l4="   *    *  *    ***    *    *  *    *** "
l5="       *  *      **        *  *      ** "
l6="      ** **      **       ** **      ** "
l7="      ** **      **       ** **      ** "
l8="    **** **      *      **** **      *  "
l9="   * *** **     *      * *** **     *   "
l10="      ** *******          ** *******    "
l11="      ** ******           ** ******     "
l12="      ** **               ** **         "
l13="      ** **               ** **         "
l14="      ** **               ** **         "
l15=" **   ** **          **   ** **         "
l16="***   *  *          ***   *  *          "
l17=" ***    *            ***    *           "
l18="  ******              ******            "
l19="    ***                 ***             "

img = [l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11,l12,l13,l14,l15,l16,l17,l18,l19]
format x = unwords $ map (\l -> l++"\n") x

-- foldr
ppfoldr f acc [] = acc
ppfoldr f acc (x:xr) = f x (ppfoldr f acc xr)

ppfoldl f acc [] = acc
ppfoldl f acc (x:xr) = f (ppfoldl f acc xr) x

ppsum l = ppfoldr (+) 0 l
ppprod l = ppfoldr (*) 1 l
-- ++
ppappend = ppfoldr (:) 
pprev = ppfoldl (\x y->x++[y]) [] 

ppmap f = foldr ((:).f) [] 
doubleall = ppmap (\x->2*x)

mat = [[1,2,3],[4,5,6],[7,8,9]]

transpose ([]:_) = []
transpose m = (map head m):(transpose (map tail m))

mult a b = map (\line -> map (\col -> foldr (+) 0 (zipWith (*) line col)) (transpose b)) a

p = [[0.0],[3.0],[0.0]]
rx angle = [[1,0,0],[0, (cos angle), 0-(sin angle)],[0, (sin angle), (cos angle)]]

rotatex angle p = (rx angle) `mult` p

im = ["-->","-->","VVV"]

flipV = reverse
flipH = map reverse 

rotLeft = flipV . transpose
rotRight = flipH . transpose

scalex = map (\line -> foldr (\h t-> h:h:t) [] line)
scaley = foldr (\l t->l:l:t) [] 

scalexy = scalex . scaley

neg = map (\ln-> map (\c-> if c == '*' then ' ' else '*') ln)
dim = map (\ln-> map (\c-> if c == '*' then '.' else ' ') ln)
