SDIR = ./src
ODIR = ./out
BINDIR = ./bin

JFLEX  = java -jar $(BINDIR)/JFlex.jar 
JAVAC  = javac
BYACCJ = $(BINDIR)/yacc.linux -tv -b minijava -J 

all: parser

parser: lexer
	$(BYACCJ) $(SDIR)/parser.y

lexer: $(SDIR)/lexer.flex
	$(JFLEX) $(SDIR)/lexer.flex

clean:
	rm *.class *.java
