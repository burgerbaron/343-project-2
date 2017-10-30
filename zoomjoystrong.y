%{
#include <stdio.h>
#include "zoomjoystrong.h"

int yylex();

void yyerror(const char *str) {
	printf("error: %s\n", str);
}

int yywrap(){
	return 1;
}

%}

%union {
	int iVal;
	float fVal;
}

%token <iVal> INT
%token <fVal> FLOAT
%token END
%token END_STATEMENT
%token POINT
%token LINE
%token CIRCLE
%token RECTANGLE
%token SET_COLOR

%%




program:
	statement_list end
	;

statement_list:
	| statement statement_list
	;

statement:
	point
	| line
	|circle
	|rectangle
	|set_color
	;

point:
	POINT INT INT END_STATEMENT
	{
		if ($2 > 1024 || $2 < 0){
			printf("Invalid x input");
		}
	
		else if ($3 > 768 || $3 < 0){
			printf("Invalid y input");	
		}
		else 
			point ($2, $3);
	}
	;

line:
	LINE INT INT INT INT END_STATEMENT
	{
		if ($2 < 0 || $2 > 1024){
			printf("Invalid x Input");
		}
		
		else if ( $3 < 0 || $3 > 768){
			printf("Invalid y Input");
		}

		else if ( $4 < 0 || $4 > 1024){
			printf("Invalid x Input");
		}

		else if ( $5 < 0 || $5 > 768){
			printf("Invalid y Input");
		}
		else
			line ($2, $3, $4, $5);
	}
	;

circle:
	CIRCLE INT INT INT END_STATEMENT
	{	
		if ($2 < 0 || $2 > 1024){
			printf("Invalid x Input");
		}
		
		else if ( $3 < 0 || $3 > 768){
			printf("Invalid y Input");
		}
		else
			circle ($2, $3, $4);
	}
	;

rectangle:
	RECTANGLE INT INT INT INT END_STATEMENT
	{	
		if ($2 < 0 || $2 > 1024){
			printf("Invalid x Input");
		}
		
		else if ( $3 < 0 || $3 > 768){
			printf("Invalid y Input");
		}
		else
			rectangle ($2, $3, $4, $5);
	}	
	;

set_color:
	SET_COLOR INT INT INT END_STATEMENT
	{
		if ($2 < 0 || $2 > 255){
			printf("Invalid r color");
		}
		
		else if ( $3 < 0 || $3 > 255){
			printf("Invalid g color");
		}
	
		else if ($2 < 0 || $2 > 255){
			printf("Invalid b color");
		}
		
		else 	
			set_color($2, $3, $4);
	}
	;

end:
	END END_STATEMENT
	{
		finish();
		return 0;
	}
	;

%%


extern FILE *yyin;

int main(int argc, char** argv) {
	setup();
	yyin = fopen(argv[1], "r");
	yyparse();
}


