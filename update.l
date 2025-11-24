/* Header files*/
%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "update.tab.h"

//Function used to print the identified token.
static void showtoken(const char *t){
    printf("TOK %-12s \"%s\"\n", t, yytext);
}
%}

/*Regular Definitions*/
DIGIT      [0-9]
LETTER     [A-Za-z]
CHAR       [A-Za-z0-9_]
TEXT1      [^\"\n]
TEXT2      [^'\n]

/*Rules*/
%%

[Uu][Pp][Dd][Aa][Tt][Ee]        { showtoken("UPDATE"); return UPDATE; }
[Ss][Ee][Tt]                    { showtoken("SET"); return SET; }
[Ww][Hh][Ee][Rr][Ee]            { showtoken("WHERE"); return WHERE; }

([Aa][Nn][Dd])      { showtoken("AND"); return AND; }
([Oo][Rr])          {showtoken("OR");return OR;}
[Nn][Uu][Ll][Ll]                {showtoken("NULL");return NULL_T;}
[Ii][Ss]                        {showtoken("IS");return IS_T;}
[Nn][Oo][Tt]                    {showtoken("NOT");return NOT_T;}
[Ii][Nn]                        {showtoken("IN");return IN_T;}
[Ll][Ii][Kk][Ee]                {showtoken("LIKE");return LIKE;}
[Bb][Ee][Tt][Ww][Ee][Ee][Nn]    {showtoken("BETWEEN");return BETWEEN;}


\"{TEXT1}+\"    { showtoken("TEXT");  return TEXT; }
\'{TEXT2}+\'    { showtoken("TEXT");  return TEXT; }

({DIGIT}+(\.{DIGIT}*)?|\.[0-9]+)([Ee][+-]?[0-9]+)?  { showtoken("NUMBER");  return NUMBER; }

"*"             { showtoken("MUL"); return MUL; }
"/"             { showtoken("DIV"); return DIV; }
"+"             { showtoken("PLUS"); return PLUS; }
"-"             { showtoken("MINUS"); return MINUS; }

{LETTER}{CHAR}* { showtoken("IDENTIFIER");  return IDENTIFIER; }

"<="            { showtoken("<="); return CONDITION; }
">="            { showtoken(">="); return CONDITION; }
"=="            { showtoken("=="); return CONDITION; }
"!="            { showtoken("!="); return CONDITION; }
"="             { showtoken("="); return ASSIGN; }
"<"             { showtoken("<"); return CONDITION; }
">"             { showtoken(">"); return CONDITION; }

";"             { showtoken("SEMICOLON"); return SEMICOLON; }
","             { showtoken("COMMA"); return COMMA; }

\n       { showtoken("NEWLINE"); return NEWLINE; }

[ \t]+      { }

.               { printf("TOK CHAR        \"%s\"\n", yytext); return yytext[0]; }

%%
