%{
    /* 
     * Pass 1 Grammar
     */

    #include <stdio.h>
    #include <stdlib.h>

    extern FILE *yyin;
    int yydebug=1;
%}

%token ARITHMETIC REG8 REG16 HEX8 HEX16 LABEL EOL DB DW COMMA

%union
{
    int num;
    char str[50];
}

%type <str> ARITHMETIC
%type <str> LABEL
%type <str> HEX8
%type <str> HEX16
%type <str> REG8
%type <str> REG16

%%
start: line start |  { printf("finish"); } 
        ;

line:   
        arith EOL |
        variable EOL |
        EOL
        ;

variable: LABEL value
        ;

value: DB HEX8 |
       DW HEX16
       ;

arith:  ARITHMETIC reginstn
        ;

reginstn: regi COMMA regi
        ;

regi:  REG8 | REG16 ;

%%

int main(int argc, char* argv[]) {

    if (argc < 2) {
        printf("Usage: ./NASM prog.asm");
        exit(1);
    }
    yyin = fopen(argv[1], "r");
    yyparse();

    return 0;
}

int yyerror() {
    printf("Error parsing!");
}