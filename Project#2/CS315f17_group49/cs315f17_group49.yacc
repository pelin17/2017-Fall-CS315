%token TRUTHVALUE SPACE NEWLINE CONCATENATION LEFTSQUARE RIGHTSQUARE MAIN ARRAY PREDICATE SEMICOLON COMMA CONSTANT_IDENTIFIER WHILE IF ELSE EQUALS NOTEQUAL CLASS RETURN LEFTPARANTHESIS RIGHTPARANTHESIS LEFTCURLY RIGHTCURLY INPUT OUTPUT VARIABLE CONSTANT SINGLELINECOMMENT CLASS_IDENTIFIER ASSIGN AND OR IMPLIES NEGATION IFANDONLYIF TRUE FALSE IDENTIFIER
%start program

%%
program: CLASS CLASS_IDENTIFIER LEFTCURLY block RIGHTCURLY {printf("Input accepted!\n");} 
| CLASS CLASS_IDENTIFIER LEFTCURLY block main RIGHTCURLY {printf("Input accepted!\n");}
;
block: assign_const block
| const_declaration block
| assign_predicate block
| statement block
|
;
statements: statement
| statement statements
;
statement: assign_var 
| re_assign_var 
| conditional_statement
| predicate_call
| comment_statement
| loop_statement 
| input_statement 
| output_statement
| var_declaration  
| array_assignment 
| array_declaration
;
comment_statement: SINGLELINECOMMENT
;
assign_const: CONSTANT CONSTANT_IDENTIFIER assignment_op compound_proposition SEMICOLON
;
assignment_op: ASSIGN
;
var_declaration: VARIABLE IDENTIFIER SEMICOLON
;
const_declaration: CONSTANT CONSTANT_IDENTIFIER SEMICOLON
;
compound_proposition: truth_value connective truth_value
| proposition connective proposition 
| proposition connective truth_value
| truth_value connective proposition
| proposition 
| truth_value
| negation truth_value
| negation proposition
| LEFTPARANTHESIS compound_proposition RIGHTPARANTHESIS
;
connective: AND 
| OR 
| IMPLIES 
| IFANDONLYIF
;
negation: NEGATION
;
proposition: CONSTANT_IDENTIFIER
| IDENTIFIER
;
truth_value: TRUE 
| FALSE
;
assign_predicate: PREDICATE TRUTHVALUE IDENTIFIER LEFTPARANTHESIS parameters RIGHTPARANTHESIS LEFTCURLY statements return_statement RIGHTCURLY
;
parameters:
| parameter 
| parameter COMMA parameters
;
parameter: compound_proposition 
| VARIABLE IDENTIFIER
;
assign_var: VARIABLE IDENTIFIER assignment_op compound_proposition SEMICOLON
| VARIABLE IDENTIFIER assignment_op input_statement SEMICOLON
;
re_assign_var: IDENTIFIER assignment_op compound_proposition SEMICOLON
| IDENTIFIER assignment_op input_statement SEMICOLON
;
conditional_statement: if_statement
;
if_statement: IF LEFTPARANTHESIS logic_expr RIGHTPARANTHESIS LEFTCURLY statements RIGHTCURLY
| IF LEFTPARANTHESIS logic_expr RIGHTPARANTHESIS LEFTCURLY statements RIGHTCURLY ELSE LEFTCURLY statements RIGHTCURLY
;
logic_expr: compound_proposition comparison compound_proposition
| compound_proposition 
;
array_declaration: ARRAY TRUTHVALUE IDENTIFIER LEFTSQUARE RIGHTSQUARE SEMICOLON
;
comparison: EQUALS
| NOTEQUAL
;
predicate_call: IDENTIFIER LEFTPARANTHESIS parameters RIGHTPARANTHESIS SEMICOLON
;
loop_statement: WHILE LEFTPARANTHESIS logic_expr RIGHTPARANTHESIS LEFTCURLY statements RIGHTCURLY
;
return_statement: RETURN truth_value SEMICOLON 
;
input_statement: INPUT
;
output_statement: OUTPUT LEFTPARANTHESIS output_string RIGHTPARANTHESIS SEMICOLON
;
output_string: IDENTIFIER CONCATENATION output_string
| VARIABLE CONCATENATION output_string
| CONSTANT CONCATENATION output_string
| IDENTIFIER
| VARIABLE
| CONSTANT
;
main: MAIN LEFTPARANTHESIS RIGHTPARANTHESIS LEFTCURLY statements RIGHTCURLY
;
array_assignment: ARRAY TRUTHVALUE IDENTIFIER LEFTSQUARE RIGHTSQUARE assignment_op LEFTSQUARE truth_values RIGHTSQUARE SEMICOLON
;
truth_values: truth_value
| truth_value COMMA truth_values
	      //warning: "TRUE" redefined [enabled by default];
%%
#include "lex.yy.c"

main(){
  return yyparse();
}

int yyerror( char * s) {fprintf(stderr, "%s on line: %d\n", s, line_count);}
