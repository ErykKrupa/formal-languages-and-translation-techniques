%{
#include <iostream>
#include "defs.h"
#include "calculator.h"
#define YYSTYPE std::string

extern int yylex();
extern void yyerror(const char*);
extern char* yytext;

Calculator calculator;
Detection detection = SKIP;
extern int yylineno;
%}
%define api.value.type {std::string};

%token N
%token PLUS
%token MINUS
%token MULTIPLICATION
%token DIVISION
%token POWER_S
%token MODULO_S
%token BRACKET_OPEN
%token BRACKET_CLOSE
%token END
%token ERR

%%

input:	| input line | input ERR {
	calculator.clear();
};
line:	S END {
	std::cout << "Rpn: " << $1 << std::endl;
	std::cout << "Result: " << calculator.result() << std::endl;
} | error END {
		std::cout << "Error!" << std::endl;
	calculator.clear();
}
;

S:  NT_PLUS | NT_MINUS | FIRST_NONTERMINAL | SECOND_NONTERMINAL;
FIRST_NONTERMINAL: NT_BRAC_NUM_NEG | NT_POWER;
SECOND_NONTERMINAL: NT_MULTIPLICATION | NT_DIV_MOD | FIRST_NONTERMINAL;

NT_PLUS: S PLUS S {
	$$ = $1 + " " + $3 + " +";
	calculator.calculate({ADD, "0"});
};
NT_MINUS: S MINUS SECOND_NONTERMINAL {
	$$ = $1 + " " + $3 + " -";
	calculator.calculate({SUBTRACT, "0"});
};
NT_MULTIPLICATION: SECOND_NONTERMINAL MULTIPLICATION SECOND_NONTERMINAL {
	$$ = $1 + " " + $3 + " *";
	calculator.calculate({MULTIPLY, "0"});
};
NT_DIV_MOD: SECOND_NONTERMINAL DIVISION FIRST_NONTERMINAL {
	$$ = $1 + " " + $3 + " /";
	calculator.calculate({DIVIDE, "0"});
}| SECOND_NONTERMINAL MODULO_S FIRST_NONTERMINAL {
	$$ = $1 + " " + $3 + " %";
	calculator.calculate({MODULO, "0"});
};
NT_POWER: NT_BRAC_NUM_NEG POWER_S FIRST_NONTERMINAL {
	$$ = $1 + " " + $3 + " ^";
	calculator.calculate({POWER, "0"});
};
NT_BRAC_NUM_NEG: BRACKET_OPEN S BRACKET_CLOSE {
	$$ = $2;
}| N {
	$$ = $1;
	calculator.calculate({NUMBER, $1});
}| MINUS NT_BRAC_NUM_NEG {
	$$ = $2 + " ~";
	calculator.calculate({NEGATE, "0"});
};

%%

void yyerror(const char* err) {
	return;
}