#include "random_char.h"

int process(char *nbr)
{
    char *charac;
    int i = 0;
    int ind = my_getnbr(nbr);
    int rand = -1;
    int len = my_strlen(charac);

    srand(time(NULL));
    while (i < ind) {
        rand = my_random(len);
        printf("%c", charac[rand]);
        if (i != 0 && i % 100 == 0)
            printf("\n");
        i++;
    }
    printf("\n");
    return 0;
}