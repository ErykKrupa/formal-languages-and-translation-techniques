%option yylineno
%option nounput
%{
#include <iostream>
#include <string>
#include "math.tab.h"

%}

%%
#(.|\\\n)*\n ;
[ \t]+ ;
[0-9]+ { yylval = yytext; return N; }
\+ { yylval = yytext; return PLUS; }
- { yylval = yytext; return MINUS; }
\* { yylval = yytext; return MULTIPLICATION; }
\/ { yylval = yytext; return DIVISION; }
% { yylval = yytext; return MODULO_S; }
\( { yylval = yytext; return BRACKET_OPEN; }
\) { yylval = yytext; return BRACKET_CLOSE; }
\n { yylval = yytext; return END; }
\^ { yylval = yytext; return POWER_S; }
\\\n ;
. return ERR;
