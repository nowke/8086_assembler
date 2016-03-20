%{
    /* 
     *  Grammar definition
     */

    #include <stdio.h>
    #include <stdlib.h>
    #include "src/assembler.h"

    extern FILE *yyin;
    int yydebug=1;

    int line_no = 1;
    int locctr = 0;

    SYMTAB symbol;
%}

%token ARITHMETIC REG8 REG16 HEX8 HEX16 LABEL EOL DB DW COMMA
%token LOGICAL CONTROL REGSEG

%union
{
    int num;
    char str[50];
    char* inst;
}

%type <str> ARITHMETIC
%type <str> LABEL
%type <str> HEX8
%type <str> HEX16
%type <str> REG8
%type <str> REG16
%type <str> EOL
%type <str> line
%type <str> arith
%type <str> regi

%%
start: line start |  { printf("\n\nCompleted parsing Pass 1\n"); } 
        ;

line:   
        arith EOL { line_no++; printf("%4d\t%04X\t", line_no, locctr); } |
        variable EOL { line_no++; printf("%4d\t%04X\t", line_no, locctr);  } |
        EOL
        ;

variable: LABEL value { symbol = insertToSymTable(symbol, $1, locctr); locctr += 1; }
        ;

value: DB HEX8 |
       DW HEX16
       ;

arith:  ARITHMETIC reginstn { locctr += 2; }
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

    symbol = initSymTable();

    printf("\n Line\tLOCCTR\tInstruction\n\n");

    printf("%4d\t%04X\t", line_no, locctr);

    yyparse();

    printf("\nSymbol Table\n");
    printf("===============\n");

    printSymTable(symbol);
    writeSymTable(symbol);

    return 0;
}

int yyerror() {
    printf("\n[ERROR] At Line No %d\n", line_no);
    printf("[ERROR] Unable to parse!\n");
}