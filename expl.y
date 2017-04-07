%{		#define YYSTYPE struct tnode*

	#include <stdio.h>
	#include <stdlib.h>
	#include "expl.c"

	FILE *fp;
	extern FILE *yyin;
	int *var[26];
%}



%token ID READ WRITE NUM NL PLUS MUL MINUS DIV MOD ASGN LT GT EQ IF ELSE THEN WHILE DO ENDWHILE ENDIF STMT START END LTE GTE NOTEQ DECL ENDDECL INT BOOL TRUE FALSE BOOLEAN AND OR NOT
%nonassoc LT GT EQ LTE GTE NOTEQ AND OR NOT 
%left PLUS MINUS
%left MUL DIV MOD
%%
program: decls main {}
	   |main {}
	   ;

decls  : DECL declarations ENDDECL {}
		;

declarations: declarations decl {}
			| decl  {}
			;

decl: INT ID ';'                 {		
						if(Glookup($2->NAME)!=NULL)
						{printf("multiple decl\n");exit(0);}
						
					    Ginstall($2->NAME,type_int,sizeof(int));
				 }
    | INT ID '['NUM']'';' {  
    					if($4->TYPE!=type_int)
    					{printf("array wrong type\n");exit(0);}
    					if(Glookup($2->NAME)!=NULL)
						{printf("multiple decl\n");exit(0);}
						
    					Ginstall($2->NAME,type_int,sizeof(int)*$4->VALUE);
    						}
    | BOOL ID ';' { 	if(Glookup($2->NAME)!=NULL)
						{printf("multiple decl\n");exit(0);}
						
    					Ginstall($2->NAME,type_bool,sizeof(int));}

    | BOOL ID '[' NUM ']' ';' {
    					
    					if($4->TYPE!=type_int)
    					{printf("array wrong type\n");exit(0);}
    					if(Glookup($2->NAME)!=NULL)
						{printf("multiple decl\n");exit(0);}
						
						Ginstall($2->NAME,type_bool,sizeof(int)*$4->VALUE);
						}
    	;
    

    
    

main :START slist END {evaluate($2);exit(0);}
		;
slist : slist stmt {
						if($1->TYPE!=type_void|| $2->TYPE != type_void)
						{
						printf("statement type error");
						exit(0);
						}
						$$ = TreeCreate(type_void,STMT,0,NULL,NULL,$1,$2,NULL);}
	  | stmt 			{   if($1->TYPE!=type_void)
								{
									printf("statement type error");
									exit(0);
								}
	  						$$=$1;}
	  ;
