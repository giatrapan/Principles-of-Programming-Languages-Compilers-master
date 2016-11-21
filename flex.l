%x incl
%{
#include <math.h> /*atof() */
#include "bison.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int line;
int line_num;

 #define MAX_INCLUDE_DEPTH 10
         YY_BUFFER_STATE include_stack[MAX_INCLUDE_DEPTH];
         int include_stack_ptr = 0;

%}
%option noyywrap
%option yylineno
%option stack

DIGIT	[0-9]
SCHAR [\"\'\0\\\t]+
MCHAR {SCHAR}?[a-zA-Z_] 


%x comment 


%% /* http://flex.sourceforge.net/manual/Multiple-Input-Buffers.html */
#include BEGIN(incl);
 
     
         <incl>[ \t ]*      /* eat the whitespace */
         <incl>[^ \"\t\n]+   { /* got the include file name */
                 if ( include_stack_ptr >= MAX_INCLUDE_DEPTH )
                     {
                     fprintf( stderr, "Includes nested too deeply" );
                     exit( 1 );
                     }
     
                 include_stack[include_stack_ptr++] =
                     YY_CURRENT_BUFFER;
     
                 yyin = fopen( yytext, "r" );
		 
                 if ( ! yyin )
                     printf("Error opening include file\n");
		  else printf("File Included\n\n");
                 yy_switch_to_buffer(
                     yy_create_buffer( yyin, YY_BUF_SIZE ) );
     
                 BEGIN(INITIAL);
                 }
     
         <<EOF>> {
                 if ( --include_stack_ptr == 0 )
                     {
                     yyterminate();
                     }
     
                 else
                     {
                     yy_delete_buffer( YY_CURRENT_BUFFER );
                     yy_switch_to_buffer(
                          include_stack[include_stack_ptr] );
                     }
                 }



int line_num = 1; /* http://www.softlab.ntua.gr/facilities/documentation/unix/gnu/flex/flex_11.html */
"/*"         BEGIN(comment);

<comment>[^*\n]*        /* eat anything that's not a '*' */
<comment>"*"+[^*/\n]*   /* eat up '*'s not followed by '/'s */
<comment>\n             ++line_num;
<comment>"*"+"/"        BEGIN(INITIAL);
	 
"\n"		{printf("%s", yytext); ++line; }
("+"|"-")?{DIGIT}+ { printf("%s", yytext); return MINTEGER ;}

"char" 		{ printf("%s", yytext); return CHAR ;}
"integer" 		{ printf("%s", yytext); return INTEGER ;}
"new"           {  printf( "%s", yytext); return NEW ;}                 
"class"         {  printf( "%s", yytext); return CLASS ;}
"if"            {  printf( "%s", yytext); return IF ;}
"else"          {  printf( "%s", yytext); return ELSE ;}
"while"         {  printf( "%s", yytext); return WHILE ;}
"return"        {  printf( "%s", yytext);  return RETURN ;}
"void"          {  printf( "%s", yytext); return VOID ;}

"public"        {  printf("%s", yytext); return PUBLIC ;}
"private"       {  printf("%s", yytext); return PRIVATE ;}
"protected"     {  printf("%s", yytext); return PROTECTED ;}
"static"        {  printf("%s", yytext); return STATIC ;}
"abstract" 	{  printf("%s", yytext); return ABSTRACT ;}
"final"		{  printf("%s", yytext); return FINAL ;}

[a-zA-Z_][a-z_A-Z0-9]*"["{DIGIT}+"]"	{printf("%s", yytext); return ARRAY;}

{MCHAR}[a-z_A-Z0-9]*  		{ printf("%s" , yytext); return ID ;}

";"             {  printf("%s", yytext); return QUESTIONM ;}
"="             {  printf("%s", yytext); return BECOMES ;}
","             {  printf("%s", yytext); return COMMA ;}
"+"             {  printf("%s", yytext); return ADD ;}
"-"             {  printf("%s", yytext); return MINUS ;}
"*"             {  printf("%s", yytext); return MUL ;}
"/"             {  printf("%s", yytext); return DIV ;}
"%"             {  printf("%s", yytext); return MOD ;}
"("             {  printf("%s", yytext); return LPAR ;}
")"             {  printf("%s", yytext); return RPAR ;}
"["             {  printf("%s", yytext); return LHOOK ;}
"]"             {  printf("%s", yytext); return RHOOK ;}
"{"             {  printf("%s", yytext); return LBLK ;}
"}"             {  printf("%s", yytext); return RBLK ;}
"=="            {  printf("%s", yytext); return EQUALS ;}
"!="            {  printf("%s", yytext); return NEQUALS ;}
">"             {  printf("%s", yytext); return GREATER ;}
"<"             {  printf("%s", yytext); return SMALLER ;}
">="            {  printf("%s", yytext); return EGREATER ;}
"<="            {  printf("%s", yytext); return ESMALLER ;}
"||"            {  printf("%s", yytext); return OR ;}
"&&"            {  printf("%s", yytext); return AND ;}
"!"             {  printf("%s", yytext); return NOT ;}


%%



 