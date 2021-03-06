%{
#include <stdio.h>
#include<string.h>
#include "TableDesSymboles.h"
#include "CodeIntermediaire.h"
extern nb_ligne;
int taille ; 
char type[12] , Op[2] , Oplog[3] , ValComp[12];

%}
%union
{
   char* chaine;
   int entier;
   float reel;
}

%token mc_algo mc_debut mc_fin  <chaine>string <chaine>idf mc_var mc_entier <reel>mc_reel 
%token mc_chaine <entier>cstE mc_pour mc_jusque mc_faire mc_fait mc_si affectation cstR;
%token ';' '|' '[' ']' ':' '(' ')' notegal supegal infegal egal;
%left '+' '-' ;
%left '*' '/' ;



%%
Programme: mc_algo idf mc_var Declaration Corps {printf("\nProgramme Syntaxiquement Correcte \n");YYACCEPT ;}
;


Corps: mc_debut Instructions mc_fin   
;


Declaration: ListeIdf  ':' Type ';'  Declaration       {printf("Regle 1 CHECK ! \n") ;}
            |Variable ':' Type ';'   Declaration       {printf("Regle 3 CHECK ! \n") ;}     
            |                                                       
;


ListeIdf: Variable '|' ListeIdf          {printf("Regle 4 CHECK ! \n") ;}               
        | Variable                       {printf("Regle 5 CHECK ! \n") ;}           
;


Variable : idf '[' cstE ']'                 { 
                                            taille= ($3) ;
                                            if (RoutineDoubleDeclaration ($1)==0) 
                                            {
                                                 Insertion($1, "NoType",  taille);
                                            } 
                                            else
                                           {
                                                printf("Variable: %s double declare ", $1) ;
                                                YYABORT;
                                           }  
                                            printf("Regle 3 CHECK ! \n") ;
                                            }
         | idf                              {
                                             if (RoutineDoubleDeclaration($1)==0) 
                                             {//Insertion dans la Table des Symboles
                                                    Insertion($1,  "NoType",  1);
                                             } 
                                             else 
                                             {
                                                printf("Ligne %d : Variable: %s double declare ",nb_ligne, $1) ;
                                                YYABORT;
                                             }       
                                             printf("Regle 5 CHECK ! \n") ;
                                            } 
;


Type: mc_entier                       {
                                       InsererType ("entier" ) ;
                                       printf("Regle 7 CHECK ! \n") ;
                                      }
    | mc_reel                         {
                                       InsererType ("reel" ) ; 
                                       printf("Regle 8 CHECK ! \n") ;
                                      }
    | mc_chaine                       {
                                       InsererType  ("chaine" ) ;
                                       printf("Regle 9 CHECK ! \n") ;
                                      }
;


CaseTab:idf  '['cstE']'               {
                                       //V??rifier si IDF n'est pas D??clar??//V??rifier si IDF n'est pas D??clar??
                                        if (RoutineIdfNonDeclare ($1)==1) 
                                         {
                                                 printf("Ligne %d : -Erreur Le Tableau : '%s' N'a pas ??t?? D??clar??e .\n" ,nb_ligne, $1) ;
                                                 YYABORT;
                                        } 
                                        //Depassement De Taille
                                        if(RoutineDepassementTailleTableau($1 , $3) == 1)
                                        {
                                                printf("Ligne %d : -Erreur Indice :' %d' sup??rieur ?? la capacit?? du Tableau : '%s'.",nb_ligne , $3 , $1);
                                                YYABORT;
                                        }
                                       printf("Regle 10 CHECK ! \n") ;
                                       }

        | idf '['idf']'               {
                                      //V??rifier si IDF n'est pas D??clar??//V??rifier si IDF n'est pas D??clar??
                                        if (RoutineIdfNonDeclare ($1)==1) 
                                         {
                                                 printf("Ligne %d : -Erreur Variable : '%s' N'a pas ??t?? D??clar??e .\n" ,nb_ligne, $1) ;
                                                 YYABORT;
                                        } 

                                      //V??rifier si IDF n'est pas D??clar??//V??rifier si IDF n'est pas D??clar??
                                       if (RoutineIdfNonDeclare ($3)==1) 
                                         {
                                                 printf("Ligne %d : -Erreur Variable : '%s' N'a pas ??t?? D??clar??e .\n" ,nb_ligne, $3) ;
                                                 YYABORT;
                                        } 
                                        printf("Regle 11 CHECK ! \n") ;
                                      }

        | idf '['ExpressionAri']'     {
                                        //V??rifier si IDF n'est pas D??clar??//V??rifier si IDF n'est pas D??clar??
                                         if (RoutineIdfNonDeclare ($1)==1) 
                                         {
                                                 printf("Ligne %d : -Erreur Variable : '%s' N'a pas ??t?? D??clar??e .\n",nb_ligne , $1) ;
                                                 YYABORT;
                                        }  
                                        printf("Regle 12 CHECK ! \n") ;
                                      }
