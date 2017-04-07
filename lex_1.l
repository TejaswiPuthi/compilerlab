%option noyywrap

%{
	//Count number of lines,words,characters
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>

	int nol,now,noc;

%}

%%

[\n] {nol++;now++;}
[\t ''] {now++;}
[a-z A-Z 0-9]|. {noc++;}
 
%%

int main()
{
	yyin= fopen("input","r");
	int n=yylex();
	printf("No of words:%d\n",now);
	printf("No of characters:%d\n",noc);
	printf("No of lines:%d\n",nol+1);

}

