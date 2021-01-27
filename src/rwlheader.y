/*
 * RWP*Load Simulator
 *
 * Copyright (c) 2021 Oracle Corporation
 * Licensed under the Universal Permissive License v 1.0
 * as shown at https://oss.oracle.com/licenses/upl/
 *
 * Real World performance Load simulator parser
 *
 * rwlheader.y, header for the bison input file
 *
 * The full input for by is generated by concatenating
 * this file with the set of .yi files.  This is purely
 * done for the purpose of making each file smaller and
 * with well defined contents.
 *
 *
 * History
 *
 * bengsig  27-jan-2021 - connectionclass
 * bengsig  19-jan-2021 - Connection pool
 * bengsig  11-jan-2021 - Add various future keywords
 * bengsig  16-dev-2020 - Add RWL_T_EXIT
 * bengsig  19-nov-2020 - few renames to match rwlman 
 * bengsig  17-nov-2020 - regextract
 * bengsig  23-sep-2020 - for .. loop syntax for control loops
 * bengsig  07-jul-2020 - Add instr, instrb
 * bengsig  16-jun-2020 - Add RWL_T_SERVERRELEASE
 * bengsig  30-apr-2020 - Regular expressions
 * bengsig  15-apr-2020 - File reading
 * bengsig  21-feb-2020 - Add statemark
 * bengsig  06-mar-2020 - Add opensessioncount
 * bengsig  21-feb-2020 - Add requestmark
 * bengsig  29-nov-2019 - Add activesessioncount
 * bengsig  31-oct-2019 - Add system( , )
 * bengsig  24-sep-2019 - Add log, exp, round
 * bengsig  23-sep-2019 - Add system
 * bengsig  07-aug-2019 - Add getenv
 * bengsig  30-jul-2019 - Add sqlid
 * bengsig  24-may-2019 - Add erlangk
 * bengsig  07-may-2019 - Add substrb/lengthb
 * bengsig  06-feb-2019 - Add RWL_T_OCIPING
 * bengsig  15-oct-2017 - Creation
 */


%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <errno.h>
#include <ctype.h>
#include "rwl.h"

/*
  rwm is an argument to rwlyparse
*/
#define YYERROR_VERBOSE 1
#define rwlyrwmscanner rwm->rwlyscanner

static void rwlyerror(rwl_main *rwm, const char *s) 
{
/* print the error text that was givin at an 'error' syntax element */
if (bit(rwm->mflags, RWL_DEBUG_PRINTYYERR))
  rwldebug(rwm, "rwlyerror %s", s);
/* mark error line as soon as error is found */
rwm->loc.errlin = rwm->loc.lineno; 
}

rwlcomp(rwlparser_y, RWL_GCCFLAGS)

// these are needed due to issues with bison
// not doing this when %name-prefix is set
#define yychar rwlychar
#define RWLYABORT YYABORT

%}
// Configuration

// don't use global variables!
%pure-parser
// don't use the yy name - ignore warning in pre2.6 bison
%name-prefix = "rwly"
//%define api.prefix {rwly}
// here's our top structure as argumentto the parser
%parse-param {rwl_main *rwm}
%lex-param {void *rwlyrwmscanner}

%expect 3


%union
{
	/* this must be declared as it is ifdef'ed as YYSTYPE
	** but we never actually use it as the lexer sets
	** apropriate fields in rwm, which it gets as argument
	*/
	void	*rwl_never_used;
};


