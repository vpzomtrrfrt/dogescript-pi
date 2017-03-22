start = statements
wsc = [ \t\n]
wsb = wsc*
ws = wsb (
	"shh" [^\n]* // comment
	/ "quiet" (!"loud" .)* "loud" // multiline comment
)? wsb
wsr = wsc ws

wow = "wow"

statements = ws statements:statement* { return statements.join(""); }

semicolonStatement = (
	"very" wsr key:varname wsr ("is" / "as") wsr value:value { return "var "+key+"\="+value; }
	/ "very" wsr key:varname { return "var "+key; }
	/ key:varname wsr "is" wsr value:value { return key+"\="+value; }
	/ "so" wsr module:[^\t\n ]+ varr:(wsr "as" wsr name:varname { return name; })? {
		module = module.join("");
		var name = varr;
		if(!varr) {
			// why am I doing this :(
			var l = module.split("/");
			name = l[l.length-1];
			var ind = name.lastIndexOf(".");
			if(ind > -1) { name = name.substring(0, ind); }
			name = name.replace("-", "_");
		}
		return "var " + name + "=require('"+module+"')";
	}
	/ val:value { return val; }
)
statement = ws statement:(
	"rly" wsr condition:value wsr body:statements mods:ifmod* wow { return "if("+condition+"){"+body+"}"+(mods?mods.join(""):""); }
	/ "many" wsr condition:value wsr body:statements wow { return "while("+condition+"){"+body+"}"; }
	/ "such" wsr name:varname wsr params:("much" wsr params:(pname:varname wsr { return pname; })* { return params.join(","); })? body:statements wow { return "function "+name+"("+(params||"")+"){"+body+"}" }
	/ "much" wsr a:semicolonStatement ws ("next" wsr)? b:value ws ("next" wsr)? c:semicolonStatement body:statements wow { return "for("+a+";"+b+";"+c+"){"+body+"}"; }
	/ value:semicolonStatement { return value+";"; }
) ws { return statement; }

ifmod = mod:(
	"but" wsr "rly" wsr condition:value wsr body:statements { return "else if("+condition+"){"+body+"}"; }
	/ ("but" wsr body:statements { return "else{"+body+"}"; })
) ws { return mod; }

value = value:(
	"maybe" { return "!!+Math.round(Math.random())"; }
	/ "trained" { return '"use strict"'; }
	/ "debooger" { return "debugger"; }
	/ "windoge" { return "window"; }
	/ ("dogeument" / "dogument") { return "document"; }
	/ "plz" wsr name:varname params:(wsr "with" wsr params:(val:value ws { return val; })* "&"? { return params.join(","); })? { return name+"("+(params||"")+")"; }
	/ "much" wsr params:(val:value wsr { return val; })* body:statements wow { return "function("+params.join(",")+"){"+body+"}"; }
	/ string
	/ number
	/ varname
) mods:valuemod* { return value + (mods?mods.join(""):"");}

valuemod = (
	wsr operator:(
		"and" { return "&&"; }
		/ "or" { return "||"; }
		/ "is" { return "\=\=\="; }
		/ "smallerish" { return "<="; }
		/ "biggerish" { return ">="; }
		/ "bigger" { return ">"; }
		/ "smaller" { return "<"; }
		/ "more" { return "+="; }
		/ "lots" { return "*="; }
		/ "less" { return "-="; }
		/ "few" { return "/="; }
		/ "as" { return "="; }
	) wsr b:value { return operator+b; }
	/ wsr "dose" wsr name:("loge" { return "log"; } / varname) params:(wsr "with" wsr params:(val:value ws { return val; })* "&"? { return params.join(","); })? { return "."+name+"("+(params||"")+")"; }
	/ ws "." ws b:varname { return "."+b; }
)

varname = !"shh" !wow !"next" !"but" chars:[a-zA-Z_$Ð0-9]+ { return chars.join(""); }

number = head:[1-9] tail:[0-9]+ { return [head].concat(tail).reduce(function(a,b) { return parseInt(a)*10+parseInt(b) }); }

string = "'" content:(
	"\\" val:(
		.
	) { return val; }
	/ [^']
)* "'" { return "'"+content.join("")+"'"; }
