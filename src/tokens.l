%{
	/* 
	 * Tokens listing for 8086 instructions
     */
    #include "y.tab.h"
	#include <string.h>
%}
arithmetic ("ADD"|"SUB"|"MUL"|"DIV")
reg8 ("AL"|"AH"|"BH"|"BL"|"CL"|"CH"|"DL"|"DH")
reg16 ("AX"|"BX"|"CX"|"DX"|"SP"|"BP"|"SI"|"DI")
hex [0-9|a-f|A-F]
hex8 {hex}{2}[hH]
hex16 {hex}{4}[hH]
label ([a-zA-Z])([a-zA-Z0-9]*)
eol \n
comma ","
whitespace [ \t]+
%%

{arithmetic} { 
				ECHO; 
				strcpy(yylval.str, yytext);
				return ARITHMETIC;
			 }

{hex8}		 {
				ECHO;
				strcpy(yylval.str, yytext);
				return HEX8;
			 }

{hex16}		 {
				ECHO;
				strcpy(yylval.str, yytext);
				return HEX16;
			 }

{whitespace} { ECHO; }

{comma} { ECHO; return COMMA; }

"DB" { ECHO; return DB; }
"DW" { ECHO; return DW; }			 

{reg8}		 {
				ECHO;
				strcpy(yylval.str, yytext);
				return REG8;
			 }

{reg16}		 {
				ECHO;
				strcpy(yylval.str, yytext);
				return REG16;
			 }

{label}		 {
				ECHO;
				strcpy(yylval.str, yytext);
				return LABEL;
			 }

{eol}		 {
				ECHO;
				return EOL;
			 }

%%

int yywrap() { return 1; }