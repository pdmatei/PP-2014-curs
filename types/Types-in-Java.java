abstract class Boolean implements Show {
	abstract Boolean land (Boolean b);
}

class Top extends Boolean {

	@Override
	Boolean land(Boolean b) {
		return b;
	}

	@Override
	public String show() {
		return "Top";
	}}
class Bot extends Boolean {

	@Override
	Boolean land(Boolean b) {
		return this;
	}

	@Override
	public String show() {
		return "Bot";
	}}

abstract class Nat {
	abstract Nat add (Nat n);
}

class Zero extends Nat {

	@Override
	Nat add(Nat n) {
		return n;
	}}
class Succ extends Nat {
	private Nat p;

	public Succ (Nat p){
		this.p = p;
	}
	@Override
	Nat add(Nat n) {
		return new Succ(p.add(n));
	}
}
/**
 * Abstract Data Types can be implemented in almost every modern language. However, some of the nice features such as 
 * pattern matching cannot be achieved in e.g. Java. There is also the "new representation vs. new functionality problem". In OO, adding
 * a new functionality is cumbersome: all classes need to be fitted with it. In Haskell, this is straightforward using pattern 
 * matching. However, in Haskell, adding a new representation is cumbersome: all functionalities must be re-adjusted. On the other 
 * hand, doing that in Java is straightforward by deriving a new class.
 * 
 * 
 * @author Matei
 *
 */

abstract class List<T extends Show> implements Show {
	public abstract T head ();
	public abstract List<T> tail ();
}
class Nil extends List{
	@Override
	public Show head() {
		return null;
	}
	@Override
	public List tail() {
		// TODO Auto-generated method stub
		return null;
	}
	@Override
	public String show() {
		return "Nil";
	}
	}
class Cons<T extends Show> extends List<T> {
	private T e;
	private List<T> l;
	public Cons (T e, List<T> l){
		this.e = e;
		this.l = l;
	}
	@Override
	public T head (){
		return e;
	}
	@Override
	public List<T> tail() {
		return l;
	}
	@Override
	public String show() {
		/* At this point, as in Haskell, we would like to formulate a constraint, asking e to be show-able. We can do this in two ways:
		 * 1) the ugly way: make a cast (Show) and make sure T implements Show. 
		 * 2) the ok way: using wildcards.
		 *  */
		return "Cons ("+e.show()+","+l.show()+")";
	}
	
} 

/** Polymorphic datatypes can be built in Java using Generics, and most OO languages support this. E.g. in C++ we have templates
 *  and the Standard Template Library. However, the way generics work is completely different. 
 * @author Matei
 *
 */

interface Show {
	public String show ();
}

public class Types {

	/* initial :
	 * public static <T> Integer length(List<T> a)
	 */
	public static <T extends Show> Integer length(List<T> a){
		if (a instanceof Nil)
			return 0;
		else
			return 1 + length(a.tail());
	}
	
	public static void main(String[] args) {
		List<Boolean> l = new Cons<Boolean>(new Top(),new Nil());
		Boolean e = l.head();
		
		/* The first thing to note is that the above generic code will be translated by the compiler to:
		List l' = new Cons(new Top(),new Nil());
		Boolean e = (Boolean)l.head();
		
		Hence, only the behavior of polymorphism is achieved, but not the idea. There is no polymorphic type inference here.
		This can be seen by inspecting Nil, and the method Head: it returns an object.
		
		However, what can be done in Java, and is actually a central part of it, is called subtype or inclusion polymorphism.
		This means:
		1) I am allowed to declare a type as a subtype of another, and by doing so, ensure that the subtype has all the functionality
		which the (super)type offers.
		2) I am allowed to declare a variable (such as l) of a type, and then assign it an instance of a subtype -> and the program works !
		3) I am allowed to do casts, which essentially means I can control how the compiler interprets the type of a variable.
		4) I am allowed to inspect the type of an object in the program itself.
		Inclusion/subtype polymorphism is not possible in Haskell.
		
		Finally, in OO, parametric polymorphism can be achieved, again using generics: We have implemented the method there.
		However, note that this is not the type of polymorphism we have in Haskell, just the behavior of it.
		*/
		
		System.out.println(l.show());
		
		/*Type classes can be simulated in Java, using interfaces. Conceptually, an interface is exactly what a Haskell type-class is.
		 * We can implement the display of a function as in Haskell.
		 * Of course, this is not how it works natively in Java.
		 * 
		 * 
		 * One final conclusion regarding Java types vs Haskell types is related to relationships between types. 
		 * OO relies on a complete hierarchy of types: all types are derived automatically from Object, and may be parents for other types.
		 * This is what we have called inclusion polymorphism.
		 * In Haskell, there is no such hierachy. A relationship between types can be specified only via type-classes, i.e. sets of types. They, on the 
		 * other hand, can be put together into a hierarchy.
		 * 
		 * 
		 * Finally, gadgets such as Functor or Container cannot be implemented in Java. Unlike Java, in Haskell we have the ability to play around with 
		 * type constructors, which is why we have such flexibility.
		 * 
		 * */
		
	}

}
