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
  	char *file2="input_file_2.l";
  	if(strcmp(file1,file2)!=0)
  	{
  		file1=file2;  
  		yyin = stdin;
    		return 0;
  	}
  	else
  		return 1;
}

int main()
{
	file1="input_file.l";
  	yylex();
  	return 1;
}
