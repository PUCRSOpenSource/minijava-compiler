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
%left '!' 
%left '.'
%left '['

%%
Goal : MainClass  ClassDeclaration
     ;
MainClass : CLASS IDENT '{' PUBLIC STATIC VOID MAIN '(' STRING '[' ']' IDENT ')' '{' Body '}' '}'
          ;
ClassDeclaration : CLASS IDENT  '{' VarDeclaration MethodeDeclaration '}'
                 |
                 ;
VarDeclaration : VarDeclaration Var
               |
               ;
Var : INT '[' ']' IDENT ';'
    | STATIC INT IDENT ';'
    | INT IDENT ';'
    ;
MethodeDeclaration : Method MethodeDeclaration
                   |
                   ;
Method : func_header '{' Body '}'
       ;
func_header: PUBLIC IDENT IDENT '('param_list ')'
           | PUBLIC INT IDENT '('param_list ')'
           | PUBLIC INT '[' ']' IDENT '(' param_list ')'
           ;
param_list : param
           | param ',' param_list
           |
           ;
param : INT IDENT
      | INT IDENT '[' INTEGER ']'
      ;
Body : VarDeclaration StatementList
     ;
StatementList : StatementList Statement
              |
              ;
Statement : IF '(' Expression ')' Statement ELSE Statement
          | WHILE '(' Expression ')' Statement
          | PRINT '(' Expression ')' ';'
          | '{' StatementList '}'
          | Expression ';'
          | RETURN Expression ';'
          ;
/*Expression : Expression AND Expression*/
           /*| Expression '<' Expression*/
           /*| Expression '+' Expression*/
           /*| Expression '-' Expression*/
           /*| Expression '*' Expression*/
           /*| Expression '[' Expression ']'*/
           /*| Expression '.' DotExpression*/
           /*| INTEGER*/
           /*| IDENT IdentOrAssign*/
           /*| THIS*/
           /*| NEW ArrayOrClassInitializer*/
           /*| '(' Expression ')'*/
           /*| '!' Expression*/
           /*;*/
/*IdentOrAssign : '=' Expression*/
              /*| '[' Expression ']' '=' Expression*/
              /*| '(' Args ')'*/
              /*;*/
Expression : LogicOrExpression
           | LogicOrExpression '=' LogicOrExpression
           ;
LogicOrExpression : RelationalExpression
                  | LogicOrExpression AND LogicOrExpression
                  ;
RelationalExpression : Term
                     | RelationalExpression '<' Term
                     ;
Term : Factor
     | Term '+' Term
     | Term '-' Term
     ;
Factor : Unary
       | Factor '*' Factor
       | Factor '/' Factor
       ;
Unary : DotExpression
      | '!' Unary
      ;
DotExpression : DotExpression '.' LENGTH
              | DotExpression '.' IDENT
              | DotExpression '.' IDENT '(' Args ')'
              | DotExpression '[' Expression ']'
              | ObjectExpression
              ;
ObjectExpression : THIS
                 | TOP
                 | BOTTOM
                 | NEW ArrayOrClassInitializer
                 | INTEGER
                 | IDENT
                 | '(' Expression ')'
                 ;
ArrayOrClassInitializer: INT '[' Expression ']'
                       | IDENT '(' ')'
                       ;
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
