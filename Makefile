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

Yylex.class: Yylex.java
	$(JAVAC) Yylex.java

Yylex.java: $(SDIR)/lexer.flex
	$(JFLEX) -d . $(SDIR)/lexer.flex

Parser.java: $(SDIR)/parser.y
	$(BYACCJ) $(SDIR)/parser.y

test_syn: 
	java Parser ./tests/Basic.java
	java Parser ./tests/Basic2.java
	java Parser ./tests/Basic3.java
	java Parser ./tests/Basic4.java
	java Parser ./tests/Basic5.java
	java Parser ./tests/Basic3.java
	java Parser ./tests/Basic7.java
	java Parser ./tests/BinarySearch.java
	java Parser ./tests/BinaryTree.java
	java Parser ./tests/BubbleSort.java
	java Parser ./tests/Factorial.java
	java Parser ./tests/LinearSearch.java
	java Parser ./tests/LinkedList.java
	java Parser ./tests/QuickSort.java
	java Parser ./tests/TreeVisitor.java
