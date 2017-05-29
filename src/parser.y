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
%token STATIC STRING STRING_LITERAL
%token THIS TOP
%token VOID
%token WHILE

%right '='
%left AND
%nonassoc '<'
%left '+' '-'
%left '*' '/'
%right '!' 
%left '.'
%left '['

%%
Goal : MainClass  ClassDeclaration
     ;
MainClass : CLASS IDENT '{' PUBLIC STATIC VOID MAIN '(' STRING '[' ']' IDENT ')' '{' VarDeclarationStatementList '}' '}'
          ;
ClassDeclaration : CLASS IDENT  '{' VarDeclarationMethodeDeclaration '}'
                 |
                 ;
VarDeclarationMethodeDeclaration : Var VarDeclarationMethodeDeclaration
                                 | IDENT IDENT ';' VarDeclarationMethodeDeclaration
                                 | MethodeDeclaration
                                 ;
Var : PrimitiveType IDENT ';'
    ;
PrimitiveType : INT
              | BOOLEAN
              | INT '[' ']'
              ;
Type : IDENT
     | PrimitiveType
     ;
MethodeDeclaration : Method MethodeDeclaration
                   |
                   ;
Method : MethodSig '{' VarDeclarationStatementList '}'
       ;
MethodSig : PUBLIC Type IDENT '('Params ')'
          ;
Params : Param
       | Param ',' Params
       |
       ;
Param : PrimitiveType IDENT
      | IDENT IDENT
      ;
VarDeclarationStatementList : PrimitiveType IDENT ';' VarDeclarationStatementList
                            | IDENT IDENT ';' VarDeclarationStatementList
                            | StatementList
                            |
                            ;
StatementList : StatementList Statement
              | Statement
              ;
Statement : IF '(' Expression ')' Statement ELSE Statement
          | WHILE '(' Expression ')' Statement
          | PRINT '(' Expression ')' ';'
          | '{' StatementList '}'
          | Expression ';'
          | IDENT AssignStatement ';'
          | RETURN Expression ';'
          ;
AssignStatement : '=' Expression
                | '[' Expression ']' '=' Expression ';'
                ;
Expression : Expression AND Expression
           | Expression '<' Expression
           | Expression '+' Expression
           | Expression '-' Expression
           | Expression '*' Expression
           | Expression '[' Expression ']'
           | Expression '.' LENGTH
           | Expression '.' Id '(' Args ')'
           | '(' Expression ')'
           | INTEGER
           | Id
           | THIS
           | NEW INT '[' Expression ']'
           | NEW Id '(' ')'
           | '!' Expression
           ;
Id : IDENT
Args : ArgList
     |
     ;
ArgList : Expression
        | Expression ',' ArgList
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
