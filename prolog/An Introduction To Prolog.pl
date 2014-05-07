/*
1. Prolog revisited. 
*/

strong(X) :- fit(X), healthy(X). %1
team(X,Y) :- strong(X), fit(Y). %2
team(X,Y) :- strong(Y), fit(X). %3
strong(X) :- smart(X). %4
strong(a). %5
fit(b). %6
fit(c). %7
healthy(b). %8
smart(b). %9

%
/*

We consider the clauses to be numbered from 1 to 9. The proof tree for team(X,Y) is:

    team(X,Y):
       | (C2)
	strong(X),                          fit(Y).
	   | (C1)                            | (C6)            |(C7) 
	 fit(X),   healthy(X).               Y=b. (X=b,Y=b)    Y = c.
	   | (C6)     | (C8)
	  X=b.        ok
 
 First result: X=b,Y=b. Second result X=b, Y=c. Re-satisfaction of healthy(X) is not possible.
 Re-satisfying fit(X):
	
	team(X,Y):
       | (C2)
	strong(X),                          fit(Y).
	   | (C1)                
	 fit(X), healthy(X).                 
	   | (C7)    |  
	  X=c.      fail.
	  
Thus, re-satisfying fit(X) does not work. Prolog proceeds to re-satisfy strong(X):
	team(X,Y):
       | (C2)
	strong(X),    fit(Y).
	   | (C4)       | (C6)    | (C7)    
	smart(X).       Y = b    Y = c
	   | (C9)      
	  X=b.      

Re-satisfying fix(Y) is no longer possible. We now again try to re-satisfy strong(X):

	team(X,Y):
       | (C2)
	strong(X),    fit(Y).
	   | (C5)       | (C6)    | (C7)    
	X = a          Y = b    Y = c

The subsequent output is X=a, Y=b and X=a, Y=c.
Now, the whole process repeats itself, in mirror. The process can also be inspected in Prolog, using the debugger:
	- activate the graphical debugger
	- set the trace flag to "on". 
	- run a query

************************************************
	2. Unification, equality and assignment
************************************************

Prolog allows us to formulate more complicated goals in Prolog, e.g.

team(X,Y), X = Y.

which asks if there is an X which unifies with Y such that team(X,Y). Another query, with the requirement that X and Y do
not unify:

team(X,Y), X \= Y.

Now, to better understand unification, the one presented in the last lecture, we need more examples:
 a = a.
 1 = 1.
 [1] = [_].
 [1] = [H|T].
 
 Note the result of the following unification:
 1 + 2 = 2 + 1.
 
 The result is false, since the expressions, although are equal if evaluated, do not unify. E.g.
 1 + X = 2. yields false.
 1 + X = 1 + 1. yields true.
 
 On the other hand:
 1 + 2 =:= 1 + 2.
 yields true. =:= evaluates arithmetic operations, and compares the result.
 
 Next, consider the following implementation of a function which adds up the numbers from a list.
 
 One unfortunate attempt may be:
 sum([],0).
 sum([H|T],R) :- sum(T,R), R = H + R.
 
 Consider the interogation sum([1],R). To satisfy this goal, we must satisfy sum([],R), which is satisfied
 via the first clause and makes R bound to the value of 0. Further on, we must satisfy R = H + R. Since R is now
 bound to 0, the unification fails, and thus the result is false.
 A key thing to keep in mind, is that, in Prolog, once a variable is bound to an expression, via unification, it
 remains bound, and cannot be modified in any way. This will become obvious later on.

 So, we need another variable, Rp: 
 
*/

sum([],0).
sum([H|T],R) :- sum(T,Rp), R = H + Rp.

%
/*
The interogation sum([1,2,3],R) will give us R = 1+ (2+ (3+0)), left ne-evaluated.
To solve this, we can replace =, which is unification, by "is". The latter binds a variable to an evaluated 
arithmetic expression.
*/

summ([],0).
summ([H|T],R) :- summ(T,Rp), R is H + Rp.

/*
************************************************
	3. Compound terms
************************************************

Recall our previous unification example:
friend(father(X),Y) = friend(Z,father(Z))

Here, father(X) is not a predicate, but a compound term. 
Compound terms can be defined and used in Prolog exactly like atoms. 
One natural application is actually in the implementation of lists, which resembles the well-known
ADT approach:

Let void designate the empty list,
and cons(H,T) designate a compound term, representing a list whose first element is H and rest of
elements is T. Then, we have:
*/
isEmpty(void).
car(cons(H,_),H).
cdr(cons(_,T),T).

