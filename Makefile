JFLEX  = java -jar JFlex.jar 
JAVAC  = javac
YACC   = yacc

SDIR = ./src
ODIR = ./out

all: lex

syntactic: lexer
	$(JAVAC) MiniJava.java

lexer:
	$(JFLEX) -d $(ODIR) $(SDIR)/lexico.flex

clean:
	rm -f $(ODIR)/*

