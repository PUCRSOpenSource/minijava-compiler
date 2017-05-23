SDIR = ./src
ODIR = ./out
BINDIR = ./bin
FILE_PREFIX = minijava
YACC_FLAGS = -tv -b $(FILE_PREFIX) -J

OS := $(shell uname)
ifeq ($(OS), Darwin)
BYACCJ = $(BINDIR)/yacc.macosx $(YACC_FLAGS)
else
BYACCJ = $(BINDIR)/yacc.linux $(YACC_FLAGS)
endif

JFLEX  = java -jar $(BINDIR)/JFlex.jar
JAVAC  = javac

all: Parser.class

build: clean Parser.class

clean:
	rm -f *~ *.class minijava.output *.java

Parser.class: Yylex.java Parser.java
	$(JAVAC) Parser.java

Yylex.java: $(SDIR)/lexer.flex
	$(JFLEX) -d . $(SDIR)/lexer.flex

Parser.java: $(SDIR)/parser.y
	$(BYACCJ) $(SDIR)/parser.y
