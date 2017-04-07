%{
    #include <stdio.h> 
	  #include "y.tab.h"
%}

%%

[a-zA-Z]+	{
	  char * str;
	  str = (char *) malloc ( 50*sizeof(char));
	  strcpy(str,yytext);
          yylval =str;
          return String;
        }
"+"	  return *yytext;

[\n]      return NEWLINE;

%%

yywrap()
{
	return 1;
}