;


Instructions: Affectation Instructions                  {printf("Regle 13 CHECK ! \n") ;}
            | Boucle Instructions                       {printf("Regle 14 CHECK ! \n") ;}
            |Condition Instructions                     {printf("Regle 15 CHECK ! \n") ;}
            |
;


Affectation:  idf affectation idf                               {
                                                                //V??rifier si IDF n'est pas D??clar??//V??rifier si IDF n'est pas D??clar??
                                                                if (RoutineIdfNonDeclare ($1)==1) 
                                                                {
                                                                     printf("Ligne %d : -Erreur Variable : '%s' N'a pas ??t?? D??clar??e .\n",nb_ligne , $1) ;
                                                                     YYABORT;
                                                                }
                                                                 if (RoutineIdfNonDeclare ($3)==1) 
                                                                {
                                                                     printf("Ligne %d : -Erreur Variable : '%s' N'a pas ??t?? D??clar??e .\n" ,nb_ligne , $3) ;
                                                                     YYABORT;
                                                                }
                                                                //Compatibilit??
                                                                        if(RoutineNonCompatibilite($1 , "<--" , $3) == 1)
                                                                        {
                                                                        printf("Ligne %d : -Erreur Incompatibilit?? des types Affectation Impossible :'%s %s %s' \n ",nb_ligne ,$1,"<--",$3);
                                                                        YYABORT;
                                                                        }
                                                                //Ajout Quadruplets
                                                                Quadr("<--" ,$3 , "vide" , $1);
                                                                        printf("Regle Affectation Simple1 CHECK ! \n") ;
                                                                }

                | idf affectation idf Operateur '(' Valeur ')' ';'  { 
                                                                //V??rifier si IDF n'est pas D??clar??//V??rifier si IDF n'est pas D??clar??
                                                                if (RoutineIdfNonDeclare ($1)==1) 
                                                                {
                                                                     printf("Ligne %d :  -Erreur Variable : '%s' N'a pas ??t?? D??clar??e .\n" ,nb_ligne , $1) ;
                                                                     YYABORT;
                                                                }
                                                                //V??rifier si IDF n'est pas D??clar??//V??rifier si IDF n'est pas D??clar??
                                                                if (RoutineIdfNonDeclare ($3)==1) 
                                                                {
                                                                     printf("Ligne %d : -Erreur Variable : '%s' N'a pas ??t?? D??clar??e .\n" ,nb_ligne , $3) ;
                                                                     YYABORT;
                                                                }

                                                                printf( " $3 = %s Op = %s type = %s \n",$3,Op , type);
                                                                //Compatibilit??
                                                                if(RoutineNonCompatibilite($3 ,Op,type ) == 1)
                                                               { printf("Ligne %d :  -Erreur Incompatibilit?? des types dans l'Expression Arithmetique : '%s %s %s' \n ",nb_ligne ,$3,Op,type);
                                                                YYABORT;
                                                               }
                                                                else
                                                                {
                                                                        strcpy(type,TypeExpressionValide());
                                                                        if(RoutineNonCompatibilite($1 , "<--" , type) == 1)
                                                                       {
                                                                                printf("Ligne %d : -Erreur Incompatibilit?? des types Affectation Impossible :'%s %s %s' \n ",nb_ligne ,$1,"<--",type);
                                                                                YYABORT;
                                                                       } 
                                                                }
                                                                //Division Par Zero 
                                                                if(strcmp(Op , "/") == 0 )
                                                                {
                                                                        if(atof(ValComp) == 0)
                                                                        {
                                                                                printf("Ligne %d : -Erreur Division Par Zero .",nb_ligne);
                                                                                YYABORT ;

                                                                        }
                                                                }
                                                                {

                                                                }
                                                                //Ajout Quadruplets 
                                                                Quadr(Op ,$3 , ValComp , $1);
                                                                printf("Regle Affectation Simple2 CHECK ! \n") ;}

            | idf affectation ExpressionAri ';'                 {
                                                                //V??rifier si IDF n'est pas D??clar??
                                                                if (RoutineIdfNonDeclare ($1)==1) 
                                                                {
                                                                     printf("Ligne %d : -Erreur Variable : '%s' N'a pas ??t?? D??clar??e .\n" ,nb_ligne, $1) ;
                                                                     YYABORT;
                                                                }   
                                                                printf("Regle 16 CHECK ! \n") ;
                                                                }
                                                                
            |CaseTab affectation ExpressionAri ';'             {printf("Regle 17 CHECK ! \n") ;}
