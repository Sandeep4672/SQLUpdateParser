%{
#include <stdio.h>
#include "update.tab.h"   

int lineno = 1;
%}

DIGIT      [0-9]
LETTER     [A-Za-z]
CHAR    [A-Za-z0-9_]
TEXT1   [^\"\n]
TEXT2  [^'\n]

%%

[Uu][Pp][Dd][Aa][Tt][Ee]        { return UPDATE; }
[Ss][Ee][Tt]                    { return SET; }
[Ww][Hh][Ee][Rr][Ee]            { return WHERE; }

([Aa][Nn][Dd])|([Oo][Rr])       { return ANDOR; }

\"{TEXT1}+\"                  { return TEXT; }   
\'{TEXT2}+\'                { return TEXT; }  

{DIGIT}+                        { return NUMBER; }
"*"                             { return MUL; } 
"/"                             { return DIV; } 
"+"                             { return PLUS; } 
"-"                             { return MINUS; }
{LETTER}{CHAR}*              { return IDENTIFIER; }

"<="                            { return CONDITION; }
">="                            { return CONDITION; }
"=="                            { return CONDITION; }
"!="                            { return CONDITION; }
"="                             { return ASSIGN; }
"<"                             { return CONDITION; }
">"                             { return CONDITION; }

";"                             { return SEMICOLON; }
","                             { return COMMA; }

(\r\n)|\n                       { lineno++; return NEWLINE; }

[ \t\f\v]+                      { /* ignore */ }

.                               { return yytext[0]; }

%%

