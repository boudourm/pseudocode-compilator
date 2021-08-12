flex lexical.l
bison -d syntaxique.y
gcc lex.yy.c Syntaxique.tab.c -lfl -ly -o COMPILATOR
