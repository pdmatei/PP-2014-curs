/* BFS exploration of a graph G, encoded as a list [V,E], where V is a list of nodes, and E is a list of directed edges [U,V]. St is the initial nodes. The list of explored nodes in L */
%bfs(St,G,L).
/*                     graph, grey nodes, exploration */
bfsv(St,G,L) :- visitbfs(G,[St],[],L).
visitbfs(_,[],Acc,R) :- reverse(Acc,R).
/*                         take the last node from Visit, not already explored, add his neighbors to visit, and explore further on */
visitbfs(G,Visit,Acc,L) :- lst(Visit,X), not(member(X,Acc)), adjlist(X,G,Adj), delete(Visit,X,Vp), append(Adj,Vp,Vpp), !, visitbfs(G,Vpp,[X|Acc],L). 
/*                         the last node from visit was explored previously. Remove it and ignore his neighbors */
visitbfs(G,Visit,Acc,L) :- lst(Visit,X), member(X,Acc), delete(Visit,X,Vp), !, visitbfs(G,Vp,Acc,L). 

/* first element from the list, respectively, the last */
fst([H|_],H).
lst([H],H) :- !.
lst([_|T],X) :- lst(T,X).

/* satisfies for all nodes R which are adjacent to the node X in G */
%adjacent(V,G,R).
adjacent(V,[_,E],U) :- member([V,U],E).

/* builds a list L of all nodes which are adjacent to the node X in G */
%adjlist(V,G,L).
/*
adjlist(V,G,L) :- temp(V,G,[],L).
temp(V,G,Acc,L) :- adjacent(V,G,U), not(member(U,Acc)), !, temp(V,G,[U|Acc],L).
temp(_,_,Acc,Acc). 
*/
%
/* alternative elegant implementation for adjlist: */
adjlist(V,G,L) :- findall(U,adjacent(V,G,U),L).

/* we are now making a general traversal where the strategy is parametrized */
dfs([H|_],H).
bfs([H],H) :- !.
bfs([_|T],X) :- bfs(T,X).

/* arbitrary visit, with selective strategy */
visit(S,G,Str,L) :- visit(G,[S],[],Str,L).
visit(_,[],Acc,_,R) :- reverse(Acc,R).
visit(G,Visit,Acc,Str,L) :- call(Str,Visit,X),  % Str(Visit,X).
                            delete(Visit,X,Vp), 
                            (not(member(X,Acc)),!,adjlist(X,G,Adj),append(Adj,Vp,Vpp), Accp = [X|Acc]; Vp = Vpp, Accp = Acc), 
                            visit(G,Vpp,Accp,Str,L).

                            %test graph: [[1,2,3,4,5,6,7],[[1,2],[2,3],[3,4],[1,4],[1,5],[1,6],[4,3],[4,5]]]
%
/* Graph representation
1
2  4  5  6
3
4
3  5

G :- F, C1.
G :- F, C2.

G :- F, (C1 ; C2).

bfs(S,G,L) :- visit(S,G,first,L).


Tasks:
1. Auxiliaries
- Write a predicate which extracts the first element of a graph
- Write one which extracts the last element of a graph
- Write a predicate which removes all occurrences of an element from a list

2. Explorations
- Write a predicate which builds the adjacency list of a node from a graph represented as above (explain findall)
- Write a predicate which constructs the BFS traversal of a graph
- Write a predicate which constructs the traversal of a graph, where the strategy is given as input (explain call)


*/

