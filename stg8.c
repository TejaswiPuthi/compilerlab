#include "stg8.h"
#include <stdlib.h>
#include <stdio.h>
#include "stg8symbol.c"
extern int address;
extern FILE * fp;
int label=0;
int reg=0;
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

int codegen(struct tnode*root)
{ struct tnode* temp;
	char name;
	int r1,r2,l1,l2,r3;
	switch(root->NODETYPE){
		case NUM: 	r1=getreg();
		 		fprintf(fp, "MOV R%d,%d\n",r1,root->VALUE );
				return r1;
				break;
		case TRUE: r1=getreg();
					fprintf(fp, "MOV R%d,1\n",r1,root->VALUE );
					return r1;
				  break;
		case FALSE: r1=getreg();
					fprintf(fp, "MOV R%d,0\n",r1,root->VALUE );
					return r1;
				  break;
		case PLUS: r1=codegen(root->ptr1);
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
		case DIV:   r1=codegen(root->ptr1);
			    r2=codegen(root->ptr2);
			    fprintf(fp, "DIV R%d,R%d\n",r1,r2 );
			    freereg();
			    return r1;
			    break;
		case MOD: r1=codegen(root->ptr1);
			    r2=codegen(root->ptr2);
			    fprintf(fp, "MOD R%d,R%d\n",r1,r2 );
			    freereg();
			    return r1;
			    break;
		case MUL:r1=codegen(root->ptr1);
			 r2=codegen(root->ptr2);
			 fprintf(fp, "MUL R%d,R%d\n",r1,r2 );
			 freereg();
			 return r1;
			 break;
		case LT: r1 = codegen(root->ptr1);
			 r2 = codegen(root->ptr2);
			 fprintf(fp, "LT R%d,R%d\n",r1,r2);
			 freereg();
			 return r1;
			 break;
		case GT: r1 = codegen(root->ptr1);
			 r2 = codegen(root->ptr2);
			 fprintf(fp, "GT R%d,R%d\n",r1,r2);
			 freereg();
			 return r1;
	                 break;	     
		case EQ: r1 = codegen(root->ptr1);
			 r2 = codegen(root->ptr2);
			 fprintf(fp, "EQ R%d,R%d\n",r1,r2);
			 freereg();
			 return r1;
			 break;
		case LTE: r1 = codegen(root->ptr1);
			  r2 = codegen(root->ptr2);
			  fprintf(fp, "LE R%d,R%d\n",r1,r2);
			  freereg();
			  return r1;
			  break; 
	    case GTE: r1 = codegen(root->ptr1);
		      r2 = codegen(root->ptr2);
		      fprintf(fp, "GE R%d,R%d\n",r1,r2);
		      freereg();
		      return r1;
						break;
	    case NOTEQ: r1 = codegen(root->ptr1);
			r2 = codegen(root->ptr2);
			fprintf(fp, "NE R%d,R%d\n",r1,r2);
			freereg();
			return r1;
			break;
		case STMT : codegen(root->ptr1);
			    codegen(root->ptr2);
			    return -1;
			    break;
		case READ: 
			   r1=getreg();
			   r2=getreg();
			   //fprintf(fp, "MOV [%d],R%d\n",address,r1 );
			   fprintf(fp, "MOV SP, %d\n",address );
			   fprintf(fp, "MOV BP, %d\n",address );
			   fprintf(fp, "MOV R%d, 7\nPUSH R%d\n",r2,r2 );
			   fprintf(fp, "MOV R%d, -1\nPUSH R%d\n",r2,r2 );
			   fprintf(fp, "MOV R%d, %d\nPUSH R%d\n",r2,address,r2 );
			   fprintf(fp, "PUSH R0\nPUSH R0\nINT 6\n");
			   fprintf(fp, "POP R%d \n",r1 );
			   fprintf(fp, "POP R%d\nPOP R%d\nPOP R%d\nPOP R%d\n",r2,r1,r2,r2 );
			   fprintf(fp,"MOV [%d],[R%d]\n",Glookup(root->ptr1->NAME)->BINDING,r1);
			   freereg();
			   return r1;
							
			break;
		case WRITE : 
		             r1=codegen(root->ptr1);
				 	 r2=getreg();		
					 fprintf(fp, "MOV [%d],R%d\n",address,r1 );
					 fprintf(fp, "MOV SP, %d\n",address );
					 fprintf(fp, "MOV R%d, 5\nPUSH R%d\n",r2,r2 );
					 fprintf(fp, "MOV R%d, -2\nPUSH R%d\n",r2,r2 );
					 fprintf(fp, "MOV R%d, %d\nPUSH R%d\n",r2,address,r2 );
					 fprintf(fp, "PUSH R0\nPUSH R0\nINT 7\n");
					 fprintf(fp, "POP R%d \n",r1 );
					 fprintf(fp, "POP R%d\nPOP R%d\nPOP R%d\nPOP R%d\n",r2,r2,r2,r2 );
					 freereg();
					 freereg();
					 return -1;
					 break;
		/*case WRITEARR :          if(Glookup(root->ptr1->NAME)==NULL)	
							{
						printf("Unallocated variable '%s'", root->NAME);
						exit(0);}
					 r3 = codegen(root->ptr2);
					 r1=getreg();
				 	 r2=getreg();
					 fprintf(fp,"MOV R%d,%d\n",r2,Glookup(root->ptr1->NAME)->BINDING);
			         fprintf(fp,"ADD R%d,R%d\n",r3,r2);		
					 fprintf(fp, "MOV [%d],[R%d]\n",address,r3 );
					 fprintf(fp, "MOV SP, %d\n",address );
					 fprintf(fp, "MOV R%d, 5\nPUSH R%d\n",r2,r2 );
					 fprintf(fp, "MOV R%d, -2\nPUSH R%d\n",r2,r2 );
					 fprintf(fp, "MOV R%d, %d\nPUSH R%d\n",r2,address,r2 );
					 fprintf(fp, "PUSH R0\nPUSH R0\nINT 7\n");
					 fprintf(fp, "POP R%d \n",r1 );
					 fprintf(fp, "POP R%d\nPOP R%d\nPOP R%d\nPOP R%d\n",r2,r2,r2,r2 );
					 freereg();
					 freereg();
					 freereg();
					 return -1;
					 break;*/
		case ID : if(Glookup(root->NAME)==NULL)
				  {printf("unallocated variable\n");
				  exit(0);}
				  r1=getreg();

				  fprintf(fp,"MOV R%d,[%d]\n",r1,Glookup(root->NAME)->BINDING);
				  return r1;
				  break;


		case ASGN:temp = root->ptr1->NAME;
			      r2=codegen(root->ptr2);
			      fprintf(fp,"MOV [%d],R%d\n",Glookup(temp)->BINDING,r2);
			      freereg();
			      return -1;
		       	  break;
		case IF:    r1 = codegen(root->ptr1);
					l1 = getLabel();
					fprintf(fp, "JZ R%d, L%d\n",r1,l1);
					codegen(root->ptr2);
					fprintf(fp, "L%d:\n",l1 );
					freereg();
					return -1;
				         break;
        case ELSE : r1 = codegen(root->ptr1);
					l1 = getLabel();
					l2 = getLabel();
					fprintf(fp, "JZ R%d, L%d\n",r1,l1);
					codegen(root->ptr2);
					fprintf(fp, "JMP L%d\n",l2);
					fprintf(fp, "L%d:\n",l1 );
					codegen(root->ptr3);
					fprintf(fp, "L%d:\n",l2 );
					freereg();
					return -1;
					break;
		case WHILE : l1 = getLabel();
					 l2 = getLabel();
					 fprintf(fp, "L%d:\n",l1);
					 r1 = codegen(root->ptr1);
					 fprintf(fp, "JZ R%d,L%d\n",r1,l2);
					 r1 = codegen(root->ptr2);
					 fprintf(fp, "JMP L%d\n",l1);
					 fprintf(fp, "L%d:\n",l2);
					 freereg();
					 freereg();
					 return -1;
					 break;
		
		case ARR: 
			r1=codegen(root->ptr2);
			r2=getreg();
			fprintf(fp,"MOV R%d,%d\n",r2,Glookup(root->NAME)->BINDING);
			fprintf(fp,"ADD R%d,R%d\n",r1,r2);
			fprintf(fp, "MOV R%d,[R%d]\n",r1,r1 );
			freereg();
			return r1;
			break;
			
		case ASGNARR : 	
		        if(Glookup(root->NAME)  == NULL)
			{
				printf("Unallocated variable '%s'", root->NAME);
				exit(0);
			}
			r1=codegen(root->ptr1);
			r2= codegen(root->ptr2);
			r3=getreg();
			fprintf(fp,"MOV R%d,%d\n",r3,Glookup(root->NAME)->BINDING);
			fprintf(fp,"ADD R%d,R%d\n",r1,r3);
			fprintf(fp,"MOV [R%d],R%d\n",r1,r2);
			freereg();
			freereg();
			return r1;
			break;	

	      case READARR: 
	           if(Glookup(root->ptr1->NAME)==NULL)	
							{
				printf("Unallocated variable '%s'", root->ptr1->NAME);
				exit(0);
							}
				r3=codegen(root->ptr2);
                r1=getreg();
			    r2=getreg();
			   
			   //fprintf(fp, "MOV [%d],R%d\n",address,r1);
			   fprintf(fp, "MOV SP, %d\n",address );
			   fprintf(fp, "MOV BP, %d\n",address );
			   fprintf(fp, "MOV R%d, 7\nPUSH R%d\n",r2,r2 );
			   fprintf(fp, "MOV R%d, -1\nPUSH R%d\n",r2,r2 );
			   fprintf(fp, "MOV R%d, %d\nPUSH R%d\n",r2,address,r2 );
			   fprintf(fp, "PUSH R0\nPUSH R0\nINT 6\n");
			   fprintf(fp, "POP R%d \n",r1 );
			   fprintf(fp, "POP R%d\nPOP R%d\nPOP R%d\nPOP R%d\n",r2,r1,r2,r2 );
			   fprintf(fp,"MOV R%d,%d\n",r2,Glookup(root->ptr1->NAME)->BINDING);
			   fprintf(fp,"ADD R%d,R%d\n",r3,r2);
			   fprintf(fp, "MOV [R%d],[R%d]\n",r3,r1 );
			   fprintf(fp, "MOV R%d,[R%d]\n",r3,r3 );
			   freereg();
			   freereg();
			   return r3;
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
	reg--;	

}

int getLabel()
{
	label++;
	return label;
}
