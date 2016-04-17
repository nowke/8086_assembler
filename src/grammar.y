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
%token LOGICAL CONTROL REGSEG SEGMENT MODELS STRING NUM DATAINSTN
%token MEMADD UNARY INTERRUPT END

%union
{
    int num;
    char str[50];
    char* inst;
}

%type <str> ARITHMETIC LABEL HEX8 HEX16 REG8 REG16 EOL line arith regi
%type <str> SEGMENT MODELS STRING NUM DATAINSTN REGSEG MEMADD UNARY
%type <str> CONTROL INTERRUPT END

%%
start: line start
        | END EOL
        { printf("\n\nCompleted parsing Pass 1\n"); }
        ;

line:
        SEGMENT MODELS EOL { line_no++; } |
        SEGMENT EOL { line_no++; } |
        arith EOL { line_no++; /* printf("%4d\t%04X\t", line_no, locctr); */ } |
        datai EOL { line_no++; } |
        unaryi EOL { line_no++; } |
        controli EOL { line_no++; } |
        interrupti EOL { line_no++; } |
        variable EOL { line_no++; /* printf("%4d\t%04X\t", line_no, locctr); */ } |
        LABEL ':' |
        EOL
        ;

variable: LABEL value { symbol = insertToSymTable(symbol, $1, locctr); locctr += 1; }
        ;

value: DB HEX8 |
       DW HEX16 |
       DB STRING |
       DB NUM
       ;

arith:  ARITHMETIC reginstn { locctr += 2; }
        ;

datai:  DATAINSTN datamovement { locctr += 2; }

datamovement:
        REG8 COMMA REG8 { /* Register addressing */ } |
        REG16 COMMA REG16 { /* Register addressing */ } |
        REGSEG COMMA regi { /* Segment addressing */ } |
        REG16 COMMA dataval { /* Immediate addressing */ } |
        REG8 COMMA dataval { /* Immediate addressing */ } |
        REG8 COMMA LABEL { /* From memory location */ }  |
        REG16 COMMA LABEL { /* From memory location */ }  |
        REG8 COMMA MEMADD {} |
        REG16 COMMA MEMADD {} |
        REG8 COMMA LABEL MEMADD {} |
        REG16 COMMA LABEL MEMADD {} |
        LABEL MEMADD COMMA REG8 |
        LABEL MEMADD COMMA REG16
        ;

reginstn: regi COMMA regi
        ;

unaryi:
        UNARY regi
        ;

controli:
        CONTROL LABEL
        ;

regi:  REG8 | REG16 ;

dataval:
        HEX8 | HEX16 | NUM ;

interrupti:
        INTERRUPT HEX8 ;

%%

int main(int argc, char* argv[]) {

    if (argc < 2) {
        printf("Usage: ./NASM prog.asm");
        exit(1);
    }
    yyin = fopen(argv[1], "r");

    symbol = initSymTable();

    /*printf("\n Line\tLOCCTR\tInstruction\n\n");*/

    /*printf("%4d\t%04X\t", line_no, locctr);*/

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
