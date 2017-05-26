%{
  import java.io.*;
%}

%token AND
%token BOOLEAN BOTTOM
%token CLASS
%token ELSE EXTENDS
%token IDENT IF INT INTEGER
%token LENGTH
%token MAIN
%token NEW NL
%token PRINT PUBLIC
%token RETURN
%token STATIC STRING
%token THIS TOP
%token VOID
%token WHILE

%right '='
%nonassoc '<'
%left '+' '-'
%left '*' '/' AND
%right '!' 
%left '.'
%left '['

%%
Goal : MainClass ClassDeclaration
     ;
MainClass : CLASS IDENT '{' PUBLIC STATIC VOID MAIN '(' STRING '[' ']' IDENT ')' '{' Statement '}' '}'
          ;
ClassDeclaration : CLASS IDENT ClassExtends '{' ClassBody '}'
                 |
                 ;
ClassExtends : EXTENDS IDENT
             |
             ;
ClassBody : VarDeclaration MethodDeclaration
          ;
VarDeclaration : Type IDENT ';'
               |
               ;
MethodDeclaration : PUBLIC Type IDENT '(' MethodParams ')' '{' Body  '}'
                  |
                  ;
MethodParams : MethodParams ',' Type IDENT
             | Type IDENT
             |
             ;
Type : PrimitiveType
     | ComplexType
     ;
PrimitiveType : INT '[' ']'
              | BOOLEAN
              | INT
              ;
ComplexType: IDENT
           ;

Body: LocalVariablesList StatementList
    | StatementList
    | RETURN Expression ';'
    ;
LocalVariablesList : Variable
                   | LocalVariablesList Variable
                   ;
Variable : Type IDENT ';'
         ;
StatementList : StatementList Statement
              ;
Statement : IF '(' Expression ')' Statement ELSE Statement
          | WHILE '(' Expression ')' Statement
          | PRINT '(' Expression ')' ';'
          | IDENT '=' Expression ';'
          | IDENT '[' Expression ']' '=' Expression ';'
          ;
Expression : Expression AND Expression
           | Expression '<' Expression
           | Expression '+' Expression
           | Expression '-' Expression
           | Expression '*' Expression
           | Expression '[' Expression ']'
           | Expression '.' LENGTH
           | Expression '.' IDENT '(' MethodInvocation ')'
           | INTEGER
           | TOP
           | BOTTOM
           | IDENT
           | THIS
           | NEW INT '[' Expression ']'
           | NEW IDENT '(' ')'
           | '!' Expression
           | '(' Expression ')'
           ;
MethodInvocation : MethodInvocation ',' Expression
                 | Expression
                 |
                 ;
%%

private Yylex lexer;

private int yylex () {
    int yyl_return = -1;
    try {
      yylval = new ParserVal(0);
      yyl_return = lexer.yylex();
    }
    catch (IOException e) {
      System.err.println("IO error :"+e);
    }
    return yyl_return;
  }


public void yyerror (String error) {
    System.err.println ("Error: " + error);
  }


public Parser(Reader r) {
    lexer = new Yylex(r, this);
  }

public void setDebug(boolean debug) {
      yydebug = debug;
  }

static boolean interactive;

public static void main(String args[]) throws IOException {
    System.out.println("BYACC/J with JFlex Minijava Compiler");

Parser yyparser;
    if ( args.length > 0 ) {
      yyparser = new Parser(new FileReader(args[0]));
    }
    else {
      System.out.println("[Quit with CTRL-D]");
      System.out.print("Expression: ");
      interactive = true;
        yyparser = new Parser(new InputStreamReader(System.in));
    }

yyparser.yyparse();

if (interactive) {
      System.out.println();
      System.out.println("Have a nice day");
    }
}
