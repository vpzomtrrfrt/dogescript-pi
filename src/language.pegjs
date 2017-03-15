start = statements
wsc = [ \t\n]
wsb = wsc*
ws = wsb (
	"shh" [^\n]* // comment
	/ "quiet" (!"loud" .)* "loud" // multiline comment
)? wsb
wsr = wsc ws

statements = ws statements:statement* { return statements.join(""); }

statement = ws statement:(
	"rly" wsr condition:value wsr body:statements mods:ifmod* "wow" { return "if("+condition+"){"+body+"}"+(mods?mods.join(""):""); }
	/ "very" wsr key:varname wsr "is" wsr value:value { return "var "+key+"\="+value+";"; }
	/ "very" wsr key:varname { return "var "+key+";"; }
	/ key:varname wsr "is" wsr value:value { return key+"\="+value+";"; }
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
		return "var " + name + " = require('"+module+"');";
	}
	/ "such" wsr name:varname wsr params:("much" wsr params:(pname:varname wsr { return pname; })* { return params.join(","); })? body:statements "wow" { return "function "+name+"("+(params||"")+"){"+body+"}" }
	/ val:value { return val+";"; }
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
	/ "dogeument" { return "document"; }
	/ number
	/ varname
) mods:valuemod* { return value + (mods?mods.join(""):"");}

valuemod = (
	wsr "and" wsr b:value { return "&&"+b; }
	/ wsr "is" wsr b:value { return "\=\=\="+b; }
)

varname = !"shh" !"wow" !"but" chars:[a-zA-Z_$Ð0-9]+ { return chars.join(""); }

number = head:[1-9] tail:[0-9]+ { return [head].concat(tail).reduce(function(a,b) { return a*10+b }); }
