%{		#define YYSTYPE struct tnode*

	#include <stdio.h>
	#include <stdlib.h>
	#include "expl.h"
	FILE *fp;
	extern FILE *yyin;
	int *var[26];
%}



%token ID READ WRITE NUM NL PLUS MUL ASGN LT GT EQ IF ELSE THEN WHILE DO ENDWHILE ENDIF STMT START END
%nonassoc LT GT EQ
%left PLUS
%left MUL
%%

program :START slist END {evaluate($2);exit(0);}
		;
slist : slist stmt {$$ = TreeCreate(type_void,STMT,0,NULL,NULL,$1,$2,NULL);}
	  | stmt {$$=$1;}
	  ;
expr : expr PLUS expr	{if($1->TYPE!=type_int||$3->TYPE!=type_int)
								{printf("PLUSERROR\n");exit(0);}
							$$ = makeOperatorNode(PLUS,$1,$3);
							$$->TYPE=type_int;
							}

	 | expr MUL expr  	{if($1->TYPE!=type_int||$3->TYPE!=type_int)
								{printf("MULERROR\n");exit(0);}
								$$ = makeOperatorNode(MUL,$1,$3);
								$$->TYPE=type_int;}

	 | expr LT expr  	{if($1->TYPE!=type_int||$3->TYPE!=type_int)
								{printf("LTERROR\n");exit(0);}
								$$ = makeOperatorNode(LT,$1,$3);
								$$->TYPE=type_bool;}

	 | expr GT expr  	{if($1->TYPE!=type_int||$3->TYPE!=type_int)
								{printf("GTERROR\n");exit(0);}
								$$ = makeOperatorNode(GT,$1,$3);
								$$->TYPE=type_bool;}

	 | expr EQ expr  	{if($1->TYPE!=type_int||$3->TYPE!=type_int)
								{printf("EQERROR\n");exit(0);}
								$$ = makeOperatorNode(EQ,$1,$3);
								$$->TYPE=type_bool;}

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

int main(int argc,char* argv[])

{ 
	if(argc>1)
	{
		fp=fopen(argv[1],"r");
		if(fp)
			yyin=fp;
	}    
    yyparse(); 
    return 1; 
}
