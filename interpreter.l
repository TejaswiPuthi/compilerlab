%{
  	#include<stdio.h>
  	#include<stdlib.h>
  	#include "y.tab.h"
%}

%%
[a-z] {yylval.character=yytext[0];
			return ID;}
"read" {return READ;}
"write" {return WRITE;}
[0-9]+ {yylval.integer=atoi(yytext);
				return NUM; }
"+" {return PLUS;}
"*" {return MUL;}
"=" {return ASGN;}
"(" {return *yytext;}
")" {return *yytext;}
[\n] {return NL;}
" " {}
. {return *yytext;}

%%

int yywrap()
{
	return 1;
}
