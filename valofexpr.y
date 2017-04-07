%{

#include <stdio.h>
#include <stdlib.h>

%}

%token DIGIT
%left '+' '-'
%left '*' '/'

%%
start : expr '\n'		{printf("%d\n",$1);exit(1);}
	;

expr:  expr '+' expr		{$$=$1+$3;}
	| expr '-' expr      {$$=$1-$3;}
	| expr '*' expr		{$$=$1*$3;}
	| expr '/' expr     {$$=$1/$3;}
	| '(' expr ')'
	| DIGIT			{$$=$1;}
	;

%%
yyerror()
{
	printf("Error");
}

yylex()
{
	int c;
	c = getchar();
	if(isdigit(c))
	{
		yylval = c - '0';
		return DIGIT;

	}
	return c;
}

main()
{
	yyparse();
	return 1;
}