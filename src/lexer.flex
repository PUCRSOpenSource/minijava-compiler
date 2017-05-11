%%

%byaccj


%{
  private Parser yyparser;

  public Yylex(java.io.Reader r, Parser yyparser) {
    this(r);
    this.yyparser = yyparser;
  }
%}

NL  = \n | \r | \r\n

%%

"public" {return Parser.PUBLIC; }
"static" {return Parser.STATIC; }
"void" {return Parser.VOID; }
"main" {return Parser.MAIN; }
"String" {return Parser.STRING; }
"extends" {return Parser.EXTENDS; }
"return" { return parser.RETURN; }
"int" { return Parser.INT; }
"boolean" { return Parser.BOOLEAN; }
"if" { return Parser.IF; }
"else" { return Parser.ELSE; }
"while" { return Parser.WHILE; }
"length" { return Parser.LENGTH; }
"System".ou.println { return Parser.PRINT; }
"true" { return Parser.TOP; }
"flase" { return Parser.BOTTOM; }
"this" { return Parser.THIS; }
"new" { return Parser.NEW; }
"&&" { return Parser.AND; }

"(" |
")" |
"{" |
"}" |
"[" |
"]" |
"," |
"." |
";" |
"!" |
"=" |
"<" |
"-" |
"*" |
"+"     { return (int) yycharat(0); }

[ \t]+ { }
{NL}+  { } 

.    { System.err.println("Error: unexpected character '"+yytext()+"' na linha "+yyline); return YYEOF; }






