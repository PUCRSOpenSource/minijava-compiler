%%

%byaccj
%unicode
%column
%line

%{
  private Parser yyparser;

  public Yylex(java.io.Reader r, Parser yyparser) {
    this(r);
    this.yyparser = yyparser;
    yyline = 1;
  }

  public int getLine() {
        return yyline;
  }
%}

WHITE_SPACE = [\n\r\ \t\b\012]
COMMENT = "//" [^\n\r]*
ID = [A-Za-z][A-Za-z0-9_]*

%%

"$TRACE_ON"  { yyparser.setDebug(true); }
"$TRACE_OFF" { yyparser.setDebug(false); }

"public"             { return Parser.PUBLIC; }
"static"             { return Parser.STATIC; }
"void"               { return Parser.VOID; }
"class"              { return Parser.CLASS; }
"main"               { return Parser.MAIN; }
"String"             { return Parser.STRING; }
"extends"            { return Parser.EXTENDS; }
"return"             { return Parser.RETURN; }
"int"                { return Parser.INT; }
"boolean"            { return Parser.BOOLEAN; }
"if"                 { return Parser.IF; }
"else"               { return Parser.ELSE; }
"while"              { return Parser.WHILE; }
"length"             { return Parser.LENGTH; }
"System.out.println" { return Parser.PRINT; }
"true"               { return Parser.TOP; }
"false"              { return Parser.BOTTOM; }
"this"               { return Parser.THIS; }
"new"                { return Parser.NEW; }
"&&"                 { return Parser.AND; }

\".*\"               { return Parser.STRING_LITERAL; }
0 | [1-9][0-9]*      { return Parser.INTEGER; }
{ID}                 { return Parser.IDENT; }
{WHITE_SPACE}+                { }

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
"+" { return (int) yycharat(0); }


[ \t]+ | {COMMENT} { }
[^]    { System.err.println("Error: unexpected character '" + yytext() + "' at line: " + yyline); return -1; }
