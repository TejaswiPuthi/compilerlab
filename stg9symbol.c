#include "stg9symbol.h"
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
 int address=4096;
 int laddress=1;
extern struct Gsymbol * node;
extern struct Lsymbol * lnode;

struct Gsymbol *Glookup(char*NAME)
{
	struct Gsymbol*temp;
	temp=node;
	while(temp!=NULL)
	{
		if(strcmp(temp->NAME,NAME)==0)
			return temp;
		temp=temp->NEXT;
	}
	return NULL;
}

void Ginstall(char*NAME, int TYPE, int SIZE,struct ArgStruct * ARGLIST)
{
	struct Gsymbol * temp;
	if(node==NULL)
	{
		node=malloc(sizeof(struct Gsymbol));
		temp=node;
	}
	else{
		temp=node;
		while(temp->NEXT!=NULL){
			temp=temp->NEXT;
		}
		temp->NEXT=malloc(sizeof(struct Gsymbol));
		temp=temp->NEXT;
	}
	temp->NAME=NAME;
	temp->TYPE=TYPE;
	temp->SIZE=SIZE;
	if (SIZE == 0)
	{
		temp->BINDING=-1;
	}
	else
	temp->BINDING=address;
	temp->NEXT= NULL;
	temp->ARGLIST=ARGLIST;
        address=address+(SIZE/sizeof(int));
        
	}

void Linstall(char*NAME, int TYPE,int SIZE)
{
	struct Lsymbol * temp;
	//printf("In Linstall\n");

	if(lnode==NULL)
		{
			lnode=malloc(sizeof(struct Lsymbol));
			temp=lnode;
			laddress=1;
		}
		else{
			temp=lnode;
			while(temp->NEXT!=NULL){
				temp=temp->NEXT;
			}
			temp->NEXT=malloc(sizeof(struct Lsymbol));
			temp=temp->NEXT;
		}
		temp->NAME=NAME;
		temp->TYPE=TYPE;
		temp->NEXT= NULL;
		temp->SIZE = SIZE;
		temp->BINDING=laddress;
		//printf("%s %d \n",NAME,laddress);
		laddress+=1;
		//temp->BINDING=malloc(SIZE);  /*do local symbol tabel have binding?*/

}


struct  Lsymbol * Llookup( char * NAME)
{
	struct Lsymbol*temp;
	temp=lnode;
	while(temp!=NULL)
	{
		if(strcmp(temp->NAME,NAME)==0)
			return temp;
		temp=temp->NEXT;
	}
	return NULL;
	
};








