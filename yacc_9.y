%{
      #include <stdio.h>
      #include <stdlib.h>
%}

%token NUMBER NEWLINE

%left '+' '-'
%left '*' '/'
%%

start : expr NEWLINE  { 
                        printf("%d\n",$1);
                        exit(1);
                      }
  ;

expr:  expr '+' expr        {$$ = $1+$3;}
  | expr '-' expr     {$$ = $1-$3;}
  | expr '*' expr     {$$ = $1*$3;}
  | expr '/' expr     {$$ = $1/$3;}
  | '(' expr ')'
  | NUMBER             {$$ = $1;}
  ;

%%

void yyerror(char const *s) 
{ 
    printf("yyerror  %s\n",s); 
    return ;
} 
int main()
{
  yyparse();
  return 1;
}
