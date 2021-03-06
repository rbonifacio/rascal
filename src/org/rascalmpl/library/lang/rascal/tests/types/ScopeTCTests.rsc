@bootstrapParser
module lang::rascal::tests::types::ScopeTCTests

import lang::rascal::tests::types::StaticTestingUtils;

test bool noEscapeFromToplevelMatch() = undeclaredVariable("bool a := true; a;");	

test bool localRedeclarationError1() = redeclaredVariable("int n; int n;");	

test bool localRedeclarationError2() = redeclaredVariable("int n = 1; int n;");	
	
test bool localRedeclarationError3() = redeclaredVariable("int n = 1; int n = 2;");	

test bool ifNoLeak1() = undeclaredVariable("if (int n := 3) {n == 3;} else  {n != 3;} n == 3;");	

test bool ifNoLeak2() = undeclaredVariable("if(int n \<- [1 .. 3], n\>=3){n == 3;}else{n != 3;} n == 3;");	
	
test bool blockNoLeak1() = undeclaredVariable("int n = 1; {int m = 2;} n == 1 && m == 2;");	

test bool innerImplicitlyDeclared() = undeclaredVariable("int n = 1; {m = 2;}; return n == 1 && m == 2;");	
	
test bool varsInEnumeratorExpressionsShouldNotLeak() = undeclaredVariable("int n \<- [1,2]; n == 1;");	
	