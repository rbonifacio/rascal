module experiments::vis2::Translate

import experiments::vis2::Figure;
import experiments::vis2::Properties;
import Node;
import String;
import IO;
import List;
import util::Cursors;
import Type;


/*
 * Translate a Figure to HTML + JSON
 */


// Translation a figure to one HTML page

public str fig2html(str title, str site_as_str){
	// TODO: get rid of this absolute path
	vis2 = "/Users/paulklint/git/rascal/src/org/rascalmpl/library/experiments/vis2";
	
	return "\<html\>
		'\<head\>
        '	\<title\><title>\</title\>
        '	\<link rel=\"stylesheet\" href=\"<vis2>/lib/reset.css\" /\>
        '	\<link rel=\"stylesheet\" href=\"<vis2>/lib/Figure.css\" /\>
        '	\<script src=\"http://d3js.org/d3.v3.min.js\" charset=\"utf-8\"\>\</script\>
        '	\<script src=\"<vis2>/JSFigure.js\"\>\</script\>
        
		'\</head\>
		'\<body\>
		'\<div id=\"figurearea\"\> 
		'\</div\>
		'\<script\>
		'	askServer(\"<site_as_str>/initial_figure\");
  		'\</script\>
		'\</body\>
		'\</html\>
		";
}

/******************** Translate figure primitives ************************************/

// Graphical elements

str trJson(_box(FProperties fps)) = 
	"{\"figure\": \"box\" <trPropsJson(fps)> }";

str trJson(_box(Figure inner, FProperties fps)) = 
	"{\"figure\": \"box\" <trPropsJson(fps,sep=", ")> 
    ' \"inner\":  <trJson(inner)> 
    '}";

str trJson(_text(str txt, FProperties fps)) = 
	"{\"figure\": \"text\", \"textValue\": <strArg(txt)> <trPropsJson(fps)> }";

str trJson(_hcat(list[Figure] figs, FProperties fps)) = 
	"{\"figure\": \"hcat\"<trPropsJson(fps, sep=", ")> 
    ' \"inner\":   [<intercalate(",\n", [trJson(f) | f <- figs])> 
    '          ] 
    '}";

str trJson(_vcat(list[Figure] figs, FProperties fps)) = 
	"{\"figure\": \"vcat\"<trPropsJson(fps, sep=", ")> 
    ' \"inner\":  [<intercalate(",\n", [trJson(f) | f <- figs])>
    '         ] 
    '}";

// Layouts

str trJson(_barchart(FProperties fps)) = 
	"{\"figure\": \"barchart\" <trPropsJson(fps)> }";

str trJson(_scatterplot(FProperties fps)) = 
	"{\"figure\": \"scatterplot\" <trPropsJson(fps)> }";

str trJson(_graph(Figures nodes, Edges edges, FProperties fps)) = 
	"{\"figure\": \"graph\" <trPropsJson(fps, sep=", ")> 
	' \"nodes\":  [<intercalate(",\n", [trJson(f) | f <- nodes])>
	'         ], 
	' \"edges\":  [<intercalate(",\n", ["{\"source\": <from>, \"target\": <to>}"| _edge(from,to,efps) <- edges])>
	'         ]
	'}";


// ---------- texteditor ----------

//Size sizeOf(_texteditor(FProperties fps),  FProperty pfps...){
//	afps = combine(fps, pfps);
//	res = getSize(afps, <200,200>);
//	println("sizeOF texteditor: <res>");
//	return res;
//}
//
//private list[PRIM] tr(_texteditor(FProperties fps), bb, FProperties pfps) {
//	println("tr _texteditor: fps <fps>, bb <bb>, pfps <pfps>");
//	fps1 = combine(fps, pfps);
//	return [texteditor_prim(bb, fps1)];
//}

// Interaction elements

// ---------- strInput ----------
 
str trJson(_strInput(Bind[str] sbinder, FProperties fps)) {
	if(isCursor(sbinder.accessor)){
		refresh = "false";
		replacement = "\"\"";
		if(bind(a, r) := sbinder){
			refresh = "true";
			replacement = r;
		}
 		return 	"{\"figure\": 		 \"strInput\" <trPropsJson(fps, sep=", ")>
 				' \"accessor_type\": \"<typeOf(sbinder.accessor)>\",
 				' \"accessor\": 	 <trPath(toPath(sbinder.accessor))>,
 				' \"refresh\":		 <refresh>,
 				' \"replacement\":	 <replacement>
 				'}";
    } else {
    	throw "strInput: accessor argument should be a cursor: <sbinder.accessor>";
    }
}

