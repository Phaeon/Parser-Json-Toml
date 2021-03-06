%{

#include "scanner.hh"

#define YY_NO_UNISTD_H

using token = json::parser::token;

#undef  YY_DECL
#define YY_DECL int json::scanner::yylex( json::parser::semantic_type * const lval, json::parser::location_type *loc )

/* update location on matching */
#define YY_USER_ACTION loc->step(); loc->columns(yyleng);

using namespace json;
%}

%option c++
%option yyclass="scanner"
%option prefix="Json_"
%option noyywrap
%option nodefault

%%

%{
    yylval = lval;
%}

"{" return '{';
"}" return '}';
"[" return '[';
"]" return ']';
":" return ':';
"," return ',';

[ \t\n]+ {

}

true {
	yylval->build<bool>(true);
	return token::BOOLEAN;
}

false {
	yylval->build<bool>(false);
	return token::BOOLEAN;
}

null {
	return token::NUL;
}


[-]?(0|[1-9][0-9]*)(\.[0-9]+((e|E)(-|\+)?[0-9]+)?|(e|E)(-|\+)?[0-9]+)	{
	yylval->build<float>(std::atof(yytext));
	return token::FLOAT;
}

[-]?(0|[1-9][0-9]*) {
	yylval->build<int>(std::atoi(yytext));
	return token::ENTIER;
}

\"(([^\"]*)|(\\\"|\\\\|\\\/|\\b|\\n|\\f|\\r|\\t|\\u[A-F0-9]{4})*)*\" {
	yylval->build<std::string>(yytext);
	return token::TEXTE;
}

<<EOF>> return token::END;

%%
