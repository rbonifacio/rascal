module Let-Example

import Let;

// Rename all bound variables in an Exp
// Version 1: purely functional
// Exp: given expression to be renamed
// rel[Var,Var]: renaming table
// Int: counter to generate unique variables

Exp rename(Exp E, rel[Var,Var] Rn, Int Cnt) {
    switch (E) {
    case let <Var V> = <Exp E1> in <Exp E2> end:
         return [| let <parseString("x" + toString(Cnt))> = 
                       <rename(E1, Rn, Cnt)>
                   in 
                       <rename(E2, {<V, Y>} + Rn, Cnt+1)>
                   end
                |];
          
    case <Var V>: return Rn[V];

    default: return E;
    }
}