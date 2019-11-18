%option noyywrap

%top {
    #include <iostream>
    using namespace std;
}

string                      \"[^"]*\"
include                     "#include"[ \t]*"<"[^>]*">"
block_comment               "/*"([^*]|\*+[^*/])*"*"+"/"
line_comment                "/"(\\\n)*"/"(.*\\\n)*.*
dot_net_line_comment        \/\/\/.*\n
important_line_comment      \/\/!.*\n
javadoc_comment             "/**"([^*]|\*+[^*/])*"*"+"/"
important_block_comment     "/*!"([^*]|\*+[^*/])*"*"+"/"

%x LEAVE_DOXYGEN
%x REMOVE_DOXYGEN     

%%

<REMOVE_DOXYGEN,LEAVE_DOXYGEN>{string}          ECHO;
<REMOVE_DOXYGEN,LEAVE_DOXYGEN>{include}         ECHO;
<LEAVE_DOXYGEN>{dot_net_line_comment}           ECHO;
<LEAVE_DOXYGEN>{important_line_comment}         ECHO;
<LEAVE_DOXYGEN>{javadoc_comment}                ECHO;
<LEAVE_DOXYGEN>{important_block_comment}        ECHO;
<REMOVE_DOXYGEN,LEAVE_DOXYGEN>{block_comment}   
<REMOVE_DOXYGEN,LEAVE_DOXYGEN>{line_comment}    

%%

int main( int argc, char **argv )
{
    if (argc <= 1) {
        cout << "No file given." << endl;
        return 1;
    }
    if (fopen(argv[1], "r") == NULL) {
        cout << "File " << argv[1] << " doesn't exist." << endl;
        return 2;
    }
    bool doxygen_comment_enabled = false;
    if (argc >= 3) {
        if (strcmp(argv[2],"-d") == 0 || strcmp(argv[2],"--doxygen") == 0) {
            doxygen_comment_enabled = true;
        } else {
            cout << "Unknown command " << argv[2] << ". Available commands are: '-d', '--doxygen'" << endl;
            return 3;
        }
    }
    string file = "output.c";
    if (argc >= 4) {
        file = argv[3];
    }
    yyin = fopen(argv[1], "r"); 
    yyout = fopen(file.c_str(), "w");
    if(doxygen_comment_enabled) {
        BEGIN(LEAVE_DOXYGEN);
    } else {
        BEGIN(REMOVE_DOXYGEN);
    }
    yylex();
    return 0;
}
