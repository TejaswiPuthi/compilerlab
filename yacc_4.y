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

expr:  expr '+' expr        {printf("+ ");}
  | expr '*' expr  {printf("* ");}
  | expr '/' expr {printf("/ ");}
  | expr '-' expr     {printf("- ");}
  | '(' expr ')'
  | CHARACTER             {printf("%s ",$1);}
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
