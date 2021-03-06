#include "stg7.h"
#include <stdlib.h>
#include <stdio.h>
extern FILE * fp;
extern int* var[26];
int regarr[26]={-1};
static int reg=0;
static addr=0;
 int label=0;

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

int codegen(struct tnode*root)
{ struct tnode* temp;
	int r1,r2,l1,l2;
	char name;
	switch(root->NODETYPE){
		case NUM: r1=getreg();
				  fprintf(fp, "MOV R%d,%d\n",r1,root->VALUE );
				  return r1;
				  break;
		case PLUS:  r1=codegen(root->ptr1);
					r2=codegen(root->ptr2);
					fprintf(fp, "ADD R%d,R%d\n",r1,r2 );
					freereg();
					return r1;
			        break;
		case MINUS: r1=codegen(root->ptr1);
					r2=codegen(root->ptr2);
					fprintf(fp, "SUB R%d,R%d\n",r1,r2 );
					freereg();
					return r1;
			        break;	        
		case MUL:   r1=codegen(root->ptr1);
					r2=codegen(root->ptr2);
					fprintf(fp, "MUL R%d,R%d\n",r1,r2 );
					freereg();
					return r1;
			        break;
		case DIV:   r1=codegen(root->ptr1);
					r2=codegen(root->ptr2);
					fprintf(fp, "DIV R%d,R%d\n",r1,r2 );
					freereg();
					return r1;
			        break;
	    case LT :   r1 = codegen(root->ptr1);
					r2 = codegen(root->ptr2);
					fprintf(fp, "LT R%d,R%d\n",r1,r2);
					freereg();
					return r1;
					break;
			case GT :   r1 = codegen(root->ptr1);
						r2 = codegen(root->ptr2);
						fprintf(fp, "GT R%d,R%d\n",r1,r2);
						freereg();
						return r1;
	                    break;
	        case EQ :   r1 = codegen(root->ptr1);
						r2 = codegen(root->ptr2);
						fprintf(fp, "EQ R%d,R%d\n",r1,r2);
						freereg();
						return r1;
						break;
			case NOTEQ :r1 = codegen(root->ptr1);
						r2 = codegen(root->ptr2);
						fprintf(fp, "NE R%d,R%d\n",r1,r2);
						freereg();
						return r1;
						break;
			case LTE :   r1 = codegen(root->ptr1);
						r2 = codegen(root->ptr2);
						fprintf(fp, "LE R%d,R%d\n",r1,r2);
						freereg();
						return r1;
						break;
			case GTE :   r1 = codegen(root->ptr1);
						r2 = codegen(root->ptr2);
						fprintf(fp, "GE R%d,R%d\n",r1,r2);
						freereg();
						return r1;
						break;
			case STMT : codegen(root->ptr1);
					codegen(root->ptr2);
					return -1;
					break;
		case READ: 	r1=getreg();
					r2=getreg();
					if(var[*(root->ptr1->NAME)-'a']==NULL)
					var[*(root->ptr1->NAME)-'a']=(int *)malloc(sizeof(int));
					fprintf(fp, "MOV [4122],R%d\n",r1 );
					fprintf(fp, "MOV SP, 4122\n" );
					fprintf(fp, "MOV BP, 4122\n" );
					fprintf(fp, "MOV R%d, 7\nPUSH R%d\n",r2,r2 );
					fprintf(fp, "MOV R%d, -1\nPUSH R%d\n",r2,r2 );
					fprintf(fp, "MOV R%d, 4122\nPUSH R%d\n",r2,r2 );
					fprintf(fp, "PUSH R0\nPUSH R0\nINT 6\n");
					fprintf(fp, "POP R%d \n",r1 );
					fprintf(fp, "POP R%d\nPOP R%d\nPOP R%d\nPOP R%d\n",r2,r1,r2,r2 );
					fprintf(fp,"MOV [%d],[R%d]\n",4096+(*(root->ptr1->NAME)-'a'),r1);
					freereg();
					regarr[*(root->ptr1->NAME)-'a']= r1;
					return r1;
					break;
		case WRITE : 		 r1=codegen(root->ptr1);
				 	 r2=getreg();		
					 fprintf(fp, "MOV [4122],R%d\n",r1 );
					 fprintf(fp, "MOV SP, 4122\n" );
					 fprintf(fp, "MOV R%d, 5\nPUSH R%d\n",r2,r2 );
					 fprintf(fp, "MOV R%d, -2\nPUSH R%d\n",r2,r2 );
					 fprintf(fp, "MOV R%d, 4122\nPUSH R%d\n",r2,r2 );
					 fprintf(fp, "PUSH R0\nPUSH R0\nINT 7\n");
					 fprintf(fp, "POP R%d \n",r1 );
					 fprintf(fp, "POP R%d\nPOP R%d\nPOP R%d\nPOP R%d\n",r2,r2,r2,r2 );
					 freereg();
					 return -1;
					 break;
		case ID : if(var[*(root->NAME)-'a']==NULL)
				  {printf("unallocated variable\n");
				  exit(0);}
				  if(regarr[*(root->NAME)-'a']!=-1)
				  	r1=regarr[*(root->NAME)-'a'];
				  else
					{r1=getreg();
						}

				  fprintf(fp,"MOV R%d,[%d]\n",r1,4096+(*(root->NAME)-'a'));
				  return r1;
				  break;
		case ASGN: temp = root->ptr1;
				   name = (temp->NAME)[0];
			       if(var[name - 'a']==NULL)
				   {var[name - 'a'] = (int *) malloc (sizeof(int));
				   r1=getreg();
				    regarr[(name)-'a']=r1;}
				    else
				    	r1=regarr[(name)-'a'];
			       r2=codegen(root->ptr2);
			       printf("r1 in assign=%d\n",r1);
			      
			       fprintf(fp,"MOV [%d],R%d\n",4096+(name-'a'),r2);
			       

			       return -1;
		       	   break;
		case IF : r1 = codegen(root->ptr1);
					l1 = getLabel();
					fprintf(fp, "JZ R%d, L%d\n",r1,l1);
					codegen(root->ptr2);
					fprintf(fp, "L%d:\n",l1 );
					return -1;
				  break;
                case ELSE :     r1 = codegen(root->ptr1);
				l1 = getLabel();
				l2 = getLabel();
				fprintf(fp, "JZ R%d, L%d\n",r1,l1);
				codegen(root->ptr2);
				fprintf(fp, "JMP L%d\n",l2);
				fprintf(fp, "L%d:\n",l1 );
				codegen(root->ptr3);
				fprintf(fp, "L%d:\n",l2 );
				return -1;
				break;
		case WHILE :             
					 l1 = getLabel();
					 l2 = getLabel();
					 fprintf(fp, "L%d:\n",l1);
					 r1 = codegen(root->ptr1);
					 fprintf(fp, "JZ R%d,L%d\n",r1,l2);
					 r1 = codegen(root->ptr2);
					 fprintf(fp, "JMP L%d\n",l1);
					 fprintf(fp, "L%d:\n",l2);
					 
					 return -1;
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

int getreg()
{
	if(reg>19)
	{
		printf("You are out of registers\n");
		exit(0);
	}
	int p= reg;
	reg++;
	return p;
}

void freereg()
{
	int i=0;
	for(;i<26;i++)
	{
		if(regarr[i]==reg)
			regarr[i]=-1;
	}
	reg--;	

}

int getLabel()
{
	label++;
	return label;
}


	

	
