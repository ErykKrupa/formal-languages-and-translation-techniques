#include <iostream>
#include "calculator.h"

extern int yyparse();

using namespace std;

int main() {
	yyparse();
	return 0;
}