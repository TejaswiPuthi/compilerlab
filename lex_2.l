%{
	//count number of int and float
	#include<stdio.h>
	#include<stdlib.h>
	int noi,nod;
%}

digit [0-9]
decimal [0-9]*.[0-9]+
integer [0-9]+

%%
[ \n\t] {}
{integer} {noi++;}
{decimal} {nod++;}

%%

int main()
{
	yyin= fopen("input","r");
	int n=yylex();
	printf("No of integer:%d\n",noi);
	printf("No of decimal:%d\n",nod);
}

int yywrap(){
	return 1;
}