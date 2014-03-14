f x = let temp i str = if i<x then temp (i+1) (str++".")
                              else str 
	  in temp 0 "world "

{-
public static String f (int x){
		int i = 0;
		String str = "world ";
		while (i<x){
			str += ".";
			i++;
		}
		return str;
	}
	-}