#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Quadruplet Quadruplet ;
struct Quadruplet
{
	char Operation[3];
	char Operande1[12];
    char Operande2[12];
    char Resultat[12] ;
	Quadruplet *suiv;
} ;

Quadruplet *Quad = NULL ; 
int Qc = 0 ; 
int sauvCond ;
int sauvDebInst ;
int sauvFin ;

void Quadr(char Opr[], char Op1[] , char Op2[]  , char Res[])
{
    Quadruplet *P ,*Q;
	Q = (Quadruplet *)malloc(sizeof(Quadruplet));
	strcpy(Q->Operation , Opr);
	strcpy(Q->Operande1 , Op1);
	strcpy(Q->Operande2 , Op2);
	strcpy(Q->Resultat  , Res);	
	Q->suiv = NULL ;
	if(Quad==NULL )		
	{
		Qc   = 1 ;
	    Quad = Q ;
    }
    else
    {
    	P=Quad; 
		while(P->suiv!=NULL )
		{
			P=P->suiv; 
		}	
		P->suiv = Q;
	}
	Qc ++;	
}

void Ajour_Quad(int NumQuad , int Colonne , char Val[])
{
	if(NumQuad <=Qc && Colonne <=4  && Colonne>=1)
	{
		Quadruplet *P ;
		P = Quad ; 
		int i = 1 ;
		while(i< NumQuad && P!=NULL)
		{
			P = P->suiv ;
			i++;
    	}
    	if(P!=NULL)
    	{
    		switch (Colonne)
    		{
    			case 1 : strcpy(P->Operation , Val) ; break ;
    			case 2 : strcpy(P->Operande1 , Val) ; break ;
    			case 3 : strcpy(P->Operande2 , Val) ; break ;
    			case 4 : strcpy(P->Resultat	 , Val) ; break ;
			}
		}
	}
}

void afficher_Qdr(void)
{
	Quadruplet *P  ;
	P = Quad ;
    printf("\n/********Les Quadruplets********/\n");

  int i = 1 ;
  while (P != NULL)
  {
	  printf("\t %d-( %s ,%s  ,%s ,%s )\n\t ----------------------\n",i,P->Operation,P->Operande1,P->Operande2 , P->Resultat);
	  P = P->suiv; i++ ;
  }
  
  
}

//Routines Sémantiques
void R1()
{
	sauvCond = Qc ;
	Quadr("BR" , "vide" , "vide" ,"vide");
    sauvDebInst = Qc ; 	
}

void R2()
{
	char val[3];
	sauvFin = Qc ;
	Quadr("BR" ,"vide" ,"vide" , "vide");
	sprintf(val , "%d" , Qc);
	Ajour_Quad(sauvCond,2,val) ;
}

void R3(char idf[] , char Comparateur[] , char cst[])
{
	char val[3];
	sprintf(val , "%d" , sauvDebInst);
	if(strcmp(Comparateur , ">")==0)
	Quadr("BG" , val, idf , cst) ;
	if(strcmp(Comparateur , ">=")==0)
	Quadr("BGE" , val , idf , cst) ;
	if(strcmp(Comparateur , "<")==0)
	Quadr("BL" , val, idf , cst) ;
	if(strcmp(Comparateur , "<=")==0)
	Quadr("BLE" , val, idf , cst) ;
	if(strcmp(Comparateur , "=")==0)
	Quadr("BE" , val, idf , cst) ;
	if(strcmp(Comparateur , "!=")==0)
	Quadr("BNE" , val, idf , cst) ;
	
	sprintf(val , "%d" , Qc);
	Ajour_Quad(sauvFin , 2 ,val );
}

/*	
int main(int argc, char *argv[]) {
	Quadr("+" , "X" ,"Y" , "TEMP" );
	Quadr("+" , "X" ,"Y" , "TEMP" );
	Quadr("+" , "X" ,"Y" , "TEMP" );
	Quadr("+" , "X" ,"Y" , "TEMP" );
	Ajour_Quad(2,3,"BANZAIII");
	R1();
	Quadr("<--" , "vide" ,"Y" , "TEMP" );	
	R2();
	R3("X1" , "!=" , "98");
	afficher();
	getchar();
	return 0;
}
*/
