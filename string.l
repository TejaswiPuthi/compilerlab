%{
	//Regular expression for strings.
	//Read and print strings.

	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
%}

string (.)+

%option noyywrap

%%

string {printf("%s",yytext);}

%%

int main()
{
	//char str[20];
	int num;
	num=yylex();
	return 1;	
}
