#include "expl.h"
#include <stdlib.h>
#include <stdio.h>
#include "explsymbol.c"


extern int* var[26];
int ret;

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
		case TRUE: return TRUE;
				  break;
		case FALSE: return FALSE;
		          break;
		case PLUS: return evaluate(root->ptr1)+evaluate(root->ptr2);
			       break;
		case MINUS: return evaluate(root->ptr1)-evaluate(root->ptr2);
			       break;
		case DIV:  if(evaluate(root->ptr2)==0)
					{printf("division by zero!\n");exit(0);}	
		           return evaluate(root->ptr1)/evaluate(root->ptr2);
			       break;
		case MOD: if(evaluate(root->ptr2)==0)
					{printf("division by zero!\n");exit(0);}
				   return evaluate(root->ptr1)%evaluate(root->ptr2);
			       break;
		case MUL:return evaluate(root->ptr1)*evaluate(root->ptr2);
			       break;
		case LT: if (evaluate(root->ptr1)<evaluate(root->ptr2))
						{return TRUE;}
				 else
				 		{return FALSE;}
			       break;
		case GT: if (evaluate(root->ptr1)>evaluate(root->ptr2))
						{return TRUE;}
				 else
				 		{return FALSE;}
			       break;	     
		case EQ: if (evaluate(root->ptr1)==evaluate(root->ptr2))
						{return TRUE;}
				 else
				 		{return FALSE;}
			       break;  
		case LTE: if (evaluate(root->ptr1)<=evaluate(root->ptr2))
						{return TRUE;}
				  else
				 		{return FALSE;}
			       break;	   
	    case GTE: if (evaluate(root->ptr1)>=evaluate(root->ptr2))
						{return TRUE;}
				  else
				 		{return FALSE;}
			       break;
	    case NOTEQ: if (evaluate(root->ptr1)!=evaluate(root->ptr2))
						{return TRUE;}
				 	else
				 		{return FALSE;}
			       break;
		case STMT : 	 
						 evaluate(root->ptr1);
						 evaluate(root->ptr2);
						 return 0;
						 break;
		case READ: {
			if(Glookup(root->ptr1->NAME)==NULL)                            //search for symbol table entry
				{printf("Unallocated variable");
				exit(0);}
			else
				scanf("%d", Glookup(root->ptr1->NAME)->BINDING);			
			return 0;
			break;
		      }
		case WRITE : 
		          printf("%d\n",evaluate(root->ptr1));
					 return 0;
					 break;
		case ID : if(Glookup(root->NAME)==NULL)
						{printf("unallocated variable\n");
						exit(0);}
					return *Glookup(root->NAME)->BINDING;
					break;
		case ASGN:  
					temp = root->ptr1->NAME;
			 		*(Glookup(temp)->BINDING)=evaluate(root->ptr2);
			 		return 0;
			 		break;
		case IF : if(evaluate(root->ptr1)==TRUE)
					return evaluate(root->ptr2);
				else return 0;
				break;
        case ELSE : if(evaluate(root->ptr1)==TRUE)
					return evaluate(root->ptr2);
				else return evaluate(root->ptr3);
				break;
		case WHILE : while(evaluate(root->ptr1)==TRUE)
						evaluate(root->ptr2);
					return 0;
					break;
		case ARR: 
			ret = evaluate(root->ptr2);
			return *((Glookup(root->ptr1->NAME) -> BINDING) + ret);
			break;			
		case ASGNARR : 	
		 if(Glookup(root->NAME)  == NULL)
			{
				printf("Unallocated variable '%s'", root->NAME);
				exit(0);
			}
			
			int abc= evaluate(root->ptr2);
			*(Glookup(root->NAME) -> BINDING +evaluate( root->ptr1)) = abc;
			return 0;
			break;	
			case READARR: if(Glookup(root->ptr1->NAME)==NULL)	
							{
				printf("Unallocated variable '%s'", root->NAME);
				exit(0);
							}
				int x= evaluate(root->ptr2);
				scanf("%d", Glookup(root->ptr1->NAME)->BINDING+x);
				return 0;
					break;
			case AND: if(evaluate(root->ptr1)==TRUE && evaluate(root->ptr2)==TRUE )
						{
							return TRUE;
						}
						else
							return FALSE;
						break;
			case OR: if(evaluate(root->ptr1)==TRUE || evaluate(root->ptr2)==TRUE )
						{
							return TRUE;
						}
						else
							return FALSE;
						break;	
			case NOT: if(evaluate(root->ptr1)==TRUE)
			 			 return FALSE;
			 		  else
			 		  	return TRUE;
			 		  break;
		default : printf("Wrong choice!\n");
					exit(0);

	}
}

struct tnode* makeLeafNode(int n , int TYPE){
    struct tnode *temp;
    temp = (struct tnode*)malloc(sizeof(struct tnode));
    bzero(temp, sizeof(struct tnode));
    temp->TYPE=TYPE;
    temp->NODETYPE=NUM;
    temp->VALUE=n;
    return temp;
}

struct tnode* makeOperatorNode(int op,struct tnode *l,struct tnode *r,int TYPE){
    struct tnode *temp;
    temp = (struct tnode*)malloc(sizeof(struct tnode));
    bzero(temp, sizeof(struct tnode));
    temp->TYPE=TYPE;
    temp->NODETYPE=op;
    temp->ptr1=l;
    temp->ptr2=r;
    return temp;
}
