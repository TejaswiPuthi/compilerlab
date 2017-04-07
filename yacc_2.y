//Program to recognize a valid variable, which starts with a letter,followed by any number of letters or digits.

%{
#include<stdio.h>
#include<stdlib.h>
%}

%token DIGIT LETTER NL

%%
stmt: variable NL {printf("valid identifiers\n"); exit(0);}
;
variable: LETTER alphanumeric
;
alphanumeric: LETTER alphanumeric | DIGIT alphanumeric | LETTER | DIGIT
;

%%

int yyerror(char *msg)
{
 printf("Invalid variable\n");
 exit(0);
}

main()
{
 printf("enter the variable: \n");
 yyparse();
}