expr : expr PLUS expr	{
							if($1->TYPE!=type_int||$3->TYPE!=type_int)
								{printf("PLUS ERROR\n");exit(0);}
							$$ = makeOperatorNode(PLUS,$1,$3,type_int);
							
							}

	 | expr MUL expr  	{if($1->TYPE!=type_int||$3->TYPE!=type_int)
								{printf("MUL ERROR\n");exit(0);}
								$$ = makeOperatorNode(MUL,$1,$3,type_int);
								}

	 | expr MINUS expr  {if($1->TYPE!=type_int||$3->TYPE!=type_int)
								{printf("MINUS ERROR\n");exit(0);}
								$$ = makeOperatorNode(MINUS,$1,$3,type_int);
								}

	 | expr DIV expr  	{if($1->TYPE!=type_int||$3->TYPE!=type_int)
								{printf("DIV ERROR\n");exit(0);}
								$$ = makeOperatorNode(DIV,$1,$3,type_int);
								}

	 | expr MOD expr  	{if($1->TYPE!=type_int||$3->TYPE!=type_int)
								{printf("MOD ERROR\n");exit(0);}
								$$ = makeOperatorNode(MOD,$1,$3,type_int);
								}

	 | expr LT expr  	{if($1->TYPE!=type_int||$3->TYPE!=type_int)
								{printf("LT ERROR\n");exit(0);}
								$$ = makeOperatorNode(LT,$1,$3,type_bool);
								}

	 | expr GT expr  	{if($1->TYPE!=type_int||$3->TYPE!=type_int)
								{printf("GT ERROR\n");exit(0);}
								$$ = makeOperatorNode(GT,$1,$3,type_bool);
								}

	 | expr EQ expr  	{if($1->TYPE!=type_int||$3->TYPE!=type_int)
								{printf("EQ ERROR\n");exit(0);}
								$$ = makeOperatorNode(EQ,$1,$3,type_bool);
								}

	 | expr LTE expr  	{if($1->TYPE!=type_int||$3->TYPE!=type_int)
								{printf("LTE ERROR\n");exit(0);}
								$$ = makeOperatorNode(LTE,$1,$3,type_bool);
								}

	 | expr NOTEQ expr  	{if($1->TYPE!=type_int||$3->TYPE!=type_int)
								{printf("NOTEQ ERROR\n");exit(0);}
								$$ = makeOperatorNode(NOTEQ,$1,$3,type_bool);
								}

	 | expr GTE expr  	{if($1->TYPE!=type_int||$3->TYPE!=type_int)
								{printf("GTE ERROR\n");exit(0);}
								$$ = makeOperatorNode(GTE,$1,$3,type_bool);
								}
	 | expr AND expr    { if($1->TYPE!=type_bool||$3->TYPE!=type_bool )
	 						{printf("AND ERROR\n");exit(0);}
	                     $$ = makeOperatorNode(AND,$1,$3,type_bool);}
	 | expr OR expr     {if($1->TYPE!=type_bool||$3->TYPE!=type_bool )
	 						{printf("OR ERROR\n");exit(0);}
	 						$$ = makeOperatorNode(OR,$1,$3,type_bool);}
	 | NOT expr  		{if($2->TYPE!=type_bool)					
	 						{printf("OR ERROR\n");exit(0);}
	 						$$=makeOperatorNode(NOT,$2,NULL,type_bool);}
	 | '(' expr ')'		{$$ = $2;}
	 | NUM			    {$$ = $1;
	 						}
	 | TRUE 			{$$ = $1;
	 					$$->NODETYPE=TRUE;}
	 | FALSE 			{$$ = $1;
	 					$$->NODETYPE=FALSE;}
     | ID '[' expr ']'  { 	
     						if((Glookup($1->NAME)->SIZE)/sizeof(int)<=$3->VALUE)
     						{
     						printf("ARRAY OVERFLOW\n");
     						exit(0);
     						}

     						if($3->TYPE!=type_int)
     						{
     						printf("Identifier expression error\n");
     						exit(0);
     						}
     						if(Glookup($1->NAME)==NULL)
     						{
     						printf("Variable undeclared");
     						exit(0);
     						}
     						if(Glookup($1->NAME)->TYPE==type_int)
     						{
     						
     						$$ = TreeCreate(type_int,ARR,0,$1->NAME,NULL,$1,$3,NULL);
     							}
     							else if(Glookup($1->NAME)->TYPE==type_bool)
     							{
     							$$ = TreeCreate(type_bool,ARR,0,$1->NAME,NULL,$1,$3,NULL);
     							}
     							else
     							{
     							printf("Wrong array type\n");
     							exit(0);
     							}
     					}
     | ID               {	
     						if(Glookup($1->NAME)==NULL)
     						{
     						printf("Variable undeclared");
     						exit(0);
     						}
	 						$1->TYPE=Glookup($1->NAME)->TYPE;
                			$$ = $1;
          				}
	 ;
