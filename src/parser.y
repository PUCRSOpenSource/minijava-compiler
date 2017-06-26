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
%nonassoc '<'
%left AND
%left '+' '-'
%left '*'
%right '!' 
%left '.'
%left '['

%type <sval> IDENT
%type <ival> INTEGER
%type <obj> Type
%type <obj> PrimitiveType
%type <obj> Expression

%%
Goal :
     {
     currEscopo = "";
     }
     MainClass ClassDeclaration
     ;
MainClass : CLASS IDENT '{' PUBLIC STATIC VOID MAIN '(' STRING '[' ']' IDENT ')' '{' VarDeclarationStatementList '}' '}'
          ;
ClassDeclaration : CLASS IDENT
                 {
                    TS_entry nodo = ts.pesquisa($2);
                    if(nodo == null) {
                        ts.insert(new TS_entry($2, Tp_OBJECT, null, ClasseID.TipoComplexo, true));
                        ts.resolveType($2);
                        currEscopo = $2;
                    }
                    else
                        yyerror("(sem) -> Classe <" + $2 + "> ja declarada");
                 }
                 Extends '{' VarDeclarationMethodeDeclaration '}' ClassDeclaration
                 |
                 ;
Extends : EXTENDS IDENT
        {
        }
        |
        ;
VarDeclarationMethodeDeclaration : Var VarDeclarationMethodeDeclaration
                                 | MethodeDeclaration
                                 ;
Var : Type IDENT ';'
    {
        TS_entry nodo = ts.pesquisa($2);
        boolean resolved = ts.isResolved(((TS_entry) $1).getId());
        if(nodo == null)
            ts.insert(new TS_entry($2, (TS_entry)$1, currEscopo, currClass, resolved));
        else
            yyerror("(sem) -> Variavel <" + $2 + "> ja declarada");
    }
    ;
PrimitiveType : INT
              {
                 $$ = Tp_INT;
              }
              | BOOLEAN
              {
                 $$ = Tp_BOOL;
              }
              | INT '[' ']'
              {
                 $$ = Tp_ARRAY;
              }
              ;
Type : IDENT
     {
        TS_entry type = ts.pesquisa($1);
        if(type == null)
            type = new TS_entry($1, null, "", ClasseID.TipoComplexo, false);
        $$ = type;
     }
     | PrimitiveType
     ;
MethodeDeclaration : Method MethodeDeclaration
                   |
                   ;
Method : MethodSig '{' VarDeclarationStatementList RETURN Expression ';' '}'
       ;
MethodSig : PUBLIC Type IDENT 
{
TS_entry nodo = ts.pesquisa($3);
                if(nodo == null) {
                 ts.insert(new TS_entry($3, Tp_OBJECT, currEscopo, ClasseID.TipoComplexo, true));
                 ts.resolveType($3);
                 currEscopo = $3;
                    }
                    else
                        yyerror("(sem) -> Type <" + $3 + "> ja declarada");
					}
              		 '(' Params ')'
                 |
                 ;
	Params : Type IDENT Param
       |
       ;
Param : ',' Type IDENT Param
      |
      ;
VarDeclarationStatementList : Var VarDeclarationStatementList
                            | Statement StatementList 
                            |
                            ;
StatementList : StatementList Statement 
              |
              ;
Statement : '{' StatementList '}'
          | IF '(' Expression ')' Statement ELSE Statement
          {
                if((TS_entry)$3 != Tp_BOOL)
                    yyerror("(sem) if expressão deve ser lógica ");
          }
          | WHILE '(' Expression ')' Statement
          {
                if($3 != Tp_BOOL)
                    yyerror("(sem) while expressão deve ser lógica ");
          }
          | PRINT '(' Expression ')' ';'
          {
          }
          | IDENT '=' Expression ';'
          {
                TS_entry nodo = ts.pesquisa($1);
                if(nodo != null)
                    validaTipo('=', nodo.getTipo(), (TS_entry)$3);
                else
                    yyerror("(sem) var <" + $1 + "> nao declarada");
          }
          | IDENT '[' Expression ']' '=' Expression ';'
          {
                TS_entry nodo = ts.pesquisa($1);
                if(nodo != null){
                    validaTipo('[', nodo.getTipoBase(), (TS_entry)$3);
                    if((TS_entry)$3 != Tp_INT)
                        yyerror("(sem) "+ $3 + " indice não é to tipo inteiro.");
                    if((TS_entry)$6 != Tp_INT)
                        yyerror("(sem) "+ $6 + " não é to tipo inteiro.");
                }
          }
          ;