summm(void,0).
summm(cons(H,T),R) :- summm(T,Rp), R is H + Rp.

/*
 The interogation summm(cons(1,cons(2,cons(3,void))),R). Will yield the expected result.
 Actually, in Prolog, lists are implemented precisely as compound terms, and [H|T] acts as a 
 convenient syntactic sugar.
 
 Compound terms are a natural an convenient way for representing ADTs in Prolog.
 
 For instance, they can be used to represent recursive structures such as HTML:
 
 html(head(PageTitle,scripts),body(div(table(Hello,World)))).
 
 Now, parsing can be done naturally, using unification. A simple example:
*/
assign(p1,html(head('PageTitle',scripts),body(div(table('hello','world'))))).
/*
assign is an ad-hoc clause, not something predefined, which allows us to assign a name to
a page structure. Next:
*/
getTitle(PageName,Title) :- assign(PageName,Cnt), Cnt = html(head(Title,_),_).

/*
We first identify the content assigned to the pagename, and next use unification to extract the title.
The intuition is similar to that from ADTs. The mechanism, however, is inherently different.

Exercice. Extract the second line from the table.

************************************************
	4. Typing
************************************************

The result of the unification:
 X = [1,two,3+2].
 
 clearly indicates that Prolog has dynamic typing, and a loose type system which is similar to that of Scheme.
 Type checks are performed at runtime:
  X is []. and
  [] =:= 1.
  fails since is binds only arithmetic expressions, and =:= compares only arithmetic expressions.
  
 We also have methods for inspecting types:
 compound([]).
 compound([1]). <- this shows that our previous statement regarding how lists are implemented is correct.
 
 number([]).
 number(2).

************************************************
	5. Cut (!), negation and provability
************************************************

One powerful mechanism for controlling goal re-satisfaction is the cut (!). 
Consider the following example:

all(X,Y) :- fst(X), snd(Y).
fst(a).
fst(b).
snd(a).
snd(b).

How many pairs X,Y satisfy all(X,Y) ?
4.

Next, consider:

all(X,Y) :- fst(X), snd(Y), !.
fst(a).
fst(b).
snd(a).
snd(b).


The cut operator has prevented the re-satisfaction of the goal. To better understand how, examine:
*/
all(X,Y) :- fst(X), !, snd(Y).
fst(a).
fst(b).
snd(a).
snd(b).

/*
Here, the satisfied goals are X=a, Y=a and X=a Y=b.
In a clause of the form :- G1,... Gi, !, Gi+1, ... Gn.
the cut will prevent re-satisfaction of the goals G1 to Gi. In effect, these goals will be satisfied only
once, and thus, only the first-found path in the proof tree corresponding to G1-Gi will be explored.
However, Gi+1 to Gn will be re-satisfied.

Technically, ! is a goal which succeds the first time, and fails upon the first attempt of re-satisfaction.
To conclude, ! is used to cut paths from the proof tree of a goal.

What happens if ! is placed at the beginning of the clause, i.e.
all(X,Y) :- !, fst(X), snd(Y).

What can you do to concretely differentiate:
all(X,Y) :- !, fst(X), snd(Y).

from
all(X,Y) :- fst(X), snd(Y).

?

Next, consider the following program:
*/
woman(W):- person(W), hasGender(W,woman).
person(alice).
hasGender(alice,woman).
person(mary).

/*
The goal woman(mary). will obviously fail. Does this, in principle mean that mary is not a woman?
There are two view-points to this:

1. The domain has insufficient information regarding mary, hence we cannot say that she is not woman.
This corresponds to the open-world assumption.

2. Since we cannot arguably prove that mary is a woman, she is not a woman. 
   This corresponds to the closed-world assumption.
   
Prolog adopts the closed-world assumption since woman(mary) is indeed false.
Also, Prolog has the operator \+G which satisfies if \+G cannot be proved. In our particular
example \+ woman(mary) is true, because we cannot prove woman(mary).

Due to the closed world assumption, logical negation is problematic in Prolog.
~woman(mary) is not the same as \+woman(mary). The first is a given fact, namely that mary is not
a woman, the second equates to the inability of proving woman(mary) - maybe due to insufficient
specification of the domain. 
Logical negation is not implemented in Prolog. In it's place, and along with \+, we have:
"negation as failure":

*/
ppnot(G) :- G,!,fail.
ppnot(_).

