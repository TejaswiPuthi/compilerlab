/* Constants */
	#define VOID -1001
	#define STATEMENT -1002
	#include "y.tab.h"
	#include <strings.h>
	#include <stdlib.h>


/** Expression Tree Node Structure **/

struct Tnode {

	int TYPE; // Integer, Boolean or Void (for statements)

	/* Must point to the type expression tree for user defined types */

	int NODETYPE;

	/* this field should carry following information:
	 *
	 * * a) operator : (+,*,/ etc.) for expressions
	 *
	 * * b) statement Type : (WHILE, READ etc.) for statements */

	char* NAME; // For Identifiers/Functions

	int VALUE; // for constants

	struct Tnode *ArgList; // List of arguments for functions

	struct Tnode *left, *right, *middle;

	/* Maximum of three subtrees (3 required for IF THEN ELSE */

//	Gsymbol *Gentry; // For global identifiers/functions

//	Lsymbol *Lentry; // For Local variables

};

struct Tnode *TreeCreate(int TYPE, int NODETYPE, char* NAME, int VALUE, struct Tnode* ArgList, struct Tnode* left, struct Tnode* right,struct Tnode* middle);

/*Make a leaf tnode and set the value of val field*/
struct Tnode* makeIntegerLeafNode(int n);

/*Make a tnode with opertor, left and right branches set*/
struct Tnode* makeBinaryOperatorNode(int op, struct Tnode *l, struct Tnode *r);

/*To evaluate an expression tree*/
int evaluate(struct Tnode *t);
