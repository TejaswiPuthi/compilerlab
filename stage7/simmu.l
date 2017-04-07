
%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	int lbl[100];
	int b=2056;
	int k=0, loop;
	FILE *fp1, *fp;
	char *str;
	int d,i;
%}

%%

"L"[0-9]+[:][\n]?  {if(loop==0){ str=(char*)malloc(sizeof(char*));strcpy(str,yytext+1); i=0;k=0; while(str[i]!=':'){d=(int)str[i];d=d-48;k=k*10+d;i++;}lbl[k]=b;}}
"L"[0-9]+     {if(loop!=0){fprintf(fp1,"%d",lbl[atoi(yytext+1)]);}}
[\n]           {if(loop==0) { b=b+2;} else fprintf(fp1,"%s",yytext);}
.             {if(loop!=0) fprintf(fp1,"%s",yytext);}


%%

int yywrap(){
	return 1;
}

int main(){
	//FILE *fp;
	int i,c=0;
	loop=0;
	fp=fopen("target.xsm", "r+");
	yyin=fp;
	yylex();
	for(i=0;i<10;i++)
		printf("label %d: %d\n", i, lbl[i]);
	loop=1;
	fp=fopen("target.xsm", "r+");
	fp1=fopen("new.xsm", "w");
	yyin=fp;
	yylex();
	return 1;
}
