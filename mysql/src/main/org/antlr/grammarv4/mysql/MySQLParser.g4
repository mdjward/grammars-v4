
parser grammar MySQLParser;

options
   { tokenVocab = MySQLLexer; }

stat
   : LPAREN stat RPAREN | ( select_clause )+
   ;

schema_name
   : ID
   ;

select_clause
   : SELECT column_list_clause ( FROM table_references )? ( where_clause )? ( group_by_clause )? ( limit_clause )? ( set_operation )? ( SEMI )?
   ;

table_name
   : ID
   ;

table_alias
   : ID
   ;

column_ref
   : (DISTINCT)? column_name
   ;

column_name
   : ( ( schema_name DOT )? table_alias ALL_FIELDS )? | ( ( schema_name DOT )? table_alias DOT )? ID  | ( table_alias DOT )? ( ID | ASTERISK ) | USER_VAR
   ;

column_name_alias
   : ID
   ;

index_name
   : ID
   ;

column_list
   : LPAREN column_expr ( COMMA column_expr )* RPAREN
   ;

column_list_clause
   : column_expr ( COMMA column_expr )*
   ;

column_expr
   : ( DISTINCT )? element ( ( AS )? column_name_alias )?
   ;

from_clause
   : FROM table_name ( COMMA table_name )*
   ;

select_key
   : SELECT
   ;

where_clause
   : WHERE expression
   ;

expression
   : ( LPAREN expression RPAREN) | expression_content
   ;

expression_content
   : simple_expression ( expr_op simple_expression )*
   ;

parameter
   : unnamed_parameter | named_parameter
   ;

unnamed_parameter
   : QUESTION_MARK
   ;

named_parameter
   : ( COLON ID )
   ;

single_quoted_element
   : SINGLE_QUOTED_STRING
   ;

element
   : ( LPAREN element RPAREN ) | element_content
   ;

element_content
   : USER_VAR | ID | ( '|' ID '|' ) | INT | case_statement | column_ref | parameter | single_quoted_element | function_call
   ;

case_statement
   : CASE ( element )? ( WHEN ( element | expression ) THEN element )+ ( ELSE element ) END
   ;

function_call
   : ID LPAREN ( function_call_parameter (COMMA function_call_parameter)* )? RPAREN
   ;

function_call_parameter
   : element
   ;

right_element
   : element
   ;

left_element
   : element
   ;

target_element
   : element
   ;

relational_op
   : EQ | LTH | GTH | NOT_EQ | LET | GET
   ;

expr_op
   : AND | XOR | OR | NOT
   ;

between_op
   : BETWEEN
   ;

is_or_is_not
   : IS | IS NOT
   ;

simple_expression
   : left_element relational_op right_element | target_element between_op left_element AND right_element | target_element is_or_is_not NULL | target_element IN column_list
   ;

table_references
   : table_reference ( ( COMMA table_reference ) | join_clause )*
   ;

table_reference
   : table_factor1 | table_atom
   ;

table_factor1
   : table_factor2 ( ( INNER | CROSS )? JOIN table_atom ( join_condition )? )?
   ;

table_factor2
   : table_factor3 ( STRAIGHT_JOIN table_atom ( ON expression )? )?
   ;

table_factor3
   : table_factor4 ( ( LEFT | RIGHT ) ( OUTER )? JOIN table_factor4 join_condition )?
   ;

table_factor4
   : table_atom ( NATURAL ( ( LEFT | RIGHT ) ( OUTER )? )? JOIN table_atom )?
   ;

table_atom
   : ( table_name ( partition_clause )? ( ( AS )? table_alias )? ( index_hint_list )? ) | ( subquery ( AS )? subquery_alias ) | ( LPAREN table_references RPAREN ) | ( OJ table_reference LEFT OUTER JOIN table_reference ON expression )
   ;

join_clause
   : ( ( INNER | CROSS )? JOIN table_atom ( join_condition )? ) | ( STRAIGHT_JOIN table_atom ( ON expression )? ) | ( ( LEFT | RIGHT ) ( OUTER )? JOIN table_factor4 join_condition ) | ( NATURAL ( ( LEFT | RIGHT ) ( OUTER )? )? JOIN table_atom )
   ;

join_condition
   : ( ON expression ( expr_op expression )* ) | ( USING column_list )
   ;

index_hint_list
   : index_hint ( COMMA index_hint )*
   ;

index_options
   : ( INDEX | KEY ) ( FOR ( ( JOIN ) | ( ORDER BY ) | ( GROUP BY ) ) )?
   ;

index_hint
   : USE index_options LPAREN ( index_list )? RPAREN | IGNORE index_options LPAREN index_list RPAREN
   ;

index_list
   : index_name ( COMMA index_name )*
   ;

partition_clause
   : PARTITION LPAREN partition_names RPAREN
   ;

partition_names
   : partition_name ( COMMA partition_name )*
   ;

partition_name
   : ID
   ;

subquery_alias
   : ID
   ;

subquery
   : LPAREN subquery_content RPAREN
   ;

subquery_content
   : ( LPAREN subquery_content RPAREN ) | select_clause
   ;

group_by_clause
   : GROUP BY column_list_clause (having_clause)?
   ;

having_clause
   : HAVING expression
   ;

limit_clause
   : LIMIT INT
   ;

set_operation
   : ( UNION | INTERSECT ) ( ALL )? select_clause
   ;
