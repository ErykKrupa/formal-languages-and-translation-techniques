%option noyywrap

%{
#include <iostream>
#include <sstream>
using namespace std;

%}

quote      \"[^"]*\"
cdata      <!\[CDATA\[(.|\n)*]]>
comment    <!--([^-]|-[^-]])*-->

%%
{quote} ECHO;
{cdata} ECHO;
{comment}

%%

int main(int argc, char* argv[]) {
    if (argc <= 1) {
        cout << "No file given." << endl;;
        return 1;
    }
    if (fopen(argv[1], "r") == NULL) {
        cout << "File " << argv[1] << " doesn't exist." << endl;
        return 2;
    }
    string file = "output.xml";
    if (argc >= 3) {
        file = argv[2];
    }
    yyin = fopen(argv[1], "r"); 
    yyout = fopen(file.c_str(), "w");
    yylex();
    return 0;
}