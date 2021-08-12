#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//TABLE DES SYMBOLES
typedef struct TableSymboles TableSymboles;
struct TableSymboles
{
	char NomEntitie[12];
    char TypeEntite[12];
    int  taille ;
	TableSymboles *suiv;
};

TableSymboles *TS = NULL;

void Insertion( char nom[] , char type[] , int taille )
{
	TableSymboles *P,*Q;
	Q = (TableSymboles *)malloc(sizeof(TableSymboles));
	strcpy(Q->NomEntitie , nom);
	strcpy(Q->TypeEntite , type);
	Q->taille = taille ;
	Q->suiv = NULL ;
	if(TS==NULL )		
	{
		TS =Q;
	}
	else
	{
		P=TS; 
		while(P->suiv!=NULL)
		{
			P=P->suiv;
		}	
		P->suiv = Q;

	}	
    		//printf("%s , %s , %d",Q->NomEntitie , Q->TypeEntite, Q->taille )  ;
	}
TableSymboles *Recherche( char nom[])
{
	TableSymboles *P ;
	P = TS;
	while(P != NULL)
	{ 
	if(strcmp(nom , P->NomEntitie ) == 0) return P ;
	P = P->suiv ;
    }
    return P ;
}

void afficher ()
{
	TableSymboles *P;
	P = TS;
    printf("\n/***************Table des symboles ******************/\n");
    printf("_______________________________________________________\n");
    printf("\t| NomEntite |  TypeEntite  |  TailleEntite\n");
    printf("_______________________________________________________\n");
  
  while (P!= NULL)
  {
	  printf("\t|%10s |%12s  |%12d\n",P->NomEntitie,P->TypeEntite,P->taille);
	  P = P->suiv;
  }
    printf("-------------------------------------------------------  \n");
  
  
}

void InsererType(char type[]){
	TableSymboles *P=TS;
	while(P!=NULL){
		if(strcmp((P->TypeEntite),"NoType")==0) {strcpy(P->TypeEntite,type);}
		P=P->suiv;
	}
}
//ROUTINES SÃ‰MANTIQUES
int RoutineIdfNonDeclare(char idf[])
{ 
	if(Recherche(idf) == NULL) return 1 ; return 0 ; 
}

int RoutineDoubleDeclaration(char idf[])
{ 
	if(Recherche(idf) == NULL) return 0 ; return 1 ; 
}

int RoutineNonCompatibilite(char entite1[] ,char Operation[] , char entite2[] )
{
	char Type1[20] , Type2[20] ;
	if(  strcmp(entite1 , "entier") == 0
	  || strcmp(entite1 , "reel") == 0
	  || strcmp(entite1 , "chaine") == 0)
	  {
	  	 strcpy(Type1 , entite1)  ;
	  }
	else
	{
		strcpy(Type1 , Recherche(entite1)->TypeEntite)  ;	
	}  
	if(  strcmp(entite2 , "entier") == 0
	  || strcmp(entite2 , "reel") == 0
	  || strcmp(entite2 , "chaine") == 0)
	  {
	  	strcpy(Type2 , entite2)  ;
	  }
	else
	{
		strcpy(Type2 , Recherche(entite2)->TypeEntite)  ;	
	}  
	
	if(  strcmp(Operation , "+") == 0
	  || strcmp(Operation , "-") == 0
	  || strcmp(Operation , "*") == 0
	  || strcmp(Operation , "/") == 0)
	  {
	  	if((strcmp(Type1 , "entier") == 0 || strcmp(Type1 , "reel") == 0) &&
		   (strcmp(Type2 , "entier") == 0 || strcmp(Type2 , "reel") == 0))
		   {
		   	 return 0 ;
		   }
		   else
		   {
		   	 return 1 ;
		   }
	  }
	if(strcmp(Operation , "<--") == 0)
	{
		if((strcmp(Type1 , "reel") == 0 && (strcmp(Type2 , "reel") == 0 || strcmp(Type2 , "entier") == 0)))
		{
			return 0 ; 
		}
		else
		{
			if(strcmp(Type1 , "entier") == 0 && strcmp(Type2 , "entier") == 0)
			{
				return 0 ;
			}
			else
			{
				if(strcmp(Type1 , "chaine") == 0 && strcmp(Type2 , "chaine") == 0)
				{
					return 0 ;
				}
				else
				{
					return 1 ;
				}
			}
		}
	}
	
	return -1 ;
}

int RoutineDepassementTailleTableau(char tableau[] , int indice)
{ 
    if(Recherche(tableau) != NULL)
	{
	  int taille = Recherche(tableau)->taille ;
	  if(indice > taille) return 1 ; return 0;
	}
	return -1 ;

}


int main(int argc, char *argv[])
{ 
	Insertion("x1" , "entier" , strlen("x1")) ;
	Insertion("x2"  , "entier" , strlen("x2")) ;
	Insertion("tab"  , "reel" , 5) ;
	Insertion("y1"  , "reel" , strlen("y1")) ;
	Insertion("y2"  , "reel" , strlen("y2")) ;
	Insertion("ch1"  , "chaine" , strlen("ch1")) ;
	Insertion("ch2"  , "chaine" , strlen("ch2")) ;
	printf("IDF nn Declare : %d \n Double declaration : %d \n Non Compatibilité de type : %d \n Depassement tail tab : %d ",RoutineIdfNonDeclare("y1") ,RoutineDoubleDeclaration("x3"),RoutineNonCompatibilite("reel" ,"<--", "x1"),RoutineDepassementTailleTableau("tab",5));     
	afficher();                                  
}
