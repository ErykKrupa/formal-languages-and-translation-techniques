%option noyywrap

%{
#include <iostream>
#include <stdio.h>
#include <math.h>
#include <stdbool.h>
#define STACK_SIZE 100
using namespace std;

int stack[STACK_SIZE];
int pointer = -1;
int error = false;
string message = "";

void push(int num) {
    if (++pointer < STACK_SIZE) {
        stack[pointer] = num;
    } else {
        error = true;
        message = "Error: stack overflow\n";
    }
}

int pop() {
    if (pointer >= 0) {
        return stack[pointer--];
    } else {
        error = true;
        message = "Error: to many operators\n";
        return -1;
    }
}
%}

%x ERROR

%%

^[ \t]*$ {
    ECHO;
    message = "Error: no data\n";
    BEGIN(ERROR);

}

-?[0-9]+ {
    ECHO;
    push(atoi(yytext));
    if (error) {
        BEGIN(ERROR);
    }
}

\+ {
    ECHO;
    push(pop() + pop());
    if (error) {
        BEGIN(ERROR);
    }
}

\- {
    ECHO;
    int buffor = pop();
    push(pop() - buffor);
    if (error) {
        BEGIN(ERROR);
    }
}

\* {
    ECHO;
    push(pop() * pop());
    if (error) {
        BEGIN(ERROR);
    }
}

\/ {
    ECHO;
    int buffor = pop();
    if (buffor == 0) {
        error = true;
        message = "Error: division by 0\n";
    } else {
        push(pop() / buffor);
    }
    if (error) {
        BEGIN(ERROR);
    }
}     

\% {
    ECHO;
    int buffor = pop();
    if (buffor == 0) {
        error = true;
        message = "Error: division by 0\n";
    } else {
        push(pop() % buffor);
    }
    if (error) {
        BEGIN(ERROR);
    }
}

\^ {
    ECHO;
    int buffor = pop();
    push((int) pow((double) pop(), (double) buffor));
    if (error) {
        BEGIN(ERROR);
    }
}

[ \t]   ECHO;

\n {
    ECHO;
    if (pointer != 0) {
        fprintf(yyout, "Error: to many arguments\n");
    } else {
        fprintf(yyout, "= %d\n", pop());
    }
    pointer = -1;
}  

. {
    ECHO;
    error = true;
    message = "Error: unknown character\n";
    if (error) {
        BEGIN(ERROR);
    }
}

<ERROR>{
    .   ECHO;
    \n  {
        ECHO;
        pointer = -1;
        fprintf(yyout, "%s", message.c_str());
        error = false;
        message = "";
        BEGIN(INITIAL);
    }
}

%%

int main(int argc, char **argv) {
    if (argc <= 1) {
        cout << "No file given." << endl;
        return 1;
    }
    if (fopen(argv[1], "r") == NULL) {
        cout << "File " << argv[1] << " doesn't exist." << endl;
        return 2;
    }
    string file = "output.txt";
    if (argc >= 3) {
        file = argv[2];
    }
    yyin = fopen(argv[1], "r"); 
    yyout = fopen(file.c_str(), "w");
    yylex();
    return 0;
}