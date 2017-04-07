%{	
	#define YYSTYPE struct tnode*
	#include <stdio.h>
	#include <stdlib.h>
	#include "stg7.h"
    int *var[26];
	FILE *fp1;
	FILE *fp;
	extern FILE *yyin;
	int *var[26];
%}



%token ID READ WRITE NUM NL PLUS MUL ASGN STMT MINUS DIV MOD START END IF THEN ELSE ENDIF WHILE DO ENDWHILE LT GT LTE GTE EQ NOTEQ 
%nonassoc LT GT EQ LTE GTE NOTEQ
%left PLUS MINUS
%left MUL DIV
%%

program :  START slist END{codegen($2);
				    fprintf(fp, "MOV SP, 4096\n" );
                    fprintf(fp, "MOV R0, 10\nPUSH R0\nPUSH R0\nPUSH  R0\nPUSH R0\n INT 10\n" );
                    fprintf(fp,"POP R0\nPOP R0\nPOP R0\nPOP R0\n");
						exit(0);}
		;
slist : slist stmt {$$ = TreeCreate(type_void,STMT,0,NULL,NULL,$1,$2,NULL);}
	  | stmt {$$=$1;}
	  ;
expr : expr PLUS expr	{$$ = makeOperatorNode(PLUS,$1,$3);}
	 | expr MUL expr  	{$$ = makeOperatorNode(MUL,$1,$3);}
	 | expr MINUS expr  	{$$ = makeOperatorNode(MINUS,$1,$3);}
	 | expr DIV expr  	{$$ = makeOperatorNode(DIV,$1,$3);}
	 | expr LT expr  	{
								$$ = makeOperatorNode(LT,$1,$3);
								}
     | expr GT expr  	{
								$$ = makeOperatorNode(GT,$1,$3);
								}	
	 | expr LTE expr  	{
								$$ = makeOperatorNode(LTE,$1,$3);
								}
	 | expr GTE expr  	{
								$$ = makeOperatorNode(GTE,$1,$3);
								}
     | expr NOTEQ expr  	{
								$$ = makeOperatorNode(NOTEQ,$1,$3);
								}
	 | expr EQ expr  	{
								$$ = makeOperatorNode(EQ,$1,$3);
								}

	 | '(' expr ')'		{$$ = $2;}
	 | NUM			    {$$ = $1;}
	 | ID              		 {
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

{   fp=fopen("target.xsm","w");
	fprintf(fp, " %d\n %d\n %d\n %d\n %d\n %d\n %d\n %d\n ",0,2056,0,0,0,0,0,0);
	if(argc>1)
	{
		yyin=fopen(argv[1],"r");
		/*if(fp1)
			yyin=fp1;*/
	}    
    yyparse(); 
    
    

    fclose(fp);
    return 1; 
}
