#include <stdio.h>

static int shared = 3;     /* This is the file-scope variable (with 
                            * internal linkage), visible only in 
                            * this compilation unit. 
                            */

extern int overShared = 1; /* This one has external linkage (not
                            * limited to this compilation unit). 
                            */

int overSharedToo = 2;      /* Also external linkage
                            */

static void changeShared(void)
{


    shared = 5; /* Reference to the file-scope 
                 * variable in a function.
                 */


}

static void localShadow(void)
{


    int shared; /* local variable that will hide 
                 * the global of the same name
                 */

    shared = 1000; /* This will affect only the local variable and will
                    * have no effect on the file-scope variable of the
                    * same name. 
                    */


}

static void paramShadow(int shared)
{


    shared = -shared; /* This will affect only the parameter and will have no
                       * effect on the file-scope variable of the same name. 
                       */


}

int main(void)
{


    printf("%d\n", shared); /* Reference to the file-scope 
                             * variable.
                             */

    changeShared();

    printf("%d\n", shared);

    localShadow();

    printf("%d\n", shared);

    paramShadow(1);

    printf("%d\n", shared);

    return 0;


}