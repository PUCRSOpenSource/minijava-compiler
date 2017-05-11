%%

%byaccj

%{
  private Parser yyparser;

  public Yylex(java.io.Reader r, Parser yyparser) {
    this(r);
    this.yyparser = yyparser;
  }
%}

LT = \r|\n|\r\n
WS = {LineTerminator} | [ \t\f]
ID = [:jletter][:jletterdigit]*

%%

"public"             { return Parser.PUBLIC; }
"static"             { return Parser.STATIC; }
"void"               { return Parser.VOID; }
"main"               { return Parser.MAIN; }
"String"             { return Parser.STRING; }
"extends"            { return Parser.EXTENDS; }
"return"             { return parser.RETURN; }
"int"                { return Parser.INT; }
"boolean"            { return Parser.BOOLEAN; }
"if"                 { return Parser.IF; }
"else"               { return Parser.ELSE; }
"while"              { return Parser.WHILE; }
"length"             { return Parser.LENGTH; }
"System".out.println { return Parser.PRINT; }
"true"               { return Parser.TOP; }
"flase"              { return Parser.BOTTOM; }
"this"               { return Parser.THIS; }
"new"                { return Parser.NEW; }
"&&"                 { return Parser.AND; }

0 | [1-9][0-9]*      { return Parser.INTEGER }
{ID}                 { return Parser.IDENT; }
{LT}+                { return Parser.NL; }

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
[^]    { System.err.println("Error: unexpected character '" + yytext() + "' at line: " + yyline); return -1; }
