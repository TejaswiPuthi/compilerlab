%{	
    #include<stdio.h>
    #include<stdlib.h>
    int parse = 0;
    int instruct = 2048;
    int labarr[100];
    FILE * fp;
    FILE * bp;

%}

%%
[L][0-9]+[:][\n]?	{if(parse == 0) labarr[atoi(yytext+1)] = instruct;}
[L][0-9]		{if(parse==1) fprintf(bp,"%d",labarr[atoi(yytext+1)]);}
"\n"			{if(parse==0) {if(instruct<=2055)instruct+=1;else instruct += 2;} else fprintf(bp,"\n");}
.			{if(parse==1) fprintf(bp,"%s",yytext);}

%%

int main()
{
	
	fp = fopen("target.xsm","r");
        yyin = fp;
        yylex();
        parse = 1;
	fp = fopen("target.xsm","r");
	bp = fopen("targetnew.xsm","w");
	yyin = fp;
	yylex();
	return 1;
}

int yywrap(){
	return 1;
}
