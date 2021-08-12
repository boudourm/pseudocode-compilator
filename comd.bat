flex lexical.l
bison -d syntaxique.y
gcc lex.yy.c Syntaxique.tab.c -lfl -ly -o compil
cd C:\Users\Moflawer\Desktop\Dol_Gul_Dur\WorkShop_Tree\C\Done\Training\COMPILATOR_3\CompilPrOjet
compil
pause