SDIR = ./src
ODIR = ./out
BINDIR = ./bin

JFLEX  = java -jar $(BINDIR)/JFlex.jar 
JAVAC  = javac
BYACCJ = $(BINDIR)/yacc.linux -tv -b minijava -J 

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
