%{		#define YYSTYPE struct tnode*
        
	#include <stdio.h>
	#include <stdlib.h>
	#include "stg9.c"

extern int address;

	FILE *fp;
	extern FILE *yyin;
	int *var[26];
	int type,x,before;	
	struct Lsymbol *lhead=NULL;
	struct Lsymbol *ltemp = NULL;
    struct ArgStruct  *argnode=NULL;
	struct ArgStruct *temp=NULL;
	struct ArgStruct  *argcomp= NULL;
	struct Lsymbol * lnode = NULL;
	int argbinding=-3;
	int argcompare(struct ArgStruct * t1,struct ArgStruct * t2);
	void  arginstall(char * NAME,int TYPE,int a);
	void freenode(struct ArgStruct *t1);
	void freelnode(struct Lsymbol * t1);
	int argcompare1(struct ArgStruct * t1,struct ArgStruct * t2);


%}



%token ID READ WRITE NUM NL PLUS MUL MINUS DIV MOD ASGN LT GT EQ IF ELSE THEN WHILE DO ENDWHILE ENDIF STMT START END LTE GTE NOTEQ DECL ENDDECL INT BOOL TRUE FALSE BOOLEAN AND OR NOT RETN MAIN
%nonassoc LT GT EQ LTE GTE NOTEQ AND OR NOT 
%left PLUS MINUS
%left MUL DIV MOD
%%

program : GDeclBlock FdefBlock main {}
|GDeclBlock main {}
        | main {}
        ;

GDeclBlock : DECL GdeclList ENDDECL {}
             | DECL ENDDECL  {}
;

GdeclList : GdeclList GDecl {}
            | GDecl {}
;
GDecl : Type GidList ';' {}
;

	

GidList : GidList ',' Gid {}
          | Gid {}
;

Gid : ID    {if(Glookup($1->NAME)!=NULL)
	   		{printf("multiple decl\n");exit(0);}
	   	    Ginstall($1->NAME,type,sizeof(int),NULL);}

| ID '[' NUM ']' {if($3->TYPE!=type_int)
    		  		{printf("array wrong type\n");exit(0);}
    			if(Glookup($1->NAME)!=NULL)
				{printf("multiple decl\n");exit(0);}
			Ginstall($1->NAME,type,sizeof(int)*$3->VALUE,NULL);}

| ID '(' ParamList ')' {	if(Glookup($1->NAME)!=NULL)
				             {printf("multiple decl\n");exit(0);}
				             Ginstall($1->NAME,type,0,argnode);    //$3
				             //freenode(argnode);
				             argnode=NULL;
							}
;

ParamList : ParamList ',' params {}
			| params {}
			| %empty {}
			;
params    : 
			  INT ID       {arginstall($2->NAME,type_int,1);}
			| INT '&' ID   {arginstall($3->NAME,type_int,0);}
			;

FdefBlock : FdefBlock Fdef {}
           | Fdef {}
;

Fdef :Type ID '(' Arglist ')' '{' LdeclBlock Body '}' 
							{
							if(Glookup($2->NAME)==NULL)	
							{
							   printf("function undeclared\n");
							   exit(0);
							}
							if(Glookup($2->NAME)->TYPE!=type)
							{ 
							   printf("ret type mismatch\n");
							   exit(0);
							}
							temp=Glookup($2->NAME)->ARGLIST;
							printa(Glookup($2->NAME)->ARGLIST);
							printa(argcomp);
							x=argcompare(temp,argcomp);
							if(x==0)
							{
							 printf("Arguments mismatch\n");
							 exit(0);
							}
							Glookup($2->NAME)->Lentry = lnode;
							before =1;
							$$ = TreeCreate(type_void,FNDEF,0,$2->NAME,NULL,$8,NULL,NULL);
							codegen($$);
							freelnode(lnode);
							lnode=NULL;
							argcomp=NULL;
							}
; 

Arglist : Arglist ',' Arg {}
         | Arg {}
         | %empty {}
;

