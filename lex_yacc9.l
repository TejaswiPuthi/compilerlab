%{
    #include <stdio.h>
    #include <stdlib.h> 
	  #include "y.tab.h"
%}

%%

[0-9]+	{
	  yylval = atoi(yytext);
          return NUMBER;
        }
"+"	  return *yytext;
"-"	  return *yytext;
"*"	  return *yytext;
"/"	  return *yytext;
[()]	  return *yytext;
[\n]      return NEWLINE;

%%

yywrap()
{
	return 1;
}
