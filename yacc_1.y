%{
      #include <stdio.h>
      #include <stdlib.h>
      int i=0,j=0;
      int maximum(int a,int b);
void yyerror(char const *s) ;
%}

%token IF THEN ELSE VAR DIG  newline B PLUS MINUS ASSIGN
%nonassoc '='
%left '+' '-'

%%

start : if_then_else newline  { 
                        printf("%d : nested\n",$1);
                        exit(0);
                      }
  ;

if_then_else :  IF exp THEN if_then_else ELSE if_then_else   {$$=maximum($4,$6)+1;printf("ITE ");}
  | IF exp THEN if_then_else    {$$=$4+1;printf("IT");}
  | exp {$$=$1;printf("exp ");}
  ;

exp : B exp B {$$=$2;}
	|exp PLUS exp {$$=0;printf("+");}
	|exp MINUS exp {$$=0;printf("-");}
	|exp ASSIGN exp {$$=0;printf("=");}
	|VAR {$$=$1;printf("VAR ");}
	|DIG {$$=$1;printf("DIG ");}
	;
%%

void yyerror(char const *s) 
{ 
    printf("yyerror  %s\n",s); 
    return ;
} 
int maximum(int a,int b)
{
	if(a>b)
		return (a);
	else
		return (b);
}
int main()
{
  yyparse();
  return 1;
}
