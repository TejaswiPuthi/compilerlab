%{	
	#define YYSTYPE struct tnode*
  	#include<stdio.h>
  	#include<stdlib.h>
  	#include "y.tab.h"
  	#include "stg7.c"


%}

%%

"read"  {return READ;}
"write" {return WRITE;}
"start" {return START;}
"end"   {return END;}
"if"	{return IF;}
"then"	{return THEN;}
"else"	{return ELSE;}
"endif"	{return ENDIF;}
"while"	{return WHILE;}
"do"	{return DO;}
"endwhile"	{return ENDWHILE;}

[a-z]  { 	 char*varn =(char *) malloc(sizeof(char));
		 *varn = *yytext;
		 yylval=TreeCreate(type_int,ID,0,varn,NULL,NULL,NULL,NULL);
		 return ID;  }
[0-9]+ {yylval=makeLeafNode(atoi(yytext));
		return NUM;}
[<]	{return LT;}
[>]	{return GT;}	
[=]    {return ASGN;}
[+]    {return PLUS;}
[-]		{return MINUS;}
[/]		{return DIV;}
[*]    {return MUL; }
"<="   {return LTE;}
">="   {return GTE;}
"!="   {return NOTEQ;}
"=="	{return EQ;}
[ \t]	{}
[\n]   {}
.      {return *yytext;}
%%
int yywrap()
{
	return 1;
}
