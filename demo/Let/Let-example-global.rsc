module Let-Example

import Let;

// Rename all bound variables in an Exp
// Version 2: using global variables
// Cnt: global counter to generate fresh variables
// rel[Var,Var]: global renaming table

global int Cnt = 0;
global rel[Var,Var] Rn = {};

Var newVar() {
    global int Cnt;  
    Cnt = Cnt + 1;
    return parseString("x" + toString(Cnt));
}

Exp rename(Exp E) {
    global int Cnt;
    global rel[Var,Var] Rn;
    switch (E) {
    case let <Var V> = <Exp E1> in <Exp E2> end: {
         Var Y = newVar();
         Rn = {<V, Y>} + Rn;
         return [| let <Y>= <rename(E1)>
                   in 
                      <rename(E2)>
                   end 
                |];
          }

    case <Var V>: return Rn[V];

    default: return E;
    }
}