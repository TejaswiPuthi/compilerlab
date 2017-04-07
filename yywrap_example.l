%{
	#include<stdio.h>
	char *file1;
%}

%%

[0-9]+ 	printf("number");

%%

int yywrap()
{
  	FILE *newfile_pointer;
  	char *file2="input";
  	newfile_pointer = fopen("input","r");
  	if(strcmp(file1,file2)!=0)
  	{
  		file1=file2;  
  		yyin = newfile_pointer;
    		return 0;
  	}
  	else
  		return 1;
}

int main()
{
	file1="input";
  	yyin = fopen("input","r");
  	yylex();
  	return 1;
}