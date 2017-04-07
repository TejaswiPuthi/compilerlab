%{
	#include <stdio.h>
	#include <stdlib.h>
	#define YYSTYPE tnode *
	#include "expr.h"
	#include "expr.c"
	int yylex(void);
	int *var[26];
%}
%union
{
	char character;
	int integer;
};

%token ID READ WRITE NUM NL PLUS MUL ASGN 

%left PLUS
%left MUL

%%
Program : slist NEWLINE
     ;
slist : slist stmt
     | stmt
     ;
expr : expr PLUS expr		{$$ = makeOperatorNode('+',$1,$3);}
	 | expr MINUS expr  	{$$ = makeOperatorNode('-',$1,$3);}
	 | '(' expr ')'		{$$ = $2;}
	 | NUM			{$$ = $1;}
	 | ID   {
            if( var[$1 - 'a'] == NULL)
                printf("unassigned variable");
            else
                $$ = *var[$1 - 'a'];
          }
	 ;
stmt : ID ASGN expr ';'     { $1=$3;}
     | READ '(' ID ')' ';'  { 	if(var[$3-'a'] == NULL)
     							{var[$3 - 'a'] = malloc(sizeof(int));}
								scanf("%d",var[$3-'a']);
							}  
     | WRITE '(' expr ')' ';' { if(var[$3-'a'] == NULL)
     								{printf("error\n");}
     							else
     								printf("%d",$3);
     						  }
     ;
