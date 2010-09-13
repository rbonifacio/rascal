module box::box::Default
import box::box::Input;
import box::box::Basic;
import ParseTree;
import box::Concrete;
import box::Box;
import IO;

alias UserDefinedFilter = Box(Tree t) ;

list[UserDefinedFilter] userDefinedFilters = [ 
       getBasic
       ];
 
public text toText(loc asf){
     Tree a = inPut(asf);
     setUserDefined(extraRules);
     text r = toText(a);
     writeData(asf, r, ".txt");
     return r;
     }

public text toLatex(loc asf){
     Tree a = inPut(asf);
     setUserDefined(extraRules);
     text r = toLatex(a);
     writeData(asf, r, ".tex");
     return r;
     } 
    
// Don't change this part 

public Box extraRules(Tree q) {  
   for (UserDefinedFilter userDefinedFilter<-userDefinedFilters) {
           Box b = userDefinedFilter(q);
           if (b!=NULL()) return b;
           }
   return NULL();
   }
