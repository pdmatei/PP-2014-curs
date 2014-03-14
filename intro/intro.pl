contains(X,[H|T]) :- X = H.
contains(X,[H|T]) :- contains(X,T). 

/*
Queries:
contains(5,[1,2,3,4]).
contains(5,[1,2,3,4,5]).
contains(X,[1,2,3]).

contains(1,L).
length(L,2), contains(1,L).
*/