stmt :	ID '[' expr ']' ASGN expr ';' 
						{ 
							if((Glookup($1->NAME)->SIZE)/sizeof(int)<=$3->VALUE)
     						{
     						printf("ARRAY OVERFLOW\n");
     						exit(0);
     						}

							if(Glookup($1->NAME)==NULL)
     						{
     						printf("Variable undeclared");
     						exit(0);
     						}

     						if($3->TYPE!=type_int)
     						{
     						printf("array assignment index incorrect\n");
     						exit(0);
     						}

     						if(Glookup($1->NAME)->TYPE==type_int && $6->TYPE==type_int)
     						$$ = TreeCreate(type_void, ASGNARR, 0,$1->NAME, NULL, $3, $6, NULL);
     						
     						else if(Glookup($1->NAME)->TYPE==type_bool && $6->TYPE==type_bool)
     						{
     						$$ = TreeCreate(type_void, ASGNARR, 0,$1->NAME, NULL, $3, $6, NULL);
     						}

     						else
     						{
     						printf("wrong assignment!\n");
     						exit(0);
     						}
     						}

     |ID ASGN expr ';'  {   if(Glookup($1->NAME)==NULL)
     						{
     						printf("Variable undeclared");
     						exit(0);
     						}
     						if(Glookup($1->NAME)->TYPE != $3->TYPE)
     						{
     						printf("type mismatch!");
     						exit(0);
     						}
     						$$=TreeCreate(type_void,ASGN,0,NULL,NULL,$1,$3,NULL);}

	 | READ '(' ID ')'';'{  

	 						if(Glookup($3->NAME)==NULL)
     						{
     						printf("Variable undeclared");
     						exit(0);
     						}

     						if(Glookup($3->NAME)->TYPE!=type_int)
     						{
     						printf("Read type error\n");
     						exit(0);
     						}
	 						$$=TreeCreate(type_void,READ,0,NULL,NULL,$3,NULL,NULL);}

	 | READ '(' ID '[' expr ']' ')' ';' 
	 						{
	 						if((Glookup($3->NAME)->SIZE)/sizeof(int)<=$5->VALUE)
     						{
     						printf("ARRAY OVERFLOW\n");
     						exit(0);
     						}
	 						if(Glookup($3->NAME)==NULL)
     						{
     						printf("Variable undeclared");
     						exit(0);
     						}
     						if($5->TYPE!=type_int)
     						{
     						printf("array type incorrect\n");
     						exit(0);
     						}

     						if(Glookup($3->NAME)->TYPE!=type_int)
     						{
     							printf("wrong read array id type\n");
     							exit(0);
     						}
     						$$= TreeCreate(type_void,READARR,0,NULL,NULL,$3,$5,NULL);}						
	 | WRITE '('expr ')' ';' { 	
	 							if($3->TYPE==type_bool)
	 							{
	 							printf("write expression error\n");
	 							exit(0);
	 							}
	 							$$=TreeCreate(type_void,WRITE,0,NULL,NULL,$3,NULL,NULL);}

	 | IF '(' expr ')' THEN slist ENDIF ';' {
	 					
	 					if($3->TYPE!=type_bool )
	 					{
	 						printf("if condition type error\n");
	 						exit(0);
	 					}
	 					if($6->TYPE!=type_void )
	 					{
	 					printf("if sttmt error\n");
	 					exit(0);
	 					}
	 					$$=TreeCreate(type_void,IF,0,NULL,NULL,$3,$6,NULL);}
	 					
	 | WHILE '(' expr ')' DO slist ENDWHILE  ';' {
	 							if($3->TYPE!=type_bool )
	 					{
	 						printf("while condition type error\n");
	 						exit(0);
	 					}
	 					if($6->TYPE!=type_void )
	 					{
	 					printf("if sttmt error\n");
	 					exit(0);
	 					}
	 							$$=TreeCreate(type_void,WHILE,0,NULL,NULL,$3,$6,NULL);}	
	 |IF '(' expr ')' THEN slist ELSE slist ENDIF ';'
				{
				if($3->TYPE!=type_bool )
	 					{
	 						printf("if condition type error\n");
	 						exit(0);
	 					}
	 					if($6->TYPE!=type_void )
	 					{
	 					printf("if sttmt error\n");
	 					exit(0);
	 					}
	 					if($8->TYPE!=type_void )
	 					{
	 					printf("if sttmt error\n");
	 					exit(0);
	 					}
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