// ---------- colorInput ----------

str trJson(_colorInput(Bind[str] sbinder, FProperties fps)) {
	if(isCursor(sbinder.accessor)){
		refresh = "false";
		replacement = "\"\"";
		if(bind(a, r) := sbinder){
			refresh = "true";
			replacement = r;
		}
 		return 	"{\"figure\": 		 \"colorInput\" <trPropsJson(fps, sep=", ")>
 				' \"accessor_type\": \"<typeOf(sbinder.accessor)>\",
 				' \"accessor\": 	 <trPath(toPath(sbinder.accessor))>,
 				' \"refresh\":		 <refresh>,
 				' \"replacement\":	 <replacement>
 				'}";
    } else {
    	throw "colorInput: accessor argument should be a cursor: <sbinder.accessor>";
    }
}

// ---------- numInput ----------

str trJson(_numInput(Bind[num] nbinder, FProperties fps)) {
	if(isCursor(nbinder.accessor)){
		refresh = "false";
		replacement = "\"\"";
		if(bind(a, r) := nbinder){
			refresh = "true";
			replacement = r;
		}
 		return 	"{\"figure\": 		 \"numInput\" <trPropsJson(fps, sep=", ")>
 				' \"accessor_type\": \"<typeOf(nbinder.accessor)>\",
 				' \"accessor\": 	 <trPath(toPath(nbinder.accessor))>,
 				' \"refresh\":		 <refresh>,
 				' \"replacement\":	 <replacement>
 				'}";
    } else {
    	throw "numInput: accessor argument should be a cursor: <nbinder.accessor>";
    }
}

str trJson(_fswitch(int sel, Figures figs, FProperties fps)) { 
	if(isCursor(sel)){
	   return 
		"{\"figure\": \"fswitch\"<trPropsJson(fps, sep=", ")> 
		  \"selector\":	 <trPath(toPath(sel))>,
    	' \"inner\":   [<intercalate(",\n", [trJson(f) | f <- figs])> 
   	 '          ] 
    	'}";
    } else {
    	throw "fswitch: selector should be a cursor: sel";
    }
 }   

str trJson(p: _rangeInput(int low, int high, int step, Bind[int] binder, FProperties fps)) {
  if(isCursor(binder.accessor)){ 
  	replacement = bind(a, v) := binder ? v : "\"undefined\"";  
	return 
	"{ \"figure\":			\"rangeInput\"<trPropsJson(fps, sep=", ")> 
	'  \"low\":	 			<numArg(low)>,
	'  \"high\":			<numArg(high)>,
	'  \"step\":			<numArg(step)>,
	'  \"type\": 			\"<typeOf(binder.accessor)>\", 
	'  \"accessor\": 		<valArg(binder.accessor)>,
	'  \"replacement\":		<replacement>	
	'}";
   } else {
   		throw "rangeInput: accessor <binder.accessor> of bind argument is not a cursor";
   }
}
    
// Default

default str trJson(Figure f) { throw "trJson: cannot translate <f>"; }

/**************** Tranlate properties *************************/

str trPropsJson(FProperties fps str sep = ""){
	res = "";
	
	for(fp <- fps){
		attr = getName(fp);
			t = trPropJson(fp);
			if(t != "")
				res += ", " + t;
	}
	return res + sep;
}

str trPropJson(pos(int xpos, int ypos)) 		= "";

str trPropJson(gap(int width, int height)) 		= "\"hgap\": <width>, \"vgap\": <height>";

str trPropJson(align(HAlign xalign, VAlign yalign)){
	xa = 0.5;
	switch(xalign){
		case left():	xa = 0.0;
		case right():	xa = 1.0;
	}
	ya = 0.5;
	switch(yalign){
		case top():		ya = 0.0;
		case bottom():	ya = 1.0;
	}
	return "\"halign\": <xa>, \"valign\": <ya>";
}

str trPath(Path path){
	
	
    accessor = "Figure.model";
	for(nav <- path){
		switch(nav){
		 	case root(str name):		accessor += ".<name>"; 
			case field(str name): 		accessor += ".<name>";
  			case subscript(int index):	accessor += "[<index>]";
  			case lookup(value key):		accessor += "[<key>]";
  			case select(list[int] indices):
  										accessor += "";		// TODO
  			case select(list[str] labels):
  										accessor += "";		// TODO
  		}
  	}
  	println("trPath: <path>: <accessor>");
  	return "\"<accessor>\"";
}