;


Boucle: mc_pour idf  affectation cstE mc_jusque cstE mc_faire Instructions mc_fait 
        {
        //V??rifier si IDF n'est pas D??clar??//V??rifier si IDF n'est pas D??clar??
        if (RoutineIdfNonDeclare ($2)==1) 
        {
                printf("Ligne %d : -Erreur Variable : '%s' N'a pas ??t?? D??clar??e .\n",nb_ligne , $2) ;
                YYABORT;
        } 
         printf("Regle 20 CHECK ! \n") ;
        }
;



Condition: Before_SI mc_si '(' idf Oplogique Valeur ')'         {
                                                                 //V??rifier si IDF n'est pas D??clar??//V??rifier si IDF n'est pas D??clar??
                                                                if (RoutineIdfNonDeclare ($4)==1) 
                                                                {
                                                                     printf("Ligne %d : -Erreur Variable : '%s' N'a pas ??t?? D??clar??e .\n" ,nb_ligne , $4) ;
                                                                     YYABORT;
                                                                }
                                                                //Ajout Quadrplets
                                                                R3($4 , Oplog ,ValComp ) ;}
;

Before_SI : Before_Instructions Instructions { //Ajout Quadruplets
                                              R2();}
;
Before_Instructions : mc_faire  {///Ajout Quadrplets
                                R1();}
;



ExpressionAri:  '(' ExpressionAri ')'                              {printf("Regle 25 CHECK ! \n") ;}
             |Terme Operateur ExpressionAri                        {printf("Regle 26 CHECK ! \n") ;}
             |'('Terme')' Operateur ExpressionAri                  {printf("Regle 27 CHECK ! \n") ;}
             |'('ExpressionAri ')' Operateur ExpressionAri         {printf("Regle 28 CHECK ! \n") ;}
             |Terme
;




Terme:idf                                                       {
                                                                //V??rifier si IDF n'est pas D??clar??//V??rifier si IDF n'est pas D??clar??
                                                                if (RoutineIdfNonDeclare ($1)==1) 
                                                                 {
                                                                          printf("-Erreur Variable : '%s' N'a pas ??t?? D??clar??e .\n" , $1) ;
                                                                 } 
                                                                 printf("Regle Terme1 CHECK ! \n") ;
                                                                 }
      |'('Valeur')'                                             {printf("Regle Terme2 CHECK ! \n") ;}
      |CaseTab                                                  {printf("Regle Terme3 CHECK ! \n") ;}
;


Valeur: cstE                                       {strcpy(type , "entier") ;
                                                    sprintf(ValComp , "%d" , $1);    
                                                     printf("Regle Val cstE CHECK ! \n") ;}
      | cstR                                       {strcpy(type , "reel") ;
                                                        sprintf(ValComp , "%f" , $1);
                                                      printf("Regle Val cstR CHECK ! \n") ;}
      | string                                     {strcpy(type , "chaine") ;
                                                    printf("Regle Val cstStr CHECK ! \n") ;}
;


Operateur: '+'                                   { strcpy(Op,"+");
                                                 printf("Regle Addition CHECK ! \n") ;}
          | '-'                                 { strcpy(Op,"-");
                                                printf("Regle Soustraction CHECK ! \n") ;}
          | '*'                                 { strcpy(Op,"*");
                                                printf("Regle Multiplication CHECK ! \n") ;}
          | '/'                                 { strcpy(Op,"/");
                                                printf("Regle DIvision CHECK ! \n") ;}
;


Oplogique: '>'          {strcpy(Oplog , ">") ;}
           | '<'           {strcpy(Oplog , "<") ;}
           | infegal           {strcpy(Oplog , "<=") ;}
           | supegal           {strcpy(Oplog , ">=") ;}
           | egal           {strcpy(Oplog , "=") ;}
           | notegal           {strcpy(Oplog , "!=") ;}
; 
%%

int yyerror ( char*  msg ) {
printf ( "Ligne %d :  Erreur Syntaxique rencontr??e .\n ",nb_ligne);
 }



main()
{
yyparse();
afficher();
afficher_Qdr();
}
yywarp()
{}

