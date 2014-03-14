interface Unary <R,A> { R f (A x); }
interface TwoAry <R,A,B> {R f (A x, B y); }

public class Clojure {
	public static void main (String [] args){
		final TwoAry two = new TwoAry<Integer,Integer,Integer>(){
			@Override 
			public Integer f (Integer x, Integer y) {return x + y;}
		};
		Unary close = new Unary<Integer,Integer>(){
			@Override
			public Integer f (Integer y){
				return (Integer)two.f(5,y);
			}
		};
		System.out.println(close.f(6));		
	}
}