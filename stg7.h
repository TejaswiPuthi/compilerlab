
#define type_int 20
#define type_void 21
#define type_bool 22

/** Sample Expression Tree Node Structure **/

struct tnode {

int TYPE; // Integer, Boolean or Void (for statements)

/* Must point to the type expression tree for user defined types */

int NODETYPE;

/* this field should carry following information:

* a) operator : (+,*,/ etc.) for expressions

* b) statement Type : (WHILE, READ etc.) for statements */

char* NAME; // For Identifiers/Functions

int VALUE; // for constants

struct tnode *ArgList; // List of arguments for functions

struct tnode *ptr1, *ptr2, *ptr3;

/* Maximum of three subtrees (3 required for IF THEN ELSE */



};

struct tnode *TreeCreate(int TYPE,int NODETYPE,int VALUE,char* NAME,struct tnode*ArgList,struct tnode *ptr1, struct tnode *ptr2,struct tnode *ptr3);
/*Make a leaf tnode and set the value of val field*/
struct tnode* makeLeafNode(int n);

/*Make a tnode with opertor, left and right branches set*/
struct tnode* makeOperatorNode(int op,struct tnode *l,struct tnode *r);

/*To evaluate an expression tree*/
int codegen(struct tnode *t);