Expression : Expression AND Expression
           {
                $$ = validaTipo(AND, (TS_entry)$1, (TS_entry)$3);
           }
           | Expression '<' Expression
           {
                $$ = validaTipo('<', (TS_entry)$1, (TS_entry)$3);
           }
           | Expression '+' Expression
           {
                $$ = validaTipo('+', (TS_entry)$1, (TS_entry)$3);
           }
           | Expression '-' Expression
           {
                $$ = validaTipo('-', (TS_entry)$1, (TS_entry)$3);
           }
           | Expression '*' Expression
           {
                $$ = validaTipo('*', (TS_entry)$1, (TS_entry)$3);
           }
           | Expression '[' Expression ']'
           {
                if((TS_entry)$1 != Tp_ARRAY)
                    yyerror("(sem) nao é array");
                if((TS_entry)$3 != Tp_INT)
                    yyerror("(sem) acesso array deve ser int");
                else
                    $$ = Tp_INT;
           }
           | Expression '.' LENGTH
           {
                $$ = validaTipo(LENGTH, (TS_entry)$1, null);
           }
           | Expression '.' IDENT '(' Args ')'
           {
           /*isso aqui é foda pra krl*/
           }
           | '(' Expression ')'
           {
                $$ = $2;
           }
           | INTEGER
           {
                $$ = Tp_INT;
           }
           | IDENT
           {
                TS_entry nodo = ts.pesquisa($1);
                if(nodo == null)
                    yyerror("(sem) var <" + $1 + "> nao declarada");
                else
                    $$ = nodo.getTipo();
           }
           | THIS
           {
                $$ = Tp_OBJECT;
           }
           | TOP
           {
                $$ = Tp_BOOL;
           }
           | BOTTOM
           {
                $$ = Tp_BOOL;
           }
           | NEW INT '[' Expression ']'
           {
                if($4 != Tp_INT)
                    yyerror("(sem) tamanho do arra tem que ser inteiro");
                else
                    $$ = Tp_ARRAY;
           }
           | NEW IDENT '(' ')'
           {
           }
           | '!' Expression
           {
                $$ = validaTipo('!', (TS_entry)$2, null);
           }
           ;
Args : Expression ArgList
     |
     ;
ArgList : ','Expression ArgList
        |
        ;
%%

private Yylex lexer;
private TabSimb ts;
private String currEscopo;
private ClasseID currClass;

public static TS_entry Tp_INT = new TS_entry("int", null, "", ClasseID.TipoBase);
public static TS_entry Tp_BOOL= new TS_entry("boolean", null, "", ClasseID.TipoBase);
public static TS_entry Tp_ARRAY = new TS_entry("array", null, "", ClasseID.TipoBase);
public static TS_entry Tp_OBJECT = new TS_entry("object", null, "", ClasseID.TipoComplexo);
public static TS_entry Tp_ERRO = new TS_entry("_erro_", null, "", ClasseID.TipoBase);

public static final int ARRAY = 1500;
public static final int ATRIB = 1600;

private int yylex () {
    int yyl_return = -1;
    try {
      yylval = new ParserVal(0);
      yyl_return = lexer.yylex();
    }
    catch (IOException e) {
      System.err.println("IO error :" + e);
    }
    return yyl_return;
}


public void yyerror (String error) {
    System.err.println ("Error: (linha: " + lexer.getLine() + ")\tMensagem: " + error);
}


public Parser(Reader r) {
    lexer = new Yylex(r, this);
    ts = new TabSimb();

    ts.insert(Tp_ERRO);
    ts.insert(Tp_INT);
    ts.insert(Tp_BOOL);
    ts.insert(Tp_ARRAY);

}

public void setDebug(boolean debug) {
    yydebug = debug;
}

public void listarTS() {
    ts.listar();
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
    yyparser.listarTS();

    if (interactive)
      System.out.println();

    System.out.println("Have a nice day");
}

TS_entry validaTipo(int operador, TS_entry A, TS_entry B) {

    if (operador == '+' || operador == '-' || operador == '*') {
      if ( A == Tp_INT && B == Tp_INT) {
        return Tp_INT;
      }
      else {
        yyerror("(sem) tipos incomp. para operador aritimetico: " + A + " " + String.valueOf(operador) + " " + B);
      }
    }

    if (operador == AND) {
      if (A == Tp_BOOL && B == Tp_BOOL) {
        return Tp_BOOL;
      } else {
        yyerror("(sem) tipos incomp. para operador lógico: "+ A + " && "+B);
      }
    }

    if (operador == '=') {
      if (A == B) {
        return A;
      } else {
        yyerror("(sem) tipos incomp. para operador atribuição: "+ A + " = " + B);
      }
    }

    if (operador == '<') {
      if (A == Tp_INT && B == Tp_INT) {
        return Tp_BOOL;
      } else {
        yyerror("(sem) tipos incomp. para operador comparador: " + A + " < " + String.valueOf(operador) + " " + B);
      }
    }
    if (operador == '!') {
      if (A == Tp_BOOL) {
        return Tp_BOOL;
      } else {
        yyerror("(sem) tipos incomp. para operador !:" + A);
      }
    }
    if (operador == LENGTH) {
      if (A == Tp_ARRAY) {
        return Tp_INT;
      } else {
        yyerror("(sem) tipos incomp. para operador comparador: !" + A);
      }
    }

    return Tp_ERRO;
}
