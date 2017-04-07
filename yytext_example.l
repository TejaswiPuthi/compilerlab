%option noyywrap
%{
	#include <stdlib.h>
	#include <stdio.h>
%}
	
number [0-9]+

 
%%
 
{number} {if(atoi(yytext)%2==0)printf("Even\n");else printf("Odd\n");}
[ \n\t]  {}
.        { yyerror("Invalid charater "); printf("%s\n",yytext); exit(1); }

%%
 
int main(int argc, char* argv[])
{
	if(argc>1)
	{
		FILE* fp=fopen(argv[1],"r");
		if(fp)
		{
			yyin=fp;
		}
	}
	yylex();

	return 1;
}
yyerror(char const *s)
{
  printf("yyerror %s",s);
}