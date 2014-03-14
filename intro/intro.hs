
mergesort [] = []
mergesort [x] = [x]
mergesort l  =      let   merge [] l = l
                          merge l [] = l
                          merge l@(h:t) l'@(h':t') = if h < h' then h:(merge t l') else h':(merge l t')
                          half = (length l) `div` 2
                    in merge (mergesort $ take half l) (mergesort $ drop half l)
