%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void parse_error(char *msg);
int yylex();
void yyerror(char *s);
%}

%token UPDATE IDENTIFIER SET ASSIGN WHERE ANDOR CONDITION SEMICOLON TEXT NUMBER COMMA NEWLINE
%token MUL DIV PLUS MINUS
%left PLUS MINUS
%left MUL DIV


%%

input_line: upd_stmt { printf("Syntax Correct\n"); return 0; } ;

upd_stmt: UPDATE table_name set_clause
        | error { parse_error(" : MISSING KEYWORD \"UPDATE\".\n"); return 1; }
        ;

table_name: IDENTIFIER
          | error { parse_error(" : Table name is missing\n"); return 1; }
          ;

set_clause: SET assign_list where_clause
          | SET assign_list terminator NEWLINE
          | error { parse_error(" : MISSING KEYWORD \"SET\".\n"); return 1; }
          ;

assign_list: assignment
           | assignment COMMA assign_list
           | error { parse_error(" : Incorrect statement for SET clause\n"); return 1; }
           ;

assignment: IDENTIFIER ASSIGN expr
          ;

where_clause: WHERE cond_expr terminator NEWLINE
            | error { parse_error(" : MISSING CLAUSE \"WHERE\".\n"); return 1; }
            ;

cond_expr: IDENTIFIER CONDITION IDENTIFIER
         | IDENTIFIER CONDITION TEXT
         | IDENTIFIER CONDITION NUMBER
         | IDENTIFIER CONDITION IDENTIFIER ANDOR cond_expr
         | IDENTIFIER CONDITION TEXT ANDOR cond_expr
         | IDENTIFIER CONDITION NUMBER ANDOR cond_expr
         | NUMBER CONDITION NUMBER
         | NUMBER CONDITION NUMBER ANDOR cond_expr
         | IDENTIFIER ASSIGN IDENTIFIER
         | IDENTIFIER ASSIGN TEXT
         | IDENTIFIER ASSIGN NUMBER
         | IDENTIFIER ASSIGN IDENTIFIER ANDOR cond_expr
         | IDENTIFIER ASSIGN TEXT ANDOR cond_expr
         | IDENTIFIER ASSIGN NUMBER ANDOR cond_expr
         | NUMBER ASSIGN NUMBER
         | NUMBER ASSIGN NUMBER ANDOR cond_expr
         | error { parse_error(" : Incorrect statement for WHERE clause\n"); return 1; }
         ;

expr: NUMBER
    | IDENTIFIER
    | expr PLUS expr
    | expr MINUS expr
    | expr MUL expr
    | expr DIV expr
    | '(' expr ')'
    ;

terminator: SEMICOLON
          | error { parse_error(" : Missing Semicolon \";\"\n"); return 1; }
          ;
%%

int yywrap() {
    return 1;
}

int main() {
    printf("\nPARSER >> ");
    yyparse();
    return 0;
}

void parse_error(char *msg) {
    printf("%s", msg);
    return;
}

void yyerror(char *s) {
    parse_error(s);
}
