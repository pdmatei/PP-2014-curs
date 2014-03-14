class C {
	String s;
	public C (String s){this.s = s;}
	public void reset (){s = "Hi ";}
}

public class SideEffects {

	public static int outside = 0;
	
	public static String f (int x, C c){
		int i = 0;
		String str = "world ";
		while (i<x){
			str += ".";
			outside++;
			i++;
		}
		c.s += str;
		System.out.println(c.s);
		return str;
	}
	
	public static void main(String[] args) {
		C c = new C("Hello ");
		c.reset();
		String r = f(5,c);
		System.out.println(r);
	}

}
