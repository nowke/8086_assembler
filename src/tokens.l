%{
    /*
     * Tokens listing for 8086 instructions
     */
    #include "y.tab.h"
    #include <string.h>
%}
arithmetic ("ADD"|"SUB"|"MUL"|"DIV")
logical ("AND"|"OR"|"NOT"|"SHL"|"SHR"|"ROL"|"ROR"|"TEST"|"CMP")
control ("JMP"|"JE"|"JZ"|"JLE"|"JG"|"JGE"|"JA"|"JB"|"CALL"|"LOOP")
unary ("INC"|"DEC")
data ("MOV"|"PUSH"|"POP")
reg8 ("AL"|"AH"|"BH"|"BL"|"CL"|"CH"|"DL"|"DH")
reg16 ("AX"|"BX"|"CX"|"DX"|"SP"|"BP"|"SI"|"DI")
regSeg ("CS"|"DS"|"ES"|"SS")
interrupt ("INT")
end ("END")
MemoryAdd  ("[BX][SI]"|"[BX][DI]"|"[BP][SI]"|"[BP][DI]"|"[BP]"|"[SP]"|"[DI]"|"[SI]")
hex [0-9|a-f|A-F]
hex8 {hex}{2}[hH]
hex16 {hex}{4}[hH]
label ([a-zA-Z])([a-zA-Z0-9]*)
eol \n
eols \n[\n]+
comma ","
whitespace [ \t]+
comments \n?";"[^\n]*
segment (".MODEL"|".CODE"|".DATA")
models ("SMALL"|"TINY")
string \"([^\"]+)\"

%%

{arithmetic} {
                ECHO;
                strcpy(yylval.str, yytext);
                return ARITHMETIC;
             }

{logical}    {
                ECHO;
                strcpy(yylval.str, yytext);
                return LOGICAL;
             }

{data}       {
                ECHO;
                strcpy(yylval.str, yytext);
                return DATAINSTN;
             }

{unary}      {
                 ECHO;
                 strcpy(yylval.str, yytext);
                 return UNARY;
             }

{control}    {
                ECHO;
                strcpy(yylval.str, yytext);
                return CONTROL;
             }

{MemoryAdd}  {
                ECHO;
                strcpy(yylval.str, yytext);
                return MEMADD;
             }

{interrupt}  {
                 ECHO;
                 strcpy(yylval.str, yytext);
                 return INTERRUPT;
             }

{end}        {
                 ECHO;
                 strcpy(yylval.str, yytext);
                 return END;
             }

{hex8}       {
                ECHO;
                strcpy(yylval.str, yytext);
                return HEX8;
             }

{hex16}      {
                ECHO;
                strcpy(yylval.str, yytext);
                return HEX16;
             }

[0-9]+       {
                ECHO;
                strcpy(yylval.str, yytext);
                return NUM;
             }

{regSeg}     {
                ECHO;
                strcpy(yylval.str, yytext);
                return REGSEG;
             }

{whitespace} {
                ECHO;
             }

{comma}      {
                ECHO;
                return COMMA;
             }

"DB"         {
                ECHO;
                return DB;
             }

"DW"         {
                ECHO;
                return DW;
             }

{reg8}       {
                ECHO;
                strcpy(yylval.str, yytext);
                return REG8;
             }

{reg16}      {
                ECHO;
                strcpy(yylval.str, yytext);
                return REG16;
             }


{models}     {
                ECHO;
                strcpy(yylval.str, yytext);
                return MODELS;
             }

{string}     {
                ECHO;
                strcpy(yylval.str, yytext);
                return STRING;
             }

{label}      {
                ECHO;
                strcpy(yylval.str, yytext);
                return LABEL;
             }

{comments}   {
                // Ignore comments
                ;
             }

{eols}       {
                 printf("\n");
                 return EOL;
             }

{eol}        {
                ECHO;
                return EOL;
             }

{segment}    {
                ECHO;
                strcpy(yylval.str, yytext);
                return SEGMENT;
             }

.            {
                ECHO;
                strcpy(yylval.str, yytext);
                return *yytext;
             }

%%

int yywrap() { return 1; }
