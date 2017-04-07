#include "expl.h"
#include <stdlib.h>
#include <stdio.h>

extern int* var[26];

struct tnode *TreeCreate(int TYPE,int NODETYPE,int VALUE,char * NAME,struct tnode *ArgList,struct tnode *ptr1,struct tnode * ptr2,struct tnode *ptr3){

	struct tnode * temp = (struct tnode *) malloc (sizeof(struct tnode));
	temp->	TYPE = TYPE;
	temp->NODETYPE=NODETYPE;
	temp->VALUE=VALUE;
	temp->NAME=NAME;
	temp->ArgList=ArgList;
	temp->ptr1=ptr1;
	temp->ptr2=ptr2;
	temp->ptr3=ptr3;
	return temp;
}

int evaluate(struct tnode*root)
{ struct tnode* temp;
	char name;
	switch(root->NODETYPE){
		case NUM: return root->VALUE;
				  break;
		case PLUS: return evaluate(root->ptr1)+evaluate(root->ptr2);
			       break;
		case MUL:return evaluate(root->ptr1)*evaluate(root->ptr2);
			       break;
		case LT: return evaluate(root->ptr1)<evaluate(root->ptr2);
			       break;
		case GT: return evaluate(root->ptr1)>evaluate(root->ptr2);
			       break;	     
		case EQ: return evaluate(root->ptr1)==evaluate(root->ptr2);
			       break;  
		case STMT : evaluate(root->ptr1);
						 evaluate(root->ptr2);
						 return 0;
						 break;
		case READ: if(var[*(root->ptr1->NAME)-'a']==NULL)
						var[*(root->ptr1->NAME)-'a']=(int *)malloc(sizeof(int));
					scanf("%d",var[*(root->ptr1->NAME)-'a']);
					return 0;
					break;
		case WRITE : printf("%d",evaluate(root->ptr1));
					 return 0;
					 break;
		case ID : if(var[*(root->NAME)-'a']==NULL)
						{printf("unallocated variable\n");
						exit(0);}
					return *var[*(root->NAME)-'a'];
					break;
		case ASGN:  if(root->ptr2->TYPE!=type_int)
						{printf("ASGNERROR\n");exit(0);}
						root->TYPE=type_int;
					temp = root->ptr1;
					name = (temp->NAME)[0];
			 		if(var[name - 'a']==NULL)
					var[name - 'a'] = (int *) malloc (sizeof(int));
			 		*var[name-'a']=evaluate(root->ptr2);
			 		return 0;
			 		break;
		case IF : if(evaluate(root->ptr1))
					return evaluate(root->ptr2);
				else return 0;
				break;
        case ELSE : if(evaluate(root->ptr1))
					return evaluate(root->ptr2);
				else return evaluate(root->ptr3);
				break;
		case WHILE : while(evaluate(root->ptr1))
						evaluate(root->ptr2);
					return 0;
					break;
		default : printf("Wrong choice!\n");
					exit(0);

	}
}

struct tnode* makeLeafNode(int n){
    struct tnode *temp;
    temp = (struct tnode*)malloc(sizeof(struct tnode));
    bzero(temp, sizeof(struct tnode));
    temp->TYPE=type_int;
    temp->NODETYPE=NUM;
    temp->VALUE=n;
    return temp;
}

struct tnode* makeOperatorNode(int op,struct tnode *l,struct tnode *r){
    struct tnode *temp;
    temp = (struct tnode*)malloc(sizeof(struct tnode));
    bzero(temp, sizeof(struct tnode));
    temp->TYPE=NUM;
    temp->NODETYPE=op;
    temp->ptr1=l;
    temp->ptr2=r;
    return temp;
}
