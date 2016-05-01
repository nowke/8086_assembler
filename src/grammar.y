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

    int increment;
    char code[20];
    char opcode[20];
    char temp[20];

    SYMTAB symbol;
    OPTAB optable;
    OBJ objectCode;
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
%type <str> CONTROL INTERRUPT END dataval

%%
start: line start
        | END EOL
        { printf("\n\nCompleted parsing Pass 1\n"); }
        ;

line:
        SEGMENT MODELS EOL { line_no++; } |
        SEGMENT EOL { line_no++; } |
        arith EOL {
                    line_no++;
                    printf("%4d\t%04X\t", line_no, locctr);
                    locctr += 3;

                    objectCode = insertToObj(objectCode, opcode);
                  } |
        datai EOL {
                    line_no++;
                    printf("%4d\t%04X\t", line_no, locctr);
                    locctr += 3;

                    objectCode = insertToObj(objectCode, opcode);
                  }
                  |
        unaryi EOL {
                     line_no++;
                     printf("%4d\t%04X\t", line_no, locctr);
                     locctr += 3;

                     objectCode = insertToObj(objectCode, opcode);
                   }
                   |
        controli EOL {
                        line_no++;
                        printf("%4d\t%04X\t", line_no, locctr);
                        locctr += 3;
                        objectCode = insertToObj(objectCode, opcode);
                      }
                      |
        interrupti EOL {
                        line_no++;
                        objectCode = insertToObj(objectCode, opcode);
                       }
                       |
        variable EOL { line_no++;  printf("%4d\t%04X\t", line_no, locctr);  } |
        LABEL ':' { line_no++; symbol = insertToSymTable(symbol, $1, locctr); locctr += 1; }  |
        EOL
        ;

variable: LABEL value { symbol = insertToSymTable(symbol, $1, locctr); locctr += increment; }
        ;

value: DB HEX8 { increment = 1; } |
       DW HEX16 { increment = 2; } |
       DB STRING { increment = strlen($2) - 2; } |
       DB NUM { increment = 1; } |
       DB '?' { increment = 1; } |
       DW '?' { increment = 2; }
       ;

arith:  ARITHMETIC datamovement {
            strcpy(opcode, getOpcodeval(optable, $1));
            strcat(opcode, code);
        }
        ;

datai:  DATAINSTN datamovement {
            strcpy(opcode, getOpcodeval(optable, $1));
            strcat(opcode, code);
        }

datamovement:
        REG8 COMMA REG8 { /* Register addressing */ strcpy(code, "0101"); } |
        REG16 COMMA REG16 { /* Register addressing */ strcpy(code, "0102"); } |
        REGSEG COMMA regi { /* Segment addressing */ strcpy(code, "0103"); } |
        REG16 COMMA dataval { /* Immediate addressing */ strcpy(code, $3); } |
        REG8 COMMA dataval { /* Immediate addressing */ strcpy(code, $3); } |
        REG8 COMMA LABEL {
                            /* From memory location */
                            strcpy(temp, "02<");
                            strcat(temp, $3);
                            strcat(temp, ">");
                            strcpy(code, temp);
                         }  |
        REG16 COMMA LABEL {
                            /* From memory location */
                            strcpy(temp, "03<");
                            strcat(temp, $3);
                            strcat(temp, ">");
                            strcpy(code, temp);
                          }  |
        REG8 COMMA MEMADD { strcpy(code, "0106"); } |
        REG16 COMMA MEMADD { strcpy(code, "0107"); } |
        REG8 COMMA LABEL MEMADD {
                                    strcpy(temp, "04<");
                                    strcat(temp, $3);
                                    strcat(temp, ">");
                                    strcpy(code, temp);
                                } |
        REG16 COMMA LABEL MEMADD {
                                    strcpy(temp, "05<");
                                    strcat(temp, $3);
                                    strcat(temp, ">");
                                    strcpy(code, temp);
                                 } |
        LABEL MEMADD COMMA REG8 {
                                    strcpy(temp, "06<");
                                    strcat(temp, $1);
                                    strcat(temp, ">");
                                    strcpy(code, temp);
                                } |
        LABEL MEMADD COMMA REG16 {
                                    strcpy(temp, "07<");
                                    strcat(temp, $1);
                                    strcat(temp, ">");
                                    strcpy(code, temp);
                                 } |
        LABEL COMMA REG8         {
                                    strcpy(temp, "08<");
                                    strcat(temp, $1);
                                    strcat(temp, ">");
                                    strcpy(code, temp);
                                 } |
         LABEL COMMA REG16         {
                                     strcpy(temp, "09<");
                                     strcat(temp, $1);
                                     strcat(temp, ">");
                                     strcpy(code, temp);
                                  } |
        ;

unaryi:
        UNARY regi {
            strcpy(opcode, getOpcodeval(optable, $1));
        }
        ;

controli:
        CONTROL LABEL {
            strcpy(opcode, getOpcodeval(optable, $1));
            strcpy(temp, "<");
            strcat(temp, $2);
            strcat(temp, ">");
            strcpy(code, temp);
            strcat(opcode, code);
        }
        ;

regi:  REG8 | REG16 ;

dataval:
        HEX8 | HEX16 | NUM ;

interrupti:
        INTERRUPT HEX8 {
            strcpy(opcode, getOpcodeval(optable, $1));
            strcat(opcode, $2);
        };

%%

int main(int argc, char* argv[]) {

    if (argc < 2) {
        printf("Usage: ./NASM prog.asm");
        exit(1);
    }
    yyin = fopen(argv[1], "r");

    symbol = initSymTable();
    optable = initOptable();
    objectCode = initObj();

    printf("\n Line\tLOCCTR\tInstruction\n\n");

    printf("%4d\t%04X\t", line_no, locctr);

    yyparse();

    printf("\nSymbol Table\n");
    printf("===============\n");

    printSymTable(symbol);
    writeSymTable(symbol);
    writeObjectCode(objectCode);

    system("./_pass2.sh");

    return 0;
}

int yyerror() {
    printf("\n[ERROR] At Line No %d\n", line_no);
    printf("[ERROR] Unable to parse!\n");
}
