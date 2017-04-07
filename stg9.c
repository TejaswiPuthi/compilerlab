#include "stg9.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "stg9symbol.c"
extern int address;
int local_space;
extern FILE * fp;
int label=0;
int reg=0;
int ret;
int fnlabel=0;
char *func_name;
char *tem;
int ph=1;

void printheader()
{
	fprintf(fp, "%d\n%d\n%d\n%d\n%d\n%d\n%d\n%d\n",0,2056,0,0,0,0,0,0);
	fprintf(fp, "MOV SP,%d\n",address);
	fprintf(fp, "MOV BP,%d\n",address);
	fprintf(fp, "JMP MAIN\n");
}

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
	if(ph==1)
	{
	printheader();
	ph=0;
	}
	char name;
	int r1,r2,l1,l2,r3;
	switch(root->NODETYPE){
		case NUM: 	r1=getreg();
		 		fprintf(fp, "MOV R%d,%d\n",r1,root->VALUE );
				return r1;
				break;
		case TRUE: r1=getreg();
					fprintf(fp, "MOV R%d,1\n",r1);
					return r1;
				  break;
		case FALSE: r1=getreg();
					fprintf(fp, "MOV R%d,0\n",r1);
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
			   r2 = getreg();
			fprintf(fp, "MOV R%d,0\n",r2);
			if (Llookup(root->NAME) != NULL){
				r1 = getreg();
				fprintf(fp, "MOV R%d, BP\n",r1);
				fprintf(fp, "ADD R%d, %d\n", r1, Llookup(root->NAME)->BINDING);
				fprintf(fp, "ADD R%d,R%d\n", r2, r1);
				freereg();
			}
			else{
				fprintf(fp, "ADD R%d,%d\n",r2,Glookup(root->NAME)->BINDING);
			}
			r1 = getreg();
			for(r1=0;r1<reg;r1++)		//push all registers in use
				fprintf(fp, "PUSH R%d\n",r1);

			fprintf(fp, "MOV R%d,\"Read\"\n",r1);
			fprintf(fp, "PUSH R%d\n",r1);

			fprintf(fp, "MOV R%d,-1\n",r1);
			fprintf(fp, "PUSH R%d\n",r1);

			fprintf(fp, "PUSH R%d\n",r2);

			fprintf(fp, "PUSH R%d\n",r1);

			fprintf(fp, "PUSH R%d\n",r1);

			fprintf(fp, "CALL 0\n");
			fprintf(fp, "POP R%d\n",r2);
			fprintf(fp, "POP R%d\n",r1);
			fprintf(fp, "POP R%d\n",r1);
			fprintf(fp, "POP R%d\n",r1);
			fprintf(fp, "POP R%d\n",r1);
			for(r1=reg-1;r1>=0;r1--)	//pop all pushed registers
				fprintf(fp, "POP R%d\n",r1);
			freereg();
			freereg();
			break;
		case WRITE : 
		             r2 = codegen(root->ptr1);
			for(r1=0;r1<reg;r1++)	//push all registers in use
				fprintf(fp, "PUSH R%d\n",r1);
			r1 = getreg();
			fprintf(fp, "MOV R%d,\"Write\"\n", r1);
			fprintf(fp, "PUSH R%d\n",r1 );

			fprintf(fp, "MOV R%d,-2\n", r1);
			fprintf(fp, "PUSH R%d\n",r1);

			fprintf(fp, "MOV R%d,SP\n",r1 );
			fprintf(fp, "SUB R%d,2\n",r1 );
			fprintf(fp, "PUSH R%d\n",r1);

			fprintf(fp, "PUSH R%d\n",r1);

			fprintf(fp, "PUSH R%d\n",r1);

			fprintf(fp, "CALL 0\n");

			fprintf(fp, "POP R%d\n",r2); //return value
			fprintf(fp, "POP R%d\n",r1);
			fprintf(fp, "POP R%d\n",r1);
			fprintf(fp, "POP R%d\n",r1);
			fprintf(fp, "POP R%d\n",r1);
			freereg();
			for(r1=reg-1;r1>=0;r1--)	//pop all pushed registers
				fprintf(fp, "POP R%d\n",r1);
			freereg();
			break;
		
		case ID : if(Llookup(root->NAME)==NULL)
                  {
		             if(Glookup(root->NAME)==NULL)
				     {
				  	    printf("unallocated variable\n");
				  		exit(0);
				  	 }
				  }
				  r1=getreg();
                  if (Llookup(root->NAME) == NULL)
				  fprintf(fp,"MOV R%d,[%d]\n",r1,Glookup(root->NAME)->BINDING);
				  else
				  {	
				  fprintf(fp, "MOV R%d, %d\n", r1, Llookup(root->NAME)->BINDING);
				
					fprintf(fp, "ADD R%d, BP\n", r1);
				fprintf(fp, "MOV R%d, [R%d]\n", r1, r1);
				  //fprintf(fp,"MOV R%d,[%d]\n",r1,Llookup(root->NAME)->BINDING);
				  }
				  return r1;
				  break;


		case ASGN:	tem = root->ptr1->NAME;
					r2=codegen(root->ptr2);
					if(Llookup(tem)==NULL)
			        fprintf(fp,"MOV [%d],R%d\n",Glookup(tem)->BINDING,r2);
			        else
			        {
					            r1=getreg();
					            fprintf(fp, "MOV R%d, %d\n", r1, Llookup(tem)->BINDING);
				                fprintf(fp, "ADD R%d, BP\n", r1);
				                fprintf(fp, "MOV [R%d], R%d\n", r1, r2);
				                freereg();
				    }
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
					 codegen(root->ptr2);
					 fprintf(fp, "JMP L%d\n",l1);
					 fprintf(fp, "L%d:\n",l2);
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
	        r2 = codegen(root->ptr2);
			fprintf(fp, "ADD R%d,%d\n",r2,Glookup(root->ptr1->NAME)->BINDING);
			r1 = getreg();
			for(r1=0;r1<reg;r1++)		//push all registers in use
				fprintf(fp, "PUSH R%d\n",r1);

			fprintf(fp, "MOV R%d,\"Read\"\n",r1);
			fprintf(fp, "PUSH R%d\n",r1);

			fprintf(fp, "MOV R%d,-1\n",r1);
			fprintf(fp, "PUSH R%d\n",r1);

			fprintf(fp, "PUSH R%d\n",r2);
			fprintf(fp, "PUSH R%d\n",r1);
			fprintf(fp, "PUSH R%d\n",r1);
			fprintf(fp, "CALL 0\n");
			fprintf(fp, "POP R%d\n",r2);
			fprintf(fp, "POP R%d\n",r1);
			fprintf(fp, "POP R%d\n",r1);
			fprintf(fp, "POP R%d\n",r1);
			fprintf(fp, "POP R%d\n",r1);
			for(r1=reg-1;r1>=0;r1--)	//pop all pushed registers
				fprintf(fp, "POP R%d\n",r1);
			freereg();
			freereg();
			break;

			   case FNDEF: 		
			   					
			   					func_name=root->NAME;
			   					local_space=0;
								if(strcmp (root->NAME,"MAIN")!=0)
								{
									Glookup(root->NAME)->flabel=getFunctionLabel();
									fprintf(fp, "F%d:\n",Glookup(root->NAME)->flabel );

								}
								else
									fprintf(fp, "MAIN:\n" );

								fprintf(fp, "PUSH BP\n");
			                    fprintf(fp, "MOV BP, SP\n");

			                    struct Lsymbol * ltemp = lnode;
			                    while(ltemp!=NULL)
			                    {
			                    	local_space+=1;
			                    	ltemp=ltemp->NEXT;
			                    }
			                    fprintf(fp, "ADD SP,%d\n",local_space );
			                    codegen(root->ptr1);

			                    
                                  break;


			   case FNCALL:   
			   				  //push registers
			   				  for(r2=0; r2<reg; r2++)
                              fprintf(fp, "PUSH R%d\n", r2);

                              
                              //push arguments
                          	  int num=0;
                              temp= root->ArgList;
                              while(temp!=NULL)
                              {
                              	r1 = codegen(temp->ptr1);
								fprintf(fp, "PUSH R%d\n", r1);
								temp = temp->ArgList;
								num++;
								freereg();
                              }

                              //push empty space
                              r1 = getreg();
                              fprintf(fp,"PUSH R%d\n",r1); 

                              //invoke function
                              fprintf(fp, "CALL F%d\n",Glookup(root->NAME)->flabel );

                              //return value
                              fprintf(fp, "POP R%d\n",r1 );

                              //pop out arguments
                              r2=getreg();
                              while(num>0)
                              {	
                              	fprintf(fp, "POP R%d\n",r2 );
                              	num--;
                              }
                              freereg();

                              //restore machine registers

                              for(r2=reg-2;r2>=0;r2--)
                              {
                              	fprintf(fp, "POP R%d\n",r2 );
                              }
                              return r1;
                              break;


			   case RETN:
			        r2 = getreg();
					if(strcmp(func_name,"MAIN")!=0)
					{
					r1 = codegen(root->ptr1);
					fprintf(fp, "MOV R%d, BP\n", r2);
					fprintf(fp, "SUB R%d, 2\n", r2);
					fprintf(fp, "MOV [R%d], R%d\n", r2, r1);
					funcRet();
					freereg();
					return r2;
					}
					else
					funcRet();
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

void funcRet(){
	fprintf(fp, "SUB SP, %d\n", local_space); //pop space for local variables
	//freereg();
	fprintf(fp, "POP BP\n");
	if (strcmp(func_name, "MAIN") != 0)
		fprintf(fp, "RET\n");
	
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

int getFunctionLabel()
{
	fnlabel++;
	return fnlabel;
}
