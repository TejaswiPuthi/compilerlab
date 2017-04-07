%{
      #include <stdio.h>
      #include <stdlib.h>
      #define YYSTYPE char*
      void yyerror(char const *s) ;
%}

%token CHARACTER NEWLINE

%left '+' '-'
%left '*' '/'
 
%%

start : expr NEWLINE  { 
                        printf("\nComplete\n");
                        exit(1);
                      }
  ;

expr:  expr '+' expr        {printf("+ %s %s",$1,$3);}
  | expr '*' expr  {printf("* %s %s ",$1,$3);}
  | expr '/' expr {printf("/ %s %s ",$1,$3);}
  | expr '-' expr     {printf("- %s %s ",$1,$3);}
  | '(' expr ')'
  | CHARACTER             
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