// The tokens
%token RWL_T_CONNECT RWL_T_USERNAME RWL_T_PASSWORD RWL_T_DATABASE
%token RWL_T_PRINT RWL_T_PRINTLINE RWL_T_PRINTVAR RWL_T_SHARDKEY RWL_T_SUPERSHK
%token RWL_T_PROCEDURE RWL_T_BIND RWL_T_DEFINE RWL_T_STRING RWL_T_INTEGER RWL_T_END 
%token RWL_T_FOR RWL_T_ARRAY RWL_T_DATE RWL_T_SQRT RWL_T_ACCESS RWL_T_REGEX RWL_T_REGEXTRACT
%token RWL_T_UNIFORM RWL_T_ERLANG RWL_T_DOTDOT RWL_T_DOUBLE RWL_T_ERLANG2 RWL_T_ERLANGK
%token RWL_T_RUN RWL_T_THREADS RWL_T_RUNSECONDS RWL_T_WHILE RWL_T_FFLUSH RWL_T_READLINE
%token RWL_T_RANDOM RWL_T_FILE RWL_T_WRITE RWL_T_WRITELINE RWL_T_BINDOUT RWL_T_GETRUSAGE
%token RWL_T_DRCP RWL_T_SESSIONPOOL RWL_T_RECONNECT RWL_T_DEDICATED RWL_T_DEFAULT RWL_T_RESULTS 
%token RWL_T_ASSIGN RWL_T_LOOP RWL_T_ALL RWL_T_NULL RWL_T_ISNULL RWL_T_SUM RWL_T_IS RWL_T_NOT
%token RWL_T_LESSEQ RWL_T_GREATEQ RWL_T_NOTEQ RWL_T_AND RWL_T_OR RWL_T_BETWEEN RWL_T_CONCAT
%token RWL_T_IF RWL_T_THEN RWL_T_ELSE RWL_T_NEVER RWL_T_APPEND RWL_T_IGNOREERROR
%token RWL_T_EXECUTE RWL_T_WAIT RWL_T_COMMIT RWL_T_ROLLBACK RWL_T_EVERY RWL_T_ASNPLUS
%token RWL_T_STOP RWL_T_START RWL_T_COUNT RWL_T_AT RWL_T_BREAK RWL_T_RETURN RWL_T_ABORT
%token RWL_T_MODIFY RWL_T_CURSORCACHE RWL_T_NOCURSORCACHE RWL_T_LEAK RWL_T_SHIFT
%token RWL_T_STATISTICS RWL_T_NOSTATISTICS RWL_T_FUNCTION RWL_T_PUBLIC RWL_T_OCIPING
%token RWL_T_QUEUE RWL_T_NOQUEUE RWL_T_PRIVATE RWL_T_BEGIN RWL_T_RELEASE RWL_T_SYSTEM
%token RWL_T_CLOB RWL_T_BLOB RWL_T_NCLOB RWL_T_READLOB RWL_T_WRITELOB RWL_T_RAW RWL_T_EXIT
%token RWL_T_SUBSTR RWL_T_SUBSTRB RWL_T_LENGTH RWL_T_LENGTHB RWL_T_SQL_ID RWL_T_GETENV
%token RWL_T_LOG RWL_T_EXP RWL_T_ROUND RWL_T_ACTIVESESSIONCOUNT RWL_T_REQUESTMARK
%token RWL_T_OPENSESSIONCOUNT RWL_T_STATEMARK RWL_T_REGEXSUB RWL_T_REGEXSUBG RWL_T_SERVERRELEASE
%token RWL_T_SQL RWL_T_SQL_TEXT RWL_T_INSTR RWL_T_INSTRB RWL_T_CONNECTIONPOOL RWL_T_CONNECTIONCLASS
%token RWL_T_UNSIGNED RWL_T_HEXADECIMAL RWL_T_OCTAL RWL_T_FPRINTF RWL_T_ENCODE RWL_T_DECODE

%token <sval> RWL_T_STRING_CONST
%token <sval> RWL_T_IDENTIFIER
%token <ival> RWL_T_INTEGER_CONST
%token <dval> RWL_T_DOUBLE_CONST

// standard order of association
%left RWL_T_CONCAT
%left RWL_T_OR
%left RWL_T_AND
%left '=' RWL_T_NOTEQ
%left '<' '>' RWL_T_LESSEQ RWL_T_GREATEQ RWL_T_BETWEEN
%left '-' '+'
%left '*' '/' '%'
%left '!' RWL_T_NOT RWL_T_UMINUS

%start rwlprogram
%%

rwlprogram: 
	programelementlist 
	{
	  ; /* do nothing but could set "all is good" flag */
	}
	;

terminator:
        ';' { if (bit(rwm->mxq->errbits,RWL_ERROR_SEVERE)) RWLYABORT; }
	;

