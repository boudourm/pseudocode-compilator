%option yylineno
%{
#include "Syntaxique.tab.h"
extern YYSTYPE yylval;
int nb_ligne = 1;


%}

idf  [a-zA-Z][a-zA-Z0-9_]*
cstE [+-]?([0-9]*)
cstR   [+-]?([0-9]*)"."[0-9]*
string  (\")([^\"]*)(\")

%%

ALGORITHME  { printf("\n-----------------------------------------\nAnalyse Lexicale et Syntaxique : \n-----------------------------------------\n");
              printf("-mc_algo .\n");  return mc_algo;}
Debut  { printf("-mc_debut .\n"); return mc_debut; }
Fin    { printf("-mc_fin .\n");return mc_fin; }
Pour {return mc_pour;}
jusque {return mc_jusque;}
Fait   return mc_fait;
Faire {printf("-mc_faire .\n");return mc_faire;}
SI    {printf("-mc_si .\n");return  mc_si;}
"|"    { printf("-'|' .\n");return '|'; }
";"    { printf("-';' .\n");return ';' ; }
":"    { printf("-':' .\n");return ':';}
"["    { printf("-'[' .\n");return '[';}
"]"    { printf("-']' .\n");return ']' ;}
"("    { printf("-'(' .\n");return '(' ;}
")"    { printf("-')' .\n");return ')' ;}
">"    {printf("-'>' .\n");return '>';}
"<"    {printf("-'<' .\n");return '<';}
"!="   {printf("-'!=' .\n");return notegal;}
">="   {printf("-'>=' .\n"); return supegal;}
"<="   {printf("-'<=' .\n"); return infegal;}
"=="   {printf("-'==' .\n"); return 
egal;}
"<--" {printf("- '<--' . \n"); return affectation;}
"+" return '+';
"/" return '/';
"*" return '*';
"-" return '-';
    
entier  { printf("-mc_entier .\n");return mc_entier; }
reel  { printf("-mc_reel .\n");return mc_reel;}
chaine { printf("-mc_chaine .\n");return mc_chaine;}
Var { printf("-mc_var .\n");return mc_var; }
{cstR} { printf("-cstR = (%s) .\n",yytext);  yylval.entier=atof(yytext); return cstE ;}
{cstE} { printf("-cstE = (%s) .\n",yytext); yylval.entier=atoi(yytext);
        if (atoi(yytext)<-32768 || atoi(yytext)>32767) 
        printf ("Erreur Lexicale - Ligne : %d  : Depacement de la taille de l'identificateur %s \n",nb_ligne,yytext) ; 
        return cstE ;}
{string} {printf("-string . \n"); return string;}
{idf} { printf("-idf = (%s).\n",yytext); yylval.chaine=strdup(yytext);
       if (strlen(yytext)>12) printf ("Erreur Lexicale - Ligne : %d  : Depacement devaleur %s \n",nb_ligne,yytext) ; return idf;}
"//".* {printf("-comment .\n") ; /*Do nothing*/}
[/][*][^*]*[*]+([^*/][^*]*[*]+)*[/]       { printf(" Commentaire multiple"); }
\n {nb_ligne++ ;} 
[ \t]           
. {printf("Erreur lexicale Chaine %s  non reconnue \n", yytext);}


%% 

