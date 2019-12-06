%option bison-bridge
%option reentrant
%option warn
%option noyywrap
%option outfile="lexer.c" header-file="lexer.h"

%top{
#include <stdlib.h>
#include "simple.h"
#include "grammar.h"
#define YYSTYPE struct smTok
}

quotedstring  \"([^\\\"]|\\[\"nrthv])*\"

int [[:digit:]]+

%%

blueprint   yylval->nVal = 1; return BLUEPRINT;

redprint    yylval->nVal = 2; return REDPRINT;

:         return ':';

,         return ',';

;         return ';';

{int}       yylval->nVal = atoi(yytext); return INTEGER;

{quotedstring} yylval->szStr = yytext; return QUOTEDSTRING;

[ \n\h\v\t\r]* /* no actions for whitespace */

%%
