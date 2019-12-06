CXX=clang++
CC=clang
LEX=flex
BISON=bison
LD=ld
LDFLAGS=-g -O0 -lreflex 
CXXFLAGS=-std=c++17 -g -O0
CFLAGS=-g -O0


simple: simple.obj grammar.o lexer.o /usr/local/lib/libreflex.a
	$(CXX) $(LDFLAGS) -o simple $^

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

%.obj: %.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

simple.o: simple.c lexer.h

simple.obj: simple.cpp lexer.h

lexer.c: lexer.l
	$(LEX) -o $@ $<

lexer.h: lexer.c lexer.l grammar.h

grammar.c: grammar.y
	$(BISON) -v --report=all --report-file grammar.output -o $@ $< 

grammar.h: grammar.c

clean:
	rm -rf grammar.c grammar.h
	rm -rf lexer.cpp lexer.h
	rm -rf grammar.output
	rm -rf *.obj *.o
	rm -rf simple


