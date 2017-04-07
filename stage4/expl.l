%{	
  	#define YYSTYPE struct tnode*
  	#include<stdio.h>
  	#include<stdlib.h>
  	#include "y.tab.h"
  	#include "expl.c"


%}

%%

"read"  {return READ;}
"write" {return WRITE;}
"if"    {return IF;}
"else"  {return ELSE;}
"then"  {return THEN;}
"endif" {return ENDIF;}
"while" {return WHILE;}
"do"    {return DO;}
"endwhile" {return ENDWHILE;}
[a-z]  { char*varn =(char *) malloc(sizeof(char));
		 *varn = *yytext;
		 yylval=TreeCreate(type_int,ID,0,varn,NULL,NULL,NULL,NULL);
		 return ID;  }
[0-9]+ {yylval=makeLeafNode(atoi(yytext));
		return NUM;}
[=]    {return ASGN;}
[+]    {return PLUS;}
[*]    {return MUL; }
[>]    {return GT;}
[<]    {return LT;}
"=="  {return EQ;}
[ \t]	{}
[\n]   {return NL;}
.      {return *yytext;}
%%
int yywrap()
{
	return 1;
}