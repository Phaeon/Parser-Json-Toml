%{

#include "scanner.hh"

#define YY_NO_UNISTD_H

using token = toml::parser::token;

#undef  YY_DECL
#define YY_DECL int toml::scanner::yylex( toml::parser::semantic_type * const lval, toml::parser::location_type *loc )


/* update location on matching */
#define YY_USER_ACTION loc->step(); loc->columns(yyleng);

using namespace toml;
%}

%option c++
%option yyclass="scanner"
%option prefix="Toml_"
%option noyywrap
%option nodefault


%%

%{
    yylval = lval;
%}

"," return ',';
"\[" return token::ARRAY_OPEN;
"\]" return token::ARRAY_CLOSE;
"\[\[" return token::ARRAY_TABLE_OPEN;
"\]\]" return token::ARRAY_TABLE_CLOSE;
"\"" return '"';
"=" return '=';
"\." {
	yylval->build<std::string>(yytext);
	return token::POINT;
}
	
[ \t]+ {
	
}

[\n]* {
}

true {
	yylval->build<bool>(true);
	return token::BOOLEAN;
}

false {
	yylval->build<bool>(false);
	return token::BOOLEAN;
}

(-|\+)?inf {
	return token::INF;
}

(-|\+)?nan {
	return token::NAN;
}

(-|\+)?(0|[1-9][0-9]*)(\.[0-9]+((e|E)(-|\+)?[0-9]+)?|(e|E)(-|\+)?[0-9]+)	{
	yylval->build<float>(std::atof(yytext));
	return token::FLOAT;
}

(-|\+)?(0|[1-9][0-9]*) {
	yylval->build<int>(std::atoi(yytext));
	return token::ENTIER;
}

0x[a-fA-F0-9]{1,8} {
	yylval->build<float>(std::atof(yytext));
	return token::HEXA;
}

(0o[0-7]{8}|0o[0-7]{3}) {
	yylval->build<std::string>(yytext);
	return token::OCTA;
}

0b[0-1]{1,8} {
	yylval->build<std::string>(yytext);
	return token::BIN;
}

(\+|-) {
	return token::SIGNE;
}

\"(([^\"]*)|(\\\"|\\\\|\\b|\\n|\\f|\\r|\\t|\\u[A-F0-9]{4}|\\U[A-F0-9]{8})*)*\" {
	yylval->build<std::string>(yytext);
	return token::TEXTE;
}

'((.*)|(\\\"|\\\\|\\b|\\n|\\f|\\r|\\t|\\u[A-F0-9]{4}|\\U[A-F0-9]{8})*)*' {
	yylval->build<std::string>(yytext);
	return token::TEXTE;
}

#.* {
}

[a-zA-Z0-9\-_]* {
	yylval->build<std::string>(yytext);
	return token::UNQUOTED_KEY;
}


<<EOF>> return token::END;

%%