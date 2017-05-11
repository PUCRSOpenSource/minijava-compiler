SDIR = ./src
ODIR = ./out
BINDIR = ./bin

JFLEX  = java -jar $(BINDIR)/JFlex.jar 
JAVAC  = javac
YACC   = $(BINDIR)/yacc


all: lex

parser: lexer
	$(JAVAC) MiniJava.java

lexer:
	$(JFLEX) -d $(ODIR) $(SDIR)/lexico.flex

clean:
	rm -f $(ODIR)/*