Arg : INT ID  {
      				if(argcomp==NULL)
						{
							argbinding=-3;
							argcomp=malloc(sizeof(struct ArgStruct));
							temp=argcomp;
						}
					else{
							temp=argcomp;
							while(temp->NEXT!=NULL)
						{
							temp=temp->NEXT;
						}
					temp->NEXT=malloc(sizeof(struct ArgStruct));
					temp=temp->NEXT;
					    }
					temp->TYPE= type_int;
					temp->NAME=$2->NAME;
					temp->NEXT=NULL;
					temp->passvalue=1;
					temp->passref=0;
					temp->BINDING=argbinding;
					argbinding--;
					Linstall($2->NAME,type_int,sizeof(int));

	   		


	  }
			| INT '&' ID  {if(argcomp==NULL)
						{
							argbinding=-3;
							argcomp=malloc(sizeof(struct ArgStruct));
							temp=argcomp;
						}
					else{
							temp=argcomp;
							while(temp->NEXT!=NULL){
							temp=temp->NEXT;
						}
					temp->NEXT=malloc(sizeof(struct ArgStruct));
					temp=temp->NEXT;}
					temp->TYPE= type_int;
					temp->NAME=$3->NAME;
					temp->NEXT=NULL;
					temp->passvalue=0;
					temp->passref=1;
					temp->BINDING=argbinding;
					argbinding--;
					Linstall($3->NAME,type_int,sizeof(int));
	   		
	   		}
			;
; 



LdeclBlock : DECL LDecList ENDDECL {print(lnode);}
             | DECL ENDDECL   {}
;
LDecList : LDecList LDecl {}
            | LDecl {}
;
LDecl : Type LIdList ';' {}
; 

LIdList : LIdList',' LID {}
           | LID {}
;

LID :  ID { if (Llookup($1->NAME) != NULL){		
			printf("Already declared %s", $1->NAME);
			exit(-1);
			}
           Linstall($1->NAME,type,sizeof(int));
				}
	| ID '[' NUM ']' {Linstall($1->NAME,type,sizeof(int)*$3->VALUE);}
	;
Type : INT  {type = type_int;}
      | BOOL {type = type_bool;}
;	

 main : INT MAIN '(' ')' '{' LdeclBlock Body '}' 
 					 {  $$ = TreeCreate(type_void,FNDEF,0,"MAIN",NULL,$7,NULL,NULL);
                        codegen($$);
                        freelnode(lnode);
                        lnode=NULL;
                       // fprintf(fp, "MOV SP, %d\n",address );
                    fprintf(fp, "MOV R0, 10\nPUSH R0\nPUSH R0\nPUSH  R0\nPUSH R0\n INT 10\n" );
                    fprintf(fp,"POP R0\nPOP R0\nPOP R0\nPOP R0\n");
						exit(0);
                         }


Body :START slist retstmt END { $$ = TreeCreate(type_void,STMT,0,NULL,NULL,$2,$3,NULL);}
	 | START retstmt END {$$ = TreeCreate(type_void,STMT,0,NULL,NULL,$2,NULL,NULL);}
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
     						printf("Variable undeclared1");
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
     						ltemp= Llookup($1->NAME);
     						if(ltemp==NULL)
     						{
     						if(Glookup($1->NAME)==NULL)
     						{
     						printf("Name of undecl variable:%s\n",$1->NAME);
     						printf("Variable undeclared2");
     						exit(0);
     						}
	 						$1->TYPE=Glookup($1->NAME)->TYPE;
                			}
                			else 
                			$1->TYPE = Llookup($1->NAME)->TYPE;
                			$$=$1; 
          				} 
     | ID '(' ActualParams  ')'  { struct Argstruct * a = Glookup($1->NAME)->ARGLIST ;
     								x=argcompare1(a,$3);
     								if(x==0)
     								{
     								printf("arguments mismatch error\n");
     								exit(0);
     								}
     								$$= TreeCreate($1->TYPE, FNCALL, 0,$1->NAME, NULL, $3, NULL, NULL);
     								}
     
	 ;



