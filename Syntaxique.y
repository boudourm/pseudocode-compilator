%{
#include <stdio.h>
#include<string.h>
#include "TableDesSymboles.h"
#include "CodeIntermediaire.h"

int taille ; 
char sauvType[20] ;
%}
%union
{
   char* chaine;
   int entier;
   float reel;
}

%token mc_algo mc_debut mc_fin  <chaine>string <chaine>idf mc_var <chaine>mc_entier <chaine>mc_reel ;
%token  mc_pour <chaine>mc_chaine <entier>cstE mc_jusque mc_faire mc_fait mc_si affectation <reel>cstR comment;
%token ';' '|' '[' ']' ':' '(' ')' notegal supegal infegal egal;
%left '+' '-' ;
%left '*' '/' ;



%%
Programme: mc_algo idf mc_var declaration Corps {printf("Programme syntaxiquement correcte \n");YYACCEPT ;}
;
Corps: mc_debut Instructions mc_fin   
;           
declaration: ListeIdf  ':' Type ';'  declaration       {printf("Regle 1 CHECK ! \n") ;}
            |Variable ':' Type ';' declaration         {printf("Regle 3 CHECK ! \n") ;}     
            |                                                       
;
ListeIdf: Variable '|' ListeIdf   {printf("Regle 4 CHECK ! \n") ;}               
        | Variable    {printf("Regle 5 CHECK ! \n") ;}           
;
Variable : idf '[' cstE ']'  { taille = ($3) ; if (RoutineDoubleDeclaration ($1)==0) { Insertion($1, sauvType,  taille);} else printf("Variable: %s double declare ", $1) ;  printf("Regle 3 CHECK ! \n") ;}
         | idf          {  if (RoutineDoubleDeclaration($1)==0) { Insertion($1, sauvType, 1 );} else printf("Idf double declare ") ;  printf("Regle 5 CHECK ! \n") ;} 
;
Type: mc_entier                                         {strcpy(sauvType , $1) ; printf("Regle 7 CHECK ! \n") ;}
    | mc_reel                                           {strcpy(sauvType , $1) ; printf("Regle 8 CHECK ! \n") ;}
    | mc_chaine                                         {strcpy(sauvType , $1) ; printf("Regle 9 CHECK ! \n") ;}
;
CaseTab:idf  '['cstE']'  {if (RoutineIdfNonDeclare ($1)==1) {printf("Variable: %s non declare ", $1) ;}  ;  printf("Regle 10 CHECK ! \n") ;}
        | idf '['idf']'   {if (RoutineIdfNonDeclare ($3)==1) {printf("Variable: %s non declare ", $3) ;}
                            if (RoutineIdfNonDeclare ($1)==1) {printf("Variable: %s non declare ", $1) ;} 
                            printf("Regle 11 CHECK ! \n") ;}
        | idf '['ExpressionAri']' {if (RoutineIdfNonDeclare ($1)==1) {printf("Variable: %s non declare ", $1) ; } printf("Regle 12 CHECK ! \n") ;}
;
Instructions: Affectation Instructions                  {printf("Regle 13 CHECK ! \n") ;}
            | Boucle Instructions                       {printf("Regle 14 CHECK ! \n") ;}
            |Condition Instructions                     {printf("Regle 15 CHECK ! \n") ;}
            |
;
Affectation: idf affectation ExpressionAri ';'                 {printf("Regle 16 CHECK ! \n") ;}
            |CaseTab affectation ExpressionAri ';'  {printf("Regle 17 CHECK ! \n") ;}
;
Boucle: mc_pour idf  affectation cstE mc_jusque cstE mc_faire Instructions mc_fait {printf("Regle 20 CHECK ! \n") ;}
;
Condition: mc_faire Instructions mc_si '(' ExpressionLog ')'   {printf("Regle 21 CHECK ! \n") ;}
;
ExpressionLog:idf Oplogique idf                                    {printf("Regle 22 CHECK ! \n") ;}
          | idf Oplogique cstE                                  {printf("Regle 23 CHECK ! \n") ;}
          |idf Oplogique idf '['cstE']'                         {printf("Regle 24 CHECK ! \n") ;}
;
ExpressionAri:  '(' ExpressionAri ')'                      {printf("Regle 25 CHECK ! \n") ;}
             |Terme Operateur ExpressionAri             {printf("Regle 26 CHECK ! \n") ;}
             |'('Terme')' Operateur ExpressionAri             {printf("Regle 27 CHECK ! \n") ;}
             |'('ExpressionAri ')' Operateur ExpressionAri            {printf("Regle 28 CHECK ! \n") ;}
             |Terme
;
Terme:idf |'('Valeur')' |idf  '['cstE']'| idf '['idf']' |idf '['ExpressionAri']'
;
Valeur: cstE | cstR | string  {printf("Regle 29 CHECK ! \n") ;}
;
Operateur: '+' | '-' | '*' | '/' {printf("Regle 28 CHECK ! \n") ;}
;
Oplogique: '>' | '<' | infegal | supegal | egal | notegal  
%%


main()
{
        
yyparse();
afficher();
afficher_Qdr();
}
yywarp()
{}