/*
assume ppnot(X). where X is some goal. If X succeeds, then the ! prevents re-satisfaction of G and ppnot(G),
and the ppnot(X) goal will simply fail. On the other hand, if X does not succede, then re-satisfaction by the
second clause is done, which will succede no matter the X.

Difference between \+ and not:
Essentially, there is no difference between \+ and not. Moreover, X \= Y actually stands for:
not(X = Y). In effect, this means that we cannot prove X and Y unify.

Also, regarding the limitations of Prolog, consider the following goal.
Arguably, inf(X). cannot be proved to be true in finite time. Thus, inf(X). will loop.
Also, \+ inf(X) will loop also. Thus, Prolog is subject to Godel's incompleteness theorems.
Although we known that inf(X) is true (see second clause). We cannot prove it, nor dis-prove it.

*/
inf(X):- inf(X).
inf(_).
%
/*
************************************************
	5. Interesting applications
************************************************

a. Backtracking

Backtracking applications usually consider an exponential number of potential solutions.
If often happens that such candidates are the powerset of a given set.

Consider, for instance, the k-Clique problem. Let us encode a graph as:
*/
nodes([1,2,3,4]).
edges([[1,2],[2,3],[3,4],[1,3]]).
/*
To make the graph unoriented, we can add the clause isEdge:
*/
isEdge(X,Y) :- edges(L), member([X,Y],L), !.
isEdge(X,Y) :- edges(L), member([Y,X],L), !.
/* next, we build a clause which selects k nodes from the graph, in a manner similar to
   the choice algorithms.
*/
selectk([],0).
selectk([X|Cp],K) :- K>0, nodes(V), Kp is K-1, selectk(Cp,Kp), member(X,V), not(member(X,Cp)).

/* note that this example choses a permutation of K elements from the set. We can change our strategy:
*/

pws([],[]).
pws([_|T],P) :- pws(T,P). 
pws([H|T],[H|P]) :- pws(T,P). 

knodes(K,C) :- nodes(V), pws(V,C), length(C,K).

/* finally, we can implement the clique verification:
*/
clique(K,C) :- knodes(K,C), not((member(X,C), member(Y,C), X \= Y, not(isEdge(X,Y)))).
%
/*
An interesting application of Prolog is in solving the constraint satisfaction problem CSP:

csp(X,[1,2,3,4],R,(X>2,X<4)).

X is a variable, [1,2,3,4] is a list of possible values of X, (X>2,X<4) is an expression
which expresses a condition on X, when csp is satisfied, R should be bound to the list of
values of X, out of the possible ones, which satisfy the condition.
In this example R = [2,3].

An initial attempt is:

csp(X,[H|T],[X|Rp],Cond):- X is H, Cond, csp(X,T,Rp,Cond).
csp(X,[H|T],Rp,Cond):- X is H, not(Cond), csp(X,T,Rp,Cond).

However, this fails since, when attempting to satisfy csp(X,T,Rp,Cond), X is no longer a free
variable ocurring in Cond, but a bound variable. It has been bound once X is H was satisfied.

How do we avoid this?
An insight is that we need to move the recursive satisfaction check, before the current one:
csp(X,[H|T],[X|Rp],Cond):- csp(X,T,Rp,Cond), X is H, Cond.
csp(X,[H|T],Rp,Cond):- csp(X,T,Rp,Cond), X is H, not(Cond).

However, this does not competely solve the problem, since X is still bound when Cond is performed.
The solution can be found by looking at negation:
%neg(Goal) :- Goal, !, fail.
%neg(_).

When attempting to satisfy Goal, certain variables may become bound in the process, which is not
what we want. However, if Goal is satisfied the negation fails. If Goal is not satisfied, the negation:
- succeeds;
- leaves all potential variables occurring in Goal free.

This is exactly what we want: we use not as a container for making checks which bind variables. If
negation succeds, the variables will remain free:
*/
csp(_,[],[],_).
csp(X,[H|T],Rp,Cond):- csp(X,T,Rp,Cond), /* recursively satisfy the constraint, and get Rp */
                       not((X is H, Cond)), /* the condition fails for X equal to H, negation succedes */
					   !. /*do not try to re-satisfy csp from this point, because the condition failed*/
csp(X,[H|T],[H|Rp],Cond) :- csp(X,T,Rp,Cond). /* if we have reached this clause, we are trying to
                          re-satisfy, as a result of negation failure. Hence, H satisfies the condition, so
						  we add it.

						   csp(X,[1,2,3,4,6,7,8],R,(X>2,X<7)).
						  */

