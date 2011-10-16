module demo::basic::Quine

import IO;
import String;

public void quine(){
  println(program); /*3*/
  println("\"" + escape(program, ("\"" : "\\\"", "\\" : "\\\\")) + "\";"); /*4*/
}

str program = /*1*/
"module Quine

import IO;
import String;

public void quine(){
  println(program);
  println(\"\\\"\" + escape(program, (\"\\\"\" : \"\\\\\\\"\", \"\\\\\" : \"\\\\\\\\\")) + \"\\\";\");
}

str program ="; /*2*/