str numArg(num n) = isCursor(n) ? "{\"use\": <trPath(toPath(n))>}" : "<n>";
str strArg(str s) = isCursor(s) ? "{\"use\": <trPath(toPath(s))>}" : "\"<s>\"";
str valArg(value v) = isCursor(v) ? "{\"use\": <trPath(toPath(v))>}" : "<v>";		

str trPropJson(width(int w))					= "\"definedWidth\": <numArg(w)>";
str trPropJson(height(int h))					= "\"definedHeight\": <numArg(h)>";

str trPropJson(xpos(int x))						= "\"xpos\": <numArg(x)>";

str trPropJson(ypos(int y))						= "\"ypos\": <numArg(y)>";

str trPropJson(hgap(int g))						= "\"hgap\": <numArg(g)>";

str trPropJson(vgap(int g))						= "\"vgap\": <numArg(g)>";

str trPropJson(lineWidth(int n)) 				= "\"lineWidth\": <numArg(n)>";

str trPropJson(lineColor(str s))				= "\"lineColor\":<strArg(s)>";

str trPropJson(lineStyle(list[int] dashes))		= "\"lineStyle\": <dashes>";			// TODO

str trPropJson(fillColor(str s)) 				= "\"fillColor\": <strArg(s)>";

str trPropJson(lineOpacity(real r))				= "lineOpacity:\"<numArg(r)>\"";

str trPropJson(fillOpacity(real r))				= "\"fill_opacity\": <numArg(r)>";

str trPropJson(rounded(int rx, int ry))			= "\"rx\": <numArg(rx)>, \"ry\": <numArg(ry)>";
str trPropJson(dataset(list[num] values1)) 		= "\"dataset\": <values1>";
str trPropJson(dataset(lrel[num,num] values2))	= "\"dataset\": [" + intercalate(",", ["[<v1>,<v2>]" | <v1, v2> <- values2]) + "]";

str trPropJson(font(str fontName))				= "\"fontName\": <strArg(fontName)>";

str trPropJson(fontSize(int fontSize))			= "\"fontSize\": <numArg(fontSize)>";

str trPropJson(prop: onClick(binder: bind(&T accessor, &T replacement))){
	println("prop = <prop>");	
	if(isCursor(binder.accessor)){ 	
		return 
			"\"onClick\":  		\"true\",
			'\"type\": 			\"<typeOf(binder.accessor)>\", 
			' \"accessor\": 	<trPath(toPath(binder.accessor))>,
			' \"replacement\":	<replacement>,
			' \"refresh\":		\"true\"
			";	
 	} else {
   		throw "onClick: accessor <accessor> in binder is not a cursor";
   }
}

default str trPropJson(FProperty fp) 			= (size(int xsize, int ysize) := fp) ? "\"definedWidth\": <xsize>, \"definedHeight\": <ysize>" : "unknown: <fp>";

/******************* Utilities for callback management ********************/
/*
private loc fig_site = |http://localhost:8081|;

public str getSite() = "<fig_site>"[1 .. -1];


// CallBack[&T]

private int ncallback = 0;
private map[str, value] callbacks = ();
private map[value, str] seen_callbacks = ();

private void init_callback(){
	ncallback = 0;
	callbacks = ();
	seen_callbacks = ();
}

public str def_callback(CallBack[&T] callback){
println("A");
	if(!callbacks?){
		init_callbacks();
	}
	if(seen_callbacks[callback]?){
		return seen_callbacks[callback];
	}
	ncallback += 1;
	str cid = "<ncallback>";
	println("callbacks = <callbacks>, cid = <cid>");
	callbacks[cid] = callback;
	seen_callbacks[callback] = cid;
	println("def_callback: <cid>, <callbacks>, <seen_callbacks>");
	return cid;
}

public  map[str, str] do_callback(str fun, map[str, str] state){
    println("do_callback: <fun>, <state>, <callbacks>");
    
    tp = state["var_type"];
    var_name = state["var_name"];
 	var_value = state[var_name];
    callback = callbacks[fun];
    switch(tp){
    	case "int":	{ if( int(int) callback := callbacks[fun]) { state[var_name] = "<callback(toInt(var_value))>"; return state; } }
    	case "str":	{ if( str(str) callback := callbacks[fun]) { state[var_name] = "<callback(var_value)>"; return state; } }
    };
    throw "do_callback: unsupported type <tp> for <var_name>";
}

*/