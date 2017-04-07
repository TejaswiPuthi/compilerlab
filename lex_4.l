%{
	#include<stdio.h>
	#include<stdlib.h>
%}
comment1    \/\*[^"*/"]*\*\/
comment2    \/\/.*
%%
{comment1}  {printf("%s\n",yytext);}
{comment2}    {printf("%s\n",yytext);}
. {;}
%%
int yywrap(){
	return 1;
}

int main(){
	yyin = fopen("input","r");
	yylex();
	
	return 1;
}
