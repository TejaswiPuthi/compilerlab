%{
  	#include<stdio.h>
  	#include<stdlib.h>
  	#include "y.tab.h"
%}

%%
[a-z]    { yylval.character = yytext[0]; return ID; }
[0-9]+   { yylvavl.integer = atoi(yytext); return NUM;}
"read"   { return READ;}
[=]      { return ASGN;}
[+]      { return PLUS;}
[-]      { return MUL;}
[()]     { return *yytext;}
[;]      { return *yytext;}
[ \t]    { }
[\n]     { return NL;}
.        { return *yytext;}
%%

int yywrap()
{
	return 1;
}
