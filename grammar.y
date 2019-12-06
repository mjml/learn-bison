%{
	#include "simple.h"
	#include <stdio.h>
	#include <string.h>
	
	#define YYPARSE_PARAM scanner
	#define YYLEX_PARAM   scanner
	
	void smerror (char const*);
%}

%require  "3.4"
%defines "grammar.h"
%define api.pure         full
%define api.push-pull    push
%define api.value.type   { struct smTok }
%define api.prefix       {sm}
%define parse.error      verbose

%type     <nVal>  top command

%type     <szStr> value value-expression list-value inner-list-value

%token    <nVal>  INTEGER
%token    <szStr> QUOTEDSTRING

%token    <nVal> BLUEPRINT     "blueprint"    
%token    <nVal> REDPRINT      "redprint"     
 

%%

top: command ':' value-expression ';'
{
	int cmdCode = $1;
	char* colorCode = NULL;
	if (cmdCode == 1) { 
		printf( "\x1b[34m" );
	} else if (cmdCode == 2) {
		printf( "\x1b[31m" );
	}
	char* expr = $3;
	printf("%s", expr);
	printf("\x1b[0m\n");
}

command: BLUEPRINT { $$ = 1; }
| REDPRINT { $$ = 2; }

value-expression:
value { $$ = $1; }
| list-value { $$ = $1; }

list-value: '[' inner-list-value ']' { $$ = $2; }

inner-list-value:
value
{
	printf("Value: %s\n", $1);
	$<szStr>$ = $<szStr>1;
}
| inner-list-value ',' value
{
	int n1 = strlen($<szStr>1);
	int n2 = strlen($<szStr>3);
	char* sz = malloc(n1+n2+2);
	strcpy(sz, $<szStr>1);
	strcat(sz, " ");
	strcat(sz, $<szStr>3);
	free($<szStr>1);
	free($<szStr>3);
}

value: INTEGER { $<szStr>$ = malloc(30); snprintf($<szStr>$, 29, "%d", $1);  }
| QUOTEDSTRING { $<szStr>$ = strdup($1); }

%%



	
void yyerror (char const* s)
{
	fprintf(stderr, "error: %s\n", s);
}
	

