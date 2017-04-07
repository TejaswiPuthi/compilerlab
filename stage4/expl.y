%{		#define YYSTYPE struct tnode*

	#include <stdio.h>
	#include <stdlib.h>
	#include "expl.h"

	int *var[26];
%}



%token ID READ WRITE NUM NL PLUS MUL ASGN LT GT EQ IF ELSE THEN WHILE DO ENDWHILE ENDIF STMT
%nonassoc LT GT EQ
%left PLUS
%left MUL
%%

program : slist NL {evaluate($1);exit(0);}
		;
slist : slist stmt {$$ = TreeCreate(type_void,STMT,0,NULL,NULL,$1,$2,NULL);}
	  | stmt {$$=$1;}
	  ;
expr : expr PLUS expr	{$$ = makeOperatorNode(PLUS,$1,$3);}
	 | expr MUL expr  	{$$ = makeOperatorNode(MUL,$1,$3);}
	 | expr LT expr  	{$$ = makeOperatorNode(LT,$1,$3);}
	 | expr GT expr  	{$$ = makeOperatorNode(GT,$1,$3);}
	 | expr EQ expr  	{$$ = makeOperatorNode(EQ,$1,$3);}
	 | '(' expr ')'		{$$ = $2;}
	 | NUM			    {$$ = $1;}
	 | ID               {
                			$$ = $1;
          				}
	 ;
stmt : ID ASGN expr ';'  {$$=TreeCreate(type_void,ASGN,0,NULL,NULL,$1,$3,NULL);}

	 | READ '(' ID ')'';'{  
	 						$$=TreeCreate(type_void,READ,0,NULL,NULL,$3,NULL,NULL);}

	 | WRITE '('expr ')' ';' { $$=TreeCreate(type_void,WRITE,0,NULL,NULL,$3,NULL,NULL);}

	 | IF '(' expr ')' THEN slist ENDIF ';' {
	 					$$=TreeCreate(type_void,IF,0,NULL,NULL,$3,$6,NULL);}
	 					
	 | WHILE '(' expr ')' DO slist ENDWHILE  ';' {
	 							$$=TreeCreate(type_void,WHILE,0,NULL,NULL,$3,$6,NULL);}	
	 |IF '(' expr ')' THEN slist ELSE slist ENDIF ';'
				{
				  $$ = TreeCreate(type_void, ELSE,0, NULL, NULL, $3, $6, $8);}
	;

%%

int yyerror(char const *s)
{
	printf("yyerror %s", s);
}

int main()
{
	yyparse();
	return 1;
}
