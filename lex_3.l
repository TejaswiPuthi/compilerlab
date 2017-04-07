%option noyywrap
%{
	//list all words with A
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	
%}

%%

A[a-zA-Z][a-zA-Z][ \t\n] {printf("%s\n",yytext);}
.|[\n] {}

%%

int main()
{
		yyin= fopen("input","r");
		yylex();
}