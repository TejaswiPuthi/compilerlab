%{
  #include "y.tab.h"
  #include<stdlib.h>
  #include<stdio.h>
%}



%%

[0-9]+  {
	yylval = atoi(yytext);
	return DIGIT;
  }

.	return *yytext;

%%

yywrap(){
	return 1;
}