stmt :  ID '(' ActualParams ')' ';' {struct Argstruct * a = Glookup($1->NAME)->ARGLIST ;
     								x=argcompare1(a,$3);
     								if(x==0)
     								{
     								printf("arguments mismatch error\n");
     								exit(0);
     								}
     								$$= TreeCreate($1->TYPE, FNCALL, 0,$1->NAME, NULL, $3, NULL, NULL);}

    	|ID '[' expr ']' ASGN expr ';' 
						{ 
							if((Glookup($1->NAME)->SIZE)/sizeof(int)<=$3->VALUE)
     						{
     						  printf("ARRAY OVERFLOW\n");
     						  exit(0);
     						}

							if(Glookup($1->NAME)==NULL)
     						{
     						   printf("Variable undeclared3");
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

     |ID ASGN expr ';'  {   
     						if(Llookup($1->NAME)==NULL)
     						{
     						   if(Glookup($1->NAME)==NULL)
     						   {
     						      printf("Variable undeclared4");
     						      exit(0);
     						    }
     						if(Glookup($1->NAME)->TYPE != $3->TYPE)
     						{
     						  printf("type mismatch!");
     						  exit(0);
     						}
     						}
     						else
     						{
     						if(Llookup($1->NAME)->TYPE != $3->TYPE)
     						{
     						printf("type mismatch!");
     						exit(0);
     						}
     						}
     						$$=TreeCreate(type_void,ASGN,0,NULL,NULL,$1,$3,NULL);}

	 | READ '(' ID ')'';'{  
	 						if(Llookup($1->NAME)==NULL)
	 						{
		 						  if(Glookup($3->NAME)==NULL)
	     						  {
	     						   printf("Variable undeclared5");
	     						   exit(0);
	     						  }

     						if(Glookup($3->NAME)->TYPE!=type_int)
     						{
     						printf("Read type error\n");
     						exit(0);
     						}
     						}
     						else
     						{
     						if(Llookup($3->NAME)->TYPE!=type_int)
     						{
     						printf("Read type error\n");
     						exit(0);
     						}
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
     						   printf("Variable undeclared6");
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

	ActualParams : ActualParams ',' expr {$3->ArgList=$1;
											 $$= $1;}
			 | expr {$$=$1;}
			 | %empty { }
			 ;
 
 retstmt : RETN expr ';'  {$$=TreeCreate(type_void,RETN,0,NULL,NULL,$2,NULL,NULL);}

%%

int yyerror(char const *s)
{
	printf("yyerror %s", s);
}

void  arginstall(char * NAME,int TYPE,int a)
{					
	                if(argnode==NULL)
						{
						    
							argnode=malloc(sizeof(struct ArgStruct));
							temp=argnode;
						}
					else{
							temp=argnode;
							while(temp->NEXT!=NULL){
							temp=temp->NEXT;
						}
					temp->NEXT=malloc(sizeof(struct ArgStruct));
					temp=temp->NEXT;}
					temp->TYPE= TYPE;
					temp->NAME=NAME;
					temp->NEXT=NULL;
					temp->passvalue=a;
					temp->passref=1-a;

}
void freenode(struct ArgStruct *t1)
{
	struct ArgStruct * t = t1;
	while(t!=NULL)
	{
	printf("free: %s\n",t->NAME);
	t=t->NEXT;
	free(t1);
	t1=t;
	}
}

void freelnode(struct Lsymbol *t1)
{
    
	struct Lsymbol * t = t1;

	while(t!=NULL)
	{
	t=t->NEXT;
	free(t1);
	t1=t;
	}
}
int argcompare1(struct ArgStruct * t1,struct ArgStruct * t2)
{
	int ret=1;
	while(t1!=NULL && t2!=NULL)
	{
			if(t1->TYPE!=t2->TYPE)
			{
				ret=0;
			    return ret;
			}
			t1=t1->NEXT;
			t2=t2->NEXT;
	}

	if((t1==NULL && t2!=NULL) || (t1!=NULL && t2==NULL))
	{
	printf("hello\n");
	printf("No of arguments do not match\n");
	return 0;
	}
	return 1;
}


int argcompare(struct ArgStruct * t1,struct ArgStruct * t2)
{
	int ret=1;
	while(t1!=NULL && t2!=NULL)
	{
			
			if(strcmp(t1->NAME,t2->NAME)!=0)
			{
			  printf("name\n");
			  ret=0;
			  return ret;
			}
			else if(t1->TYPE!=t2->TYPE)
			{
			    printf("type\n");
				ret=0;
			    return ret;
			}
			t1=t1->NEXT; 
			t2=t2->NEXT;
	}

	if((t1==NULL && t2!=NULL) || (t1!=NULL && t2==NULL))
	{
	
	printf("No of arguments do not match");
	return 0;
	}
	return 1;
}

void print(struct Lsymbol *p)
{	
	while(p!=NULL)
	{
	
	p=p->NEXT;
	}
	}

void printa(struct ArgStruct * p)
{	int count=0;
	while(p!=NULL)
	{
	
	p=p->NEXT;
	count++;
	}
}

int main(int argc,char* argv[])

{   fp=fopen("target.xsm","w");
	fprintf(fp, "%d\n%d\n%d\n%d\n%d\n%d\n%d\n%d\n",0,2056,0,0,0,0,0,0);
	fprintf(fp, "MOV SP,%d\n",address);
	fprintf(fp, "MOV BP,%d\n",address+1);
	fprintf(fp, "JMP MAIN\n");

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