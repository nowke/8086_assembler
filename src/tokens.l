%{
    /* 
     * Tokens listing for 8086 instructions
     */
    #include "y.tab.h"
    #include <string.h>
%}
arithmetic ("ADD"|"SUB"|"MUL"|"DIV")
logical ("AND"|"OR"|"NOT"|"SHL"|"SHR"|"ROL"|"ROR"|"TEST")
control ("JMP"|"JE"|"JZ"|"JLE"|"JG"|"JGE"|"JA"|"JB"|"CALL")
data ("MOV"|"PUSH"|"POP")
reg8 ("AL"|"AH"|"BH"|"BL"|"CL"|"CH"|"DL"|"DH")
reg16 ("AX"|"BX"|"CX"|"DX"|"SP"|"BP"|"SI"|"DI")
regSeg ("CS"|"DS"|"ES"|"SS")
hex [0-9|a-f|A-F]
hex8 {hex}{2}[hH]
hex16 {hex}{4}[hH]
label ([a-zA-Z])([a-zA-Z0-9]*)
eol \n
eols \n[\n]+
comma ","
whitespace [ \t]+
comments \n?";"[^\n]*
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

{control}    {
                ECHO;
                strcpy(yylval.str, yytext);
                return CONTROL;                
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

%%

int yywrap() { return 1; }