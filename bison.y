%{
#define YYSTYPE double
#include <math.h>
#include <stdio.h>


 int yylex(void);
 int line;
 FILE *yyin;
 void yyerror(char *errorinfo);
  int errors;
%}


%debug

%token NEW CLASS IF ELSE WHILE RETURN VOID
%token ADD DIV EGREATER EQUALS ESMALLER GREATER MOD MUL SMALLER NEQUALS MINUS
%token LPAR RPAR LBLK RBLK LHOOK RHOOK COMMA 
%token QUESTIONM /* ';' */
%token BECOMES /* '=' */
%token THEN OR AND NOT 
%token PUBLIC STATIC PROTECTED PRIVATE ABSTRACT FINAL
%token ID DIGIT ARRAY 
%token INTEGER CHAR  MINTEGER MCHAR NLINE

%%
        
eclass : CLASS ID LBLK block RBLK ;
block : | var_decl constructor meth_declaration  ; 

var_decl :  var_decl ID BECOMES NEW type QUESTIONM | ID BECOMES NEW type QUESTIONM  ;

type : CHAR | INTEGER | carray | iarray | ARRAY ;
iarray : INTEGER LHOOK MINTEGER RHOOK ;
carray : CHAR LHOOK MINTEGER RHOOK ;



constructor : scope ID LPAR parameters RPAR LBLK var_decl RBLK ; /*public AB(int/char/intArray[]/charArray[]) {var def} */


parameters : | parameter ID parameters  | COMMA parameter ID parameters ;
parameter : CHAR | INTEGER | iarray | carray | ARRAY ;

scope : PUBLIC | PROTECTED | PRIVATE | STATIC | FINAL ;
meth_declaration : meth_decl | meth_decla ;
meth_decl : scope meth_type ; 
meth_type : VOID ID LPAR parameters RPAR LBLK vbody RBLK | type ID LPAR parameters RPAR LBLK tbody RBLK ;
vbody :  statement;
tbody :  statement RETURN ID QUESTIONM ;

meth_decla : ABSTRACT VOID ID LPAR parameters RPAR LBLK RBLK | ABSTRACT type ID LPAR parameters RPAR LBLK RBLK ;


statement : | loop statement | meth_var statement | expression oper expression statement ;
meth_var : ID BECOMES MINTEGER QUESTIONM | ID BECOMES MCHAR QUESTIONM ;
/* var_def | var_decl | meth_decl */
loop : if_express | while_express ;

if_express : IF LPAR condition RPAR LBLK statement RBLK | IF LPAR condition RPAR LBLK statement RBLK ELSE LBLK statement RBLK ;
while_express : WHILE LPAR condition RPAR LBLK statement RBLK ; 

condition : expression oper expression | expression oper expression oper condition | expression  ;
expression :  ID  | MINTEGER | iarray | carray | ARRAY  ;

oper : boper | loper | aroper | expression ;
aroper : ADD | DIV | MINUS | MOD | MUL ;
boper : AND | NOT | OR ;
loper : EQUALS | GREATER | SMALLER | ESMALLER | EGREATER | NEQUALS ;


 
%%



main(int argc, char *argv[])
	{
	
		
		++argv;
		--argc;
		errors=0;
		if (argv>0)
		{
		printf("\n\n");
			yyin=fopen(argv[0],"r");
			yydebug=0;
			yyparse();
		printf("\n\n");
		}
	
		if(errors==0)
		{	
			
			printf("\n");
			printf("***************************************************\n");
			
			printf(" 		     No Errors\n");
			
			printf("*************************************************** \n\n");
		}	
		
	}

	void yyerror(char *msg)
	{	errors++;
		printf("\n***************************************************\n");
		printf("Error at line %d: %s\n",line, msg);
		printf("***************************************************\n\n");
	}
