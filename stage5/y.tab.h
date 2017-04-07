/* A Bison parser, made by GNU Bison 3.0.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    ID = 258,
    READ = 259,
    WRITE = 260,
    NUM = 261,
    NL = 262,
    PLUS = 263,
    MUL = 264,
    MINUS = 265,
    DIV = 266,
    MOD = 267,
    ASGN = 268,
    LT = 269,
    GT = 270,
    EQ = 271,
    IF = 272,
    ELSE = 273,
    THEN = 274,
    WHILE = 275,
    DO = 276,
    ENDWHILE = 277,
    ENDIF = 278,
    STMT = 279,
    START = 280,
    END = 281,
    LTE = 282,
    GTE = 283,
    NOTEQ = 284,
    DECL = 285,
    ENDDECL = 286,
    INT = 287,
    BOOL = 288,
    TRUE = 289,
    FALSE = 290
  };
#endif
/* Tokens.  */
#define ID 258
#define READ 259
#define WRITE 260
#define NUM 261
#define NL 262
#define PLUS 263
#define MUL 264
#define MINUS 265
#define DIV 266
#define MOD 267
#define ASGN 268
#define LT 269
#define GT 270
#define EQ 271
#define IF 272
#define ELSE 273
#define THEN 274
#define WHILE 275
#define DO 276
#define ENDWHILE 277
#define ENDIF 278
#define STMT 279
#define START 280
#define END 281
#define LTE 282
#define GTE 283
#define NOTEQ 284
#define DECL 285
#define ENDDECL 286
#define INT 287
#define BOOL 288
#define TRUE 289
#define FALSE 290

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
