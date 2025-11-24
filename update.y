%{
/*
  This parser validates SQL UPDATE statements.
  It checks the syntax, tokens, operators, WHERE conditions,
  expressions, and list-based conditions such as IN(...) and IS NULL.
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex();
void yyerror(char *s);
%}



%token UPDATE IDENTIFIER SET ASSIGN WHERE AND OR CONDITION SEMICOLON TEXT NUMBER COMMA NEWLINE
%token IN_T IS_T NOT_T NULL_T BETWEEN LIKE
%token MUL DIV PLUS MINUS


%%

/*---------------------------------------------
  Starting rule: A valid line must be an UPDATE
----------------------------------------------*/
input_line:
      upd_stmt        { printf("Correct Statement\n"); return 0; }
    ;

/* UPDATE <table> <set_clause> */
upd_stmt:
      UPDATE table_name set_clause
    | error           { yyerror(": UPDATE STATEMENT MIGHT BE MISSING : PLEASE CHECK YOUR STATEMENT\n"); return 1; }
    ;

/* Table name must be an identifier */
table_name:
      IDENTIFIER
    | error           { yyerror(": TABLE_NAME MIGHT BE MISSING : PLEASE CHECK YOUR STATEMENT\n"); return 1; }
    ;

/* SET clause with assignment list and optional WHERE */
set_clause:
      SET assign_list where_clause
    | SET assign_list terminator NEWLINE
    | error           { yyerror(": ERROR IN SET STATEMENT : PLEASE CHECK YOUR STATEMENT\n"); return 1; }
    ;

/* One or more assignments, separated by commas */
assign_list:
      assignment
    | assignment COMMA assign_list
    | error           { yyerror(" : PLEASE CHECK YOUR STATEMENT\n"); return 1; }
    ;

/* column = expression */
assignment:
      IDENTIFIER ASSIGN expr_text
    ;
expr_text:
      TEXT
    | expr
    ;
/* WHERE <condition> ; newline */
where_clause:
      WHERE cond_expr terminator NEWLINE
    | error      { yyerror("ERROR IN WHERE CLAUSE : PLEASE CHECK YOUR STATEMENT\n"); return 1; }
    ;

/*------------------------------------------------------------
  Conditions allowed in WHERE:
    col <op> value
    col <op> value AND/OR more conditions
    col IN (val1, val2, ...)
    col IS [NOT] NULL
-------------------------------------------------------------*/
/* boolean expressions: allow parentheses and chaining with AND/OR */
cond_expr:
      cond_atom
    | cond_expr andor cond_atom
    ;
andor:
      AND
    | OR
    ;
/* a single condition unit (can be grouped with parentheses) */
cond_atom:
      '(' cond_expr ')'                               
    | expr compop expr                                
    | IDENTIFIER opt_not IN_T '(' val_list ')'         
    | IDENTIFIER IS_T opt_not NULL_T                   
    | IDENTIFIER IS_T opt_not TEXT                      
    | IDENTIFIER opt_not LIKE TEXT                      
    | IDENTIFIER BETWEEN value AND value              
    | IDENTIFIER NOT_T BETWEEN value AND value     
    ;


/* comparison operators  */
compop:
      CONDITION
    | ASSIGN
    ;

/* Optional NOT keyword */
opt_not:
      /* empty */
    | NOT_T
    ;

/* Values inside IN(...) */
val_list:
      value_text
    | value_text COMMA val_list
    ;

/* A value can be number, text, or identifier */
value_text:
      NUMBER
    | IDENTIFIER
    | TEXT
    ;
value:
      NUMBER
    | IDENTIFIER
    ;

/* Arithmetic expressions allowed on SET side */
expr:
      NUMBER
    | IDENTIFIER
    | TEXT
    | expr PLUS expr
    | expr MINUS expr
    | expr MUL expr
    | expr DIV expr
    | '(' expr ')'
    ;

/* Must end with semicolon */
terminator:
      SEMICOLON
    | error { yyerror("SEMICOLON MIGHT BE MISSING : PLEASE CHECK YOUR STATEMENT\n"); return 1; }
    ;
%%

int yywrap() {
    return 1;
}

/* Main entry */
int main() {
    printf("\nINPUT >> ");
    yyparse();
    return 0;
}

/* Error printing functions */


void yyerror(char *s) {
    printf("%s", s);
}
