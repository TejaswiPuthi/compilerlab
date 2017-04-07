%{	
  	#define YYSTYPE struct tnode*
  	#include<stdio.h>
  	#include<stdlib.h>
  	#include "y.tab.h"
  	#include "explsymbol.h"
  	#include "expl.h"
  	struct Gsymbol * node=NULL;


%}

%%
"boolean" {return BOOL;}
"true" {yylval=makeLeafNode(TRUE,type_bool);return TRUE;}
"false" {yylval=makeLeafNode(FALSE,type_bool);return FALSE;}
"decl" {return DECL;}
"enddecl" {return ENDDECL;}
"integer" {return INT;}
"start" {return START;}
"end"   {return END;}
"read"  {return READ;}
"write" {return WRITE;}
"if"    {return IF;}
"else"  {return ELSE;}
"then"  {return THEN;}
"endif" {return ENDIF;}
"while" {return WHILE;}
"do"    {return DO;}
"endwhile" {return ENDWHILE;}
[a-zA-Z_][a-zA-Z_0-9]*  { char*varn =(char *) malloc(sizeof(char)*(strlen(yytext)+1));
		 		strcpy(varn, yytext);
		 		yylval=TreeCreate(type_int,ID,0,varn,NULL,NULL,NULL,NULL);
		 		return ID;  }
[0-9]+ {yylval=makeLeafNode(atoi(yytext),type_int);
		return NUM;}
[=]    {return ASGN;}
[+]    {return PLUS;}
[*]    {return MUL; }
[>]    {return GT;}
[<]    {return LT;}
"<="   {return LTE;}
">="   {return GTE;}
"!="   {return NOTEQ;}
[-]    {return MINUS;}
[/]    {return DIV;}
[%]    {return MOD;}
"=="   {return EQ;}
"&&"   {return AND;}
"||"   {return OR;}
"!"    {return NOT;}
[ \t]	{}
[\n]   {}
.      {return *yytext;}
%%
int yywrap()
{
	return 1;
}
