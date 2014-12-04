module experiments::Compiler::Examples::Tst

import lang::rascal::\syntax::tests::ImplodeTestGrammar;
import ParseTree;
import Exception;

import IO;


public data Num = \int(str n);
public data Exp = id(str name) | eq(Exp e1, Exp e2) | number(Num n);
public Exp number(Num::\int("0")) = Exp::number(Num::\int("01"));

public anno loc Num@location;
public anno loc Exp@location;
public anno map[int,list[str]] Num@comments;
public anno map[int,list[str]] Exp@comments;

public data Number = \int(str n);
public data Expr = id(str name) | eq(Expr e1, Expr e2) | number(Number n);
public Expr number(Number::\int("0")) = Expr::number(Number::\int("02"));

public anno loc Number@location;
public anno loc Expr@location;
public anno map[int,list[str]] Number@comments;
public anno map[int,list[str]] Expr@comments;

public Exp implodeExp(str s) = implode(#Exp, parseExp(s));
public Exp implodeExpLit1() = implode(#Exp, expLit1());
public Exp implodeExpLit2() = implode(#Exp, expLit2());

public Expr implodeExpr(str s) = implode(#Expr, parseExp(s));
public Expr implodeExprLit1() = implode(#Expr, exprLit1());
public Expr implodeExprLit2() = implode(#Expr, exprLit2());


// ---- test1 ----

test bool test11() { try return Exp::id(_) := implodeExp("a"); catch ImplodeError(_): return false;}

test bool test12() { try return Exp::number(Num::\int("01")) := implodeExp("0"); catch ImplodeError(_): return false;}

test bool test13() { try return Exp::eq(Exp::id(_),Exp::id(_)) := implodeExp("a == b"); catch ImplodeError(_): return false;}

test bool test14() { try return Exp::eq(Exp::number(Num::\int("01")), Exp::number(Num::\int("1"))) := implodeExp("0 == 1"); catch ImplodeError(_): return false;}

test bool test15() { try return  Expr::id(_) := implodeExpr("a"); catch ImplodeError(_): return false;}

test bool test16() { try return Expr::number(Number::\int("02")) := implodeExpr("0"); catch ImplodeError(_): return false;}

test bool test17() { try return Expr::eq(Expr::id(_),Expr::id(_)) := implodeExpr("a == b"); catch ImplodeError(_): return false;}

test bool test18() { try return Expr::eq(Expr::number(Number::\int("02")), Expr::number(Number::\int("1"))) := implodeExpr("0 == 1"); catch ImplodeError(_): return false;}

// ---- test2 ----

test bool test21() { try return Exp::eq(Exp::id("a"),Exp::id("b")) := implodeExpLit1(); catch ImplodeError(_): return false;}

test bool test22() { try return Exp::eq(Exp::id("a"),Exp::number(Num::\int("11"))) := implodeExpLit2(); catch ImplodeError(_): return false;}

test bool test23() { try return Expr::eq(Expr::id("a"),Expr::id("b")) := implodeExprLit1(); catch ImplodeError(_): return false;}

test bool test24() { try return  Expr::eq(Expr::id("a"),Expr::number(Number::\int("11"))) := implodeExprLit2(); catch ImplodeError(_): return false;}
