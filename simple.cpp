#include <stdio.h>

#include <locale.h>
#include "simple.h"

extern "C" {
#include "lexer.h"
}

void usage()
{
	printf("Usage:\n  simple \"text-to-parse\"\n");
}


int main (int argc, char* argv[])
{
	yyscan_t scanner;
	yylex_init(&scanner);
	
	struct smTok tok;
	memset(&tok, 0, sizeof(struct smTok));
	int status = 0;
	smpstate* state = smpstate_new();
	int code = 0;
	do {
		code = yylex(&tok, scanner);
		status = smpush_parse(state, code, &tok);
	} while (status == YYPUSH_MORE);
	
	smpstate_delete(state);
	yylex_destroy(scanner);
	
	return 0;
	
}

