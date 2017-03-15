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
	"very" wsr key:varname wsr "is" wsr value:value { return "var "+key+" \= "+value+";"; }
	/ "so" wsr module:[^\t\n ]+ varr:(wsr "as" wsr name:varname { return name; })? {
		module = module.join("");
		return "var " + (varr || module) + " = require(\""+module+"\");";
	}
	/ value
) ws { return statement; }

value = (
	"maybe" { return "!!+Math.round(Math.random())"; }
	/ "trained" { return '"use strict"'; }
	/ (!"wow" name:varname { return name; })
)

varname = !"shh" chars:[a-zA-Z_$Ð]+ { return chars.join(""); }

number = head:[1-9] tail:[0-9]+ { return [head].concat(tail).reduce(function(a,b) { return a*10+b }); }
