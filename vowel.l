%option noyywrap

%{
	//Repeat vowels
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>

	

%}

vowel [aAeEiIoOuU]

%%
{vowel} {printf("%s%s",yytext,yytext);}
%%

int main()
{
	yylex();
	return;
}