%{
#include "y.tab.h"
%}

%%
[i][f] {return IF;}

\n {return NL;}
" " {}
[^"if"] {return OTHER;}
. {return yytext[0];}
%%

int yywrap()
{
return 1;
}
